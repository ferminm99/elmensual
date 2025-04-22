<template>
    <div>
        <!-- Título -->
        <v-row>
            <v-col>
                <h1 class="title font-weight-bold">Gestión de Artículos</h1>
            </v-col>
        </v-row>

        <v-row class="d-flex mb-2">
            <!-- Buscar por nombre -->
            <v-col cols="12" sm="6" md="4">
                <v-text-field
                    v-model="searchNombre"
                    label="Buscar por nombre"
                    dense
                    solo
                    clearable
                ></v-text-field>
            </v-col>

            <!-- Buscar por número -->
            <v-col cols="12" sm="6" md="4">
                <v-text-field
                    v-model="searchNumero"
                    label="Buscar por número"
                    dense
                    solo
                    clearable
                ></v-text-field>
            </v-col>
        </v-row>

        <!-- Botones más juntos en una sola fila -->
        <v-row class="d-flex align-center mb-4">
            <v-col cols="auto">
                <v-btn color="black" @click="openAddDialog">
                    <v-icon left>mdi-plus-box</v-icon> Agregar Artículo
                </v-btn>
            </v-col>
            <v-col cols="auto">
                <v-btn color="primary" @click="recalcularPrecios">
                    <v-icon left>mdi-currency-usd</v-icon> Recalcular Precios
                </v-btn>
            </v-col>
            <v-col cols="auto">
                <v-btn color="green" @click="abrirDialogoAumento">
                    <v-icon left>mdi-percent</v-icon> Aumentar Costos
                </v-btn>
            </v-col>
            <v-col cols="auto">
                <v-btn color="orange" class="ml-2" @click="exportarExcel">
                    <v-icon left>mdi-download</v-icon> Exportar Excel
                </v-btn>
            </v-col>
        </v-row>

        <!-- Tabla -->
        <ResponsiveTable :headers="headers" :items="articulosFiltrados">
            <template #item.actions="{ item }">
                <v-btn flat icon @click="openEditDialog(item)">
                    <v-icon color="black">mdi-pencil-outline</v-icon>
                </v-btn>
                <v-btn flat icon @click="openDeleteConfirm(item)">
                    <v-icon color="black">mdi-trash-can-outline</v-icon>
                </v-btn>
            </template>
        </ResponsiveTable>

        <!-- Dialogos existentes (agregar/editar/eliminar) -->
        <!-- ... (los dejás como ya están) ... -->

        <!-- Diálogo de aumento por porcentaje -->
        <v-dialog v-model="dialogoAumento" max-width="400px">
            <v-card>
                <v-card-title> Aumentar Costos Originales </v-card-title>
                <v-card-text>
                    <v-text-field
                        v-model="porcentajeAumento"
                        label="Porcentaje de aumento (%)"
                        type="number"
                        required
                    ></v-text-field>
                </v-card-text>
                <v-card-actions>
                    <v-btn text @click="dialogoAumento = false">Cancelar</v-btn>
                    <v-btn color="green" text @click="aumentarCostos">
                        Aplicar
                    </v-btn>
                </v-card-actions>
            </v-card>
        </v-dialog>

        <!-- Diálogo para agregar/editar artículos -->
        <v-dialog v-model="dialog" max-width="600px">
            <v-card>
                <v-card-title class="d-flex justify-space-between align-center">
                    {{ isEdit ? "Editar" : "Agregar" }} Artículo
                    <v-btn flat icon @click="dialog = false">
                        <v-icon color="red">mdi-close</v-icon>
                    </v-btn>
                </v-card-title>
                <v-card-text>
                    <v-form>
                        <v-text-field
                            v-model="form.numero"
                            label="Número de Artículo"
                            required
                        ></v-text-field>
                        <v-text-field
                            v-model="form.nombre"
                            label="Nombre de Artículo"
                            required
                        ></v-text-field>
                        <v-text-field
                            v-model="form.precio"
                            label="Precio"
                            type="number"
                            required
                        ></v-text-field>
                        <v-text-field
                            v-model="form.costo_original"
                            label="Costo Original"
                            type="number"
                            required
                        ></v-text-field>
                    </v-form>
                </v-card-text>
                <v-card-actions>
                    <v-btn text @click="dialog = false">Cancelar</v-btn>
                    <v-btn color="black" text @click="saveArticulo">
                        {{ isEdit ? "Guardar" : "Agregar" }}
                    </v-btn>
                </v-card-actions>
            </v-card>
        </v-dialog>

        <!-- Diálogo de confirmación para eliminar artículo -->
        <v-dialog v-model="confirmDeleteDialog" max-width="400px">
            <v-card>
                <v-card-title class="headline"
                    >¿Eliminar artículo?</v-card-title
                >
                <v-card-text>
                    ¿Estás seguro de que querés eliminar el artículo
                    <strong>{{ articuloAEliminar?.nombre }}</strong
                    >? Esta acción no se puede deshacer.
                </v-card-text>
                <v-card-actions>
                    <v-spacer />
                    <v-btn text @click="confirmDeleteDialog = false"
                        >Cancelar</v-btn
                    >
                    <v-btn color="red" text @click="deleteArticulo"
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
    updateCache,
    appendToCache,
    removeFromCache,
    modifyInCache,
    getMemoryCache,
} from "@/utils/cacheFetch";
import { onCacheChange, notifyCacheChange } from "@/utils/cacheEvents";
import ExcelJS from "exceljs";
import { ARTICULOS_KEY } from "@/utils/cacheKeys";

