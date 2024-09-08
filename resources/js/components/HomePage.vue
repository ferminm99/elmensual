<template>
    <v-container>
        <!-- Selector de Artículos -->
        <v-autocomplete
            v-model="selectedArticulo"
            :items="articulos"
            :item-title="(item) => `${item.numero} - ${item.nombre}`"
            item-value="id"
            label="Selecciona un artículo"
            @update:modelValue="onArticuloChange"
            clearable
            filterable
        />
        <!-- Botón para dialogs -->
        <v-btn color="primary" @click="openDialog('agregar')"
            >Agregar Bombachas</v-btn
        >
        <v-btn color="error" @click="openDialog('eliminar')"
            >Eliminar Bombachas</v-btn
        >
        <!-- Tabla de talles y colores -->
        <v-data-table
            :key="selectedArticulo"
            :headers="headers"
            :items="talles"
            class="elevation-1"
        >
            <!-- Personalización de las celdas -->
            <template v-slot:item.marron="{ item }">
                <span class="marron-text">{{ item.marron }}</span>
            </template>
            <template v-slot:item.negro="{ item }">
                <span class="negro-text">{{ item.negro }}</span>
            </template>
            <template v-slot:item.verde="{ item }">
                <span class="verde-text">{{ item.verde }}</span>
            </template>
            <template v-slot:item.azul="{ item }">
                <span class="azul-text">{{ item.azul }}</span>
            </template>
            <template v-slot:item.celeste="{ item }">
                <span class="celeste-text">{{ item.celeste }}</span>
            </template>
            <template v-slot:item.blancobeige="{ item }">
                <span class="blanco-text">{{ item.blancobeige }}</span>
            </template>
            <template v-slot:item.total_bombachas="{ item }">
                {{ getTotalBombachas(item) }}
            </template>
            <!-- Botón de eliminar y editar -->
            <template v-slot:item.actions="{ item }">
                <v-btn icon @click="openEditDialog(item)">
                    <v-icon color="blue">mdi-pencil</v-icon>
                    <!-- Icono de editar -->
                </v-btn>
                <v-btn icon @click="openDeleteFullConfirm(item.talle)">
                    <v-icon color="red">mdi-trash-can</v-icon>
                </v-btn>
            </template>
        </v-data-table>

        <!-- Diálogo para agregar bombachas -->
        <v-dialog v-model="dialog" max-width="600px">
            <v-card>
                <v-card-title>
                    <span class="headline"
                        >{{ isAgregar ? "Agregar" : "Eliminar" }} Bombachas al
                        Artículo</span
                    >
                </v-card-title>

                <v-card-text>
                    <v-form ref="form">
                        <v-row
                            ><v-autocomplete
                                v-model="selectedArticuloDialog"
                                :items="articulos"
                                :item-title="
                                    (item) => `${item.numero} - ${item.nombre}`
                                "
                                item-value="id"
                                label="Selecciona un artículo"
                                @update:modelValue="tallesCorrectos"
                                clearable
                                filterable
                        /></v-row>
                        <v-row
                            ><v-select
                                v-model="selectedTalles"
                                :items="tallesDisponiblesSeleccionados"
                                item-title="talle"
                                item-value="talle"
                                label="Selecciona los talles"
                                multiple
                                chips
                                clearable
                        /></v-row>

                        <v-row>
                            <v-col cols="4">
                                <v-text-field
                                    v-model="newQuantities.verde"
                                    label="Verde"
                                    type="number"
                                    class="verde-text"
                                    min="0"
                                ></v-text-field>
                            </v-col>
                            <v-col cols="4">
                                <v-text-field
                                    v-model="newQuantities.azul"
                                    label="Azul"
                                    type="number"
                                    class="azul-text"
                                    min="0"
                                ></v-text-field>
                            </v-col>
                            <v-col cols="4">
                                <v-text-field
                                    v-model="newQuantities.marron"
                                    label="Marrón"
                                    type="number"
                                    class="marron-text"
                                    min="0"
                                ></v-text-field>
                            </v-col>
                        </v-row>
                        <v-row>
                            <v-col cols="4">
                                <v-text-field
                                    v-model="newQuantities.negro"
                                    label="Negro"
                                    type="number"
                                    class="negro-text"
                                    min="0"
                                ></v-text-field>
                            </v-col>

                            <v-col cols="4">
                                <v-text-field
                                    v-model="newQuantities.celeste"
                                    label="Celeste"
                                    type="number"
                                    class="celeste-text"
                                    min="0"
                                ></v-text-field>
                            </v-col>
                            <v-col cols="4">
                                <v-text-field
                                    v-model="newQuantities.blancobeige"
                                    label="Blanco/Beige"
                                    type="number"
                                    class="blancobeige-text"
                                    min="0"
                                ></v-text-field>
                            </v-col>
                        </v-row>
                        <!-- Más colores... -->
                    </v-form>
                </v-card-text>

                <v-card-actions>
                    <v-btn color="blue darken-1" text @click="dialog = false"
                        >Cancelar</v-btn
                    >
                    <v-btn
                        color="blue darken-1"
                        text
                        @click="
                            isAgregar ? openAddConfirm() : openDeleteConfirm()
                        "
                    >
                        {{ isAgregar ? "Agregar" : "Eliminar" }}
                    </v-btn>
                </v-card-actions>
            </v-card>
        </v-dialog>

        <!-- Diálogo para editar bombachas -->
        <v-dialog v-model="editDialog" max-width="500px">
            <v-card>
                <v-card-title class="headline"
                    >Editar Cantidades del Talle
                    {{ currentTalle.talle }}</v-card-title
                >
                <v-card-text>
                    <!-- Formulario para editar las cantidades -->
                    <v-row>
                        <v-col cols="6">
                            <v-text-field
                                label="Marrón"
                                v-model="currentTalle.marron"
                                class="marron-text"
                            ></v-text-field>
                        </v-col>
                        <v-col cols="6">
                            <v-text-field
                                label="Negro"
                                v-model="currentTalle.negro"
                                class="negro-text"
                            ></v-text-field>
                        </v-col>
                        <v-col cols="6">
                            <v-text-field
                                label="Verde"
                                v-model="currentTalle.verde"
                                class="verde-text"
                            ></v-text-field>
                        </v-col>
                        <v-col cols="6">
                            <v-text-field
                                label="Azul"
                                v-model="currentTalle.azul"
                                class="azul-text"
                            ></v-text-field>
                        </v-col>
                        <v-col cols="6">
                            <v-text-field
                                label="Celeste"
                                v-model="currentTalle.celeste"
                                class="celeste-text"
                            ></v-text-field>
                        </v-col>
                        <v-col cols="6">
                            <v-text-field
                                label="Blanco/Beige"
                                v-model="currentTalle.blancobeige"
                                class="blancobeige-text"
                            ></v-text-field>
                        </v-col>
                    </v-row>
                </v-card-text>

                <v-card-actions>
                    <v-spacer></v-spacer>
                    <v-btn
                        color="blue darken-1"
                        text
                        @click="editDialog = false"
                        >Cancelar</v-btn
                    >
                    <v-btn color="blue darken-1" text @click="saveChanges"
                        >Guardar</v-btn
                    >
                </v-card-actions>
            </v-card>
        </v-dialog>

        <!-- Diálogo de confirmación para eliminar -->
        <v-dialog v-model="confirmDeleteDialog" max-width="400px">
            <v-card>
                <v-card-title class="headline"
                    >Confirmar eliminación</v-card-title
                >
                <v-card-text
                    >¿Estás seguro de que deseas eliminar esas bombachas?
                    ?</v-card-text
                >
                <v-card-actions>
                    <v-spacer></v-spacer>
                    <v-btn
                        color="grey"
                        text
                        @click="confirmDeleteDialog = false"
                        >Cancelar</v-btn
                    >
                    <v-btn color="red" text @click="removeQuantities"
                        >Eliminar</v-btn
                    >
                </v-card-actions>
            </v-card>
        </v-dialog>

        <!-- Diálogo de confirmación para eliminar -->
        <v-dialog v-model="confirmFullDeleteDialog" max-width="400px">
            <v-card>
                <v-card-title class="headline"
                    >Confirmar eliminación</v-card-title
                >
                <v-card-text
                    >¿Estás seguro de que deseas eliminar todas las bombachas de
                    este talle {{ talleAEliminar }}?</v-card-text
                >
                <v-card-actions>
                    <v-spacer></v-spacer>
                    <v-btn
                        color="grey"
                        text
                        @click="confirmDeleteDialog = false"
                        >Cancelar</v-btn
                    >
                    <v-btn color="red" text @click="deleteCompleteTalle"
                        >Eliminar</v-btn
                    >
                </v-card-actions>
            </v-card>
        </v-dialog>

        <!-- Diálogo de confirmación para agregar bombachas -->
        <v-dialog v-model="confirmAddDialog" max-width="400px">
            <v-card>
                <v-card-title class="headline">Confirmar adición</v-card-title>
                <v-card-text
                    >¿Estás seguro de que deseas agregar estas
                    bombachas?</v-card-text
                >
                <v-card-actions>
                    <v-spacer></v-spacer>
                    <v-btn color="grey" text @click="confirmAddDialog = false"
                        >Cancelar</v-btn
                    >
                    <v-btn color="green" text @click="addQuantities"
                        >Agregar</v-btn
                    >
                </v-card-actions>
            </v-card>
        </v-dialog>
    </v-container>
