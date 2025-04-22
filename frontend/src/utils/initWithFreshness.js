import { cachedFetch, getCacheLastUpdate } from "./cacheFetch";
import axios from "axios";

export async function initWithFreshness({
    key,
    apiPath,
    fetchFn,
    ttl = 86400,
    setLoading = () => {},
    onData = () => {},
}) {
    setLoading(true);

    try {
        const { data } = await axios.get(`/api${apiPath}`);
        const backendLastUpdate = Number(data.last_update || 0);
        const localLastUpdate = getCacheLastUpdate(key);

        if (backendLastUpdate > localLastUpdate) {
            console.warn(`♻️ Reset cache de ${key} por update más nuevo`);
            localStorage.removeItem(key);
            localStorage.removeItem(`${key}_time`);
            localStorage.removeItem(`${key}_last_update`);
        }

        const dataCache = await cachedFetch(key, fetchFn, { ttl });
        onData(Array.isArray(dataCache) ? dataCache : []);
    } catch (err) {
        console.error(`❌ Error al inicializar ${key}:`, err);
        onData([]);
    } finally {
        setLoading(false);
    }
}
