import { getCacheLastUpdate, getMemoryCache } from "./cacheFetch";

export function initCacheSync(keys, { onUpdate }) {
    const ttl = 86400;
    const toleranciaMs = 2000;

    // ✅ Comparar y limpiar si hay diferencias significativas
    keys.forEach((key) => {
        const lastUpdate = getCacheLastUpdate(key);
        const localTime = parseInt(localStorage.getItem(`${key}_time`)) || 0;

        if (lastUpdate - localTime > toleranciaMs) {
            console.warn(
                `🟡 Cambios detectados en ${key} (diff ${
                    lastUpdate - localTime
                }ms). Limpiando cache local.`
            );
            localStorage.removeItem(key);
            localStorage.removeItem(`${key}_time`);
            localStorage.removeItem(`${key}_last_update`);
        }
    });

    // 🧠 Escuchamos cambios entre pestañas/dispositivos
    const handleStorage = (e) => {
        const keyChanged = e.key?.replace("_time", "");
        if (keys.includes(keyChanged)) {
            const updated = getMemoryCache(keyChanged, ttl);
            if (updated) onUpdate(keyChanged, updated);
        }
    };

    window.addEventListener("storage", handleStorage);

    // ✅ Cleanup real
    return () => {
        window.removeEventListener("storage", handleStorage);
    };
}
