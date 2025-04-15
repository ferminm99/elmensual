export async function cachedFetch(key, fetchFn, options = { ttl: 3600 }) {
    const { ttl } = options;
    const now = Date.now();

    // Revisar memoria primero
    const memory = memoryCache[key];
    if (memory && now - memory.time < ttl * 1000) {
        return memory.data;
    }

    // Revisar localStorage si no hay en memoria o expiró
    // Revisar localStorage si no hay en memoria o expiró
    const cached = localStorage.getItem(key);
    const cachedTime = localStorage.getItem(key + "_time");

    if (cached && cachedTime) {
        let parsed = null;
        try {
            parsed = JSON.parse(cached);
        } catch (e) {
            console.warn("Cache JSON inválido para", key, e);
        }

        if (parsed && now - cachedTime < ttl * 1000) {
            memoryCache[key] = { data: parsed, time: Number(cachedTime) };
            return parsed;
        }
    }

    // Hacer fetch si no hay nada válido
    const data = await fetchFn();
    if (data !== undefined) {
        localStorage.setItem(key, JSON.stringify(data));
        localStorage.setItem(key + "_time", now.toString());
        memoryCache[key] = { data, time: now };
    }
    return data;
}

export function updateCache(key, newData) {
    const now = Date.now();
    if (!Array.isArray(newData)) {
        console.warn(
            `updateCache: El valor para "${key}" no es un array.`,
            newData
        );
    }
    localStorage.setItem(key, JSON.stringify(newData));
    localStorage.setItem(key + "_time", now.toString());
    memoryCache[key] = { data: newData, time: now };
}

export function appendToCache(key, newItem) {
    const cached =
        memoryCache[key]?.data || JSON.parse(localStorage.getItem(key)) || [];
    const updated = [...cached, newItem];
    updateCache(key, updated);
    return updated;
}

export function removeFromCache(key, predicateFn) {
    let cached = memoryCache[key]?.data;
    if (!Array.isArray(cached)) {
        try {
            cached = JSON.parse(localStorage.getItem(key));
        } catch {
            cached = [];
        }
    }
    if (!Array.isArray(cached)) cached = [];

    const updated = cached.filter((item) => !predicateFn(item));
    updateCache(key, updated);
    return updated;
}

export function modifyInCache(key, modifyFn) {
    const cachedRaw = memoryCache[key]?.data || localStorage.getItem(key);
    let cached = [];

    try {
        cached =
            typeof cachedRaw === "string" ? JSON.parse(cachedRaw) : cachedRaw;
        if (!Array.isArray(cached)) throw new Error("El valor no es un array");
    } catch (e) {
        console.warn(
            `modifyInCache: El valor para "${key}" no es un array`,
            cachedRaw
        );
        return;
    }

    const updated = modifyFn(cached);
    updateCache(key, updated);
    return updated;
}

export function applyStockDelta(articuloId, talle, color, cantidad) {
    modifyInCache("articulos", (articulos) => {
        return articulos.map((articulo) => {
            if (articulo.id !== articuloId) return articulo;
            const nuevoTalles = articulo.talles.map((t) => {
                if (t.talle !== talle) return t;
                return {
                    ...t,
                    [color]: (parseInt(t[color]) || 0) + cantidad,
                };
            });
            return { ...articulo, talles: nuevoTalles };
        });
    });
}

const memoryCache = {}; // clave: { data, time }

export function getMemoryCache(key, ttl) {
    const entry = memoryCache[key];
    const now = Date.now();
    if (entry && now - entry.time < ttl * 1000) {
        return entry.data;
    }
    return null;
}
