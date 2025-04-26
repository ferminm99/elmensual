import {
    getMemoryCache,
    getCacheLastUpdate,
    cachedFetch,
    updateCache,
    clearCacheKey,
} from "@/utils/cacheFetch";
import axios from "axios";
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
            // Si no hay lastUpdate o es del año 55000, lo reseteamos
            localLastUpdate = 0;
        }

        const noHayCache =
            !cached || !Array.isArray(cached) || cached.length === 0;

        if (!noHayCache) {
            if (localLastUpdate > 0) {
                // ✅ Solo si localLastUpdate es válido hacemos el axios
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

                const nuevos = Array.isArray(data?.data) ? data.data : [];

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
            } else {
                // 🛑 Si el localLastUpdate era inválido, salteamos el fetch incremental
                console.warn(
                    `⛔ No hay localLastUpdate válido para ${key}. Se hace fetch normal.`
                );
            }
        }

        // Si no había cache o está todo OK, simplemente fetch normal
        const result = await cachedFetch(key, fetchFn, { ttl });

        // ⬇️ Y ahora sí: si no hubo diferencias, mantenemos el localLastUpdate
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
