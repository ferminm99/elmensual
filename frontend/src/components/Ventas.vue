<template>
    <div class="mobile-root">
        <!-- TÍTULO -->
        <v-row class="acciones-top">
            <v-col>
                <h1 class="title font-weight-bold mb-3">Gestión de Ventas</h1>
            </v-col>
        </v-row>

        <!-- BOTONES -->
        <v-row class="acciones-top">
            <v-col>
                <div class="botones-container">
                    <v-row
                        justify="start"
                        class="acciones-top d-flex align-center mb-2"
                    >
                        <v-btn
                            color="black"
                            class="mr-2"
                            @click="openVentaDialog"
                        >
                            <v-icon left color="white">mdi-cash</v-icon>
                            Registrar Venta
                        </v-btn>

                        <v-btn
                            outlined
                            class="mr-2"
                            @click="openFacturarDialog"
                        >
                            <v-icon left>mdi-file-document</v-icon> Facturar
                        </v-btn>

                        <v-btn outlined @click="openFechaDialog">
                            <v-icon left>mdi-calendar</v-icon> Filtrar por Fecha
                        </v-btn>
                    </v-row>
                </div>
                <div class="facturacion-text mt-2">
                    Última Facturación:
                    <strong v-if="ultimaFacturacion">
                        {{ formatFechaMoment(ultimaFacturacion.fecha) }} de
                        {{ ultimaFacturacion.cliente.nombre }}
                    </strong>
                    <span v-else class="gray--text"
                        >Sin facturación registrada</span
                    >
                </div>
            </v-col>
        </v-row>

        <!-- BÚSQUEDA -->
        <v-row class="busqueda-top">
            <v-col cols="12" md="3">
                <v-select
                    v-model="tipoBusqueda"
                    :items="['General', 'Producto', 'Otros datos']"
                    label="Buscar por"
                    dense
                    variant="solo"
                ></v-select>
            </v-col>
            <v-col cols="12" md="9">
                <v-text-field
                    v-model="search"
                    label="Buscar"
                    append-inner-icon="mdi-magnify"
                    dense
                    variant="solo"
                ></v-text-field>
            </v-col>
        </v-row>

        <!-- TOTALES -->
        <v-row class="totales-top">
            <v-col cols="12">
                <h4>
                    Total de Ventas:
                    <span class="black--text">${{ totalVentas }}</span>
                </h4>
                <h4>
                    Ganancias Netas:
                    <span class="green--text"
                        >${{ calcularTotalGastado() }}</span
                    >
                </h4>
            </v-col>
        </v-row>

        <v-row v-if="filtroAplicado" class="total-fecha-row">
            <v-col
                cols="12"
                class="d-flex flex-column pa-3 bordered-total rounded"
            >
                <!-- Rango de fechas -->
                <div class="mb-3">
                    <v-icon small class="mr-1" color="primary"
                        >mdi-calendar-range</v-icon
                    >
                    Ventas del
                    <strong>{{ formatFechaMoment(fechaDesde) }}</strong>
                    al
                    <strong>{{ formatFechaMoment(fechaHasta) }}</strong>
                </div>

                <!-- Totales -->
                <div
                    class="d-flex flex-column flex-md-row justify-md-space-between align-md-center"
                >
                    <div class="mb-2 mb-md-0">
                        <div class="text-caption grey--text text--darken-1">
                            Total bruto de ventas
                        </div>
                        <div class="font-weight-bold text-h6 black--text">
                            ${{ totalVentasFiltradas }}
                        </div>
                    </div>

                    <div>
                        <div class="text-caption grey--text text--darken-1">
                            Ganancia neta (precio - costo)
                        </div>
                        <div class="font-weight-bold text-h6 green--text">
                            ${{ gananciasNetasFiltradas }}
                        </div>
                    </div>

                    <v-btn
                        icon
                        @click="cancelarFiltro"
                        class="ml-md-4 mt-3 mt-md-0"
                    >
                        <v-icon color="red">mdi-close-circle</v-icon>
                    </v-btn>
                </div>
            </v-col>
        </v-row>

        <!-- Tabla para visualizar las ventas -->
        <!-- <v-card class="pa-5"> -->
        <!-- <v-card-title class="text-left mb-4"> -->
        <!-- </v-card-title> -->
        <!-- </v-card> -->
        <ResponsiveTable
            :key="tablaKey"
            :headers="headers"
            :items="ventasFiltradas"
            :search="search"
            :custom-filter="
                tipoBusqueda === 'Producto'
                    ? buscarPorProducto
                    : tipoBusqueda === 'Otros datos'
                    ? buscarPorOtrosDatos
                    : buscarPorTodo
            "
            :options.sync="options"
            :item-class="getItemClass"
            class="elevation-1 mt-4"
        >
            <!-- Formato de la Fecha -->
            <template v-slot:item.fecha="{ item }">
                <span class="fecha-text">{{ formatFecha(item.fecha) }}</span>
            </template>

            <!-- Producto (Artículo + Talle + Color) -->
            <template v-slot:item.articulo_talle_color="{ item }">
                <span class="producto-text">
                    {{ item.articulo.nombre }} - Talle {{ item.talle }}
                    {{ item.color }}
                </span>
            </template>

            <!-- Cliente -->
            <template v-slot:item.cliente="{ item }">
                <div>{{ item.cliente.nombre }} {{ item.cliente.apellido }}</div>
                <div class="cliente-text">
                    <span v-if="item.cliente.cuit"
                        >CUIT: {{ item.cliente.cuit }}</span
                    >
                    <span v-else-if="item.cliente.cbu"
                        >CBU: {{ item.cliente.cbu }}</span
                    >
                </div>
            </template>

            <!-- Precio -->
            <template v-slot:item.precio="{ item }">
                <span class="precio-text">${{ formatPrice(item.precio) }}</span>
            </template>

            <!-- Costo Original -->
            <template v-slot:item.costo_original="{ item }">
                <span class="costo-text"
                    >${{ formatPrice(item.costo_original) }}</span
                >
            </template>

            <!-- Forma de Pago -->
            <template v-slot:item.forma_pago="{ item }">
                <span
                    :class="
                        item.forma_pago === 'efectivo'
                            ? 'efectivo-text'
                            : 'transferencia-text'
                    "
                >
                    {{
                        item.forma_pago === "efectivo"
                            ? "💵 Efectivo"
                            : "💳 Transferencia"
                    }}
                </span>
            </template>

            <!-- Botones de acciones -->
            <template v-slot:item.actions="{ item }">
                <v-btn flat icon @click="openEditDialog(item)">
                    <v-icon color="black">mdi-pencil-outline</v-icon>
                </v-btn>
                <v-btn flat icon @click="openDeleteConfirm(item)">
                    <v-icon color="black">mdi-trash-can-outline</v-icon>
                </v-btn>
                <v-btn flat icon @click="openCambioBombachaDialog(item)">
                    <v-icon color="black">mdi-swap-horizontal</v-icon>
                </v-btn>
            </template>
        </ResponsiveTable>

        <!-- Diálogo para registrar ventas -->
        <v-dialog v-model="dialogVenta" max-width="600px">
            <v-card>
                <v-card-title class="d-flex justify-space-between align-center">
                    <span class="headline">Registrar Venta</span>
                    <v-btn flat icon @click="closeDialogVenta">
                        <v-icon color="red">mdi-close</v-icon>
                    </v-btn>
                </v-card-title>
                <v-card-text>
                    <v-form ref="form">
                        <!-- Selección de artículo -->
                        <v-autocomplete
                            v-model="form.articulo_id"
                            :items="articulos"
                            :item-title="
                                (item) => `${item.numero} - ${item.nombre}`
                            "
                            item-value="id"
                            label="Selecciona un artículo"
                            clearable
                            filterable
                            @update:modelValue="loadTallesYColores"
                        />

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
                                    {{ producto.color }} - Precio ${{
                                        producto.precio
                                    }}
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

                        <!-- Forma de pago -->
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
                        <Datepicker
                            v-model="form.fecha"
                            placeholder="Seleccione una fecha"
                        ></Datepicker>
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
                <v-card-title
                    class="multi-line-title d-flex justify-space-between"
                >
                    <!-- Título con nombre del cliente y producto -->
                    <div>
                        Editar Venta de
                        <strong
                            >{{ selectedVenta.cliente_nombre }}&nbsp;</strong
                        >
                        <strong>{{ selectedVenta.cliente_apellido }}</strong> de
                        <div>
                            {{ selectedVenta.articulo.nombre }} - Talle
                            {{ selectedVenta.talle }} - Color
                            {{ selectedVenta.color }}
                        </div>
                    </div>
                    <!-- Botón de cierre en la parte superior derecha -->
                    <v-btn
                        flat
                        icon
                        @click="editDialog = false"
                        class="close-btn"
                    >
                        <v-icon color="red">mdi-close</v-icon>
                    </v-btn>
                </v-card-title>

                <v-card-text>
                    <!-- Campo para el nuevo precio -->
                    <v-text-field
                        v-model="selectedVenta.precio"
                        label="Precio"
                        type="number"
                    ></v-text-field>
                    <!-- Campo para el costo original -->
                    <v-text-field
                        v-model="selectedVenta.costo_original"
                        label="Precio por mayor"
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
                    <Datepicker
                        v-model="selectedVenta.fecha"
                        placeholder="Seleccione una fecha"
                    ></Datepicker>
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
                    ¿Estás seguro de que deseas eliminar la venta de
                    {{ selectedVenta.articulo.nombre }}
                    para el cliente
                    <strong
                        >{{ selectedVenta.cliente.nombre }}
                        {{ selectedVenta.cliente.apellido }}</strong
                    >?
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
                <v-card-title class="d-flex justify-space-between align-center"
                    >Generar Facturación<v-btn
                        flat
                        icon
                        @click="dialogFacturacion = false"
                    >
                        <v-icon color="red">mdi-close</v-icon>
                    </v-btn></v-card-title
                >

                <v-card-text>
                    <Datepicker
                        v-model="fechaDesdeFacturar"
                        label="Fecha Desde"
                    ></Datepicker>
                    <Datepicker
                        v-model="fechaHastaFacturar"
                        label="Fecha Hasta"
                    ></Datepicker>
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

        <v-dialog v-model="dialogoFechas" max-width="600px">
            <v-card>
                <v-card-title class="d-flex justify-space-between align-center"
                    >Seleccionar Fecha Desde y Hasta<v-btn
                        flat
                        icon
                        @click="dialogoFechas = false"
                    >
                        <v-icon color="red">mdi-close</v-icon>
                    </v-btn></v-card-title
                >
                <v-card-text>
                    <Datepicker v-model="fechaDesde"></Datepicker>

                    <Datepicker v-model="fechaHasta"></Datepicker>
                </v-card-text>
                <v-card-actions>
                    <v-btn text @click="dialogoFechas = false">Cancelar</v-btn>
                    <v-btn color="primary" text @click="aplicarFiltro"
                        >Aplicar</v-btn
                    >
                </v-card-actions>
            </v-card>
        </v-dialog>

        <v-dialog v-model="dialogCambioBombacha" max-width="600px">
            <v-card>
                <v-card-title class="d-flex justify-space-between">
                    <span class="headline">Cambiar Bombacha</span>
                    <v-spacer></v-spacer>
                    <v-btn icon @click="dialogCambioBombacha = false">
                        <v-icon color="red">mdi-close</v-icon>
                    </v-btn>
                </v-card-title>
                <v-card-text>
                    <v-form ref="cambioBombacha">
                        <!-- Selección de artículo -->
                        <v-select
                            v-model="cambioBombacha.articulo_id"
                            :items="articulos"
                            :item-title="
                                (item) => `${item.numero} - ${item.nombre}`
                            "
                            item-value="id"
                            label="Selecciona un artículo"
                            @update:modelValue="loadTallesYColores"
                        ></v-select>

                        <!-- Selección de talle y color -->
                        <v-row>
                            <v-col cols="6">
                                <v-select
                                    v-model="cambioBombacha.talle"
                                    :items="tallesDisponibles"
                                    item-title="talle"
                                    label="Selecciona un talle"
                                    :disabled="!cambioBombacha.articulo_id"
                                    @update:modelValue="onTalleChange"
                                ></v-select>
                            </v-col>
                            <v-col cols="6">
                                <v-select
                                    v-model="cambioBombacha.color"
                                    :items="coloresDisponibles"
                                    item-title="title"
                                    item-value="value"
                                    label="Selecciona un color"
                                    clearable
                                ></v-select>
                            </v-col>
                        </v-row>
                    </v-form>
                </v-card-text>
                <v-card-actions>
                    <v-spacer></v-spacer>
                    <v-btn text @click="dialogCambioBombacha = false"
                        >Cancelar</v-btn
                    >
                    <v-btn color="green" text @click="confirmarCambioBombacha"
                        >Confirmar</v-btn
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
import Datepicker from "./components/datepicker.vue";
import moment from "moment";
import {
    cachedFetch,
    updateCache,
    appendToCache,
    removeFromCache,
    modifyInCache,
    getMemoryCache,
    getCacheLastUpdate,
    resetAllCache,
    setSimpleCache,
    applyStockDelta,
} from "@/utils/cacheFetch"; // ajustá la ruta si está en otro lado
import { notifyCacheChange, onCacheChange } from "@/utils/cacheEvents";
import {
    ARTICULOS_TALLES_KEY,
    VENTAS_KEY,
    CLIENTES_KEY,
} from "../utils/cacheKeys";
import { useSyncedCache } from "@/utils/useSyncedCache";

