export const memoryCache = {}; // clave: { data, time }

export function getMemoryCache(key, ttl = 86400) {
    const now = Date.now();

    if (memoryCache[key]) {
        if (
            memoryCache[key]._time &&
            now - memoryCache[key]._time < ttl * 1000
        ) {
            return memoryCache[key].data;
        }
    }

    // ⚡ Si no había en RAM, intento recuperar desde localStorage
    const localData = localStorage.getItem(key);
    const localTime = localStorage.getItem(`${key}_time`);

    if (localData && localTime && now - Number(localTime) < ttl * 1000) {
        const parsed = JSON.parse(localData);
        memoryCache[key] = {
            data: parsed,
            _time: Number(localTime),
        };
        return parsed;
    }

    return null;
}

export function clearCacheKey(key) {
    try {
        delete memoryCache[key];
        localStorage.removeItem(key);
        localStorage.removeItem(`${key}_time`);
        localStorage.removeItem(`${key}_last_update`);
        console.log("CACHE CLEARED");
    } catch (e) {
        console.error(`❌ Error al limpiar cache para "${key}"`, e);
    }
}

export function resetAllCache() {
    try {
        localStorage.clear();
        memoryCache = {}; // también limpiar la cache en memoria
        console.log("🧹 Limpieza total de localStorage + memoryCache hecha.");
    } catch (e) {
        console.error("❌ Error limpiando todo el cache", e);
    }
}

export function getCacheLastUpdate(key) {
    return Number(localStorage.getItem(`${key}_last_update`) || 0);
}

export function updateSimpleCache(key, value) {
    const now = Date.now();
    memoryCache[key] = { data: value, time: now };
}

// Guarda un objeto o dato simple en localStorage
export function setSimpleCache(key, value) {
    try {
        localStorage.setItem(key, JSON.stringify(value));
        localStorage.setItem(`${key}_time`, Date.now().toString());
    } catch (e) {
        console.error(`❌ Error al guardar simple cache para "${key}"`, e);
    }
}

// Obtiene un objeto o dato simple de localStorage
export function getSimpleCache(key, ttl = 86400) {
    try {
        const raw = localStorage.getItem(key);
        const time = localStorage.getItem(`${key}_time`);
        const now = Date.now();

        if (raw && time && now - Number(time) < ttl * 1000) {
            return JSON.parse(raw);
        }
    } catch (e) {
        console.error(`❌ Error al obtener simple cache para "${key}"`, e);
    }
    return null;
}

// Borra un simple cache
export function clearSimpleCache(key) {
    try {
        localStorage.removeItem(key);
        localStorage.removeItem(`${key}_time`);
    } catch (e) {
        console.error(`❌ Error al borrar simple cache para "${key}"`, e);
    }
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
    const safeData = Array.isArray(data) ? data : []; // Asegura array
    localStorage.setItem(key, JSON.stringify(safeData));
    localStorage.setItem(key + "_time", now.toString());
    memoryCache[key] = { data: safeData, time: now };
    return safeData;
}

export function updateCache(key, newData, lastUpdate = Date.now()) {
    if (!Array.isArray(newData)) {
        console.warn(
            `updateCache: El valor para "${key}" no es un array.`,
            newData
        );
    }
    localStorage.setItem(key, JSON.stringify(newData));
    localStorage.setItem(key + "_time", Date.now().toString());
    localStorage.setItem(key + "_last_update", lastUpdate.toString());
    memoryCache[key] = { data: newData, time: Date.now() };
}

export function appendToCache(key, newItem) {
    const cached =
        memoryCache[key]?.data || JSON.parse(localStorage.getItem(key)) || [];
    const updated = [...cached, newItem];
    const lastUpdate = newItem?.updated_at || Date.now();
    updateCache(key, updated, lastUpdate);
    return updated;
}
export function removeFromCache(key, predicateFn, updated_at = null) {
    let cached = memoryCache[key]?.data;
    if (!Array.isArray(cached)) {
        try {
            cached = JSON.parse(localStorage.getItem(key));
        } catch {
            cached = [];
        }
    }
    const updated = cached.filter((item) => !predicateFn(item));
    updateCache(key, updated, updated_at || Date.now());
    return updated;
}

export function modifyInCache(key, modifyFn, updated_at = null) {
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
    updateCache(key, updated, updated_at || Date.now());
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

    let cache = memoryCache[cacheKey]?.data;
    if (!cache) {
        try {
            cache = JSON.parse(localStorage.getItem(cacheKey)) || [];
        } catch {
            cache = [];
        }
    }

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

    updateCache(cacheKey, updatedCache, Date.now());
}
