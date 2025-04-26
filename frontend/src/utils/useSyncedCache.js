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

        if (
            !localLastUpdate ||
            isNaN(localLastUpdate) ||
            localLastUpdate > Date.now() + 60000
        ) {
            console.warn(
                `⛔ No hay localLastUpdate válido para ${key}. Borrando caché.`
            );

            clearCacheKey(key);
            notifyCacheChange(key);
            localLastUpdate = 0; // seteo en 0 explícitamente
        }

        const noHayCache =
            !cached || !Array.isArray(cached) || cached.length === 0;

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

        // Si no había cache o ya está fresca
        const result = await cachedFetch(key, fetchFn, { ttl });
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
