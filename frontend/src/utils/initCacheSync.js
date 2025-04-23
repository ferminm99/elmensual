// utils/initCacheSync.js
import { getCacheLastUpdate, getMemoryCache } from "./cacheFetch";

export function initCacheSync(keys, { onUpdate }) {
    const ttl = 86400;
    const toleranciaMs = 2000; // ⚠️ Margen para evitar limpiar por diferencia mínima

    // Revisión inicial por cambios remotos (al iniciar el componente)
    keys.forEach((key) => {
        const lastUpdate = getCacheLastUpdate(key);
        const localTime = parseInt(localStorage.getItem(`${key}_time`) || "0");

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

    // Suscripción al evento 'storage' para otros dispositivos/pestañas
    window.addEventListener("storage", (e) => {
        const keyChanged = e.key?.replace("_time", "");
        if (keys.includes(keyChanged)) {
            const updated = getMemoryCache(keyChanged, ttl);
            if (updated) onUpdate(keyChanged, updated);
        }
    });

    // Retornar función de cleanup para usar en `beforeUnmount`
    return () => {
        window.removeEventListener("storage", () => {}); // (opcional) podrías mejorar esto si querés evitar memory leaks
    };
}
