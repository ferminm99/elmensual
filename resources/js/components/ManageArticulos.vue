<template>
    <div>
        <!-- Título -->
        <v-row>
            <v-col>
                <h1 class="title font-weight-bold">Gestión de Artículos</h1>
            </v-col>
        </v-row>
        <!-- Botón para agregar artículos -->
        <v-row class="d-flex align-center mb-4">
            <v-btn color="black" class="ml-3" @click="openAddDialog">
                <v-icon left>mdi-plus-box</v-icon> Agregar Artículo
            </v-btn>
        </v-row>

        <!-- Tabla para listar artículos -->
        <v-data-table
            :headers="headers"
            :items="articulos"
            class="elevation-1 mt-2"
            dense
        >
            <template v-slot:item.actions="{ item }">
                <v-btn flat icon @click="openEditDialog(item)">
                    <v-icon color="black">mdi-pencil-outline</v-icon>
                </v-btn>
                <v-btn flat icon @click="openDeleteConfirm(item)">
                    <v-icon color="black">mdi-trash-can-outline</v-icon>
                </v-btn>
            </template>
        </v-data-table>

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
                    <v-btn color="black" text @click="saveArticulo">{{
                        isEdit ? "Guardar" : "Agregar"
                    }}</v-btn>
                </v-card-actions>
            </v-card>
        </v-dialog>

        <!-- Diálogo de confirmación para eliminar -->
        <v-dialog v-model="confirmDeleteDialog" max-width="400px">
            <v-card>
                <v-card-title class="d-flex justify-space-between align-center"
                    >Confirmar eliminación<v-btn
                        flat
                        icon
                        @click="confirmDeleteDialog = false"
                    >
                        <v-icon color="red">mdi-close</v-icon>
                    </v-btn></v-card-title
                >
                <v-card-text>
                    ¿Estás seguro de que deseas eliminar el artículo
                    {{ articuloAEliminar.nombre }}?
                </v-card-text>
                <v-card-actions>
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
</template>

<script>
export default {
    data() {
        return {
            dialog: false,
            confirmDeleteDialog: false,
            isEdit: false,
            articuloAEliminar: null,
            form: {
                id: null,
                numero: "",
                nombre: "",
                precio: 0,
                costo_original: 0,
            },
            articulos: [], // Lista de artículos
            headers: [
                { title: "Número", key: "numero" },
                { title: "Nombre", key: "nombre" },
                { title: "Precio", key: "precio" },
                { title: "Costo Original", key: "costo_original" },
                {
                    title: "Acciones",
                    key: "actions",
                    align: "center",
                    sortable: false,
                },
            ],
        };
    },
    created() {
        this.fetchArticulos();
    },
    methods: {
        fetchArticulos() {
            // Simulación de la solicitud HTTP
            axios.get("/articulos").then((response) => {
                this.articulos = response.data;
            });
        },
        openAddDialog() {
            this.isEdit = false;
            this.form = {
                id: null,
                numero: "",
                nombre: "",
                precio: 0,
                costo_original: 0,
            }; // Limpiar el formulario
            this.dialog = true;
        },
        openEditDialog(item) {
            this.isEdit = true;
            this.form = { ...item }; // Cargar los datos del artículo a editar
            this.dialog = true;
        },
        saveArticulo() {
            if (!this.validateForm()) {
                console.log("ASD");
                this.snackbarText =
                    "Por favor completa todos los campos obligatorios.";
                this.snackbar = true;
                return;
            }

            this.form.precio = parseInt(this.form.precio);
            this.form.costo_original = parseInt(this.form.costo_original);

            if (this.isEdit) {
                axios.put(`/articulo/${this.form.id}`, this.form).then(() => {
                    this.fetchArticulos();
                    this.dialog = false;
                });
            } else {
                axios.post("/articulo", this.form).then(() => {
                    this.fetchArticulos();
                    this.dialog = false;
                });
            }
        },
        openDeleteConfirm(item) {
            this.articuloAEliminar = item;
            this.confirmDeleteDialog = true;
        },
        deleteArticulo() {
            axios.delete(`/articulo/${this.articuloAEliminar.id}`).then(() => {
                this.fetchArticulos();
                this.confirmDeleteDialog = false;
            });
        },
        // Método de validación
        validateForm() {
            if (!this.form.numero || String(this.form.numero).trim() === "") {
                alert("Por favor ingresa el número de artículo.");
                return false;
            }
            if (!this.form.nombre || this.form.nombre.trim() === "") {
                alert("Por favor ingresa el nombre del artículo.");
                return false;
            }
            if (!this.form.precio || isNaN(this.form.precio)) {
                alert("Por favor ingresa un precio válido.");
                return false;
            }
            if (!this.form.costo_original || isNaN(this.form.costo_original)) {
                alert("Por favor ingresa un costo original válido.");
                return false;
            }

            return true; // Todo está correcto
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
</style>
