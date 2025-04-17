// utils/initCacheSync.js
import { getCacheLastUpdate, getMemoryCache } from "./cacheFetch";

export function initCacheSync(keys, { onUpdate }) {
    const ttl = 86400;

    // Revisión inicial por cambios remotos (al iniciar el componente)
    keys.forEach((key) => {
        const lastUpdate = getCacheLastUpdate(key);
        const localTime = parseInt(localStorage.getItem(`${key}_time`) || "0");

        if (lastUpdate > localTime) {
            console.warn(
                `🟡 Cambios detectados en ${key}. Limpiando cache local.`
            );
            localStorage.removeItem(key);
            localStorage.removeItem(`${key}_time`);
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
        window.removeEventListener("storage", () => {});
    };
}