export default {
    data() {
        return {
            loading: false,
            dialog: false,
            dialogoAumento: false,
            confirmDeleteDialog: false,
            isEdit: false,
            articuloAEliminar: null,
            porcentajeAumento: 0,
            searchNombre: "",
            searchNumero: "",
            form: {
                id: null,
                numero: "",
                nombre: "",
                precio: 0,
                costo_original: 0,
            },
            articulos: [],
            headers: [
                { title: "Número", key: "numero" },
                { title: "Nombre", key: "nombre" },
                { title: "Precio", key: "precio" },
                { title: "Costo Original", key: "costo_original" },
                { title: "Efectivo", key: "precio_efectivo" },
                { title: "Transferencia", key: "precio_transferencia" },
                {
                    title: "Acciones",
                    key: "actions",
                    align: "center",
                    sortable: false,
                },
            ],
        };
    },
    computed: {
        articulosFiltrados() {
            const normalizar = (str) =>
                str?.toLowerCase().normalize("NFD").replace(/[̀-ͯ]/g, "");
            const textoNombre = normalizar(this.searchNombre.trim());
            const textoNumero = normalizar(this.searchNumero.trim());
            return this.articulos.filter((art) => {
                const nombre = normalizar(art.nombre);
                const numero = normalizar(String(art.numero));
                return (
                    (!textoNombre || nombre.includes(textoNombre)) &&
                    (!textoNumero || numero.includes(textoNumero))
                );
            });
        },
    },
    created() {
        const cache = getMemoryCache(ARTICULOS_KEY, 86400);
        if (cache) {
            this.articulos = cache;
        } else {
            this.fetchArticulos();
        }

        onCacheChange((key) => {
            if (key === ARTICULOS_KEY) {
                console.log("🔁 Recargando artículos desde otro componente");
                this.fetchArticulos();
            }
        });
    },
    beforeUnmount() {
        window.removeEventListener("notifyCacheChange", this.handleCacheSync);
    },
    methods: {
        async fetchArticulos() {
            this.loading = true;
            try {
                const data = await cachedFetch(
                    ARTICULOS_KEY,
                    () => axios.get("/api/articulos").then((res) => res.data),
                    { ttl: 86400 }
                );

                this.articulos = Array.isArray(data) ? data : [];
            } catch (error) {
                console.error("Error al cargar los artículos:", error);
                this.articulos = []; // fallback para evitar romper la app
            } finally {
                this.loading = false;
            }
        },
        openAddDialog() {
            this.isEdit = false;
            this.form = {
                id: null,
                numero: "",
                nombre: "",
                precio: 0,
                costo_original: 0,
            };
            this.dialog = true;
        },
        openEditDialog(item) {
            this.isEdit = true;
            this.form = { ...item };
            this.dialog = true;
        },
        saveArticulo() {
            if (!this.validateForm()) return;
            this.loading = true;
            this.form.precio = parseInt(this.form.precio);
            this.form.costo_original = parseInt(this.form.costo_original);

            const req = this.isEdit
                ? axios.put(`/api/articulo/${this.form.id}`, this.form)
                : axios.post("/api/articulo", this.form);

            req.then((res) => {
                if (this.isEdit) {
                    this.articulos = modifyInCache(ARTICULOS_KEY, (articulos) =>
                        articulos.map((a) =>
                            a.id === this.form.id ? { ...this.form } : a
                        )
                    );
                } else {
                    // res.data.articulo porque es como lo devuelve el backend
                    this.articulos = appendToCache(
                        ARTICULOS_KEY,
                        res.data.articulo
                    );
                }
                notifyCacheChange(ARTICULOS_KEY);
                this.dialog = false;
                this.loading = false;
            }).catch((err) => {
                this.loading = false;
                if (err.response?.status === 422) {
                    alert("❌ Ya existe un artículo con ese número.");
                } else {
                    console.error("❌ Error inesperado:", err);
                    alert("Ocurrió un error al guardar el artículo.");
                }
            });
        },
        openDeleteConfirm(item) {
            this.articuloAEliminar = item;
            this.confirmDeleteDialog = true;
        },
        deleteArticulo() {
            this.loading = true;
            axios
                .delete(`/api/articulo/${this.articuloAEliminar.id}`)
                .then(() => {
                    this.articulos = removeFromCache(
                        ARTICULOS_KEY,
                        (a) => a.id === this.articuloAEliminar.id
                    );
                    notifyCacheChange(ARTICULOS_KEY);
                    this.confirmDeleteDialog = false;
                    this.loading = false;
                });
        },
        recalcularPrecios() {
            this.loading = true;
            axios.put("/api/articulos/recalcular-precios").then((res) => {
                this.articulos = res.data;
                updateCache(ARTICULOS_KEY, res.data);
                notifyCacheChange(ARTICULOS_KEY);
                this.loading = false;
                alert("Precios recalculados correctamente.");
            });
        },
        abrirDialogoAumento() {
            this.porcentajeAumento = 0;
            this.dialogoAumento = true;
        },
        aumentarCostos() {
            this.loading = true;
            axios
                .put("/api/articulos/aumentar-costos", {
                    porcentaje: this.porcentajeAumento,
                })
                .then((res) => {
                    this.articulos = res.data;
                    updateCache(ARTICULOS_KEY, res.data);
                    notifyCacheChange(ARTICULOS_KEY);
                    this.dialogoAumento = false;
                    this.loading = false;
                    alert("Costos actualizados correctamente.");
                });
        },
        async exportarExcel() {
            this.loading = true;
            const workbook = new ExcelJS.Workbook();
            const worksheet = workbook.addWorksheet("Artículos");

            worksheet.columns = [
                { header: "Número", key: "numero", width: 15 },
                { header: "Nombre", key: "nombre", width: 40 },
                { header: "Precio", key: "precio", width: 15 },
                { header: "Costo Original", key: "costo_original", width: 20 },
                { header: "Efectivo", key: "efectivo", width: 15 },
                { header: "Transferencia", key: "transferencia", width: 20 },
            ];

            this.articulosFiltrados.forEach((item) => {
                worksheet.addRow({
                    numero: item.numero,
                    nombre: item.nombre,
                    precio: item.precio,
                    costo_original: item.costo_original,
                    efectivo: item.precio_efectivo,
                    transferencia: item.precio_transferencia,
                });
            });

            const buffer = await workbook.xlsx.writeBuffer();
            const blob = new Blob([buffer], {
                type: "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet",
            });
            const link = document.createElement("a");
            link.href = URL.createObjectURL(blob);
            link.download = "articulos.xlsx";
            link.click();
            this.loading = false;
        },
        validateForm() {
            if (!this.form.numero || String(this.form.numero).trim() === "")
                return false;
            if (!this.form.nombre || this.form.nombre.trim() === "")
                return false;
            if (!this.form.precio || isNaN(this.form.precio)) return false;
            if (!this.form.costo_original || isNaN(this.form.costo_original))
                return false;
            return true;
        },
    },
};
</script>

<style scoped>
@media (max-width: 768px) {
    h1.title {
        font-size: 24px !important;
        margin-bottom: 16px;
    }

    .v-text-field,
    .v-select {
        font-size: 18px;
    }

    .v-btn {
        font-size: 18px;
        min-height: 44px;
    }

    .v-btn .v-icon {
        font-size: 20px;
    }

    .mb-4 .v-col[cols="auto"] {
        width: 100% !important;
        margin-bottom: 12px;
    }

    .mb-4 .v-col,
    .mb-4 .v-col-auto {
        width: 100% !important;
        margin-bottom: 12px;
    }

    .mb-4 .v-btn {
        width: 100% !important;
        justify-content: center;
    }

    .v-dialog .v-card-title {
        font-size: 20px;
        font-weight: bold;
    }

    .v-dialog .v-text-field {
        font-size: 18px;
    }

    .v-card-actions .v-btn {
        font-size: 18px;
    }
}
</style>
