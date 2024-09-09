<template>
    <v-container>
        <!-- Botón para abrir el diálogo de registrar venta -->
        <v-col cols="3">
            <v-btn color="primary" @click="openVentaDialog"
                >Registrar Venta</v-btn
            >
        </v-col>
        <v-col cols="12">
            <v-text-field
                align="center"
                justify="space-between"
                v-model="search"
                label="Buscar en las ventas"
                append-icon="mdi-magnify"
                single-line
                hide-details
            ></v-text-field>
        </v-col>
        <span class="total-text font-weight-bold"
            >Total de Ventas: ${{ totalVentas }}</span
        >
        <!-- Tabla para visualizar las ventas -->
        <v-data-table
            :headers="headers"
            :items="ventas"
            :search="search"
            :options.sync="options"
            class="elevation-1"
        >
            <!-- Formato de la Fecha (DD-MM-YYYY) -->
            <template v-slot:item.fecha="{ item }">
                <span class="fecha-text">
                    {{ formatFecha(item.fecha) }}
                </span>
            </template>

            <!-- Formato del Producto (Artículo + Talle + Color) -->
            <template v-slot:item.articulo_talle_color="{ item }">
                <span class="producto-text">
                    {{ item.articulo.nombre }} - Talle {{ item.talle }}
                    {{ item.color }}
                </span>
            </template>

            <template v-slot:item.cliente="{ item }">
                <span class="cliente-text">
                    {{ item.cliente.nombre }} {{ item.cliente.apellido }}
                    <template v-if="item.cliente.dni">
                        - DNI: {{ item.cliente.dni }}</template
                    >
                    <template v-else-if="item.cliente.cbu">
                        - CBU: {{ item.cliente.cbu }}</template
                    >
                </span>
            </template>

            <template v-slot:item.precio="{ item }">
                <span class="precio-text"
                    >${{
                        typeof item.precio === "number"
                            ? item.precio.toFixed(2)
                            : item.precio
                    }}</span
                >
            </template>

            <template v-slot:item.forma_pago="{ item }">
                <span
                    :class="
                        item.forma_pago == 'efectivo'
                            ? 'efectivo-text'
                            : 'transferencia-text'
                    "
                >
                    {{
                        item.forma_pago == "efectivo"
                            ? "💵 Efectivo"
                            : "💳 Transferencia"
                    }}
                </span>
            </template>

            <!-- Botones de Acciones -->
            <template v-slot:item.actions="{ item }">
                <v-btn icon @click="openEditDialog(item)">
                    <v-icon color="green">mdi-pencil</v-icon>
                </v-btn>
                <v-btn icon @click="openDeleteConfirm(item)">
                    <v-icon color="red">mdi-trash-can</v-icon>
                </v-btn>
            </template>
        </v-data-table>

        <!-- Diálogo para registrar ventas -->
        <v-dialog v-model="dialogVenta" max-width="600px">
            <v-card>
                <v-card-title>
                    <span class="headline">Registrar Venta</span>
                </v-card-title>
                <v-card-text>
                    <v-form ref="form">
                        <!-- Selección de artículo -->
                        <v-select
                            v-model="form.articulo_id"
                            :items="articulos"
                            :item-title="
                                (item) => `${item.numero} - ${item.nombre}`
                            "
                            item-value="id"
                            label="Selecciona un artículo"
                            @update:modelValue="loadTallesYColores"
                        ></v-select>

                        <!-- Selección de talle y color dependientes -->
                        <v-row>
                            <v-col cols="6">
                                <v-select
                                    v-model="form.talle"
                                    :items="tallesDisponibles"
                                    item-title="talle"
                                    label="Selecciona un talle"
                                    :disabled="!form.articulo_id"
                                    @update:modelValue="onTalleChange"
                                ></v-select>
                            </v-col>
                            <v-col cols="6">
                                <v-select
                                    v-model="form.color"
                                    :items="coloresDisponibles"
                                    item-title="title"
                                    item-value="value"
                                    :item-props="(item) => item.props"
                                    label="Selecciona un color"
                                    clearable
                                ></v-select>
                            </v-col>
                        </v-row>

                        <!-- Agregar Producto -->
                        <v-btn color="green" @click="agregarProducto">
                            Agregar Producto
                        </v-btn>

                        <!-- Lista de productos agregados -->
                        <v-list dense>
                            <v-list-item
                                v-for="(producto, index) in productos"
                                :key="index"
                                class="d-flex align-center"
                            >
                                <v-list-item-content>
                                    {{ producto.articulo.nombre }} - Talle
                                    {{ producto.talle }} - Color
                                    {{ producto.color }}
                                </v-list-item-content>
                                <v-list-item-action>
                                    <v-btn
                                        icon
                                        @click="eliminarProducto(index)"
                                    >
                                        <v-icon color="red">mdi-delete</v-icon>
                                    </v-btn>
                                </v-list-item-action>
                            </v-list-item>
                        </v-list>

                        <!-- Mostrar el precio total -->
                        <v-text-field
                            label="Precio Total"
                            v-model="precioTotal"
                            readonly
                        ></v-text-field>

                        <!-- Información del cliente -->
                        <v-text-field
                            v-model="form.cliente_nombre"
                            label="Nombre del cliente"
                            required
                        ></v-text-field>
                        <v-text-field
                            v-model="form.cliente_apellido"
                            label="Apellido"
                            required
                        ></v-text-field>
                        <v-text-field
                            v-model="form.cliente_dni"
                            label="DNI (opcional)"
                            type="number"
                        ></v-text-field>
                        <v-text-field
                            v-model="form.cliente_cbu"
                            label="CBU (opcional)"
                        ></v-text-field>

                        <!-- Precio y forma de pago -->
                        <v-text-field
                            v-model="form.precio"
                            label="Precio"
                            :value="form.precio || getArticuloPrecio()"
                            readonly
                        ></v-text-field>
                        <v-radio-group
                            v-model="form.forma_pago"
                            label="Forma de Pago"
                            :mandatory="true"
                        >
                            <v-radio
                                label="Efectivo"
                                value="efectivo"
                            ></v-radio>
                            <v-radio
                                label="Transferencia"
                                value="transferencia"
                            ></v-radio>
                        </v-radio-group>

                        <!-- Selección de fecha -->
                        <!-- <v-text-field
                            type="date"
                            v-model="form.fecha"
                            placeholder="Seleccione una fecha"
                        ></v-text-field> -->
                        <datepicker
                            v-model="form.fecha"
                            placeholder="Seleccione una fecha"
                        ></datepicker>
                    </v-form>
                </v-card-text>
                <v-card-actions>
                    <v-spacer></v-spacer>
                    <v-btn text @click="dialogVenta = false">Cancelar</v-btn>
                    <v-btn color="green" text @click="registrarVenta"
                        >Guardar</v-btn
                    >
                </v-card-actions>
            </v-card>
        </v-dialog>

        <!-- Diálogo para editar el precio -->
        <v-dialog v-model="editDialog" max-width="600px" scrollable>
            <v-card>
                <v-card-title class="headline">Editar Venta</v-card-title>
                <v-card-text>
                    <!-- Campo para el nuevo precio -->
                    <v-text-field
                        v-model="selectedVenta.precio"
                        label="Nuevo Precio"
                        type="number"
                    ></v-text-field>

                    <!-- Campo para la forma de pago -->
                    <v-radio-group
                        v-model="selectedVenta.forma_pago"
                        label="Forma de Pago"
                        :mandatory="true"
                    >
                        <v-radio label="Efectivo" value="efectivo"></v-radio>
                        <v-radio
                            label="Transferencia"
                            value="transferencia"
                        ></v-radio>
                    </v-radio-group>
                    <!-- Campo para la fecha -->
                    <v-text-field
                        type="date"
                        v-model="selectedVenta.fecha"
                    ></v-text-field>
                    <!-- <datepicker
                        v-model="selectedVenta.fecha"
                        placeholder="Seleccione una fecha"
                        :value="selectedVenta.fecha"
                        style="z-index: 1000; position: relative;"
                    ></datepicker> -->
                </v-card-text>
                <v-card-actions>
                    <v-spacer></v-spacer>
                    <v-btn text @click="editDialog = false">Cancelar</v-btn>
                    <v-btn color="green" text @click="updateVenta"
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
                <v-card-text>
                    ¿Estás seguro de que deseas eliminar la venta de
                    {{ selectedVenta.articulo.nombre }}?
                </v-card-text>
                <v-card-actions>
                    <v-btn text @click="confirmDeleteDialog = false"
                        >Cancelar</v-btn
                    >
                    <v-btn color="red" text @click="deleteVenta"
                        >Eliminar</v-btn
                    >
                </v-card-actions>
            </v-card>
        </v-dialog>

        <v-snackbar
            v-model="snackbar"
            :timeout="3000"
            :color="snackbarColor"
            timeout="5000"
            location="center"
        >
            {{ snackbarText }}
            <v-btn color="red" text @click="snackbar = false">Cerrar</v-btn>
        </v-snackbar>
    </v-container>
