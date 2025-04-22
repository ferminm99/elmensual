const memoryCache = {}; // clave: { data, time }

export function getMemoryCache(key, ttl) {
    const entry = memoryCache[key];
    const now = Date.now();
    if (entry && now - entry.time < ttl * 1000) {
        return entry.data;
    }
    return null;
}

export function getCacheLastUpdate(key) {
    return Number(localStorage.getItem(`${key}_last_update`) || 0);
}

function setCacheLastUpdate(key) {
    const now = Date.now();
    localStorage.setItem(`${key}_last_update`, now.toString());
}

export async function cachedFetch(
    key,
    fetchFn,
    options = { ttl: 3600, forceRefresh: false }
) {
    const { ttl, forceRefresh } = options;
    const now = Date.now();

    if (!forceRefresh) {
        const memory = memoryCache[key];
        if (
            memory &&
            memory.data !== undefined &&
            now - memory.time < ttl * 1000
        ) {
            return memory.data;
        }

        const cached = localStorage.getItem(key);
        const cachedTime = localStorage.getItem(key + "_time");

        if (
            cached &&
            cached !== "undefined" &&
            cached !== "" &&
            cachedTime &&
            now - cachedTime < ttl * 1000
        ) {
            try {
                const parsed = JSON.parse(cached);
                memoryCache[key] = { data: parsed, time: Number(cachedTime) };
                return parsed;
            } catch (e) {
                console.warn(`❌ Error al parsear cache de ${key}:`, e);
                localStorage.removeItem(key);
                localStorage.removeItem(key + "_time");
                localStorage.removeItem(key + "_last_update");
            }
        }
    }

    // fetch real
    const data = await fetchFn();
    localStorage.setItem(key, JSON.stringify(data));
    localStorage.setItem(key + "_time", now.toString());
    localStorage.setItem(key + "_last_update", now.toString());
    memoryCache[key] = { data, time: now };
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
    localStorage.setItem(key + "_last_update", now.toString()); // NUEVO
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

export function applyStockDelta(
    articuloId,
    talle,
    color,
    delta,
    cacheKey = "articulos_completos"
) {
    delta = parseInt(delta) || 0;
    if (delta === 0) return;

    // Obtener copia actual del cache (de memoria si existe, o localStorage si no)
    let cache = memoryCache[cacheKey]?.data;
    if (!cache) {
        try {
            cache = JSON.parse(localStorage.getItem(cacheKey)) || [];
        } catch {
            cache = [];
        }
    }

    const now = Date.now();

    const updatedCache = cache.map((articulo) => {
        if (articulo.id !== articuloId) return articulo;

        const talles = Array.isArray(articulo.talles)
            ? [...articulo.talles]
            : [];

        const existente = talles.find((t) => t.talle === talle);

        if (existente) {
            existente[color] = Math.max((existente[color] || 0) + delta, 0);

            const sigueVacio = [
                "marron",
                "negro",
                "verde",
                "azul",
                "celeste",
                "blancobeige",
            ].every((c) => (existente[c] || 0) === 0);

            if (sigueVacio) {
                return {
                    ...articulo,
                    talles: talles.filter((t) => t.talle !== talle),
                };
            }

            return { ...articulo, talles };
        } else if (delta > 0) {
            // Crear nuevo talle
            const nuevoTalle = {
                talle,
                marron: 0,
                negro: 0,
                verde: 0,
                azul: 0,
                celeste: 0,
                blancobeige: 0,
                [color]: delta,
            };
            return {
                ...articulo,
                talles: [...talles, nuevoTalle],
            };
        }

        return articulo;
    });

    // Actualizar ambos
    memoryCache[cacheKey] = { data: updatedCache, time: now };
    localStorage.setItem(cacheKey, JSON.stringify(updatedCache));
    localStorage.setItem(`${cacheKey}_time`, now.toString());
    localStorage.setItem(`${cacheKey}_last_update`, now.toString());
}
