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

        if (!noHayCache) {
            const { data } = await axios.get(`/api${apiPath}`, {
                params: { timestamp: localLastUpdate },
            });

            const backendLastUpdate = Number(data.last_update || 0) * 1000;

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
                console.warn(`♻️ Backend más nuevo. Borrando caché de ${key}`);
                localStorage.removeItem(key);
                localStorage.removeItem(`${key}_time`);
                localStorage.removeItem(`${key}_last_update`);
                notifyCacheChange(key);
            } else {
                // Guardar last_update aunque no haya cambio
                localStorage.setItem(`${key}_last_update`, backendLastUpdate);
            }
        }

        const result = await cachedFetch(key, fetchFn, { ttl });
        await updateCache(key, result);

        onData(Array.isArray(result) ? result : []);
    } catch (err) {
        console.error(`❌ Error en useSyncedCache ${key}:`, err);
        onData([]);
    } finally {
        setLoading(false);
    }
}