</template>

<script>
import datepicker from "./components/datepicker.vue";
import moment from "moment";

export default {
    components: {
        Datepicker: datepicker,
    },
    data() {
        return {
            search: "", // Variable para el campo de búsqueda
            options: {
                sortBy: ["fecha"],
                sortDesc: [true], // true para orden descendente (de más nueva a más antigua)
            },
            selectedVenta: {
                forma_pago: null,
                fecha: null,
                precio: null,
            },
            dialogVenta: false,
            articulos: [], // Lista de artículos
            tallesDisponibles: [], // Talles para el artículo seleccionado
            coloresDisponibles: [], // Colores para el artículo seleccionado
            ventas: [], // Lista de ventas registradas
            editDialog: false, // Control para abrir/cerrar el diálogo de edición
            confirmDeleteDialog: false, // Control para abrir/cerrar el diálogo de confirmación de eliminación
            productos: [], // Lista de productos agregados en la venta
            precioTotal: 0, // Precio total calculado
            snackbar: false,
            snackbarText: "",
            form: {
                articulo_id: null,
                talle: null,
                color: null,
                cliente_nombre: "",
                cliente_apellido: "",
                cliente_dni: "",
                cliente_cbu: "",
                precio: 0,
                fecha: moment().format("YYYY-MM-DD"),
                forma_pago: "efectivo",
            },
            headers: [
                { title: "Fecha", key: "fecha", sortable: true }, // Solo la fecha es ordenable
                {
                    title: "Producto",
                    key: "articulo_talle_color",
                    sortable: false,
                }, // Deshabilitamos orden para esta columna
                { title: "Cliente", key: "cliente", sortable: false },
                { title: "Precio", key: "precio", sortable: false },
                { title: "Forma de Pago", key: "forma_pago", sortable: false },
                { title: "Acciones", key: "actions", sortable: false },
            ],
        };
    },
    created() {
        this.fetchArticulos();
        this.fetchVentas();
    },
    watch: {
        // Este watch actualiza el precio total cada vez que cambien los productos
        productos: {
            handler(nuevosProductos) {
                this.calcularPrecioTotal(); // Calculamos el precio total al cambiar la lista de productos
            },
            deep: true, // Observar cambios profundos dentro del array de productos
        },
    },

    computed: {
        snackbarStyle() {
            return {
                left: "50%",
                top: "50%",
                transform: "translate(-50%, -50%)",
                "max-width": "400px",
                width: "auto",
            };
        },
        totalVentas() {
            const total = this.ventas.reduce((total, venta) => {
                return total + parseFloat(venta.precio || 0); // Suma los precios
            }, 0);
            // Formatear el número con separador de miles sin usar toFixed, ya que toLocaleString se encarga de los decimales
            return total.toLocaleString("es-AR", {
                minimumFractionDigits: 2,
                maximumFractionDigits: 2,
            });
        },
    },

    methods: {
        formatFecha(fecha) {
            const [year, month, day] = fecha.split("-");
            return `${day}-${month}-${year}`; // Formato DD-MM-YYYY
        },
        // Abrir el diálogo de edición con la venta seleccionada
        openEditDialog(item) {
            this.selectedVenta = { ...item };
            this.editDialog = true;
        },
        // Actualizar el precio de la venta
        updateVenta() {
            axios
                .put(`/ventas/${this.selectedVenta.id}`, {
                    precio: this.selectedVenta.precio,
                    fecha: moment(this.selectedVenta.fecha).format(
                        "YYYY-MM-DD"
                    ), // Incluimos la fecha
                    forma_pago: this.selectedVenta.forma_pago, // Incluimos la forma de pago
                })
                .then((response) => {
                    console.log(response.data.message);
                    this.fetchVentas(); // Recargar la lista de ventas
                    this.editDialog = false; // Cerrar el diálogo
                })
                .catch((error) => {
                    console.error(error);
                });
        },
        // Abrir el diálogo de confirmación para eliminar la venta
        openDeleteConfirm(item) {
            this.selectedVenta = { ...item };
            this.confirmDeleteDialog = true;
        },
        // Eliminar la venta
        deleteVenta() {
            axios
                .delete(`/ventas/${this.selectedVenta.id}`)
                .then((response) => {
                    console.log(response.data.message);
                    this.fetchVentas(); // Recargar la lista de ventas
                    this.confirmDeleteDialog = false;
                })
                .catch((error) => {
                    console.error(error);
                });
        },
        openVentaDialog() {
            this.dialogVenta = true;
        },
        // Cargar los artículos desde el backend
        fetchArticulos() {
            axios.get("/articulos").then((response) => {
                this.articulos = response.data;
            });
        },
        // Cargar ventas para mostrar en la tabla
        fetchVentas() {
            axios.get("/ventas/listar").then((response) => {
                this.ventas = response.data;
                console.log("Cliente data:", this.ventas);
            });
        },
        onTalleChange(talleSeleccionado) {
            // Lógica para cargar colores basados en el talle seleccionado
            const talleSeleccionadoObj = this.tallesDisponibles.find(
                (talle) => parseInt(talle.talle) === parseInt(talleSeleccionado)
            );

            if (talleSeleccionadoObj) {
                this.form.color = null; // Reiniciar el color antes de cargar los nuevos
                this.coloresDisponibles = Object.keys(talleSeleccionadoObj)
                    .filter(
                        (color) =>
                            !["id", "articulo_id", "talle"].includes(color)
                    )
                    .map((color) => {
                        const stock = talleSeleccionadoObj[color];
                        return {
                            title: color,
                            value: color,
                            props: {
                                disabled: parseInt(stock) === 0, // Deshabilitar si el stock es 0
                            },
                        };
                    });
                console.log(
                    "Colores disponibles para el talle seleccionado:",
                    this.coloresDisponibles
                );
            }
        },
        // Cargar talles y colores cuando se selecciona un artículo
        loadTallesYColores() {
            this.form.color = null;
            this.form.talle = null;

            axios.get(`/articulo/${this.form.articulo_id}`).then((response) => {
                this.tallesDisponibles = response.data.talles;

                console.log("Talles disponibles:", this.tallesDisponibles);
            });
        },
        // Obtener el precio del artículo seleccionado
        getArticuloPrecio() {
            const articulo = this.articulos.find(
                (item) => parseInt(item.id) === parseInt(this.form.articulo_id)
            );
            this.form.precio = articulo ? articulo.precio : 0;
            return this.form.precio;
        },
        agregarProducto() {
            const articulo = this.articulos.find(
                (item) => item.id === this.form.articulo_id
            );
            if (articulo && this.form.talle && this.form.color) {
                this.productos.push({
                    articulo: articulo,
                    talle: this.form.talle,
                    color: this.form.color,
                    precio: articulo.precio,
                });

                this.forceUpdate++;

                // Limpiar los campos del formulario para agregar más productos
                this.form.articulo_id = null;
                this.form.talle = null;
                this.form.color = null;
            }
        },
        eliminarProducto(index) {
            this.productos.splice(index, 1);
        },
        // Registrar venta
        registrarVenta() {
            this.form.fecha = moment(this.form.fecha).format("YYYY-MM-DD");

            // Validar que haya productos
            if (!this.productos.length) {
                this.snackbarText = "Por favor ingresa los productos";
                this.snackbar = true;
                return;
            }

            // Validar que el nombre y apellido estén presentes
            if (!this.form.cliente_nombre || !this.form.cliente_apellido) {
                this.snackbarText =
                    "Por favor ingresa el nombre y apellido del cliente.";
                this.snackbar = true;
                return;
            }

            const ventaData = {
                cliente_nombre: this.form.cliente_nombre,
                cliente_apellido: this.form.cliente_apellido,
                cliente_dni: this.form.cliente_dni,
                cliente_cbu: this.form.cliente_cbu,
                forma_pago: this.form.forma_pago,
                productos: this.productos, // Enviamos los productos agregados
                fecha: this.form.fecha,
            };

            console.log(ventaData);

            axios
                .post("/ventas", ventaData)
                .then((response) => {
                    console.log(response.data.message);
                    this.fetchVentas(); // Actualiza la lista de ventas
                    this.dialogVenta = false;
                    // Limpiar formulario y productos
                    this.form = {
                        cliente_nombre: "",
                        cliente_apellido: "",
                        cliente_dni: "",
                        cliente_cbu: "",
                        fecha: moment().format("YYYY-MM-DD"),
                        forma_pago: "efectivo",
                    };
                    this.productos = [];
                })
                .catch((error) => {
                    console.error(error);
                });
        },
        calcularPrecioTotal() {
            // Recalcula el precio total
            this.precioTotal = this.productos.reduce((total, producto) => {
                return total + parseFloat(producto.articulo.precio);
            }, 0);
        },
    },
};
</script>

<style scoped>
.precio-text {
    color: #4caf50; /* Verde */
    font-weight: bold;
}
.efectivo-text {
    color: #009688; /* Verde/Teal */
    font-weight: bold;
}
.transferencia-text {
    color: #3f51b5; /* Azul */
    font-weight: bold;
}
/* Estilos para los artículos, talles y nombres */
.articulo-text {
    font-size: 1.1em;
    font-weight: bold;
}
.producto-text {
    font-weight: 500;
    font-size: 14px;
    color: #333;
}

.cliente-text {
    font-style: italic;
    font-weight: 500;
    color: #555;
}

.fecha-text {
    color: #666;
    font-size: 14px;
}

.v-btn {
    background-color: transparent;
}

.v-btn .v-icon {
    color: #333;
}

.v-btn:hover .v-icon {
    color: #1976d2;
}

.v-data-table {
    background-color: #f9f9f9;
    border: 1px solid #ddd;
    border-radius: 4px;
}

.v-data-table-header th {
    font-weight: bold;
    color: #555;
}

.v-data-table-header th,
.v-data-table-row td {
    padding: 10px;
}
</style>
