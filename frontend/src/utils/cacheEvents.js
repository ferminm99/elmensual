// ✅ Nuevo archivo: utils/cacheEvents.js

export function notifyCacheChange(key) {
    const event = new CustomEvent("cache-updated", { detail: { key } });
    window.dispatchEvent(event);
}

export function onCacheChange(callback) {
    window.addEventListener("cache-updated", (e) => {
        callback(e.detail.key);
    });
}
