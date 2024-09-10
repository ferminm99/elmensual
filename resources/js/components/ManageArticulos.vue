<template>
    <v-container>
        <!-- Botón para agregar artículos -->
        <v-btn color="primary" @click="openAddDialog">Agregar Artículo</v-btn>

        <!-- Tabla para listar artículos -->
        <v-data-table :headers="headers" :items="articulos" class="elevation-1">
            <template v-slot:item.actions="{ item }">
                <v-btn icon @click="openEditDialog(item)">
                    <v-icon color="blue">mdi-pencil</v-icon>
                </v-btn>
                <v-btn icon @click="openDeleteConfirm(item)">
                    <v-icon color="red">mdi-trash-can</v-icon>
                </v-btn>
            </template>
        </v-data-table>

        <!-- Diálogo para agregar/editar artículos -->
        <v-dialog v-model="dialog" max-width="600px">
            <v-card>
                <v-card-title class="d-flex justify-space-between">
                    <span class="headline"
                        >{{ isEdit ? "Editar" : "Agregar" }} Artículo</span
                    >
                    <v-spacer></v-spacer>
                    <v-btn icon @click="dialog = false">
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
                            label="Costo original"
                            type="number"
                            required
                        ></v-text-field>
                    </v-form>
                </v-card-text>
                <v-card-actions>
                    <v-btn text @click="dialog = false">Cancelar</v-btn>
                    <v-btn text @click="saveArticulo">{{
                        isEdit ? "Guardar" : "Agregar"
                    }}</v-btn>
                </v-card-actions>
            </v-card>
        </v-dialog>

        <!-- Diálogo de confirmación para eliminar -->
        <v-dialog v-model="confirmDeleteDialog" max-width="400px">
            <v-card>
                <v-card-title>Confirmar eliminación</v-card-title>
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
    </v-container>
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
            },
            articulos: [], // Lista de artículos
            headers: [
                { title: "Número", key: "numero" },
                { title: "Nombre", key: "nombre" },
                { title: "Precio", key: "precio" },
                { title: "Costo original", key: "costo_original" },
                { title: "Acciones", key: "actions", align: "center" },
            ],
        };
    },
    created() {
        this.fetchArticulos();
    },
    methods: {
        fetchArticulos() {
            axios
                .get("/articulos")
                .then((response) => {
                    this.articulos = response.data;
                })
                .catch((error) => {
                    console.error(error);
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
            if (this.isEdit) {
                axios
                    .put(`/articulo/${this.form.id}`, {
                        numero: this.form.numero,
                        nombre: this.form.nombre,
                        precio: this.form.precio,
                        costo_original: this.form.costo_original,
                    })
                    .then((response) => {
                        console.log(response.data.message);
                        this.fetchArticulos(); // Actualiza la lista de artículos
                        this.dialog = false;
                    })
                    .catch((error) => {
                        console.error(error);
                    });
            } else {
                axios
                    .post("/articulo", {
                        numero: this.form.numero,
                        nombre: this.form.nombre,
                        precio: this.form.precio,
                        costo_original: this.form.costo_original,
                    })
                    .then((response) => {
                        console.log(response.data.message);
                        this.fetchArticulos(); // Actualiza la lista de artículos
                        this.dialog = false;
                    })
                    .catch((error) => {
                        console.error(error);
                    });
            }
        },
        openDeleteConfirm(item) {
            this.articuloAEliminar = item;
            this.confirmDeleteDialog = true;
        },
        deleteArticulo() {
            axios
                .delete(`/articulo/${this.articuloAEliminar.id}`)
                .then((response) => {
                    console.log(response.data.message);
                    this.fetchArticulos(); // Actualiza la lista de artículos después de eliminar
                    this.confirmDeleteDialog = false;
                })
                .catch((error) => {
                    console.error(error);
                });
        },
    },
};
</script>

<style scoped>
/* Opcional, puedes agregar estilos adicionales si es necesario */
</style>
