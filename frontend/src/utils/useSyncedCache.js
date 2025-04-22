// utils/useSyncedCache.js
import {
    getCacheLastUpdate,
    cachedFetch,
    updateCache,
} from "@/utils/cacheFetch";
import axios from "axios";

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
        const { data } = await axios.get(`/api${apiPath}`);
        const backendLastUpdate = Number(data.last_update || 0) * 1000;
        const localLastUpdate = getCacheLastUpdate(key);

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

        if (backendLastUpdate > localLastUpdate) {
            console.warn(`♻️ Backend más nuevo. Borrando caché de ${key}`);
            localStorage.removeItem(key);
            localStorage.removeItem(`${key}_time`);
            localStorage.removeItem(`${key}_last_update`);
        }

        const result = await cachedFetch(key, fetchFn, { ttl });

        // 🧠 Reemplazamos el cache por completo
        await updateCache(key, result);

        // 🧠 Guardamos la fecha nueva si corresponde
        if (backendLastUpdate > localLastUpdate) {
            localStorage.setItem(`${key}_last_update`, backendLastUpdate);
        }

        onData(Array.isArray(result) ? result : []);
    } catch (err) {
        console.error(`❌ Error en useSyncedCache ${key}:`, err);
        onData([]);
    } finally {
        setLoading(false);
    }
}
