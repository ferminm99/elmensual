import axios from "axios";
import { getCacheLastUpdate } from "./cacheFetch";

export async function checkCacheFreshness(key, apiPath) {
    try {
        const { data } = await axios.get(`/api${apiPath}`);
        const backendLastUpdate = Number(data.last_update || 0);
        const localTime = getCacheLastUpdate(key);

        if (backendLastUpdate > localTime) {
            console.warn(`🔄 Cache desactualizada para ${key}, limpiando...`);
            localStorage.removeItem(key);
            localStorage.removeItem(`${key}_time`);
            localStorage.removeItem(`${key}_last_update`);
        }
    } catch (error) {
        console.error(
            `❌ Error al verificar frescura de cache para ${key}:`,
            error
        );
    }
}
