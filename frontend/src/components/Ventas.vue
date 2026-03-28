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
                            class="mr-2 registrar-venta-btn"
                            @click="openVentaDialog"
                        >
                            <v-icon left>mdi-cash</v-icon>
                            Registrar Venta
                        </v-btn>

                        <v-btn
                            class="mr-2 sin-stock-btn"
                            @click="openVentaSinStockDialog"
                        >
                            <v-icon left>mdi-cart-plus</v-icon>
                            Registrar Venta Sin Stock
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

                        <v-btn
                            v-if="selectedVentas.length"
                            color="black"
                            class="ml-2"
                            @click="openEditSelectedDialog"
                        >
                            <v-icon left color="white"
                                >mdi-pencil-multiple</v-icon
                            >
                            Editar seleccionadas
                        </v-btn>
                    </v-row>
                </div>
                <div class="facturacion-text mt-2">
                    Última Facturación:
                    <strong v-if="ultimaFacturacion">
                        {{
                            formatFechaMoment(
                                ultimaFacturacion.fecha_corte_facturacion,
                            )
                        }}
                        <template v-if="ultimaFacturacion.cliente">
                            de {{ ultimaFacturacion.cliente.nombre }}
                            {{ ultimaFacturacion.cliente.apellido }}
                        </template>
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
                <h4>
                    Total Financiado:
                    <span class="blue--text text--darken-2"
                        >${{ totalFinanciadoGeneral }}</span
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

                    <div class="mt-2 mt-md-0">
                        <div class="text-caption grey--text text--darken-1">
                            Total financiado del período
                        </div>
                        <div
                            class="font-weight-bold text-h6 blue--text text--darken-2"
                        >
                            ${{ totalFinanciadoFiltrado }}
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
            show-select
            item-value="id"
            return-object
            v-model:selected="selectedVentas"
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

            <template v-slot:item.plan="{ item }">
                <div v-if="item.cuota">
                    <div class="font-weight-medium">
                        {{ formatCuotaLabel(item.cuota) }}
                    </div>
                    <div class="text-caption grey--text">
                        {{
                            item.cuota.es_con_interes
                                ? "Con interés"
                                : "Sin interés"
                        }}
                    </div>
                </div>
                <span v-else>Contado</span>
            </template>

            <template v-slot:item.total_financiado="{ item }">
                <span>
                    $
                    {{
                        formatCurrency(
                            item.total_financiado ?? item.precio ?? 0,
                        )
                    }}
                </span>
            </template>

            <template v-slot:item.importe_cuota="{ item }">
                <span v-if="item.importe_cuota">
                    $
                    {{ formatCurrency(item.importe_cuota) }}
                </span>
                <span v-else>—</span>
            </template>

            <template v-slot:item.cantidad_cuotas="{ item }">
                <span v-if="item.cantidad_cuotas">
                    {{ item.cantidad_cuotas }}
                </span>
                <span v-else>—</span>
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
            <v-card
                :class="[
                    'venta-dialog-card',
                    sinStock
                        ? 'venta-dialog-card--sin-stock'
                        : 'venta-dialog-card--regular',
                ]"
            >
                <v-card-title class="d-flex justify-space-between align-center">
                    <span
                        class="headline"
                        :class="[
                            sinStock
                                ? 'venta-dialog-title--sin-stock'
                                : 'venta-dialog-title--regular',
                        ]"
                    >
                        Registrar Venta
                        <template v-if="sinStock"> Sin Stock</template>
                    </span>
                    <v-btn flat icon @click="closeDialogVenta">
                        <v-icon color="red">mdi-close</v-icon>
                    </v-btn>
                </v-card-title>
                <v-card-text>
                    <v-form ref="form">
                        <v-row class="d-flex flex-wrap align-end" dense>
                            <!-- Forma de Pago -->
                            <v-col cols="12" md="6">
                                <v-radio-group
                                    v-model="form.forma_pago"
                                    label="Forma de Pago"
                                    :mandatory="true"
                                    class="pt-0"
                                    column
                                >
                                    <v-radio
                                        label="Efectivo"
                                        value="efectivo"
                                    />
                                    <v-radio
                                        label="Transferencia"
                                        value="transferencia"
                                    />
                                </v-radio-group>
                            </v-col>

                            <!-- Fecha -->
                            <v-col cols="12" md="6">
                                <div class="w-100">
                                    <Datepicker
                                        v-model="form.fecha"
                                        placeholder="Seleccione una fecha"
                                        class="w-100"
                                        :input-class="'w-100'"
                                    />
                                </div>
                            </v-col>
                        </v-row>

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

                        <v-row>
                            <v-col cols="12">
                                <v-select
                                    v-model="form.cuota_id"
                                    :items="cuotasDisponiblesVenta"
                                    item-title="label"
                                    item-value="id"
                                    label="Plan de cuotas"
                                    :disabled="!cuotasDisponiblesVenta.length"
                                    clearable
                                    persistent-hint
                                    :hint="
                                        cuotasDisponiblesVenta.length
                                            ? 'Los montos finales se calculan automáticamente al agregar el producto.'
                                            : 'Selecciona un artículo para ver los planes disponibles.'
                                    "
                                ></v-select>
                            </v-col>
                        </v-row>

                        <v-alert
                            v-if="totalFinanciadoActual"
                            type="info"
                            variant="tonal"
                            color="blue"
                            class="mb-4"
                            border="start"
                        >
                            <div class="font-weight-medium">
                                Monto final estimado: $
                                {{
                                    formatCurrency(totalFinanciadoActual.total)
                                }}
                            </div>
                            <div class="text-caption">
                                {{ totalFinanciadoActual.cantidad }} cuota{{
                                    totalFinanciadoActual.cantidad === 1
                                        ? ""
                                        : "s"
                                }}
                                de $
                                {{
                                    formatCurrency(
                                        totalFinanciadoActual.importe,
                                    )
                                }}
                            </div>
                        </v-alert>

                        <!-- Agregar con y sin mantener selección -->
                        <!-- Agregar con y sin mantener selección -->
                        <v-row class="mt-3" dense>
                            <v-col cols="12" md="6">
                                <v-btn
                                    color="green"
                                    block
                                    @click="agregarProducto"
                                >
                                    Agregar y Limpiar
                                </v-btn>
                            </v-col>
                            <v-col cols="12" md="6">
                                <v-btn
                                    color="blue"
                                    block
                                    @click="agregarProducto(true)"
                                >
                                    Agregar Manteniendo
                                </v-btn>
                            </v-col>
                        </v-row>

                        <!-- Lista de productos agregados -->
                        <v-list dense>
                            <v-list-item
                                v-for="(producto, index) in productos"
                                :key="index"
                                class="d-flex align-center"
                            >
                                <v-list-item-content>
                                    <div class="font-weight-medium">
                                        {{ producto.articulo.nombre }} - Talle
                                        {{ producto.talle }} - Color
                                        {{ producto.color }} - Precio ${{
                                            formatCurrency(producto.precio)
                                        }}
                                    </div>
                                    <div class="text-caption grey--text">
                                        <template v-if="producto.cuota">
                                            {{
                                                producto.cuota.label ||
                                                formatCuotaLabel(producto.cuota)
                                            }}
                                            — Total: $
                                            {{
                                                formatCurrency(
                                                    producto.total_financiado,
                                                )
                                            }}
                                            — Cuota: $
                                            {{
                                                formatCurrency(
                                                    producto.importe_cuota,
                                                )
                                            }}
                                        </template>
                                        <template v-else
                                            >Venta al contado</template
                                        >
                                    </div>
                                </v-list-item-content>
                                <v-list-item-action>
                                    <v-btn icon @click="editarProducto(index)">
                                        <v-icon color="blue">mdi-pencil</v-icon>
                                    </v-btn>
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

                        <v-text-field
                            label="Total Financiado (productos)"
                            :model-value="totalFinanciadoSeleccionado"
                            readonly
                        ></v-text-field>

                        <!-- Información del cliente -->
                        <v-switch
                            v-model="clienteExistente"
                            label="Cliente existente"
                            class="mb-2"
                            @update:modelValue="toggleClienteExistente"
                        ></v-switch>
                        <v-autocomplete
                            v-if="clienteExistente"
                            v-model="clienteSeleccionado"
                            :items="clientes"
                            :item-title="
                                (item) => `${item.nombre} ${item.apellido}`
                            "
                            item-value="id"
                            return-object
                            label="Selecciona un cliente"
                            clearable
                            @update:modelValue="onClienteSelect"
                        ></v-autocomplete>
                        <template v-else>
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
                        </template>
                        <v-text-field
                            v-model="form.cliente_cuit"
                            label="CUIT (opcional)"
                            type="number"
                            :readonly="clienteExistente"
                        ></v-text-field>
                        <v-text-field
                            v-model="form.cliente_cbu"
                            label="CBU (opcional)"
                            :readonly="clienteExistente"
                        ></v-text-field>

                        <!-- Selección de fecha -->
                        <!-- <v-text-field
                            type="date"
                            v-model="form.fecha"
                            placeholder="Seleccione una fecha"
                        ></v-text-field> -->

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

                    <v-select
                        v-if="cuotasDisponiblesEdicion.length"
                        v-model="selectedVenta.cuota_id"
                        :items="cuotasDisponiblesEdicion"
                        item-title="label"
                        item-value="id"
                        label="Plan de cuotas"
                        class="mt-3"
                        clearable
                    ></v-select>
                    <div
                        v-else-if="selectedVenta.articulo"
                        class="text-caption grey--text mt-3"
                    >
                        Este artículo no tiene planes de cuotas configurados.
                    </div>
                    <v-alert
                        v-if="resumenCuotaEdicion"
                        type="info"
                        variant="tonal"
                        color="blue"
                        border="start"
                        class="mt-2"
                    >
                        <div class="font-weight-medium">
                            Monto final: $
                            {{ formatCurrency(resumenCuotaEdicion.total) }}
                        </div>
                        <div class="text-caption">
                            {{ resumenCuotaEdicion.cantidad }} cuota{{
                                resumenCuotaEdicion.cantidad === 1 ? "" : "s"
                            }}
                            de $
                            {{ formatCurrency(resumenCuotaEdicion.importe) }}
                        </div>
                    </v-alert>

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

        <!-- Diálogo para editar ventas seleccionadas -->
        <v-dialog v-model="editSelectedDialog" max-width="500px">
            <v-card>
                <v-card-title class="d-flex justify-space-between align-center">
                    Editar Ventas
                    <v-btn flat icon @click="editSelectedDialog = false">
                        <v-icon color="red">mdi-close</v-icon>
                    </v-btn>
                </v-card-title>

                <v-card-text>
                    <v-text-field
                        v-model="editSelected.precio"
                        label="Precio"
                        type="number"
                    ></v-text-field>

                    <v-radio-group
                        v-model="editSelected.forma_pago"
                        label="Forma de Pago"
                    >
                        <v-radio label="Efectivo" value="efectivo"></v-radio>
                        <v-radio
                            label="Transferencia"
                            value="transferencia"
                        ></v-radio>
                    </v-radio-group>

                    <Datepicker
                        v-model="editSelected.fecha"
                        placeholder="Seleccione una fecha"
                        class="w-100"
                        :input-class="'w-100'"
                    ></Datepicker>
                </v-card-text>

                <v-card-actions>
                    <v-spacer></v-spacer>
                    <v-btn text @click="editSelectedDialog = false"
                        >Cancelar</v-btn
                    >
                    <v-btn color="green" text @click="confirmEditSelected"
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

        <v-dialog v-model="editarProductoDialog" max-width="400">
            <v-card>
                <v-card-title>Editar Precio</v-card-title>
                <v-card-text>
                    <v-text-field
                        v-model="productoEnEdicion.precio"
                        label="Precio"
                        type="number"
                        min="0"
                    ></v-text-field>
                </v-card-text>
                <v-card-actions>
                    <v-spacer></v-spacer>
                    <v-btn text @click="editarProductoDialog = false"
                        >Cancelar</v-btn
                    >
                    <v-btn color="green" text @click="guardarEdicionProducto"
                        >Guardar</v-btn
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
    <v-alert
        v-if="productoCargado"
        type="success"
        class="mt-2 mb-1"
        dense
        border="left"
        text
    >
        Producto agregado correctamente ✔️
    </v-alert>
