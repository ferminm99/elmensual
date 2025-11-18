<template>
    <v-card class="critical-alerts-widget" elevation="2">
        <v-card-title class="d-flex justify-space-between align-center">
            <span class="text-h6 font-weight-semibold"
                >Alertas de talles críticos</span
            >
            <div class="d-flex align-center">
                <v-select
                    v-model="sortBy"
                    :items="sortOptions"
                    item-title="label"
                    item-value="value"
                    class="mr-2"
                    density="compact"
                    hide-details
                    style="max-width: 190px"
                    variant="outlined"
                />
                <v-btn
                    icon
                    variant="text"
                    :loading="loading"
                    @click="fetchAlerts"
                    :disabled="loading"
                    aria-label="Actualizar alertas"
                >
                    <v-icon>mdi-refresh</v-icon>
                </v-btn>
            </div>
        </v-card-title>
        <v-divider />
        <v-card-text>
            <v-alert
                v-if="error"
                type="error"
                class="mb-4"
                border="start"
                variant="tonal"
            >
                {{ error }}
            </v-alert>
            <div v-if="!alerts.length && !loading" class="text-medium-emphasis">
                No hay alertas críticas activas.
            </div>
            <v-skeleton-loader v-else-if="loading" type="table" class="mt-2" />
            <v-table v-else density="comfortable" class="critical-alerts-table">
                <thead>
                    <tr>
                        <th>Artículo</th>
                        <th class="text-center">Talle</th>
                        <th class="text-center">Stock</th>
                        <th class="text-center">Criticidad</th>
                        <th class="text-center">Estado</th>
                        <th>Última detección</th>
                        <th class="text-right">Acciones</th>
                    </tr>
                </thead>
                <tbody>
                    <tr v-for="alert in sortedAlerts" :key="alert.id">
                        <td>
                            <div class="font-weight-medium">
                                {{ alert.articulo.numero }} -
                                {{ alert.articulo.nombre }}
                            </div>
                        </td>
                        <td class="text-center">
                            <v-chip
                                size="small"
                                color="primary"
                                variant="tonal"
                            >
                                {{ alert.talle }}
                            </v-chip>
                        </td>
                        <td class="text-center">
                            <span class="text-error font-weight-bold">{{
                                alert.total_stock
                            }}</span>
                        </td>
                        <td class="text-center">
                            <v-chip
                                size="small"
                                :color="criticidadColor(alert.criticidad)"
                                class="font-weight-medium"
                                variant="flat"
                            >
                                {{ criticidadLabel(alert.criticidad) }}
                            </v-chip>
                        </td>
                        <td class="text-center">
                            <v-chip
                                size="small"
                                :color="estadoColor(alert.estado_reposicion)"
                                variant="tonal"
                                class="text-capitalize"
                            >
                                {{ estadoLabel(alert.estado_reposicion) }}
                            </v-chip>
                        </td>
                        <td>
                            {{ formatFecha(alert.ultimo_detectado_en) }}
                        </td>
                        <td class="text-right">
                            <v-btn
                                size="small"
                                color="deep-purple"
                                variant="flat"
                                :loading="linkingAlertId === alert.id"
                                :disabled="
                                    alert.estado_reposicion ===
                                        'en_reposicion' &&
                                    alert.pedido_referencia
                                "
                                @click="abrirPedidos(alert)"
                            >
                                Gestionar
                                <v-icon end>mdi-open-in-new</v-icon>
                            </v-btn>
                        </td>
                    </tr>
                </tbody>
            </v-table>
        </v-card-text>
    </v-card>
</template>

<script setup>
import { computed, onMounted, ref, watch } from "vue";
import axios from "axios";
import { useRouter } from "vue-router";

const router = useRouter();
const alerts = ref([]);
const loading = ref(false);
const error = ref("");
const sortBy = ref("criticidad");
const linkingAlertId = ref(null);

const sortOptions = [
    { label: "Prioridad", value: "criticidad" },
    { label: "Fecha detección", value: "fecha" },
];

const fetchAlerts = async () => {
    loading.value = true;
    error.value = "";
    try {
        const { data } = await axios.get("/api/alertas/criticas", {
            params: { sort: sortBy.value },
        });
        alerts.value = data;
    } catch (err) {
        console.error("No se pudieron cargar las alertas", err);
        error.value =
            "No se pudieron cargar las alertas de stock crítico. Intenta nuevamente.";
    } finally {
        loading.value = false;
    }
};

onMounted(fetchAlerts);

watch(sortBy, () => {
    fetchAlerts();
});

const sortedAlerts = computed(() => {
    if (sortBy.value === "criticidad") {
        return [...alerts.value].sort((a, b) => {
            if (b.criticidad !== a.criticidad) {
                return b.criticidad - a.criticidad;
            }
            return (
                new Date(b.ultimo_detectado_en ?? 0).getTime() -
                new Date(a.ultimo_detectado_en ?? 0).getTime()
            );
        });
    }

    return [...alerts.value].sort(
        (a, b) =>
            new Date(b.ultimo_detectado_en ?? 0).getTime() -
            new Date(a.ultimo_detectado_en ?? 0).getTime()
    );
});

const criticidadLabel = (nivel) => {
    if (nivel >= 4) return "Crítica";
    if (nivel >= 3) return "Alta";
    if (nivel === 2) return "Media";
    return "Baja";
};

const criticidadColor = (nivel) => {
    if (nivel >= 4) return "red";
    if (nivel >= 3) return "orange";
    if (nivel === 2) return "amber";
    return "green";
};

const estadoColor = (estado) => {
    if (estado === "en_reposicion") return "blue";
    if (estado === "resuelto") return "green";
    return "red";
};

const estadoLabel = (estado) => {
    if (estado === "en_reposicion") return "En reposición";
    if (estado === "resuelto") return "Resuelto";
    return "Sin stock";
};

const formatFecha = (fechaIso) => {
    if (!fechaIso) return "-";
    return new Intl.DateTimeFormat("es-AR", {
        dateStyle: "short",
        timeStyle: "short",
    }).format(new Date(fechaIso));
};

const abrirPedidos = async (alert) => {
    const referencia =
        alert.pedido_referencia || `ALERTA-${alert.id}-${Date.now()}`;
    linkingAlertId.value = alert.id;
    try {
        await axios.post(`/api/alertas/${alert.id}/vincular-pedido`, {
            pedido_referencia: referencia,
        });
        alerts.value = alerts.value.map((item) =>
            item.id === alert.id
                ? {
                      ...item,
                      pedido_referencia: referencia,
                      estado_reposicion: "en_reposicion",
                  }
                : item
        );
        await router.push({
            path: "/managepedidos",
            query: {
                alertId: alert.id,
                articuloId: alert.articulo_id,
                talle: alert.talle,
                pedidoRef: referencia,
            },
        });
    } catch (err) {
        console.error("No se pudo vincular el pedido", err);
        error.value =
            "No se pudo iniciar la gestión del pedido para esta alerta.";
    } finally {
        linkingAlertId.value = null;
    }
};
</script>

<style scoped>
.critical-alerts-widget {
    margin-top: 16px;
}

.critical-alerts-table thead th {
    font-weight: 600;
    color: rgba(0, 0, 0, 0.6);
}

.critical-alerts-table tbody tr:hover {
    background-color: rgba(98, 0, 234, 0.04);
}
</style>
