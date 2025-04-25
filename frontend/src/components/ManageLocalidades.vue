<template>
    <div>
        <v-row class="mb-3 acciones-localidad">
            <v-col cols="12" md="4">
                <v-text-field
                    v-model="search"
                    label="Buscar localidad"
                    solo
                    dense
                    clearable
                ></v-text-field>
            </v-col>
            <v-col cols="12" md="auto">
                <v-btn color="primary" block @click="openDialog">
                    Agregar Localidad
                </v-btn>
            </v-col>
            <v-col cols="12" md="auto">
                <v-btn color="orange" block @click="exportarExcel">
                    <v-icon left>mdi-download</v-icon> Exportar Excel
                </v-btn>
            </v-col>
        </v-row>

        <ResponsiveTable
            :headers="headers"
            :items="localidadesFiltradas"
            :search="search"
        >
            <template #item.disponibilidad="{ item }">
                <v-chip
                    :color="
                        item.disponibilidad
                            ? 'green lighten-4'
                            : 'red lighten-4'
                    "
                >
                    <v-icon left>{{
                        item.disponibilidad
                            ? "mdi-check-circle"
                            : "mdi-close-circle"
                    }}</v-icon>
                    {{ item.disponibilidad ? "Disponible" : "No disponible" }}
                </v-chip>
            </template>

            <template #item.actions="{ item }">
                <v-btn icon @click="editLocalidad(item)">
                    <v-icon>mdi-pencil</v-icon>
                </v-btn>
                <v-btn icon @click="openDeleteConfirm(item)">
                    <v-icon color="red">mdi-delete</v-icon>
                </v-btn>
            </template>
        </ResponsiveTable>

        <v-dialog v-model="dialog" max-width="500px">
            <v-card>
                <v-card-title
                    >{{ isEdit ? "Editar" : "Agregar" }} Localidad</v-card-title
                >
                <v-card-text>
                    <v-text-field
                        v-model="form.nombre"
                        label="Nombre"
                    ></v-text-field>
                    <v-switch
                        v-model="form.disponibilidad"
                        label="Disponible"
                    ></v-switch>
                </v-card-text>
                <v-card-actions>
                    <v-btn text @click="dialog = false">Cancelar</v-btn>
                    <v-btn color="primary" @click="saveLocalidad"
                        >Guardar</v-btn
                    >
                </v-card-actions>
            </v-card>
        </v-dialog>

        <v-dialog v-model="confirmDeleteDialog" max-width="400">
            <v-card>
                <v-card-title class="text-h6"
                    >¿Eliminar Localidad?</v-card-title
                >
                <v-card-actions>
                    <v-spacer />
                    <v-btn text @click="confirmDeleteDialog = false"
                        >Cancelar</v-btn
                    >
                    <v-btn color="red" text @click="confirmarEliminacion"
                        >Eliminar</v-btn
                    >
                </v-card-actions>
            </v-card>
        </v-dialog>
    </div>
    <v-overlay
        :model-value="loading"
        class="d-flex align-center justify-center"
        persistent
    >
        <v-progress-circular
            indeterminate
            size="64"
            width="6"
            color="primary"
        />
    </v-overlay>
</template>

<script>
import {
    cachedFetch,
    appendToCache,
    modifyInCache,
    removeFromCache,
    getMemoryCache,
} from "@/utils/cacheFetch";
import { onCacheChange, notifyCacheChange } from "@/utils/cacheEvents";
import { LOCALIDADES_KEY } from "@/utils/cacheKeys";
import ExcelJS from "exceljs";
import ResponsiveTable from "./components/ResponsiveTable.vue";
import { useSyncedCache } from "@/utils/useSyncedCache";

function normalize(text) {
    // text = text.toString();
    if (!text) return "";
    return text
        .normalize("NFD")
        .replace(/[\u0300-\u036f]/g, "")
        .toLowerCase();
}

