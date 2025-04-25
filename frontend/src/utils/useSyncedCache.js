import {
    getMemoryCache,
    getCacheLastUpdate,
    cachedFetch,
    updateCache,
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
        const localLastUpdate = getCacheLastUpdate(key);
        const noHayCache =
            !cached || !Array.isArray(cached) || cached.length === 0;
        let updatedItems = null;

        if (!noHayCache) {
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
            alert(
                `[${key}] local: ${localLastUpdate}, backend: ${backendLastUpdate}`
            );

            if (backendLastUpdate > localLastUpdate + MARGEN_TIEMPO) {
                console.warn(`♻️ Backend más nuevo. Borrando caché de ${key}`);
                localStorage.removeItem(key);
                localStorage.removeItem(`${key}_time`);
                localStorage.removeItem(`${key}_last_update`);
                notifyCacheChange(key);

                // ⚠️ Forzar que fetch vuelva al backend
                const result = await cachedFetch(key, fetchFn, {
                    ttl,
                    forceRefresh: true,
                });
                await updateCache(key, result, backendLastUpdate); // 👈 Aca le pasás explícitamente el del backend
                onData(result);
                return;
            } else {
                localStorage.setItem(`${key}_last_update`, backendLastUpdate); // 👈 Esto está bien
            }
        }

        const result = await cachedFetch(key, fetchFn, { ttl });
        await updateCache(key, result, localLastUpdate); // mismo timestamp viejo

        onData(updatedItems !== null ? updatedItems : result);
    } catch (err) {
        console.error(`❌ Error en useSyncedCache ${key}:`, err);
        onData([]);
    } finally {
        setLoading(false);
    }
}
