<template>
    <div>
        <!-- Título -->
        <v-row>
            <v-col>
                <h1 class="title font-weight-bold">Gestión de Clientes</h1>
            </v-col>
        </v-row>

        <!-- Buscador -->
        <v-row class="mb-4">
            <v-col>
                <v-text-field
                    v-model="search"
                    label="Buscar Cliente"
                    append-icon="mdi-magnify"
                    single-line
                    hide-details
                    variant="solo"
                ></v-text-field>
            </v-col>
        </v-row>

        <!-- Botón para agregar clientes -->
        <v-row class="d-flex align-center mb-4 botones-clientes">
            <v-col cols="12" sm="auto">
                <v-btn color="black" block @click="openAddDialog">
                    <v-icon left>mdi-plus-box</v-icon> Agregar Cliente
                </v-btn>
            </v-col>
        </v-row>

        <!-- Tabla para listar clientes -->
        <ResponsiveTable :headers="headers" :items="clientes" :search="search">
            <template #item.totalVentas="{ item }">
                <span>{{ item.totalVentas || 0 }}</span>
            </template>

            <template #item.totalPago="{ item }">
                <span>${{ formatCurrency(item.totalPago || 0) }}</span>
            </template>

            <template #item.actions="{ item }">
                <v-btn flat icon @click="openEditDialog(item)">
                    <v-icon color="black">mdi-pencil-outline</v-icon>
                </v-btn>
                <v-btn flat icon @click="openDeleteConfirm(item)">
                    <v-icon color="black">mdi-trash-can-outline</v-icon>
                </v-btn>
            </template>
        </ResponsiveTable>

        <!-- Diálogo para agregar/editar clientes -->
        <v-dialog v-model="dialog" max-width="600px">
            <v-card>
                <v-card-title class="d-flex justify-space-between align-center">
                    {{ isEdit ? "Editar" : "Agregar" }} Cliente
                    <v-btn flat icon @click="dialog = false">
                        <v-icon color="red">mdi-close</v-icon>
                    </v-btn>
                </v-card-title>
                <v-card-text>
                    <v-form ref="formCliente" v-model="valid" lazy-validation>
                        <v-text-field
                            v-model="form.nombre"
                            label="Nombre"
                            required
                            :rules="[(v) => !!v || 'Nombre es requerido']"
                        ></v-text-field>
                        <v-text-field
                            v-model="form.apellido"
                            label="Apellido"
                            required
                            :rules="[(v) => !!v || 'Apellido es requerido']"
                        ></v-text-field>
                        <v-text-field
                            v-model="form.cuit"
                            label="CUIT"
                        ></v-text-field>
                        <v-text-field
                            v-model="form.cbu"
                            label="CBU"
                        ></v-text-field>
                    </v-form>
                </v-card-text>
                <v-card-actions>
                    <v-btn text @click="dialog = false">Cancelar</v-btn>
                    <v-btn color="black" text @click="saveCliente">{{
                        isEdit ? "Guardar" : "Agregar"
                    }}</v-btn>
                </v-card-actions>
            </v-card>
        </v-dialog>

        <!-- Diálogo de confirmación para eliminar -->
        <v-dialog v-model="confirmDeleteDialog" max-width="400px">
            <v-card>
                <v-card-title class="d-flex justify-space-between align-center">
                    Confirmar eliminación
                    <v-btn flat icon @click="confirmDeleteDialog = false">
                        <v-icon color="red">mdi-close</v-icon>
                    </v-btn>
                </v-card-title>
                <v-card-text>
                    ¿Estás seguro de que deseas eliminar al cliente
                    {{ clienteAEliminar.nombre }}
                    {{ clienteAEliminar.apellido }}?
                </v-card-text>
                <v-card-actions>
                    <v-btn text @click="confirmDeleteDialog = false"
                        >Cancelar</v-btn
                    >
                    <v-btn color="red" text @click="deleteCliente"
                        >Eliminar</v-btn
                    >
                </v-card-actions>
            </v-card>
        </v-dialog>
    </div>
