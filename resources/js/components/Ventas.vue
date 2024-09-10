<template>
    <v-container>
        <!-- Botón para abrir el diálogo de registrar venta -->
        <v-row>
            <v-btn color="primary" @click="openVentaDialog"
                >Registrar Venta</v-btn
            >
            <div style="padding: 5px"></div>
            <v-btn color="secondary" @click="openFacturarDialog"
                >Facturar</v-btn
            >
        </v-row>

        <v-row
            ><v-col cols="2">
                <v-select
                    v-model="tipoBusqueda"
                    :items="['General', 'Producto', 'Otros datos']"
                    label="Buscar por"
                ></v-select
            ></v-col>

            <v-col cols="10">
                <!-- Campo de búsqueda -->
                <v-text-field
                    v-model="search"
                    label="Buscar"
                    append-icon="mdi-magnify"
                    single-line
                    hide-details
                ></v-text-field></v-col
        ></v-row>

        <v-col cols="3" class="total-text font-weight-bold"
            >Total de Ventas: ${{ totalVentas }}</v-col
        >
        <v-col cols="3">
            <h4>Ganancias Netas: ${{ calcularTotalGastado() }}</h4>
        </v-col>

        <!-- Tabla para visualizar las ventas -->
        <v-data-table
            :headers="headers"
            :items="ventas"
            :search="search"
            :custom-filter="
                tipoBusqueda === 'Producto'
                    ? buscarPorProducto
                    : tipoBusqueda === 'Otros datos'
                    ? buscarPorOtrosDatos
                    : buscarPorTodo
            "
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
                    <template v-if="item.cliente.cuit">
                        - cuit: {{ item.cliente.cuit }}</template
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
                <v-card-title class="d-flex justify-space-between">
                    <span class="headline">Registrar Venta</span>
                    <v-spacer></v-spacer>
                    <v-btn icon @click="closeDialogVenta">
                        <v-icon color="red">mdi-close</v-icon>
                    </v-btn>
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
                            v-model="form.cliente_cuit"
                            label="CUIT (opcional)"
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
                        <!-- <v-date-picker
                            v-model="form.fecha"
                            label="Seleccione una fecha"
                        ></v-date-picker> -->
                    </v-form>
                </v-card-text>
                <v-card-actions>
                    <v-spacer></v-spacer>
                    <v-btn text @click="closeDialogVenta">Cancelar</v-btn>
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
                    <!-- Campo para el costo original -->
                    <v-text-field
                        v-model="selectedVenta.costo_original"
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

        <v-dialog v-model="dialogFacturacion" max-width="500px">
            <v-card>
                <v-card-title class="headline"
                    >Generar Facturación</v-card-title
                >

                <v-card-text>
                    <v-form ref="facturacionForm">
                        <v-date-picker
                            v-model="fechaDesde"
                            label="Fecha Desde"
                        ></v-date-picker>
                    </v-form>
                </v-card-text>

                <v-card-actions>
                    <v-spacer></v-spacer>
                    <v-btn text @click="dialogFacturacion = false"
                        >Cancelar</v-btn
                    >
                    <v-btn color="green" text @click="generarFacturacion"
                        >Generar</v-btn
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
            tipoBusqueda: "General",
            dialogFacturacion: false,
            fechaDesde: null, // Variable para la fecha seleccionada de facturacion
            options: {
                sortBy: ["fecha"],
                sortDesc: [true], // true para orden descendente (de más nueva a más antigua)
            },
            selectedVenta: {
                forma_pago: null,
                fecha: null,
                precio: null,
                costo_original: null,
            },
            dialogVenta: false,
            articuloActual: null,
            articulos: [], // Lista de artículos
            tallesDisponibles: [], // Talles para el artículo seleccionado
            tallesDisponibles: [],
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
                cliente_cuit: "",
                cliente_cbu: "",
                precio: 0,
                costo_original: 0,
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
                {
                    title: "Costo Original",
                    key: "costo_original",
                    sortable: false,
                },
                { title: "Forma de Pago", key: "forma_pago", sortable: false },
                { title: "Acciones", key: "actions", sortable: false },
            ],
        };
    },
    created() {
        this.fetchArticulos();
        this.fetchVentas();

        this.options.sortBy = ["fecha"];
        this.options.sortDesc = [true];
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
        openFacturarDialog() {
            this.dialogFacturacion = true;
        },

        descargarArchivo(texto, nombreArchivo) {
            const blob = new Blob([texto], { type: "text/plain" });
            const link = document.createElement("a");
            link.href = URL.createObjectURL(blob);
            link.download = nombreArchivo;
            document.body.appendChild(link);
            link.click();
            document.body.removeChild(link);
        },

        generarFacturacion() {
            if (!this.fechaDesde) {
                this.snackbarText = "Por favor selecciona una fecha desde.";
                this.snackbar = true;
                return;
            }

            const ventasFiltradas = this.filtrarVentasPorFecha();

            if (ventasFiltradas.length === 0) {
                alert("No se encontraron ventas desde la fecha seleccionada.");
                return;
            }

            let textoFacturacion = "Facturación de ventas agrupadas:\n\n";

            // Objeto para agrupar las ventas por cliente
            let ventasAgrupadas = {};

            // Recorremos las ventas filtradas y las agrupamos
            ventasFiltradas.forEach((venta) => {
                const cliente = venta.cliente;
                const cuitOCbu = cliente.cuit || cliente.cbu || ""; // Puede ser CUIT, CBU o vacío si no hay ninguno

                // Creamos una clave única para identificar al cliente por nombre, apellido y, si existe, CUIT/CBU
                const clienteKey = `${cliente.nombre} ${cliente.apellido} ${cuitOCbu}`;

                // Si el cliente ya existe en ventasAgrupadas, sumamos sus ventas
                if (ventasAgrupadas[clienteKey]) {
                    ventasAgrupadas[clienteKey].total += parseFloat(
                        venta.precio
                    );
                    ventasAgrupadas[clienteKey].articulos.push({
                        nombre: venta.articulo.nombre,
                        precio: venta.precio,
                    });
                } else {
                    // Si es la primera vez que encontramos este cliente, lo agregamos
                    ventasAgrupadas[clienteKey] = {
                        cliente: cliente,
                        total: parseFloat(venta.precio),
                        articulos: [
                            {
                                nombre: venta.articulo.nombre,
                                precio: venta.precio,
                            },
                        ],
                    };
                }
            });

            // Generamos el texto de la facturación agrupada
            for (const [key, clienteInfo] of Object.entries(ventasAgrupadas)) {
                const { cliente, total, articulos } = clienteInfo;
                const cuitOCbu = cliente.cuit
                    ? `CUIT: ${cliente.cuit}`
                    : cliente.cbu
                    ? `CBU: ${cliente.cbu}`
                    : "Sin CUIT/CBU";

                // Detalles del cliente y total de ventas
                textoFacturacion += `Cliente: ${cliente.nombre} ${cliente.apellido}\n`;
                textoFacturacion += `${cuitOCbu}\n`;

                // Listamos los artículos comprados
                textoFacturacion += `Artículos comprados:\n`;
                articulos.forEach((articulo) => {
                    textoFacturacion += `- ${articulo.nombre}: $${articulo.precio}\n`;
                });

                // Total del cliente
                textoFacturacion += `Total: $${total.toLocaleString("es-AR", {
                    minimumFractionDigits: 2,
                    maximumFractionDigits: 2,
                })}\n\n`;
            }

            const nombreArchivo = `facturacion_desde_${this.fechaDesde}_hasta_hoy.txt`;
            this.descargarArchivo(textoFacturacion, nombreArchivo);

            this.dialogFacturacion = false; // Cerrar el diálogo después de generar
        },

        filtrarVentasPorFecha() {
            // Convertimos la fecha desde seleccionada a formato YYYY-MM-DD
            const desde = moment(this.fechaDesde).format("YYYY-MM-DD");
            const hoy = moment().format("YYYY-MM-DD");

            return this.ventas.filter((venta) => {
                const fechaVenta = moment(venta.fecha).format("YYYY-MM-DD");
                return fechaVenta >= desde && fechaVenta <= hoy;
            });
        },

        mostrarTextoFacturacion(texto) {
            alert(texto); // Puedes mostrar el texto en un modal o alert, o proceder a descargarlo.
        },
        buscarPorTodo(value, search, item) {
            const searchText = search.toLowerCase().trim();

            // Acceder al cliente
            const cliente = item.raw.cliente || {};
            const clienteNombreCompleto = `${cliente.nombre || ""} ${
                cliente.apellido || ""
            }`.toLowerCase();
            const cbu = (cliente.cbu || "").toLowerCase();
            const cuit = (cliente.cuit || "").toLowerCase(); // Puede ser el DNI o CUIT

            // Acceder al artículo
            const articulo = item.raw.articulo || {};
            const articuloNombre = (articulo.nombre || "").toLowerCase();
            const talle = (item.raw.talle || "").toString(); // Convertimos a string para comparar
            const color = (item.raw.color || "").toLowerCase();

            // Comparar por precio y costo original
            const precio = (item.raw.precio || "").toString(); // Convertimos a string
            const costoOriginal = (item.raw.costo_original || "").toString(); // Convertimos a string

            // Ver si alguno de estos campos coincide con el texto de búsqueda
            const matchesCliente = clienteNombreCompleto.includes(searchText);
            const matchesCBU = cbu.includes(searchText);
            const matchesCUIT = cuit.includes(searchText);
            const matchesArticulo = articuloNombre.includes(searchText);
            const matchesTalle = talle.includes(searchText);
            const matchesColor = color.includes(searchText);
            const matchesPrecio = precio.includes(searchText);
            const matchesCostoOriginal = costoOriginal.includes(searchText);

            // Retornamos true si alguna de estas condiciones se cumple
            return (
                matchesCliente ||
                matchesCBU ||
                matchesCUIT ||
                matchesArticulo ||
                matchesTalle ||
                matchesColor ||
                matchesPrecio ||
                matchesCostoOriginal
            );
        },
        buscarPorProducto(value, search, item) {
            const searchText = search.toLowerCase().trim();

            // Acceder al artículo
            const articulo = item.raw.articulo || {};
            const articuloNombre = (articulo.nombre || "").toLowerCase();
            const numeroArticulo = (articulo.numero || "").toString(); // Número de artículo
            const talle = (item.raw.talle || "").toString(); // Convertimos a string
            const color = (item.raw.color || "").toLowerCase();

            // Ver si alguno de estos campos coincide con el texto de búsqueda
            const matchesArticulo = articuloNombre.includes(searchText);
            const matchesNumeroArticulo = numeroArticulo.includes(searchText);
            const matchesTalle = talle.includes(searchText);
            const matchesColor = color.includes(searchText);

            // Retornamos true si alguna de estas condiciones se cumple
            return (
                matchesArticulo ||
                matchesNumeroArticulo ||
                matchesTalle ||
                matchesColor
            );
        },

        // Filtro personalizado para buscar por otros datos
        buscarPorOtrosDatos(value, search, item) {
            const searchText = search.toLowerCase().trim();

            // Acceder al cliente
            const cliente = item.raw.cliente || {};
            const clienteNombreCompleto = `${cliente.nombre || ""} ${
                cliente.apellido || ""
            }`.toLowerCase();
            const cbu = (cliente.cbu || "").toLowerCase();
            const cuit = (cliente.cuit || "").toLowerCase(); // Puede ser el DNI o CUIT

            // Comparar por precio y costo original
            const precio = (item.raw.precio || "").toString(); // Convertimos a string
            const costoOriginal = (item.raw.costo_original || "").toString(); // Convertimos a string

            // Ver si alguno de estos campos coincide con el texto de búsqueda
            const matchesCliente = clienteNombreCompleto.includes(searchText);
            const matchesCBU = cbu.includes(searchText);
            const matchesCUIT = cuit.includes(searchText);
            const matchesPrecio = precio.includes(searchText);
            const matchesCostoOriginal = costoOriginal.includes(searchText);

            // Retornamos true si alguna de estas condiciones se cumple
            return (
                matchesCliente ||
                matchesCBU ||
                matchesCUIT ||
                matchesPrecio ||
                matchesCostoOriginal
            );
        },
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
                    costo_original: this.selectedVenta.costo_original,
                    fecha: moment(this.selectedVenta.fecha).format(
                        "YYYY-MM-DD"
                    ), // Incluimos la fecha
                    forma_pago: this.selectedVenta.forma_pago, // Incluimos la forma de pago
                })
                .then((response) => {
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
        closeDialogVenta() {
            this.form = {
                cliente_nombre: "",
                cliente_apellido: "",
                cliente_cuit: "",
                cliente_cbu: "",
                fecha: moment().format("YYYY-MM-DD"),
                forma_pago: "efectivo",
            };
            this.articuloActual = null;
            this.tallesDisponibles = [];
            this.coloresDisponibles = [];
            this.productos = [];
            this.dialogVenta = false;
        },
        // Cargar los artículos desde el backend
        fetchArticulos() {
            axios.get("/articulo/listar/talles").then((response) => {
                this.articulos = response.data;
            });
        },
        // Cargar ventas para mostrar en la tabla
        fetchVentas() {
            axios.get("/ventas/listar").then((response) => {
                this.ventas = response.data.sort((a, b) => {
                    return new Date(b.fecha) - new Date(a.fecha);
                });
            });
        },
        onTalleChange(talleSeleccionado) {
            // Usamos tallesDisponibles en lugar de tallesDisponibles
            const articuloSeleccionado = this.articulos.find(
                (item) => item.id === this.form.articulo_id
            );

            if (articuloSeleccionado) {
                const talleSeleccionadoObj = this.tallesDisponibles.find(
                    (talle) =>
                        parseInt(talle.talle) === parseInt(talleSeleccionado)
                );

                if (talleSeleccionadoObj) {
                    this.form.color = null; // Reiniciar el color antes de cargar los nuevos

                    // Cargar los colores originales basados en los talles disponibles activos
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

                    // Cargar los colores activos desde coloresDisponibles
                    this.coloresDisponibles = JSON.parse(
                        JSON.stringify(this.coloresDisponibles)
                    );
                }
            }
        },
        loadTallesYColores() {
            // Resetear los campos
            this.form.color = null;
            this.form.talle = null;

            // Encontrar el artículo seleccionado
            const articuloSeleccionado = this.articulos.find(
                (item) => item.id === this.form.articulo_id
            );
            if (this.articuloActual != articuloSeleccionado) {
                this.articuloActual = this.articulos.find(
                    (item) => item.id === this.form.articulo_id
                );
                this.tallesDisponibles = this.articuloActual.talles;
            }
        },
        // Obtener el precio del artículo seleccionado
        getArticuloPrecio() {
            const articulo = this.articulos.find(
                (item) => parseInt(item.id) === parseInt(this.form.articulo_id)
            );
            this.form.precio = articulo ? articulo.precio : 0;
            return this.form.precio;
        },

        calcularTotalGastado() {
            const total = this.ventas.reduce((total, venta) => {
                const diferencia =
                    parseFloat(venta.precio) - parseFloat(venta.costo_original);
                return total + diferencia; // Suma la diferencia entre precio y costo original
            }, 0);

            return total.toLocaleString("es-AR", {
                minimumFractionDigits: 2,
                maximumFractionDigits: 2,
            });
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
                    precio: parseInt(articulo.precio),
                    costo_original: parseInt(articulo.costo_original),
                });

                // Actualizar el stock localmente restando 1
                const talleSeleccionado = this.tallesDisponibles.find(
                    (talle) => talle.talle === this.form.talle
                );

                if (
                    talleSeleccionado &&
                    talleSeleccionado[this.form.color] > 0
                ) {
                    // Restar 1 al stock del color seleccionado
                    talleSeleccionado[this.form.color] -= 1;

                    // Si el stock llega a 0, deshabilitar el color en coloresDisponibles
                    if (talleSeleccionado[this.form.color] === 0) {
                        const colorIndex = this.coloresDisponibles.findIndex(
                            (color) => color.value === this.form.color
                        );
                        if (colorIndex !== -1) {
                            // Actualizar la lista de colores activos
                            this.coloresDisponibles =
                                this.coloresDisponibles.map((color, index) => {
                                    if (index === colorIndex) {
                                        return {
                                            ...color,
                                            props: {
                                                ...color.props,
                                                disabled: true,
                                            },
                                        };
                                    }
                                    return color;
                                });
                        }
                    }
                }

                // Limpiar los campos del formulario para agregar más productos
                this.form.articulo_id = null;
                this.form.talle = null;
                this.form.color = null;
            }
        },
        eliminarProducto(index) {
            const producto = this.productos[index];

            // Devolver el stock del talle y color eliminados
            const talleSeleccionado = this.tallesDisponibles.find(
                (talle) => talle.talle === producto.talle
            );

            if (talleSeleccionado) {
                // Aumentar el stock en 1
                talleSeleccionado[producto.color] += 1;

                // Habilitar el color en coloresDisponibles si el stock es mayor a 0
                if (talleSeleccionado[producto.color] > 0) {
                    const colorIndex = this.coloresDisponibles.findIndex(
                        (color) => color.value === producto.color
                    );
                    if (colorIndex !== -1) {
                        // Actualizar la lista de colores activos
                        this.coloresDisponibles = this.coloresDisponibles.map(
                            (color, index) => {
                                if (index === colorIndex) {
                                    return {
                                        ...color,
                                        props: {
                                            ...color.props,
                                            disabled: false,
                                        },
                                    };
                                }
                                return color;
                            }
                        );
                    }
                }
            }

            // Eliminar el producto del array de productos
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
                cliente_cuit: this.form.cliente_cuit,
                cliente_cbu: this.form.cliente_cbu,
                forma_pago: this.form.forma_pago,
                productos: this.productos, // Enviamos los productos agregados
                fecha: this.form.fecha,
            };

            axios
                .post("/ventas", ventaData)
                .then((response) => {
                    this.fetchVentas(); // Actualiza la lista de ventas
                    this.dialogVenta = false;
                    // Limpiar formulario y productos
                    this.form = {
                        cliente_nombre: "",
                        cliente_apellido: "",
                        cliente_cuit: "",
                        cliente_cbu: "",
                        fecha: moment().format("YYYY-MM-DD"),
                        forma_pago: "efectivo",
                    };
                    this.productos = [];
                    this.articuloActual = null;
                    this.tallesDisponibles = [];
                    this.coloresDisponibles = [];
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