</template>

<script>
import axios from "axios";
import Datepicker from "./components/datepicker.vue";
import moment from "moment";
import {
    cachedFetch,
    updateCache,
    appendToCache,
    removeFromCache,
    modifyInCache,
    getMemoryCache,
    setSimpleCache,
} from "@/utils/cacheFetch"; // ajustá la ruta si está en otro lado
import { notifyCacheChange, onCacheChange } from "@/utils/cacheEvents";
import { showToast } from "@/utils/toast";
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
            productoCargado: false,
            editarProductoDialog: false,
            productoEnEdicion: {
                index: null,
                precio: 0,
            },
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
            fechaDesdeFacturar: moment().startOf("month").format("YYYY-MM-DD"), // Fecha desde seleccionada
            fechaHastaFacturar: moment().format("YYYY-MM-DD"), // Fecha hasta seleccionada
            fechaHasta: moment().format("YYYY-MM-DD"), // Fecha hasta seleccionada
            fechaDesde: moment().startOf("month").format("YYYY-MM-DD"), // Variable para la fecha seleccionada de facturacion
            dialogFechas: false,
            ventasFiltradas: [],
            overlay: false,
            options: {
                sortBy: ["fecha"],
                sortDesc: [true], // true para orden descendente (de más nueva a más antigua)
            },
            selectedVentas: [],
            selectedVenta: {
                forma_pago: null,
                fecha: null,
                precio: null,
                costo_original: null,
                cuota_id: null,
            },
            snackbarColor: "success",
            dialogVenta: false,
            articuloActual: null,
            articulos: [], // Lista de artículos
            tallesDisponibles: [], // Talles para el artículo seleccionado
            coloresDisponibles: [], // Colores para el artículo seleccionado
            cuotasDisponiblesVenta: [],
            sinStock: false,
            tallesGenerales: [
                0, 2, 4, 6, 8, 10, 12, 14, 16, 32, 34, 36, 38, 40, 42, 44, 46,
                48, 50, 52, 54, 56, 58, 60, 62, 64, 66, 68, 70,
            ],
            coloresGenerales: [
                "verde",
                "azul",
                "marron",
                "negro",
                "celeste",
                "blancobeige",
            ],
            ventas: [], // Lista de ventas registradas
            clientes: [], // Lista de clientes disponibles
            clienteSeleccionado: null,
            clienteExistente: false,
            editDialog: false, // Control para abrir/cerrar el diálogo de edición
            editSelectedDialog: false,
            editSelected: {
                precio: null,
                forma_pago: null,
                fecha: null,
            },
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
                fecha: moment().format("YYYY-MM-DD"),
                forma_pago: "efectivo",
                cuota_id: null,
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
                { title: "Plan", key: "plan", sortable: false },
                {
                    title: "Total Financiado",
                    key: "total_financiado",
                    sortable: false,
                },
                {
                    title: "Importe de Cuota",
                    key: "importe_cuota",
                    sortable: false,
                },
                {
                    title: "Cuotas",
                    key: "cantidad_cuotas",
                    sortable: false,
                },
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
                    this.ventas = data.sort((a, b) =>
                        this.compareFechaDesc(a.fecha, b.fecha),
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
            const total = this.productos.reduce((acc, producto) => {
                return acc + Number(producto.precio || 0);
            }, 0);

            return this.formatCurrency(total);
        },
        totalFinanciadoSeleccionado() {
            const total = this.productos.reduce((acc, producto) => {
                if (producto.total_financiado) {
                    return acc + Number(producto.total_financiado || 0);
                }
                return acc + Number(producto.precio || 0);
            }, 0);

            return this.formatCurrency(total);
        },
        cuotaSeleccionada() {
            if (!this.form.cuota_id) return null;
            return (
                this.cuotasDisponiblesVenta.find(
                    (cuota) => cuota.id === this.form.cuota_id,
                ) || null
            );
        },
        totalFinanciadoActual() {
            const cuota = this.cuotaSeleccionada;
            if (!cuota || !this.articuloActual) return null;

            const base = Number(this.articuloActual.precio_transferencia || 0);
            const total = this.redondearPrecio(
                base * Number(cuota.factor_total || 0),
            );
            const cantidad = Number(cuota.cantidad_cuotas || 0);
            const importe = cantidad ? total / cantidad : 0;

            return {
                total,
                cantidad,
                importe,
            };
        },
        cuotasDisponiblesEdicion() {
            const cuotas = this.selectedVenta?.articulo?.cuotas;
            if (!Array.isArray(cuotas)) {
                return [];
            }
            const filtradas = this.filtrarCuotasPorFormaPago(
                cuotas,
                this.selectedVenta?.forma_pago || null,
            );
            return filtradas.map((cuota) => ({
                ...cuota,
                label: this.formatCuotaLabel(cuota),
            }));
        },
        resumenCuotaEdicion() {
            if (!this.selectedVenta?.cuota_id) {
                return null;
            }
            const cuota = this.cuotasDisponiblesEdicion.find(
                (item) => item.id === this.selectedVenta.cuota_id,
            );
            if (!cuota) {
                return null;
            }
            const base = Number(this.selectedVenta?.precio || 0);
            const total = this.redondearPrecio(
                base * Number(cuota.factor_total || 0),
            );
            const cantidad = Number(cuota.cantidad_cuotas || 0);
            const importe = cantidad ? total / cantidad : 0;

            return {
                total,
                cantidad,
                importe,
            };
        },
        totalVentas() {
            const total = this.ventas.reduce((total, venta) => {
                return total + parseFloat(venta.precio || 0); // Suma los precios
            }, 0);
            return total.toLocaleString("es-AR", {
                minimumFractionDigits: 2,
                maximumFractionDigits: 2,
            });
        },
        totalFinanciadoGeneral() {
            const total = this.ventas.reduce((acc, venta) => {
                const final = venta.total_financiado ?? venta.precio ?? 0;
                return acc + Number(final);
            }, 0);

            return this.formatCurrency(total);
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
        totalFinanciadoFiltrado() {
            const total = this.ventasFiltradas.reduce((acc, venta) => {
                const final = venta.total_financiado ?? venta.precio ?? 0;
                return acc + Number(final);
            }, 0);

            return this.formatCurrency(total);
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
        "form.forma_pago"() {
            this.actualizarCuotasPorFormaPago();
        },
        "form.cuota_id"(nuevo) {
            if (nuevo && this.form.forma_pago !== "transferencia") {
                this.form.forma_pago = "transferencia";
            }
        },
        "selectedVenta.forma_pago"() {
            this.validarCuotaSeleccionadaEdicion();
        },
        "selectedVenta.cuota_id"(nuevo) {
            if (!this.selectedVenta) {
                return;
            }
            if (nuevo && this.selectedVenta.forma_pago !== "transferencia") {
                this.selectedVenta.forma_pago = "transferencia";
            }
        },
    },

    methods: {
        redondearPrecio(valor) {
            const numero = Number(valor || 0);
            if (!numero) {
                return 0;
            }
            return Math.round(numero / 500) * 500;
        },
        formatCurrency(value) {
            const number = Number(value ?? 0);
            if (!isFinite(number)) {
                return "0,00";
            }
            return number.toLocaleString("es-AR", {
                minimumFractionDigits: 2,
                maximumFractionDigits: 2,
            });
        },
        formatCuotaLabel(cuota) {
            if (!cuota) {
                return "Venta al contado";
            }
            const cantidad =
                Number(
                    cuota.cantidad_cuotas ?? cuota?.pivot?.cantidad_cuotas ?? 0,
                ) || 1;
            const plural = cantidad === 1 ? "cuota" : "cuotas";
            const tipo = cuota.es_con_interes ? "con interés" : "sin interés";
            const factor = Number(cuota.factor_total ?? 1);
            const factorTexto = Number.isFinite(factor)
                ? factor.toFixed(2)
                : "1.00";
            return `${cantidad} ${plural} ${tipo} (${factorTexto}x)`;
        },
        toggleClienteExistente() {
            if (!this.clienteExistente) {
                this.clienteSeleccionado = null;
                this.form.cliente_nombre = "";
                this.form.cliente_apellido = "";
                this.form.cliente_cuit = "";
                this.form.cliente_cbu = "";
            }
        },
        filtrarCuotasPorFormaPago(cuotas, formaPago) {
            if (!Array.isArray(cuotas)) {
                return [];
            }

            if (formaPago !== "transferencia") {
                return [];
            }

            return cuotas.filter((cuota) => Boolean(cuota));
        },
        mapearCuotasParaSelect(cuotas) {
            return cuotas.map((cuota) => ({
                ...cuota,
                label: this.formatCuotaLabel(cuota),
            }));
        },
        actualizarCuotasPorFormaPago() {
            if (
                !this.articuloActual ||
                !Array.isArray(this.articuloActual.cuotas)
            ) {
                this.cuotasDisponiblesVenta = [];
                this.form.cuota_id = null;
                return;
            }

            const filtradas = this.filtrarCuotasPorFormaPago(
                this.articuloActual.cuotas,
                this.form.forma_pago,
            );
            const mapeadas = this.mapearCuotasParaSelect(filtradas);
            this.cuotasDisponiblesVenta = mapeadas;

            if (!mapeadas.some((cuota) => cuota.id === this.form.cuota_id)) {
                this.form.cuota_id = null;
            }
        },
        validarCuotaSeleccionadaEdicion() {
            if (
                !this.selectedVenta ||
                !this.selectedVenta.articulo ||
                !Array.isArray(this.selectedVenta.articulo.cuotas)
            ) {
                return;
            }

            const filtradas = this.filtrarCuotasPorFormaPago(
                this.selectedVenta.articulo.cuotas,
                this.selectedVenta.forma_pago,
            );

            if (
                !filtradas.some(
                    (cuota) => cuota.id === this.selectedVenta.cuota_id,
                )
            ) {
                this.selectedVenta.cuota_id = null;
            }
        },
        onClienteSelect(cliente) {
            if (cliente) {
                this.form.cliente_nombre = cliente.nombre;
                this.form.cliente_apellido = cliente.apellido;
                this.form.cliente_cuit = cliente.cuit || "";
                this.form.cliente_cbu = cliente.cbu || "";
            } else {
                this.form.cliente_nombre = "";
                this.form.cliente_apellido = "";
                this.form.cliente_cuit = "";
                this.form.cliente_cbu = "";
            }
        },
        getItemClass(item) {
            if (item.id === this.ventaUltimaFacturada) {
                return "ultima-facturada"; // Clase para la última facturada
            } else if (this.ventasFacturadas.includes(item.id)) {
                return "facturada-general"; // Clase para otras facturadas
            }
            return "";
        },
        editarProducto(index) {
            const producto = this.productos[index];
            this.productoEnEdicion = {
                index,
                precio: producto.precio,
            };
            this.editarProductoDialog = true;
        },
        guardarEdicionProducto() {
            const { index, precio } = this.productoEnEdicion;

            if (precio <= 0 || isNaN(precio)) {
                this.snackbarText = "Precio inválido.";
                this.snackbar = true;
                return;
            }

            const precioRedondeado = this.redondearPrecio(parseFloat(precio));
            this.productos[index].precio = precioRedondeado;
            const cuota = this.productos[index].cuota;
            if (cuota) {
                const total = this.redondearPrecio(
                    precioRedondeado * Number(cuota.factor_total || 0),
                );
                const cantidad = Number(cuota.cantidad_cuotas || 0);
                this.productos[index].total_financiado = total;
                this.productos[index].importe_cuota = cantidad
                    ? total / cantidad
                    : null;
            }
            this.editarProductoDialog = false;
        },
        async fetchUltimaFacturacion() {
            this.loading = true;

            try {
                const response = await axios.get("/api/facturaciones/ultima");
                const ultima = response.data;

                const fechaCorte =
                    ultima?.fecha_corte_facturacion ||
                    ultima?.fecha_facturacion;

                if (ultima && fechaCorte) {
                    const ventaRelacionadaId =
                        ultima?.venta_destacada_id || ultima?.venta_id;
                    const ventaRelacionada = this.ventas.find(
                        (venta) => venta.id === ventaRelacionadaId,
                    );
                    this.ultimaFacturacion = {
                        fecha_corte_facturacion: fechaCorte,
                        cliente: ventaRelacionada?.cliente || null,
                    };
                    this.ventaUltimaFacturada =
                        ultima.venta_destacada_id || null;

                    setSimpleCache("ultimaFacturacion", this.ultimaFacturacion);
                    notifyCacheChange("ultimaFacturacion");
                } else {
                    this.ultimaFacturacion = null;
                    this.ventaUltimaFacturada = null;
                }
            } catch (error) {
                console.error("❌ Error fetching última facturación", error);
                this.ultimaFacturacion = null;
                this.ventaUltimaFacturada = null;
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
                                    : v,
                            ),
                        ventaActualizada.updated_at,
                    );

                    // 🔁 Asegurar que esté en ventas
                    const idx = this.ventas.findIndex(
                        (v) => v.id === ventaActualizada.id,
                    );
                    if (idx !== -1) {
                        this.ventas[idx] = ventaActualizada;
                    } else {
                        this.ventas.push(ventaActualizada);
                    }

                    this.ventas.sort((a, b) =>
                        this.compareFechaDesc(a.fecha, b.fecha),
                    );
                    this.ventasFiltradas = [...this.ventas];
                    this.tablaKey += 1;

                    notifyCacheChange(VENTAS_KEY);
                    notifyCacheChange(ARTICULOS_TALLES_KEY);

                    // Refrescar articulos desde memoria (stock ya ajustado)
                    this.articulos = getMemoryCache(
                        ARTICULOS_TALLES_KEY,
                        86400,
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
            this.fechaDesde = moment().startOf("month").format("YYYY-MM-DD"); // Reiniciar la fecha desde
            this.fechaHasta = moment().format("YYYY-MM-DD"); // Reiniciar la fecha hasta
        },
        aplicarFiltro() {
            if (!this.fechaDesde || !this.fechaHasta) {
                alert("Por favor selecciona ambas fechas.");
                return;
            }

            const desde = this.normalizeFecha(this.fechaDesde);
            const hasta = this.normalizeFecha(this.fechaHasta);

            this.ventasFiltradas = this.ventas.filter((venta) => {
                const fechaVenta = this.normalizeFecha(venta.fecha);
                return fechaVenta >= desde && fechaVenta <= hasta;
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
                (venta) => venta.forma_pago !== "efectivo",
            );

            if (ventasFiltradas.length === 0) {
                alert(
                    "No se encontraron ventas con transferencia en el rango seleccionado.",
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
                        venta.precio,
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

            const fechaDesde = moment(this.fechaDesdeFacturar).format(
                "YYYY-MM-DD",
            );
            const fechaHasta = moment(this.fechaHastaFacturar).format(
                "YYYY-MM-DD",
            );

            // Ahora hacemos la llamada para guardar las facturaciones en la base de datos
            axios
                .post("/api/facturaciones/guardar", {
                    ventas: ventasFiltradas,
                    fecha: new Date(), // Fecha actual
                    fecha_desde: fechaDesde,
                    fecha_hasta: fechaHasta,
                })
                .then((response) => {
                    const ventaDestacada = ventasFiltradas.find(
                        (venta) =>
                            venta.id === response.data.venta_destacada_id,
                    );
                    this.ventaUltimaFacturada =
                        response.data.venta_destacada_id;
                    this.ultimaFacturacion = {
                        fecha_corte_facturacion:
                            response.data.fecha_corte_facturacion,
                        cliente:
                            response.data.cliente_destacado ||
                            ventaDestacada?.cliente ||
                            null,
                    };
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
            const desde = this.normalizeFecha(this.fechaDesdeFacturar);
            const hoy = this.normalizeFecha(this.fechaHastaFacturar);

            return this.ventas.filter((venta) => {
                const fechaVenta = this.normalizeFecha(venta.fecha);
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

            const cuota = item.raw.cuota || {};
            const planLabel = cuota.id
                ? this.formatCuotaLabel(cuota).toLowerCase()
                : "";
            const interesTexto = cuota.id
                ? cuota.es_con_interes
                    ? "con interes"
                    : "sin interes"
                : "";
            const totalFinanciado = (
                item.raw.total_financiado || ""
            ).toString();
            const importeCuota = (item.raw.importe_cuota || "").toString();
            const cantidadCuotas = (item.raw.cantidad_cuotas || "").toString();

            // Ver si alguno de estos campos coincide con el texto de búsqueda
            const matchesCliente = clienteNombreCompleto.includes(searchText);
            const matchesCBU = cbu.includes(searchText);
            const matchesCUIT = cuit.includes(searchText);
            const matchesArticulo = articuloNombre.includes(searchText);
            const matchesTalle = talle.includes(searchText);
            const matchesColor = color.includes(searchText);
            const matchesPrecio = precio.includes(searchText);
            const matchesCostoOriginal = costoOriginal.includes(searchText);
            const matchesPlan = planLabel.includes(searchText);
            const matchesInteres = interesTexto.includes(searchText);
            const matchesTotalFinanciado = totalFinanciado.includes(searchText);
            const matchesImporteCuota = importeCuota.includes(searchText);
            const matchesCantidadCuotas = cantidadCuotas.includes(searchText);

            // Retornamos true si alguna de estas condiciones se cumple
            return (
                matchesCliente ||
                matchesCBU ||
                matchesCUIT ||
                matchesArticulo ||
                matchesTalle ||
                matchesColor ||
                matchesPrecio ||
                matchesCostoOriginal ||
                matchesPlan ||
                matchesInteres ||
                matchesTotalFinanciado ||
                matchesImporteCuota ||
                matchesCantidadCuotas
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
                textoCompleto.includes(word),
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

            const cuota = item.raw.cuota || {};
            const planLabel = cuota.id
                ? this.formatCuotaLabel(cuota).toLowerCase()
                : "";
            const totalFinanciado = (
                item.raw.total_financiado || ""
            ).toString();
            const importeCuota = (item.raw.importe_cuota || "").toString();
            const cantidadCuotas = (item.raw.cantidad_cuotas || "").toString();

            // Ver si alguno de estos campos coincide con el texto de búsqueda
            const matchesCliente = clienteNombreCompleto.includes(searchText);
            const matchesCBU = cbu.includes(searchText);
            const matchesCUIT = cuit.includes(searchText);
            const matchesPrecio = precio.includes(searchText);
            const matchesCostoOriginal = costoOriginal.includes(searchText);
            const matchesPlan = planLabel.includes(searchText);
            const matchesTotalFinanciado = totalFinanciado.includes(searchText);
            const matchesImporteCuota = importeCuota.includes(searchText);
            const matchesCantidadCuotas = cantidadCuotas.includes(searchText);

            // Retornamos true si alguna de estas condiciones se cumple
            return (
                matchesCliente ||
                matchesCBU ||
                matchesCUIT ||
                matchesPrecio ||
                matchesCostoOriginal ||
                matchesPlan ||
                matchesTotalFinanciado ||
                matchesImporteCuota ||
                matchesCantidadCuotas
            );
        },
        normalizeFecha(fecha) {
            const parsed = moment(fecha, "YYYY-MM-DD", true);
            if (parsed.isValid()) {
                return parsed.format("YYYY-MM-DD");
            }

            const fallback = moment(fecha);
            return fallback.isValid()
                ? fallback.format("YYYY-MM-DD")
                : moment().format("YYYY-MM-DD");
        },
        compareFechaDesc(fechaA, fechaB) {
            const a = this.normalizeFecha(fechaA);
            const b = this.normalizeFecha(fechaB);
            return b.localeCompare(a);
        },
        formatFecha(fecha) {
            if (!fecha) return "-";
            const fechaMoment = moment(fecha, "YYYY-MM-DD", true);
            if (!fechaMoment.isValid()) {
                return fecha;
            }
            return fechaMoment.format("DD/MM/YYYY");
        },
        formatFechaMoment(fecha) {
            if (!fecha) return "-";
            const fechaMoment = moment(fecha, "YYYY-MM-DD", true);
            if (!fechaMoment.isValid()) {
                return fecha;
            }
            return fechaMoment.format("DD/MM/YYYY");
        },
        // Abrir el diálogo de edición con la venta seleccionada
        openEditDialog(item) {
            this.selectedVenta = { ...item };
            this.selectedVenta.fecha = this.normalizeFecha(item.fecha);
            this.selectedVenta.cliente_nombre = item.cliente.nombre;
            this.selectedVenta.cliente_apellido = item.cliente.apellido;
            this.selectedVenta.cuota_id =
                item.cuota?.id ?? item.cuota_id ?? null;
            this.validarCuotaSeleccionadaEdicion();
            this.editDialog = true;
        },
        // Actualizar el precio de la venta
        updateVenta() {
            this.loading = true;
            this.selectedVenta.precio = this.redondearPrecio(
                this.selectedVenta.precio,
            );
            axios
                .put(`/api/ventas/${this.selectedVenta.id}`, {
                    precio: this.selectedVenta.precio,
                    costo_original: this.selectedVenta.costo_original,
                    fecha: this.normalizeFecha(this.selectedVenta.fecha),
                    forma_pago: this.selectedVenta.forma_pago,
                    cuota_id: this.selectedVenta.cuota_id,
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
                                    : v,
                            ),
                        updatedAtMs,
                    );

                    notifyCacheChange(VENTAS_KEY);

                    const idx = this.ventas.findIndex(
                        (v) => v.id === ventaActualizada.id,
                    );
                    if (idx !== -1) {
                        this.ventas[idx] = ventaActualizada;
                    } else {
                        this.ventas.push(ventaActualizada);
                    }

                    this.ventas.sort((a, b) =>
                        this.compareFechaDesc(a.fecha, b.fecha),
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
        openEditSelectedDialog() {
            this.editSelected = {
                precio: null,
                forma_pago: null,
                fecha: null,
            };
            this.editSelectedDialog = true;
        },
        confirmEditSelected() {
            const precioParsed = Number(this.editSelected.precio);
            const shouldUpdatePrecio =
                this.editSelected.precio !== null &&
                this.editSelected.precio !== "" &&
                Number.isFinite(precioParsed);

            const payload = {
                ids: this.selectedVentas.map((v) => v.id),
            };

            if (shouldUpdatePrecio) {
                payload.precio = precioParsed;
            }
            if (this.editSelected.forma_pago) {
                payload.forma_pago = this.editSelected.forma_pago;
            }
            if (this.editSelected.fecha) {
                payload.fecha = this.normalizeFecha(this.editSelected.fecha);
            }
            if (Object.keys(payload).length === 1) {
                this.editSelectedDialog = false;
                return;
            }
            this.loading = true;
            axios
                .put("/api/ventas/editar-multiples", payload)
                .then((res) => {
                    const ventasActualizadas = res.data.ventas || [];
                    const updatedAtMs = res.data.last_update
                        ? Number(res.data.last_update)
                        : Date.now();
                    modifyInCache(
                        VENTAS_KEY,
                        (ventas) =>
                            ventas.map((v) => {
                                const nv = ventasActualizadas.find(
                                    (u) => u.id === v.id,
                                );
                                return nv ? nv : v;
                            }),
                        updatedAtMs,
                    );
                    notifyCacheChange(VENTAS_KEY);
                    ventasActualizadas.forEach((venta) => {
                        const idx = this.ventas.findIndex(
                            (v) => v.id === venta.id,
                        );
                        if (idx !== -1) {
                            this.ventas[idx] = venta;
                        } else {
                            this.ventas.push(venta);
                        }
                    });
                    this.ventas.sort((a, b) =>
                        this.compareFechaDesc(a.fecha, b.fecha),
                    );
                    this.ventasFiltradas = [...this.ventas];
                    this.tablaKey += 1;
                    this.snackbarText = "Ventas actualizadas correctamente.";
                    this.snackbar = true;
                    this.editSelectedDialog = false;
                    this.selectedVentas = [];
                })
                .catch((error) => {
                    console.error(error);
                    this.snackbarText = "Error al actualizar las ventas.";
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
                        updatedAt,
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
                                                            ],
                                                        ) || 0) + 1,
                                                };
                                            }
                                            return talle;
                                        }),
                                    };
                                }
                                return art;
                            });
                        },
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
            this.sinStock = false;
            this.dialogVenta = true;
        },
        openVentaSinStockDialog() {
            this.sinStock = true;
            this.dialogVenta = true;
        },
        resetStockLocal() {
            // Recorre cada producto que fue agregado y restaura el stock localmente
            this.productos.forEach((producto) => {
                const talle = this.tallesDisponibles.find(
                    (t) => t.talle === producto.talle,
                );

                if (talle && talle[producto.color] !== undefined) {
                    // Aumentar el stock en 1 para el color correspondiente
                    talle[producto.color] += 1;

                    // Habilitar el color en coloresDisponibles si estaba deshabilitado
                    const colorIndex = this.coloresDisponibles.findIndex(
                        (color) => color.value === producto.color,
                    );
                    if (colorIndex !== -1) {
                        this.coloresDisponibles[colorIndex].props.disabled =
                            false;
                    }
                }
            });

            // Limpiar la lista de productos después de restablecer el stock
            this.productos = [];
        },
        closeDialogVenta() {
            this.resetStockLocal();
            if (!this.sinStock) {
                this.resetStockLocal();
            }

            this.form = {
                cliente_nombre: "",
                cliente_apellido: "",
                cliente_cuit: "",
                cliente_cbu: "",
                fecha: moment().format("YYYY-MM-DD"),
                forma_pago: "efectivo",
            };
            this.clienteSeleccionado = null;
            this.clienteExistente = false;
            this.articuloActual = null;
            this.tallesDisponibles = [];
            this.coloresDisponibles = [];
            this.productos = [];
            this.sinStock = false;
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
                { ttl: 86400 },
            );
            this.articulos = data;
        },

        // Cargar ventas para mostrar en la tabla
        async fetchVentas() {
            const data = await cachedFetch(
                VENTAS_KEY,
                () => axios.get("/api/ventas/listar").then((r) => r.data),
                { ttl: 1000 * 60 * 60 * 24 }, // 1 dia
            );
            this.ventas = data.sort((a, b) =>
                this.compareFechaDesc(a.fecha, b.fecha),
            );
            this.ventasFiltradas = this.ventas;
        },
        onTalleChange(talleSeleccionado) {
            if (this.sinStock) {
                this.coloresDisponibles = this.coloresGenerales.map((c) => ({
                    title: c,
                    value: c,
                }));
                return;
            }
            let articuloSeleccionado = null;

            // Determinar si estamos trabajando con una venta o un cambio de bombacha
            if (this.form.articulo_id) {
                // Buscar el artículo seleccionado para la venta
                articuloSeleccionado = this.articulos.find(
                    (item) => item.id === this.form.articulo_id,
                );
            } else if (this.cambioBombacha.articulo_id) {
                // Buscar el artículo seleccionado para el cambio de bombacha
                articuloSeleccionado = this.articulos.find(
                    (item) => item.id === this.cambioBombacha.articulo_id,
                );
            }

            if (articuloSeleccionado) {
                const talleSeleccionadoObj = this.tallesDisponibles.find(
                    (talle) => talle.talle === talleSeleccionado,
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
                                typeof talleSeleccionadoObj[key] === "number",
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
                        JSON.stringify(this.coloresDisponibles),
                    );
                }
            }
        },

        loadTallesYColores() {
            // Resetear los campos
            this.form.color = null;
            this.form.talle = null;
            this.form.cuota_id = null;

            if (this.sinStock) {
                // Mostrar todos los talles y colores disponibles sin verificar stock
                this.tallesDisponibles = this.tallesGenerales.map((t) => ({
                    talle: t,
                }));
                this.coloresDisponibles = this.coloresGenerales.map((c) => ({
                    title: c,
                    value: c,
                }));
                this.cuotasDisponiblesVenta = [];
                return;
            }

            let articuloSeleccionado = null; // Cambiado a 'let' para permitir la reasignación

            // Determinar si la selección proviene de la venta o del cambio de bombacha
            if (this.form.articulo_id) {
                // Encontrar el artículo seleccionado para el registro de venta
                articuloSeleccionado = this.articulos.find(
                    (item) => item.id === this.form.articulo_id,
                );
            } else if (this.cambioBombacha.articulo_id) {
                // Encontrar el artículo seleccionado para el cambio de bombacha
                articuloSeleccionado = this.articulos.find(
                    (item) => item.id === this.cambioBombacha.articulo_id,
                );
            }

            if (articuloSeleccionado) {
                // Solo actualizar si el artículo seleccionado es diferente al actual
                this.articuloActual = articuloSeleccionado;
                console.log(this.articuloActual);
                this.tallesDisponibles = [...this.articuloActual.talles].sort(
                    (a, b) => a.talle - b.talle,
                );
                this.actualizarCuotasPorFormaPago();

                this.form.cuota_id = null;
            } else {
                // Limpiar si no se selecciona un artículo válido
                this.tallesDisponibles = [];
                this.cuotasDisponiblesVenta = [];
            }
        },

        // Obtener el precio del artículo seleccionado
        getArticuloPrecio() {
            const articulo = this.articulos.find(
                (item) => parseInt(item.id) === parseInt(this.form.articulo_id),
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
        agregarProducto(mantener = false) {
            const articulo = this.articulos.find(
                (item) => item.id === this.form.articulo_id,
            );
            if (!articulo || this.form.talle === null || !this.form.color) {
                showToast("No se pudo agregar el artículo", "error");
                return;
            }

            if (articulo) {
                const cuotaSeleccionada = this.cuotaSeleccionada;
                const esVentaEnCuotas = Boolean(cuotaSeleccionada);
                const precioReferencia = esVentaEnCuotas
                    ? Number(articulo.precio_transferencia || 0)
                    : this.form.forma_pago === "efectivo"
                      ? Number(articulo.precio_efectivo || 0)
                      : Number(articulo.precio_transferencia || 0);
                const precioBase = this.redondearPrecio(precioReferencia);

                const totalFinanciado = cuotaSeleccionada
                    ? this.redondearPrecio(
                          precioBase *
                              Number(cuotaSeleccionada.factor_total || 0),
                      )
                    : null;
                const cantidadCuotas = cuotaSeleccionada
                    ? Number(cuotaSeleccionada.cantidad_cuotas || 0)
                    : null;
                const importeCuota =
                    cuotaSeleccionada && cantidadCuotas
                        ? totalFinanciado / cantidadCuotas
                        : null;

                this.productos.push({
                    articulo: articulo,
                    talle: this.form.talle,
                    color: this.form.color,
                    precio: precioBase,
                    costo_original: Number(articulo.costo_original || 0),
                    cuota: cuotaSeleccionada ? { ...cuotaSeleccionada } : null,
                    cuota_id: cuotaSeleccionada ? cuotaSeleccionada.id : null,
                    cantidad_cuotas: cantidadCuotas,
                    total_financiado: totalFinanciado,
                    importe_cuota: importeCuota,
                });

                if (this.sinStock) {
                    if (!mantener) {
                        this.form.articulo_id = null;
                        this.form.talle = null;
                        this.form.color = null;
                        this.form.cuota_id = null;
                    }
                    this.productoCargado = true;
                    setTimeout(() => (this.productoCargado = false), 1000);
                    return;
                }
                // Actualizar el stock localmente restando 1
                const talleSeleccionado = this.tallesDisponibles.find(
                    (talle) => talle.talle === this.form.talle,
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
                            (color) => color.value === this.form.color,
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
                            // 🧹 Limpiar color si ya no hay stock
                            this.form.color = null;
                        }
                    }
                }

                // 👁️ Revisar si ya no hay colores habilitados para ese talle
                const talleRestante = this.tallesDisponibles.find(
                    (t) => t.talle === this.form.talle,
                );

                const coloresConStock = talleRestante
                    ? Object.keys(talleRestante)
                          .filter(
                              (key) =>
                                  ![
                                      "id",
                                      "articulo_id",
                                      "talle",
                                      "created_at",
                                      "updated_at",
                                  ].includes(key),
                          )
                          .some((color) => parseInt(talleRestante[color]) > 0)
                    : false;

                if (!coloresConStock && mantener) {
                    this.snackbarText =
                        "⚠️ No hay más colores disponibles para este talle.";
                    this.snackbar = true;
                    return;
                }
                // 🧹 Si no quedan colores para ese talle, limpiamos selección aunque pidió mantener

                // 👇 Lógica después de agregar producto y reducir stock
                // 🧹 Limpiar si NO se desea mantener selección
                if (!mantener) {
                    if (!coloresConStock) {
                        this.form.talle = null;
                        this.form.color = null;
                    } else {
                        this.form.articulo_id = null;
                        this.form.talle = null;
                        this.form.color = null;
                        this.cuotasDisponiblesVenta = [];
                    }
                    this.form.cuota_id = null;
                }
                this.productoCargado = true;
                setTimeout(() => {
                    this.productoCargado = false;
                }, 1000);
                showToast("Artículo agregado", "success");
            }
        },
        eliminarProducto(index) {
            const producto = this.productos[index];

            if (this.sinStock) {
                this.productos.splice(index, 1);
                return;
            }
            // Devolver el stock del talle y color eliminados
            const talleSeleccionado = this.tallesDisponibles.find(
                (talle) => talle.talle === producto.talle,
            );

            if (talleSeleccionado) {
                // Aumentar el stock en 1
                talleSeleccionado[producto.color] += 1;

                // Habilitar el color en coloresDisponibles si el stock es mayor a 0
                if (talleSeleccionado[producto.color] > 0) {
                    const colorIndex = this.coloresDisponibles.findIndex(
                        (color) => color.value === producto.color,
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
                            },
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
            this.form.fecha = this.normalizeFecha(this.form.fecha);
            this.form.cliente_nombre = this.capitalizarPalabras(
                this.form.cliente_nombre,
            );
            this.form.cliente_apellido = this.capitalizarPalabras(
                this.form.cliente_apellido,
            );

            if (!this.productos.length) {
                this.snackbarText = "Por favor ingresa los productos";
                this.snackbar = true;
                this.loading = false;
                return;
            }

            if (this.clienteExistente && !this.clienteSeleccionado) {
                this.snackbarText =
                    "Por favor selecciona un cliente existente.";
                this.snackbar = true;
                this.loading = false;
                return;
            }

            if (
                !this.clienteExistente &&
                (!this.form.cliente_nombre || !this.form.cliente_apellido)
            ) {
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
                const url = this.sinStock
                    ? "/api/ventas/sin-stock"
                    : "/api/ventas";
                const res = await axios.post(url, ventaData);

                // Las ventas que devuelve el backend ya vienen con articulo, cliente, id, etc.
                const nuevasVentas = Array.isArray(res.data.ventas)
                    ? res.data.ventas
                    : [];

                nuevasVentas.forEach((v) =>
                    appendToCache(VENTAS_KEY, v, v.updated_at),
                );

                notifyCacheChange(VENTAS_KEY);

                // ✅ Mostrar de inmediato en esta pestaña
                this.ventas.push(...nuevasVentas);
                this.ventas.sort((a, b) =>
                    this.compareFechaDesc(a.fecha, b.fecha),
                );
                this.ventasFiltradas = [...this.ventas];
                this.tablaKey += 1;

                notifyCacheChange(ARTICULOS_TALLES_KEY);
                this.articulos = getMemoryCache(ARTICULOS_TALLES_KEY, 86400); // refrescar desde memoria

                this.dialogVenta = false;
                this.sinStock = false;
                this.resetFormVenta?.();
                this.fetchUltimaFacturacion();
                showToast("Venta registrada correctamente", "success");
            } catch (error) {
                console.error(error);
                showToast("Error al registrar la venta", "error");
            } finally {
                this.loading = false;
            }
        },
        resetFormVenta() {
            this.form = {
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
                cuota_id: null,
            };
            this.productos = [];
            this.articuloActual = null;
            this.tallesDisponibles = [];
            this.coloresDisponibles = [];
            this.cuotasDisponiblesVenta = [];
            this.clienteSeleccionado = null;
            this.clienteExistente = false;
        },
        calcularPrecioTotal() {
            // Recalcula el precio total
            this.precioTotal = this.productos.reduce((total, producto) => {
                return total + parseFloat(producto.articulo.precio);
            }, 0);
        },
        capitalizarPalabras(texto) {
            return (texto || "")
                .toLowerCase()
                .split(" ")
                .map(
                    (palabra) =>
                        palabra.charAt(0).toUpperCase() + palabra.slice(1),
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

.registrar-venta-btn {
    border: 2px solid #2e7d32 !important;
    color: #2e7d32 !important;
    font-weight: 600;
}

.registrar-venta-btn:hover {
    background-color: rgba(46, 125, 50, 0.12) !important;
}

.registrar-venta-btn .v-icon {
    color: #2e7d32 !important;
}

.sin-stock-btn {
    border: 2px solid #d32f2f !important;
    color: #d32f2f !important;
    font-weight: 600;
}

.sin-stock-btn:hover {
    background-color: rgba(211, 47, 47, 0.12) !important;
}

.sin-stock-btn .v-icon {
    color: #d32f2f !important;
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

.venta-dialog-card {
    border: 2px solid transparent;
    transition:
        border-color 0.2s ease,
        box-shadow 0.2s ease;
}

.venta-dialog-card--regular {
    border-color: #2e7d32;
    box-shadow: 0 0 0 1px rgba(46, 125, 50, 0.1);
}

.venta-dialog-card--sin-stock {
    border-color: #d32f2f;
    box-shadow: 0 0 0 1px rgba(211, 47, 47, 0.15);
}

.venta-dialog-title--regular {
    color: #2e7d32;
    font-weight: 700;
}

.venta-dialog-title--sin-stock {
    color: #d32f2f;
    font-weight: 800;
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
    /* Si Datepicker sigue chico */
    .datepicker-wrapper {
        width: 100%;
    }
}
</style>