export default {
    components: {
        Datepicker,
    },
    data() {
        return {
            tablaKey: 0,
            loading: false,
            ultimaFacturacion: null, // Para almacenar el último registro de facturación
            ventaUltimaFacturada: null, // Para almacenar el ID de la venta última facturada
            dialogCambioBombacha: false,
            cambioBombacha: {
                articulo_id: null,
                talle: null,
                color: null,
            },
            search: "", // Variable para el campo de búsqueda
            tipoBusqueda: "General",
            dialogoFechas: false, // Control del diálogo de fechas
            filtroAplicado: false, // Para mostrar el total solo si se aplicó el filtro
            dialogFacturacion: false,
            fechaDesdeFacturar: moment().startOf("month").toDate(), // Fecha desde seleccionada
            fechaHastaFacturar: moment().toDate(), // Fecha desde seleccionada
            fechaHasta: moment().toDate(), // Fecha hasta seleccionada
            fechaDesde: moment().startOf("month").toDate(), // Variable para la fecha seleccionada de facturacion
            dialogFechas: false,
            ventasFiltradas: [],
            overlay: false,
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
            snackbarColor: "success",
            dialogVenta: false,
            articuloActual: null,
            articulos: [], // Lista de artículos
            tallesDisponibles: [], // Talles para el artículo seleccionado
            coloresDisponibles: [], // Colores para el artículo seleccionado
            ventas: [], // Lista de ventas registradas
            editDialog: false, // Control para abrir/cerrar el diálogo de edición
            confirmDeleteDialog: false, // Control para abrir/cerrar el diálogo de confirmación de eliminación
            productos: [], // Lista de productos agregados en la venta
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
                fecha: moment().toDate(),
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
    mounted() {
        this.loading = true;

        window.addEventListener("notifyCacheChange", this.cacheListener);

        Promise.all([
            useSyncedCache({
                key: ARTICULOS_TALLES_KEY,
                apiPath: "/articulos/talles/actualizados-desde",
                fetchFn: () =>
                    axios
                        .get("/api/articulo/listar/talles")
                        .then((r) => r.data),
                onData: (data) => (this.articulos = data),
                setLoading: (val) => (this.loading = val), // opcional
            }),
            useSyncedCache({
                key: VENTAS_KEY,
                apiPath: "/ventas/actualizados-desde",
                fetchFn: () =>
                    axios.get("/api/ventas/listar").then((r) => r.data),
                onData: (data) => {
                    this.ventas = data.sort(
                        (a, b) => new Date(b.fecha) - new Date(a.fecha)
                    );
                    this.ventasFiltradas = this.ventas;
                },
            }),
            useSyncedCache({
                key: CLIENTES_KEY,
                apiPath: "/clientes/actualizados-desde",
                fetchFn: () =>
                    axios.get("/api/clientes/listar").then((r) => r.data),
                onData: (data) => (this.clientes = data),
            }),
        ]).then(() => {
            console.log("✅ Todas las sync completadas");
            console.log("👉 Ventas cargadas:", this.ventas.length);
            this.fetchUltimaFacturacion();
        });
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
        precioTotal() {
            return this.productos
                .reduce((total, producto) => {
                    const precio =
                        this.form.forma_pago === "efectivo"
                            ? parseFloat(producto.articulo.precio_efectivo)
                            : parseFloat(
                                  producto.articulo.precio_transferencia
                              );
                    return total + (isNaN(precio) ? 0 : precio);
                }, 0)
                .toLocaleString("es-AR", {
                    minimumFractionDigits: 2,
                    maximumFractionDigits: 2,
                });
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
        totalVentasFiltradas() {
            const total = this.ventasFiltradas.reduce((total, venta) => {
                return total + parseFloat(venta.precio || 0);
            }, 0);
            return total.toLocaleString("es-AR", {
                minimumFractionDigits: 2,
                maximumFractionDigits: 2,
            });
        },
        gananciasNetasFiltradas() {
            const total = this.ventasFiltradas.reduce((total, venta) => {
                const diferencia =
                    parseFloat(venta.precio) - parseFloat(venta.costo_original);
                return total + diferencia;
            }, 0);
            return total.toLocaleString("es-AR", {
                minimumFractionDigits: 2,
                maximumFractionDigits: 2,
            });
        },
    },
    beforeUnmount() {
        window.removeEventListener("notifyCacheChange", this.cacheListener);
    },

    watch: {
        ventas(newVentas) {
            this.ventasFiltradas = [...newVentas];
        },
    },

    methods: {
        getItemClass(item) {
            if (item.id === this.ventaUltimaFacturada) {
                return "ultima-facturada"; // Clase para la última facturada
            } else if (this.ventasFacturadas.includes(item.id)) {
                return "facturada-general"; // Clase para otras facturadas
            }
            return "";
        },
        async fetchUltimaFacturacion() {
            this.loading = true;

            try {
                const response = await axios.get("/api/facturaciones/ultima");
                const ultima = response.data;

                if (ultima && ultima.venta_id) {
                    // Si no hay ventas cargadas todavía, espero que se sincronicen
                    if (!this.ventas.length) {
                        console.warn(
                            "⏳ No hay ventas cargadas aún. Esperando..."
                        );
                        await new Promise((resolve) =>
                            setTimeout(resolve, 300)
                        ); // Esperar 300ms
                    }

                    const ventaCorrespondiente = this.ventas.find(
                        (venta) => venta.id === ultima.venta_id
                    );

                    if (ventaCorrespondiente) {
                        this.ultimaFacturacion = ventaCorrespondiente;
                        this.ventaUltimaFacturada = ventaCorrespondiente.id;

                        // Guardarlo opcionalmente
                        setSimpleCache(
                            "ultimaFacturacion",
                            ventaCorrespondiente
                        );
                        notifyCacheChange("ultimaFacturacion");
                    } else {
                        console.warn(
                            "⚠️ No se encontró la venta correspondiente en las ventas locales."
                        );
                        this.ultimaFacturacion = null;
                    }
                } else {
                    this.ultimaFacturacion = null;
                }
            } catch (error) {
                console.error("❌ Error fetching última facturación", error);
                this.ultimaFacturacion = null;
            } finally {
                this.loading = false;
            }
        },
        formatPrice(value) {
            const number = parseFloat(value); // Convertir el valor a número
            return isNaN(number) ? value : number.toFixed(2); // Verificar si es un número y aplicar toFixed
        },
        openCambioBombachaDialog(venta) {
            this.selectedVenta = venta;
            this.cambioBombacha = {
                articulo_id: null,
                talle: null,
                color: null,
            };
            this.dialogCambioBombacha = true;
        },
        confirmarCambioBombacha() {
            this.loading = true;
            if (
                !this.cambioBombacha.articulo_id ||
                this.cambioBombacha.talle === null ||
                !this.cambioBombacha.color
            ) {
                this.snackbarText = "Por favor selecciona la nueva bombacha.";
                this.snackbar = true;
                this.loading = false;
                return;
            }

            axios
                .post("/api/ventas/cambiar-bombachas", {
                    venta_id: this.selectedVenta.id,
                    original: {
                        articulo_id: this.selectedVenta.articulo.id,
                        talle: this.selectedVenta.talle,
                        color: this.selectedVenta.color,
                    },
                    nueva: this.cambioBombacha,
                    precio: this.selectedVenta.precio,
                    costo_original: this.selectedVenta.costo_original,
                    fecha: this.selectedVenta.fecha,
                    forma_pago: this.selectedVenta.forma_pago,
                })
                .then((res) => {
                    const ventaActualizada = res.data.venta || res.data;

                    // 🔄 Actualizar en cache
                    this.ventas = modifyInCache(
                        VENTAS_KEY,
                        (ventas) =>
                            ventas.map((v) =>
                                v.id === ventaActualizada.id
                                    ? ventaActualizada
                                    : v
                            ),
                        ventaActualizada.updated_at
                    );

                    // 🔁 Asegurar que esté en ventas
                    const idx = this.ventas.findIndex(
                        (v) => v.id === ventaActualizada.id
                    );
                    if (idx !== -1) {
                        this.ventas[idx] = ventaActualizada;
                    } else {
                        this.ventas.push(ventaActualizada);
                    }

                    this.ventas.sort(
                        (a, b) => new Date(b.fecha) - new Date(a.fecha)
                    );
                    this.ventasFiltradas = [...this.ventas];
                    this.tablaKey += 1;

                    notifyCacheChange(VENTAS_KEY);

                    // 📦 Ajustar stock
                    // applyStockDelta(
                    //     this.selectedVenta.articulo.id,
                    //     this.selectedVenta.talle,
                    //     this.selectedVenta.color,
                    //     1,
                    //     ARTICULOS_TALLES_KEY
                    // );
                    // applyStockDelta(
                    //     this.cambioBombacha.articulo_id,
                    //     this.cambioBombacha.talle,
                    //     this.cambioBombacha.color,
                    //     -1,
                    //     ARTICULOS_TALLES_KEY
                    // );
                    notifyCacheChange(ARTICULOS_TALLES_KEY);

                    // Refrescar articulos desde memoria (stock ya ajustado)
                    this.articulos = getMemoryCache(
                        ARTICULOS_TALLES_KEY,
                        86400
                    );

                    this.dialogCambioBombacha = false;
                    this.snackbarText =
                        "Cambio de bombacha realizado con éxito.";
                    this.snackbar = true;
                })
                .catch((error) => {
                    console.error(error);
                    this.snackbarText = "Error al cambiar la bombacha.";
                    this.snackbar = true;
                })
                .finally(() => {
                    this.loading = false;
                });
        },
        cancelarFiltro() {
            this.ventasFiltradas = this.ventas; // Restablecer la lista original
            this.filtroAplicado = false; // Desactivar el indicador del filtro
            this.fechaDesde = moment().startOf("month").toDate(); // Reiniciar la fecha desde
            this.fechaHasta = moment().toDate(); // Reiniciar la fecha hasta
        },
        aplicarFiltro() {
            if (!this.fechaDesde || !this.fechaHasta) {
                alert("Por favor selecciona ambas fechas.");
                return;
            }

            const desde = moment(this.fechaDesde).startOf("day"); // Asegurarnos de comparar desde el inicio del día
            const hasta = moment(this.fechaHasta).endOf("day"); // Comparar hasta el final del día

            // Filtrar las ventas dentro del rango de fechas
            this.ventasFiltradas = this.ventas.filter((venta) => {
                const fechaVenta = moment(venta.fecha);
                // Comparar si la fecha de la venta está entre las fechas seleccionadas
                return fechaVenta.isBetween(desde, hasta, null, "[]");
            });

            this.filtroAplicado = true; // Activar indicador para mostrar total
            this.dialogoFechas = false; // Cerrar diálogo
        },
        openFechaDialog() {
            this.dialogoFechas = true;
        },
        openFacturarDialog() {
            this.dialogFacturacion = true;
        },

        descargarArchivo(texto, nombreArchivo) {
            this.loading = true;
            const blob = new Blob([texto], { type: "text/plain" });
            const link = document.createElement("a");
            link.href = URL.createObjectURL(blob);
            link.download = nombreArchivo;
            document.body.appendChild(link);
            link.click();
            document.body.removeChild(link);
            this.loading = false;
        },

        generarFacturacion() {
            this.loading = true;
            if (!this.fechaDesdeFacturar) {
                this.snackbarText = "Por favor selecciona una fecha desde.";
                this.snackbar = true;
                return;
            }

            // Filtrar ventas por la fecha seleccionada
            const ventasPorFecha = this.filtrarVentasPorFecha();

            // Filtrar ventas para excluir las que son en efectivo
            const ventasFiltradas = ventasPorFecha.filter(
                (venta) => venta.forma_pago !== "efectivo"
            );

            if (ventasFiltradas.length === 0) {
                alert(
                    "No se encontraron ventas con transferencia en el rango seleccionado."
                );
                return;
            }

            let textoFacturacion =
                "Facturación de ventas agrupadas (solo transferencia):\n\n";

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

            const nombreArchivo = `facturacion_desde_${this.fechaDesdeFacturar}_hasta_hoy.txt`;
            this.descargarArchivo(textoFacturacion, nombreArchivo);

            // Ahora hacemos la llamada para guardar las facturaciones en la base de datos
            axios
                .post("/api/facturaciones/guardar", {
                    ventas: ventasFiltradas,
                    fecha: new Date(), // Fecha actual
                })
                .then((response) => {
                    // Actualizamos el id de la última facturación
                    this.ventaUltimaFacturada = response.data.ultima_venta_id;
                    this.snackbarText =
                        "Facturación generada y guardada con éxito.";
                    this.snackbar = true;
                })
                .catch((error) => {
                    console.error("Error al guardar las facturaciones", error);
                    this.snackbarText = "Error al guardar la facturación.";
                    this.snackbar = true;
                });

            this.dialogFacturacion = false; // Cerrar el diálogo después de generar
            this.loading = false;
        },

        filtrarVentasPorFecha() {
            // Convertimos la fecha desde seleccionada a formato YYYY-MM-DD
            const desde = moment(this.fechaDesdeFacturar).format("YYYY-MM-DD");
            const hoy = moment(this.fechaHastaFacturar).format("YYYY-MM-DD");

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
            const searchText = search.toLowerCase().trim().split(" ");

            // Acceder al artículo
            const articulo = item.raw.articulo || {};
            const articuloNombre = (articulo.nombre || "").toLowerCase();
            const numeroArticulo = (articulo.numero || "").toString(); // Número de artículo
            const talle = (item.raw.talle || "").toString(); // Convertimos a string
            const color = (item.raw.color || "").toLowerCase();

            // Concatenar todos los campos en un solo string de búsqueda
            const textoCompleto =
                `${articuloNombre} ${numeroArticulo} talle ${talle} ${color}`.toLowerCase();

            // Ver si todas las palabras del texto de búsqueda están en el texto completo (sin importar el orden)
            const allWordsMatch = searchText.every((word) =>
                textoCompleto.includes(word)
            );

            return allWordsMatch;
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
        formatFechaMoment(fecha) {
            // Usar moment para formatear la fecha en el formato que desees
            return moment(fecha).format("DD-MM-YYYY");
        },
        // Abrir el diálogo de edición con la venta seleccionada
        openEditDialog(item) {
            this.selectedVenta = { ...item };
            this.selectedVenta.cliente_nombre = item.cliente.nombre;
            this.selectedVenta.cliente_apellido = item.cliente.apellido;
            this.editDialog = true;
        },
        // Actualizar el precio de la venta
        updateVenta() {
            this.loading = true;
            axios
                .put(`/api/ventas/${this.selectedVenta.id}`, {
                    precio: this.selectedVenta.precio,
                    costo_original: this.selectedVenta.costo_original,
                    fecha: moment(this.selectedVenta.fecha).format(
                        "YYYY-MM-DD"
                    ),
                    forma_pago: this.selectedVenta.forma_pago,
                })
                .then((res) => {
                    const ventaActualizada = res.data.venta || res.data;

                    // 👇 Asegurás que updated_at esté en milisegundos
                    const updatedAtMs = ventaActualizada.updated_at
                        ? Number(ventaActualizada.updated_at) * 1000
                        : Date.now();

                    modifyInCache(
                        VENTAS_KEY,
                        (ventas) =>
                            ventas.map((v) =>
                                v.id === ventaActualizada.id
                                    ? ventaActualizada
                                    : v
                            ),
                        updatedAtMs
                    );

                    notifyCacheChange(VENTAS_KEY);

                    const idx = this.ventas.findIndex(
                        (v) => v.id === ventaActualizada.id
                    );
                    if (idx !== -1) {
                        this.ventas[idx] = ventaActualizada;
                    } else {
                        this.ventas.push(ventaActualizada);
                    }

                    this.ventas.sort(
                        (a, b) => new Date(b.fecha) - new Date(a.fecha)
                    );
                    this.ventasFiltradas = [...this.ventas];
                    this.tablaKey += 1;

                    this.snackbarText = "Venta actualizada correctamente.";
                    this.snackbar = true;
                    this.editDialog = false;
                })
                .catch((error) => {
                    console.error(error);
                    this.snackbarText = "Error al actualizar la venta.";
                    this.snackbar = true;
                })
                .finally(() => {
                    this.loading = false;
                });
        },
        // Abrir el diálogo de confirmación para eliminar la venta
        openDeleteConfirm(item) {
            this.selectedVenta = { ...item };
            this.confirmDeleteDialog = true;
        },
        cacheListener(e) {
            if (e.detail === VENTAS_KEY) {
                console.log("🔁 Cambios detectados en ventas desde otro tab");
                this.refreshVentasDesdeCache();
                this.tablaKey += 1;
            }
        },

        // Eliminar la venta
        deleteVenta() {
            this.loading = true;
            axios
                .delete(`/api/ventas/${this.selectedVenta.id}`)
                .then((res) => {
                    const updatedAt = res.data.updated_at || Date.now();
                    this.ventas = removeFromCache(
                        VENTAS_KEY,
                        (venta) => venta.id === this.selectedVenta.id,
                        updatedAt
                    );

                    notifyCacheChange(VENTAS_KEY);
                    this.refreshVentasDesdeCache();
                    this.tablaKey += 1;

                    // Restaurar stock
                    this.articulos = modifyInCache(
                        ARTICULOS_TALLES_KEY,
                        (articulos) => {
                            return articulos.map((art) => {
                                if (art.id === this.selectedVenta.articulo.id) {
                                    return {
                                        ...art,
                                        talles: art.talles.map((talle) => {
                                            if (
                                                talle.talle ===
                                                this.selectedVenta.talle
                                            ) {
                                                return {
                                                    ...talle,
                                                    [this.selectedVenta.color]:
                                                        (parseInt(
                                                            talle[
                                                                this
                                                                    .selectedVenta
                                                                    .color
                                                            ]
                                                        ) || 0) + 1,
                                                };
                                            }
                                            return talle;
                                        }),
                                    };
                                }
                                return art;
                            });
                        }
                    );
                    notifyCacheChange(ARTICULOS_TALLES_KEY);

                    this.confirmDeleteDialog = false;
                    this.snackbarText = "Venta eliminada y stock restaurado.";
                    this.snackbar = true;
                })
                .catch((error) => {
                    console.error(error);
                    if (error.response?.status === 404) {
                        this.snackbarText = "La venta ya no existe.";
                    } else {
                        this.snackbarText = "Error al eliminar la venta.";
                    }
                    this.snackbar = true;
                })
                .finally(() => {
                    this.loading = false;
                });
        },
        openVentaDialog() {
            this.dialogVenta = true;
        },
        resetStockLocal() {
            // Recorre cada producto que fue agregado y restaura el stock localmente
            this.productos.forEach((producto) => {
                const talle = this.tallesDisponibles.find(
                    (t) => t.talle === producto.talle
                );

                if (talle && talle[producto.color] !== undefined) {
                    // Aumentar el stock en 1 para el color correspondiente
                    talle[producto.color] += 1;

                    // Habilitar el color en coloresDisponibles si estaba deshabilitado
                    const colorIndex = this.coloresDisponibles.findIndex(
                        (color) => color.value === producto.color
                    );
                    if (colorIndex !== -1) {
                        this.coloresDisponibles[
                            colorIndex
                        ].props.disabled = false;
                    }
                }
            });

            // Limpiar la lista de productos después de restablecer el stock
            this.productos = [];
        },
        closeDialogVenta() {
            this.resetStockLocal();

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

        async fetchArticulos() {
            const data = await cachedFetch(
                ARTICULOS_TALLES_KEY,
                () =>
                    axios
                        .get("/api/articulo/listar/talles")
                        .then((r) => r.data),
                { ttl: 86400 }
            );
            this.articulos = data;
        },

        // Cargar ventas para mostrar en la tabla
        async fetchVentas() {
            const data = await cachedFetch(
                VENTAS_KEY,
                () => axios.get("/api/ventas/listar").then((r) => r.data),
                { ttl: 1000 * 60 * 60 * 24 } // 1 dia
            );
            this.ventas = data.sort(
                (a, b) => new Date(b.fecha) - new Date(a.fecha)
            );
            this.ventasFiltradas = this.ventas;
        },
        onTalleChange(talleSeleccionado) {
            let articuloSeleccionado = null;

            // Determinar si estamos trabajando con una venta o un cambio de bombacha
            if (this.form.articulo_id) {
                // Buscar el artículo seleccionado para la venta
                articuloSeleccionado = this.articulos.find(
                    (item) => item.id === this.form.articulo_id
                );
            } else if (this.cambioBombacha.articulo_id) {
                // Buscar el artículo seleccionado para el cambio de bombacha
                articuloSeleccionado = this.articulos.find(
                    (item) => item.id === this.cambioBombacha.articulo_id
                );
            }

            if (articuloSeleccionado) {
                const talleSeleccionadoObj = this.tallesDisponibles.find(
                    (talle) => talle.talle === talleSeleccionado
                );

                if (talleSeleccionadoObj) {
                    this.form.color = null; // Reiniciar el color antes de cargar los nuevos

                    // Cargar los colores originales basados en los talles disponibles activos
                    this.coloresDisponibles = Object.keys(talleSeleccionadoObj)
                        .filter(
                            (key) =>
                                ![
                                    "id",
                                    "articulo_id",
                                    "talle",
                                    "created_at",
                                    "updated_at",
                                ].includes(key) &&
                                typeof talleSeleccionadoObj[key] === "number"
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

            let articuloSeleccionado = null; // Cambiado a 'let' para permitir la reasignación

            // Determinar si la selección proviene de la venta o del cambio de bombacha
            if (this.form.articulo_id) {
                // Encontrar el artículo seleccionado para el registro de venta
                articuloSeleccionado = this.articulos.find(
                    (item) => item.id === this.form.articulo_id
                );
            } else if (this.cambioBombacha.articulo_id) {
                // Encontrar el artículo seleccionado para el cambio de bombacha
                articuloSeleccionado = this.articulos.find(
                    (item) => item.id === this.cambioBombacha.articulo_id
                );
            }

            if (articuloSeleccionado) {
                // Solo actualizar si el artículo seleccionado es diferente al actual
                this.articuloActual = articuloSeleccionado;
                console.log(this.articuloActual);
                this.tallesDisponibles = [...this.articuloActual.talles].sort(
                    (a, b) => a.talle - b.talle
                );
            } else {
                // Limpiar si no se selecciona un artículo válido
                this.tallesDisponibles = [];
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
            if (articulo && this.form.talle !== null && this.form.color) {
                this.productos.push({
                    articulo: articulo,
                    talle: this.form.talle,
                    color: this.form.color,
                    precio:
                        this.form.forma_pago === "efectivo"
                            ? parseInt(articulo.precio_efectivo)
                            : parseInt(articulo.precio_transferencia),

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
        async registrarVenta() {
            this.loading = true;
            this.form.fecha = moment(this.form.fecha).format("YYYY-MM-DD");
            this.form.cliente_nombre = this.capitalizarPalabras(
                this.form.cliente_nombre
            );
            this.form.cliente_apellido = this.capitalizarPalabras(
                this.form.cliente_apellido
            );

            if (!this.productos.length) {
                this.snackbarText = "Por favor ingresa los productos";
                this.snackbar = true;
                this.loading = false;
                return;
            }

            if (!this.form.cliente_nombre || !this.form.cliente_apellido) {
                this.snackbarText =
                    "Por favor ingresa el nombre y apellido del cliente.";
                this.snackbar = true;
                this.loading = false;
                return;
            }

            const ventaData = {
                cliente_nombre: this.form.cliente_nombre,
                cliente_apellido: this.form.cliente_apellido,
                cliente_cuit: this.form.cliente_cuit,
                cliente_cbu: this.form.cliente_cbu,
                forma_pago: this.form.forma_pago,
                productos: this.productos,
                fecha: this.form.fecha,
            };

            try {
                const res = await axios.post("/api/ventas", ventaData);

                // Las ventas que devuelve el backend ya vienen con articulo, cliente, id, etc.
                const nuevasVentas = Array.isArray(res.data.ventas)
                    ? res.data.ventas
                    : [];

                nuevasVentas.forEach((v) =>
                    appendToCache(VENTAS_KEY, v, v.updated_at)
                );

                notifyCacheChange(VENTAS_KEY);

                // ✅ Mostrar de inmediato en esta pestaña
                this.ventas.push(...nuevasVentas);
                this.ventas.sort(
                    (a, b) => new Date(b.fecha) - new Date(a.fecha)
                );
                this.ventasFiltradas = [...this.ventas];
                this.tablaKey += 1;

                // Restar stock en cache y local
                // this.productos.forEach((p) => {
                //     applyStockDelta(
                //         p.articulo.id,
                //         p.talle,
                //         p.color,
                //         -1,
                //         ARTICULOS_TALLES_KEY
                //     );
                // });
                notifyCacheChange(ARTICULOS_TALLES_KEY);
                this.articulos = getMemoryCache(ARTICULOS_TALLES_KEY, 86400); // refrescar desde memoria

                this.dialogVenta = false;
                this.resetFormVenta?.();
                this.fetchUltimaFacturacion();
            } catch (error) {
                console.error(error);
            } finally {
                this.loading = false;
            }
        },
        resetFormVenta() {
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
        },
        calcularPrecioTotal() {
            // Recalcula el precio total
            this.precioTotal = this.productos.reduce((total, producto) => {
                return total + parseFloat(producto.articulo.precio);
            }, 0);
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
        refreshVentasDesdeCache() {
            const updated = getMemoryCache(VENTAS_KEY, 86400);
            if (updated) {
                this.ventas = [...updated]; // fuerza nueva referencia
                this.ventasFiltradas = [...updated];
            }
        },
    },
};
</script>

<style scoped>
@import url("https://fonts.googleapis.com/css2?family=Nunito:wght@300;400;600;700&display=swap");
* {
    font-family: "Nunito", sans-serif;
}
/* Ajuste del estilo para eliminar los espacios innecesarios */
.v-card-title {
    font-size: 24px;
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

/* Color para el texto del precio */
.precio-text {
    color: black;
    font-weight: bold;
}

/* Color para efectivo y transferencia */
.efectivo-text {
    color: green;
}

.transferencia-text {
    color: #555;
}

/* Tabla de ventas con bordes limpios y espaciado reducido */
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

.v-icon {
    color: #555;
}

.v-icon:hover {
    color: black;
}

.total-text {
    font-size: 18px;
    font-weight: 500;
    margin-top: 10px;
}

.black--text {
    color: black;
}

.green--text {
    color: green;
}

.gray--text {
    color: #999;
}

.multi-line-title {
    white-space: normal; /* Permitir que el texto se ajuste en múltiples líneas */
    word-wrap: break-word; /* Asegurar que palabras largas se corten adecuadamente */
    font-size: 16px; /* Ajusta el tamaño según sea necesario */
    display: flex;
    flex-direction: column;
    margin-right: auto; /* Mantener el texto a la izquierda */
}

.close-btn {
    position: absolute;
    top: 16px;
    right: 16px;
}

.ultima-facturada {
    background-color: #1dbe45; /* Color de fondo para la última facturada */
}

.facturada {
    background-color: #dff0d8; /* Color de fondo para la última facturada */
}

.facturada-general {
    background-color: #f0e68c; /* Color para las demás ventas facturadas */
}

.bordered-total {
    border: 1px solid #e0e0e0;
    background-color: #fdfdfd;
    box-shadow: 0 2px 4px rgba(0, 0, 0, 0.04);
}

.rounded {
    border-radius: 12px;
}

/* Escala general para evitar "todo mini" */
@media (max-width: 768px) {
    .mobile-root {
        font-size: 18px;
        padding: 12px;
    }

    h1.title {
        font-size: 26px !important;
        margin-bottom: 16px;
    }

    .acciones-top {
        flex-direction: column !important;
        align-items: stretch !important;
        gap: 12px;
    }

    .acciones-top .v-btn {
        font-size: 18px !important;
        min-height: 44px !important;
        justify-content: center;
    }

    h1,
    h2,
    h3,
    h4,
    h5 {
        font-size: 24px !important;
    }

    .v-btn {
        font-size: 18px !important;
        padding: 10px 16px !important;
        min-height: 44px !important;
    }

    .v-text-field,
    .v-select {
        font-size: 18px !important;
    }

    .v-label {
        font-size: 17px !important;
    }

    .v-input__control {
        min-height: 48px !important;
    }

    .v-card {
        font-size: 18px;
    }

    .v-icon {
        font-size: 24px !important;
    }

    .total-text {
        font-size: 20px !important;
    }

    .label {
        font-size: 18px !important;
    }

    .value {
        font-size: 19px !important;
    }

    .v-card-actions .v-btn {
        font-size: 17px !important;
    }
}
</style>
