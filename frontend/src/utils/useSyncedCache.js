import {
    getMemoryCache,
    getCacheLastUpdate,
    updateCache,
    clearCacheKey,
    cachedFetch,
} from "@/utils/cacheFetch";
import { notifyCacheChange } from "@/utils/cacheEvents";

export async function useSyncedCache({
    key,
    apiPath,
    fetchFn,
    ttl = 86400,
    onData = () => {},
    setLoading = () => {},
}) {
    setLoading(true);

    try {
        const MARGEN_TIEMPO = 2000;
        const cached = getMemoryCache(key, ttl);
        let localLastUpdate = getCacheLastUpdate(key);

        const noHayCache =
            !cached || !Array.isArray(cached) || cached.length === 0;

        if (!localLastUpdate && noHayCache) {
            console.warn(
                `⛔ No hay localLastUpdate y tampoco datos para ${key}. Borrando caché.`
            );
            clearCacheKey(key);
            notifyCacheChange(key);
            localLastUpdate = 0;
        } else if (!localLastUpdate && !noHayCache) {
            console.info(
                `ℹ️ No había localLastUpdate para ${key}, pero sí cache válido. Continuando.`
            );
            localLastUpdate = 0;
        } else if (
            isNaN(localLastUpdate) ||
            localLastUpdate > Date.now() + 60000
        ) {
            console.warn(
                `⚠️ LocalLastUpdate inválido para ${key}. Borrando caché.`
            );
            clearCacheKey(key);
            notifyCacheChange(key);
            localLastUpdate = 0;
        }

        if (!noHayCache) {
            if (localLastUpdate > 0) {
                const { data } = await axios.get(`/api${apiPath}`, {
                    params: { timestamp: localLastUpdate },
                });

                const backendLastUpdate = data?.last_update
                    ? Number(data.last_update) * 1000
                    : (() => {
                          console.error(
                              `❌ [${key}] No se recibió last_update del backend`
                          );
                          throw new Error("No se recibió last_update");
                      })();

                console.log(`🧠 Cache check para "${key}"`);
                console.log(
                    "🔸 localLastUpdate:",
                    localLastUpdate,
                    new Date(localLastUpdate)
                );
                console.log(
                    "🔹 backendLastUpdate:",
                    backendLastUpdate,
                    new Date(backendLastUpdate)
                );

                if (backendLastUpdate > localLastUpdate + MARGEN_TIEMPO) {
                    console.warn(
                        `♻️ Backend más nuevo. Borrando caché de ${key}`
                    );
                    clearCacheKey(key);
                    notifyCacheChange(key);

                    const result = await cachedFetch(key, fetchFn, { ttl });
                    await updateCache(key, result, backendLastUpdate);

                    console.log(
                        "🔁 useSyncedCache ejecutado (backend más nuevo)"
                    );
                    onData(result);
                    return;
                } else {
                    localStorage.setItem(
                        `${key}_last_update`,
                        backendLastUpdate
                    );
                }
            }
        }

        const result = await cachedFetch(key, fetchFn, { ttl });

        if (!result || !Array.isArray(result) || result.length === 0) {
            console.error(
                `❌ [${key}] No se pudieron cargar datos desde fetchFn.`
            );
            throw new Error("Falló el fetch inicial");
        }

        await updateCache(key, result, localLastUpdate);

        console.log("🔁 useSyncedCache ejecutado (sin cambios)");
        onData(result);
    } catch (err) {
        console.error(`❌ Error en useSyncedCache ${key}:`, err);
        onData([]);
    } finally {
        setLoading(false);
    }
}