export default {
    components: {
        ResponsiveTable,
    },
    data() {
        return {
            loading: false,
            dialog: false,
            confirmDeleteDialog: false,
            isEdit: false,
            localidadAEliminar: null,
            localidades: [],
            search: "",
            form: {
                id: null,
                nombre: "",
                disponibilidad: false,
            },
            headers: [
                { title: "Nombre", key: "nombre" },
                { title: "Disponibilidad", key: "disponibilidad" },
                {
                    title: "Acciones",
                    key: "actions",
                    sortable: false,
                    align: "end",
                },
            ],
        };
    },
    computed: {
        localidadesFiltradas() {
            const palabras = normalize(this.search).split(" ").filter(Boolean);
            return this.localidades.filter((loc) =>
                palabras.every((p) => normalize(loc.nombre).includes(p))
            );
        },
    },
    mounted() {
        window.addEventListener("notifyCacheChange", this.handleCacheSync);

        useSyncedCache({
            key: LOCALIDADES_KEY,
            apiPath: "/localidades/actualizados-desde",
            fetchFn: () =>
                axios.get("/api/localidades").then((res) => res.data),
            onData: (data) => (this.localidades = data),
            setLoading: (val) => (this.loading = val),
        });
    },

    beforeUnmount() {
        window.removeEventListener("notifyCacheChange", this.handleCacheSync);
    },

    methods: {
        handleCacheSync(e) {
            if (e.detail === LOCALIDADES_KEY) {
                this.fetchLocalidades(); // actualiza si se recibe evento externo
            }
        },

        async fetchLocalidades() {
            this.localidades = await cachedFetch(
                LOCALIDADES_KEY,
                () => axios.get("/api/localidades").then((r) => r.data),
                { ttl: 86400 }
            );
        },
        openDialog() {
            this.isEdit = false;
            this.form = { id: null, nombre: "", disponibilidad: false };
            this.dialog = true;
        },
        editLocalidad(item) {
            this.isEdit = true;
            this.form = { ...item };
            this.dialog = true;
        },
        openDeleteConfirm(item) {
            this.localidadAEliminar = item;
            this.confirmDeleteDialog = true;
        },
        saveLocalidad() {
            this.loading = true;
            const req = this.isEdit
                ? axios.put(`/api/localidad/${this.form.id}`, this.form)
                : axios.post("/api/localidad", this.form);

            req.then((res) => {
                const nueva = this.isEdit ? this.form : res.data.localidad;

                if (this.isEdit) {
                    this.localidades = modifyInCache(LOCALIDADES_KEY, (list) =>
                        list.map((l) => (l.id === nueva.id ? nueva : l))
                    );
                } else {
                    this.localidades = appendToCache(LOCALIDADES_KEY, nueva);
                }
                notifyCacheChange(LOCALIDADES_KEY);
                this.dialog = false;
                this.loading = false;
            });
        },

        confirmarEliminacion() {
            this.loading = true;
            axios
                .delete(`/api/localidad/${this.localidadAEliminar.id}`)
                .then(() => {
                    this.localidades = removeFromCache(
                        LOCALIDADES_KEY,
                        (l) => l.id === this.localidadAEliminar.id
                    );
                    notifyCacheChange(LOCALIDADES_KEY);
                    this.confirmDeleteDialog = false;
                    this.loading = false;
                });
        },
        async exportarExcel() {
            this.loading = true;
            const workbook = new ExcelJS.Workbook();
            const sheet = workbook.addWorksheet("Localidades");
            sheet.columns = [
                { header: "Nombre", key: "nombre", width: 30 },
                { header: "Disponibilidad", key: "disponibilidad", width: 20 },
            ];

            this.localidadesFiltradas.forEach((loc) => {
                sheet.addRow({
                    nombre: loc.nombre,
                    disponibilidad: loc.disponibilidad ? "Sí" : "No",
                });
            });

            const buffer = await workbook.xlsx.writeBuffer();
            const blob = new Blob([buffer], {
                type: "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet",
            });
            this.loading = false;
            const link = document.createElement("a");
            link.href = URL.createObjectURL(blob);
            link.download = "localidades.xlsx";
            link.click();
        },
    },
};
</script>

<style scoped>
.v-chip {
    font-weight: 500;
    border-radius: 20px;
}
@media (max-width: 768px) {
    .acciones-localidad .v-col {
        margin-bottom: 12px;
    }

    .acciones-localidad .v-btn {
        width: 100%;
        justify-content: center;
    }

    .acciones-localidad .v-icon {
        font-size: 20px;
    }
}
</style>