</template>

<script>
import {
    cachedFetch,
    getMemoryCache,
    appendToCache,
    removeFromCache,
    modifyInCache,
    updateCache,
} from "@/utils/cacheFetch";
import { onCacheChange, notifyCacheChange } from "@/utils/cacheEvents";
import { CLIENTES_KEY, VENTAS_KEY } from "@/utils/cacheKeys"; // si querés ser prolijo
import { useSyncedCache } from "@/utils/useSyncedCache";

export default {
    data() {
        return {
            dialog: false,
            confirmDeleteDialog: false,
            isEdit: false,
            clienteAEliminar: null,
            search: "",
            valid: true,
            form: {
                id: null,
                nombre: "",
                apellido: "",
                cuit: "",
                cbu: "",
            },
            ventas: [],
            clientes: [],
            datosCargados: {
                clientes: false,
                ventas: false,
            },
            headers: [
                { title: "Nombre", key: "nombre", sortable: true },
                { title: "Apellido", key: "apellido", sortable: true },
                { title: "CUIT", key: "cuit", sortable: true },
                { title: "CBU", key: "cbu" },
                { title: "Total Ventas", key: "totalVentas", sortable: true },
                { title: "Total Pagado", key: "totalPago", sortable: true },
                {
                    title: "Acciones",
                    key: "actions",
                    align: "center",
                    sortable: false,
                },
            ],
        };
    },
    mounted() {
        this.loading = true;
        window.addEventListener("notifyCacheChange", this.cacheListener);

        Promise.all([
            useSyncedCache({
                key: CLIENTES_KEY,
                apiPath: "/clientes/actualizados-desde",
                fetchFn: () =>
                    axios.get("/api/clientes/listar").then((r) => r.data),
                onData: (data) => {
                    this.clientes = data;
                    this.datosCargados.clientes = true;
                    this.verificarYCalcularTotales();
                },
                setLoading: (val) => (this.loading = val),
            }),
            useSyncedCache({
                key: VENTAS_KEY,
                apiPath: "/ventas/actualizadas-desde",
                fetchFn: () =>
                    axios.get("/api/ventas/listar").then((r) => r.data),
                onData: (data) => {
                    this.ventas = data;
                    this.datosCargados.ventas = true;
                    this.verificarYCalcularTotales();
                },
            }),
        ]);
    },

    beforeUnmount() {
        window.removeEventListener("notifyCacheChange", this.cacheListener);
    },

    methods: {
        cacheListener(e) {
            if (e?.detail?.key === CLIENTES_KEY) {
                this.fetchClientes();
            }
        },

        async fetchClientes() {
            this.clientes = await cachedFetch(
                CLIENTES_KEY,
                () => axios.get("/api/clientes/listar").then((r) => r.data),
                { ttl: 86400 }
            );
            this.datosCargados.clientes = true;
            this.verificarYCalcularTotales();
        },
        async fetchVentas() {
            this.ventas = await cachedFetch(
                VENTAS_KEY,
                () => axios.get("/api/ventas/listar").then((r) => r.data),
                { ttl: 86400 }
            );
            this.datosCargados.ventas = true;
            this.verificarYCalcularTotales();
        },
        verificarYCalcularTotales() {
            if (this.datosCargados.clientes && this.datosCargados.ventas) {
                this.calculateTotals();
            }
        },
        calculateTotals() {
            this.clientes.forEach((cliente) => {
                cliente.totalVentas = 0;
                cliente.totalPago = 0;
            });

            this.ventas.forEach((venta) => {
                const cliente = this.clientes.find(
                    (c) => c.id === venta.cliente_id
                );
                if (cliente) {
                    cliente.totalVentas += 1;
                    cliente.totalPago += parseFloat(venta.precio || 0);
                }
            });
        },
        formatCurrency(value) {
            return value.toLocaleString("es-AR", {
                minimumFractionDigits: 2,
                maximumFractionDigits: 2,
            });
        },
        openAddDialog() {
            this.isEdit = false;
            this.form = {
                id: null,
                nombre: "",
                apellido: "",
                cuit: "",
                cbu: "",
            };
            this.dialog = true;
        },
        openEditDialog(item) {
            this.isEdit = true;
            this.form = { ...item };
            this.dialog = true;
        },
        saveCliente() {
            if (!this.form.nombre || !this.form.apellido) {
                alert("Por favor ingresa nombre y apellido.");
                return;
            }

            this.form.nombre = this.capitalizarPalabras(this.form.nombre);
            this.form.apellido = this.capitalizarPalabras(this.form.apellido);

            if (this.isEdit) {
                axios
                    .put(`/api/cliente/${this.form.id}`, this.form)
                    .then(() => {
                        this.clientes = modifyInCache(
                            CLIENTES_KEY,
                            (clientes) =>
                                clientes.map((c) =>
                                    c.id === this.form.id ? { ...this.form } : c
                                )
                        );
                        notifyCacheChange(CLIENTES_KEY);
                        this.calculateTotals();
                        this.dialog = false;
                    });
            } else {
                axios.post("/api/cliente", this.form).then((res) => {
                    this.clientes = appendToCache(CLIENTES_KEY, res.data);
                    notifyCacheChange(CLIENTES_KEY);
                    this.calculateTotals();
                    this.dialog = false;
                });
            }
        },
        openDeleteConfirm(item) {
            this.clienteAEliminar = item;
            this.confirmDeleteDialog = true;
        },
        deleteCliente() {
            axios
                .delete(`/api/cliente/${this.clienteAEliminar.id}`)
                .then(() => {
                    this.clientes = removeFromCache(
                        CLIENTES_KEY,
                        (c) => c.id === this.clienteAEliminar.id
                    );
                    notifyCacheChange(CLIENTES_KEY);
                    this.calculateTotals();
                    this.confirmDeleteDialog = false;
                })
                .catch((error) => {
                    alert(
                        "No se pudo eliminar el cliente. Probablemente ya fue eliminado."
                    );
                    console.error(error);
                });
        },
        capitalizarPalabras(texto) {
            return texto
                .toLowerCase()
                .split(" ")
                .map(
                    (palabra) =>
                        palabra.charAt(0).toUpperCase() + palabra.slice(1)
                )
                .join(" ");
        },
    },
};
</script>