</template>

<script>
import { toRaw } from "vue";
import { shallowReactive } from "vue";
export default {
    data() {
        return {
            //dialogs confirmar
            confirmDeleteDialog: false,
            confirmAddDialog: false,
            confirmFullDeleteDialog: false,
            //para editar bombachas segun talle
            editDialog: false,
            currentTalle: {
                marron: 0,
                negro: 0,
                verde: 0,
                azul: 0,
                celeste: 0,
                blancobeige: 0,
                talle: null,
            },
            //para agregar o borrar
            dialog: false,
            selected: null,
            isAgregar: true, // Determina si se agrega o elimina
            selectedArticulo: null,
            selectedArticuloDialog: null,
            articulos: shallowReactive([]),
            talles: [],
            selectedTalles: [], // Almacena los talles seleccionados
            tallesDisponiblesSeleccionados: [],
            tallesDisponibles: [
                { talle: 0 },
                { talle: 2 },
                { talle: 4 },
                { talle: 6 },
                { talle: 8 },
                { talle: 10 },
                { talle: 12 },
                { talle: 14 },
                { talle: 16 },
                { talle: 18 },
                { talle: 20 },
                { talle: 22 },
                { talle: 24 },
                { talle: 26 },
                { talle: 28 },
                { talle: 30 },
                { talle: 32 },
                { talle: 34 },
                { talle: 36 },
                { talle: 38 },
                { talle: 40 },
                { talle: 42 },
                { talle: 44 },
                { talle: 46 },
                { talle: 48 },
                { talle: 50 },
                { talle: 52 },
                { talle: 54 },
            ], // Los talles disponibles para seleccionar
            newQuantities: {
                verde: 0,
                azul: 0,
                marron: 0,
                negro: 0,
                celeste: 0,
                blancobeige: 0,
            },
            headers: [
                { title: "Talle", key: "talle", align: "center" },
                {
                    title: "Marrón",
                    key: "marron",
                    align: "center",
                    sortable: false,
                    class: "marron-text",
                },
                {
                    title: "Negro",
                    key: "negro",
                    sortable: false,
                    align: "center",
                    class: "negro-text",
                },
                {
                    title: "Verde",
                    key: "verde",
                    sortable: false,
                    align: "center",
                    class: "verde-text",
                },
                {
                    title: "Azul",
                    key: "azul",
                    sortable: false,
                    align: "center",
                    class: "azul-text",
                },
                {
                    title: "Celeste",
                    key: "celeste",
                    sortable: false,
                    align: "center",
                    class: "celeste-text",
                },
                {
                    title: "Blanco/Beige",
                    key: "blancobeige",
                    sortable: false,
                    align: "center",
                    headerClass: "blancobeige-text",
                },
                { title: "Total", key: "total_bombachas", align: "center" },
                { title: "Acciones", key: "actions", align: "center" },
            ],
        };
    },
    created() {
        this.fetchArticulos();
    },
    methods: {
        //dialogs para confirmar agregados y borrados
        openDeleteConfirm(talle) {
            this.talleAEliminar = talle;
            this.confirmDeleteDialog = true;
        },

        openDeleteFullConfirm(talle) {
            this.talleAEliminar = talle;
            this.confirmFullDeleteDialog = true;
        },
        openAddConfirm() {
            this.confirmAddDialog = true;
        },

        //dialog editar cantidad bombachas por talle
        openEditDialog(item) {
            this.currentTalle = { ...item }; // Copia los datos del talle actual
            this.editDialog = true;
        },
        //guardar editar cantidades bombachas por talle
        saveChanges() {
            axios
                .post(`/articulo/${this.selectedArticulo}/editar-bombachas`, {
                    cantidades: {
                        marron: this.currentTalle.marron,
                        negro: this.currentTalle.negro,
                        verde: this.currentTalle.verde,
                        azul: this.currentTalle.azul,
                        celeste: this.currentTalle.celeste,
                        blancobeige: this.currentTalle.blancobeige,
                    },
                    talle: this.currentTalle.talle,
                })
                .then((response) => {
                    console.log(response.data.message);
                    this.editDialog = false;
                    this.fetchTalles(); // Actualiza la tabla después de guardar los cambios
                })
                .catch((error) => {
                    console.error(error);
                });
        },
        openDialog(action) {
            this.isAgregar = action === "agregar";
            this.dialog = true;
        },

        fetchArticulos() {
            fetch("/articulos/listar")
                .then((response) => response.json())
                .then((data) => {
                    this.articulos = data;
                    console.log(this.articulos);
                });
        },
        onArticuloChange() {
            this.fetchTalles();
        },
        fetchTalles() {
            if (!this.selectedArticulo) {
                console.error(
                    "No hay artículo seleccionado para obtener los talles"
                );
                return;
            }

            fetch(`/articulo/${this.selectedArticulo}`)
                .then((response) => response.json())
                .then((data) => {
                    this.talles = data.talles;
                    console.log(this.talles);
                });
        },
        getTotalBombachas(talle) {
            return (
                talle.marron +
                talle.negro +
                talle.verde +
                talle.azul +
                talle.celeste +
                talle.blancobeige
            );
        },
        addQuantities() {
            this.selectedTalles.forEach((talle) => {
                axios
                    .post(
                        `/articulo/${this.selectedArticuloDialog}/agregar-bombachas`,
                        {
                            cantidades: this.newQuantities,
                            talle: talle, // Talle actual en la iteración
                        }
                    )
                    .then((response) => {
                        console.log(response.data.message);
                        this.dialog = false;
                        this.confirmAddDialog = false;
                        this.fetchTalles(); // Actualiza la tabla
                        this.resetQuantities();
                    })
                    .catch((error) => {
                        console.error(error);
                    });
            });
        },
        removeQuantities() {
            this.selectedTalles.forEach((talle) => {
                axios
                    .post(
                        `/articulo/${this.selectedArticuloDialog}/eliminar-bombachas`,
                        {
                            cantidades: this.newQuantities,
                            talle: talle, // Talle actual en la iteración
                        }
                    )
                    .then((response) => {
                        console.log(response.data.message);
                        this.dialog = false;
                        this.confirmDeleteDialog = false;
                        this.fetchTalles(); // Actualiza la tabla
                        this.resetQuantities();
                    })
                    .catch((error) => {
                        console.error(error);
                    });
            });
        },

        resetQuantities() {
            this.newQuantities = {
                verde: 0,
                azul: 0,
                marron: 0,
                negro: 0,
                celeste: 0,
                blancobeige: 0,
            };
            this.selectedTalles = [];
            this.selectedArticuloDialog = null; // Reiniciar selección del artículo
        },

        deleteCompleteTalle() {
            axios
                .post(
                    `/articulo/${this.selectedArticulo}/eliminar-talle-completo`,
                    {
                        talle: this.talleAEliminar,
                    }
                )
                .then((response) => {
                    console.log(response.data.message);
                    this.confirmFullDeleteDialog = false;
                    this.fetchTalles(); // Actualiza la tabla después de eliminar
                })
                .catch((error) => {
                    console.error(error);
                });
        },
        getRangoTalles(nombre) {
            // Busca los números en el nombre del artículo
            const matches = nombre.match(/\d+/g);

            // Si encontramos dos números, los convertimos en el rango de talles
            if (matches && matches.length >= 2) {
                const minTalle = parseInt(matches[0], 10);
                const maxTalle = parseInt(matches[1], 10);
                return { minTalle, maxTalle };
            }

            // Si no hay números, devolvemos un rango predeterminado o vacío
            return { minTalle: null, maxTalle: null };
        },
        tallesCorrectos() {
            this.selectedTalles = [];
            this.tallesDisponiblesSeleccionados = this.tallesDisponibles;
            // Llama a la función cuando se selecciona un artículo
            const articuloSeleccionado = this.articulos.find(
                (articulo) => articulo.id === this.selectedArticuloDialog
            );

            if (articuloSeleccionado) {
                const { minTalle, maxTalle } = this.getRangoTalles(
                    articuloSeleccionado.nombre
                );

                console.log(articuloSeleccionado.nombre);
                console.log(minTalle);
                console.log(maxTalle);

                // Filtra los talles disponibles en base al rango extraído del nombre
                if (minTalle != null && maxTalle != null) {
                    this.tallesDisponiblesSeleccionados =
                        this.tallesDisponibles.filter(
                            (talleObj) =>
                                talleObj.talle >= minTalle &&
                                talleObj.talle <= maxTalle
                        );
                    console.log(this.tallesDisponiblesSeleccionados); // Imprime antes del filtrado
                }
            }
        },
    },
};
</script>

<style scoped>
.marron-text {
    color: #8b4513; /* Marrón */
    font-weight: bold;
}
.negro-text {
    color: #000000; /* Negro */
    font-weight: bold;
}
.verde-text {
    color: #228b22; /* Verde */
    font-weight: bold;
}
.azul-text {
    color: #0000ff; /* Azul */
    font-weight: bold;
}
.celeste-text {
    color: #87ceeb; /* Celeste */
    font-weight: bold;
}
.blanco-text {
    color: #7a7a7a; /* Blanco/Beige */
    font-weight: bold;
}
</style>