<style scoped>
@import url("https://fonts.googleapis.com/css2?family=Nunito:wght@300;400;600;700&display=swap");
* {
    font-family: "Nunito", sans-serif;
}
.v-btn {
    background-color: transparent;
    color: black;
}

.v-btn:hover {
    background-color: #f5f5f5;
}

.v-btn.outlined {
    border: 1px solid #ccc;
    background-color: white;
}

.v-btn.outlined:hover {
    background-color: #f5f5f5;
}

.v-icon {
    color: #555;
}

.v-icon:hover {
    color: black;
}

.v-data-table {
    border: 1px solid #e0e0e0;
    border-radius: 4px;
}

.v-data-table-header th {
    font-weight: bold;
    color: #555;
}

.v-data-table-header th,
.v-data-table-row td {
    padding: 8px;
}

.v-data-table-row td {
    font-size: 14px;
}

.v-card-title {
    font-size: 24px;
}
@media (max-width: 768px) {
    h1.title {
        font-size: 24px !important;
        margin-bottom: 16px;
    }

    .v-text-field {
        font-size: 18px;
    }

    .v-btn {
        font-size: 18px;
        min-height: 44px;
        width: 100% !important;
        justify-content: center;
    }

    .botones-clientes .v-col {
        width: 100% !important;
        margin-bottom: 12px;
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
