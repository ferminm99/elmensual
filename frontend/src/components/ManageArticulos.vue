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
            <template #item.costo_original="{ item }">
                ${{ formatCurrency(item.costo_original) }}
            </template>
            <template #item.precio_efectivo="{ item }">
                ${{ formatCurrency(item.precio_efectivo) }}
            </template>
            <template #item.precio_transferencia="{ item }">
                ${{ formatCurrency(item.precio_transferencia) }}
            </template>
            <template #item.cuotas="{ item }">
                <div class="cuotas-chips">
                    <v-chip
                        v-for="cuota in item.cuotas"
                        :key="cuota.id"
                        size="small"
                        color="primary"
                        variant="tonal"
                        class="ma-0"
                    >
                        {{ formatCuotaLabel(cuota) }}
                    </v-chip>
                    <span
                        v-if="!item.cuotas || !item.cuotas.length"
                        class="text-caption text-grey"
                    >
                        Sin cuotas
                    </span>
                </div>
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

        <v-card class="mt-6">
            <v-card-title class="d-flex justify-space-between align-center">
                Planes de cuotas
                <v-btn color="black" @click="openCuotaDialog()">
                    <v-icon left>mdi-plus</v-icon>
                    Cargar plan
                </v-btn>
            </v-card-title>
            <v-card-text>
                <v-progress-linear
                    v-if="loadingCuotas"
                    indeterminate
                    color="primary"
                    class="mb-3"
                />
                <div v-else class="text-caption grey--text mb-3">
                    Valores estimados según precio transferencia $
                    {{ formatCurrency(preciosCalculados.transferencia) }}.
                </div>
                <v-table
                    v-if="!loadingCuotas && cuotasDisponibles.length"
                    density="compact"
                    class="planes-table"
                >
                    <thead>
                        <tr>
                            <th class="text-left">Plan</th>
                            <th class="text-left">Tipo</th>
                            <th class="text-right">Factor</th>
                            <th class="text-right">Total transf.</th>
                            <th class="text-right">Cuota transf.</th>
                            <th class="text-right">Total efectivo</th>
                            <th class="text-right">Cuota efectivo</th>
                            <th class="text-center">Acciones</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr v-for="plan in simulacionCuotas" :key="plan.id">
                            <td>
                                {{ plan.cantidad_cuotas }} cuota{{
                                    plan.cantidad_cuotas === 1 ? "" : "s"
                                }}
                            </td>
                            <td>
                                {{
                                    plan.es_con_interes
                                        ? "Con interés"
                                        : "Sin interés"
                                }}
                            </td>
                            <td class="text-right">
                                x{{ Number(plan.factor_total || 0).toFixed(2) }}
                            </td>
                            <td class="text-right">
                                $
                                {{ formatCurrency(plan.totalTransferencia) }}
                            </td>
                            <td class="text-right">
                                $
                                {{ formatCurrency(plan.cuotaTransferencia) }}
                            </td>
                            <td class="text-center">
                                <v-btn
                                    icon
                                    variant="text"
                                    @click="openCuotaDialog(plan)"
                                >
                                    <v-icon color="black"
                                        >mdi-pencil-outline</v-icon
                                    >
                                </v-btn>
                                <v-btn
                                    icon
                                    variant="text"
                                    @click="deleteCuota(plan)"
                                >
                                    <v-icon color="red">mdi-delete</v-icon>
                                </v-btn>
                            </td>
                        </tr>
                    </tbody>
                </v-table>
                <v-alert
                    v-else-if="!loadingCuotas"
                    type="info"
                    variant="tonal"
                    density="comfortable"
                >
                    Todavía no cargaste planes de cuotas.
                </v-alert>
            </v-card-text>
        </v-card>

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
                            v-model="form.costo_original"
                            label="Costo original"
                            type="number"
                            required
                            @wheel.prevent
                        ></v-text-field>

                        <v-row dense>
                            <v-col cols="12" md="6">
                                <v-text-field
                                    :model-value="`$${formatCurrency(
                                        preciosCalculados.efectivo
                                    )}`"
                                    label="Precio en efectivo"
                                    readonly
                                ></v-text-field>
                            </v-col>
                            <v-col cols="12" md="6">
                                <v-text-field
                                    :model-value="`$${formatCurrency(
                                        preciosCalculados.transferencia
                                    )}`"
                                    label="Precio transferencia"
                                    readonly
                                ></v-text-field>
                            </v-col>
                        </v-row>

                        <v-select
                            v-model="form.cuotas"
                            :items="cuotasDisponibles"
                            item-title="label"
                            item-value="id"
                            label="Planes de cuotas disponibles"
                            multiple
                            chips
                            closable-chips
                            clearable
                            :loading="loadingCuotas"
                            :disabled="
                                loadingCuotas || !cuotasDisponibles.length
                            "
                            hint="Seleccioná los planes habilitados para este artículo"
                            persistent-hint
                        ></v-select>

                        <div class="cuotas-preview mt-4">
                            <h3 class="text-subtitle-1 font-weight-medium mb-2">
                                Simulación de cuotas
                                <span class="text-body-2 grey--text">
                                    (base transferencia $
                                    {{
                                        formatCurrency(
                                            preciosCalculados.transferencia
                                        )
                                    }})
                                </span>
                            </h3>
                            <v-progress-linear
                                v-if="loadingCuotas"
                                indeterminate
                                color="primary"
                                class="mb-3"
                            />
                            <v-table
                                v-else-if="simulacionCuotas.length"
                                density="compact"
                                class="cuotas-preview__table"
                            >
                                <thead>
                                    <tr>
                                        <th class="text-left">Plan</th>
                                        <th class="text-left">Tipo</th>
                                        <th class="text-right">
                                            Total transf.
                                        </th>
                                        <th class="text-right">
                                            Cuota transf.
                                        </th>
                                        <th class="text-right">
                                            Total efectivo
                                        </th>
                                        <th class="text-right">
                                            Cuota efectivo
                                        </th>
                                        <th class="text-center">Estado</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <tr
                                        v-for="plan in simulacionCuotas"
                                        :key="plan.id"
                                    >
                                        <td>
                                            {{ plan.cantidad_cuotas }} cuota{{
                                                plan.cantidad_cuotas === 1
                                                    ? ""
                                                    : "s"
                                            }}
                                        </td>
                                        <td>
                                            {{
                                                plan.es_con_interes
                                                    ? "Con interés"
                                                    : "Sin interés"
                                            }}
                                        </td>
                                        <td class="text-right">
                                            $
                                            {{
                                                formatCurrency(
                                                    plan.totalTransferencia
                                                )
                                            }}
                                        </td>
                                        <td class="text-right">
                                            $
                                            {{
                                                formatCurrency(
                                                    plan.cuotaTransferencia
                                                )
                                            }}
                                        </td>
                                        <td class="text-right">
                                            $
                                            {{
                                                formatCurrency(
                                                    plan.totalEfectivo
                                                )
                                            }}
                                        </td>
                                        <td class="text-right">
                                            $
                                            {{
                                                formatCurrency(
                                                    plan.cuotaEfectivo
                                                )
                                            }}
                                        </td>
                                        <td class="text-center">
                                            <v-chip
                                                v-if="
                                                    form.cuotas.includes(
                                                        plan.id
                                                    )
                                                "
                                                color="green"
                                                size="small"
                                                variant="tonal"
                                            >
                                                Asignado
                                            </v-chip>
                                            <span
                                                v-else
                                                class="text-caption grey--text"
                                            >
                                                Disponible
                                            </span>
                                        </td>
                                    </tr>
                                </tbody>
                            </v-table>
                            <v-alert
                                v-else
                                type="info"
                                variant="tonal"
                                density="comfortable"
                            >
                                Todavía no cargaste planes de cuotas.
                            </v-alert>
                        </div>
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

        <v-dialog v-model="dialogCuota" max-width="400px">
            <v-card>
                <v-card-title class="d-flex justify-space-between align-center">
                    {{ isEditCuota ? "Editar" : "Nueva" }} cuota
                    <v-btn flat icon @click="closeCuotaDialog">
                        <v-icon color="red">mdi-close</v-icon>
                    </v-btn>
                </v-card-title>
                <v-card-text>
                    <v-form>
                        <v-text-field
                            v-model="cuotaForm.cantidad_cuotas"
                            label="Cantidad de cuotas"
                            type="number"
                            min="1"
                            required
                            @wheel.prevent
                        ></v-text-field>
                        <v-text-field
                            v-model="cuotaForm.factor_total"
                            label="Factor total"
                            type="number"
                            step="0.01"
                            min="0"
                            required
                            @wheel.prevent
                        ></v-text-field>
                        <v-switch
                            v-model="cuotaForm.es_con_interes"
                            label="Tiene interés"
                        ></v-switch>
                    </v-form>
                </v-card-text>
                <v-card-actions>
                    <v-spacer></v-spacer>
                    <v-btn text @click="closeCuotaDialog">Cancelar</v-btn>
                    <v-btn color="black" text @click="saveCuota">Guardar</v-btn>
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
import axios from "axios";
import {
    cachedFetch,
    updateCache,
    appendToCache,
    removeFromCache,
    modifyInCache,
    getCacheLastUpdate,
} from "@/utils/cacheFetch";
import { notifyCacheChange } from "@/utils/cacheEvents";
import { showToast } from "@/utils/toast";
import ExcelJS from "exceljs";
import { ARTICULOS_KEY, CUOTAS_KEY } from "@/utils/cacheKeys";
import { useSyncedCache } from "@/utils/useSyncedCache";

export default {
    data() {
        return {
            loading: false,
            loadingCuotas: false,
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
                cuotas: [],
            },
            preciosCalculados: {
                efectivo: 0,
                transferencia: 0,
            },
            articulos: [],
            cuotasDisponibles: [],
            dialogCuota: false,
            isEditCuota: false,
            cuotaForm: {
                id: null,
                cantidad_cuotas: 1,
                factor_total: 1,
                es_con_interes: false,
            },
            headers: [
                { title: "Número", key: "numero" },
                { title: "Nombre", key: "nombre" },
                { title: "Costo Original", key: "costo_original" },
                { title: "Efectivo", key: "precio_efectivo" },
                { title: "Transferencia", key: "precio_transferencia" },
                { title: "Planes", key: "cuotas" },
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
            const list = Array.isArray(this.articulos) ? this.articulos : [];
            const normalizar = (str) =>
                str?.toLowerCase().normalize("NFD").replace(/[̀-ͯ]/g, "");
            const textoNombre = normalizar(this.searchNombre.trim());
            const textoNumero = normalizar(this.searchNumero.trim());
            return list.filter((art) => {
                const nombre = normalizar(art.nombre);
                const numero = normalizar(String(art.numero));
                return (
                    (!textoNombre || nombre.includes(textoNombre)) &&
                    (!textoNumero || numero.includes(textoNumero))
                );
            });
        },
        simulacionCuotas() {
            const baseTransfer = Number(
                this.preciosCalculados.transferencia || 0
            );
            const baseEfectivo = Number(this.preciosCalculados.efectivo || 0);

            if (
                !Array.isArray(this.cuotasDisponibles) ||
                !this.cuotasDisponibles.length
            ) {
                return [];
            }

            return this.cuotasDisponibles.map((cuota) => ({
                ...cuota,
                totalTransferencia: this.calcularTotalCuota(
                    baseTransfer,
                    cuota
                ),
                cuotaTransferencia: this.calcularImporteCuota(
                    baseTransfer,
                    cuota
                ),
            }));
        },
    },
    watch: {
        "form.costo_original": {
            handler(valor) {
                this.actualizarPreciosCalculados(valor);
            },
        },
    },
    mounted() {
        window.addEventListener("notifyCacheChange", this.handleCacheSync);

        useSyncedCache({
            key: ARTICULOS_KEY,
            apiPath: "/articulos/actualizados-desde",
            fetchFn: () => axios.get("/api/articulos").then((res) => res.data), // ⚠️ solo array
            onData: (data) => {
                const normalized = Array.isArray(data)
                    ? data
                    : Array.isArray(data?.data)
                    ? data.data
                    : Array.isArray(data?.articulos)
                    ? data.articulos
                    : [];

                this.articulos = normalized;
            },
            setLoading: (val) => (this.loading = val),
        });

        this.fetchCuotas();
    },

    beforeUnmount() {
        window.removeEventListener("notifyCacheChange", this.handleCacheSync);
    },
    methods: {
        async fetchCuotas(force = false) {
            this.loadingCuotas = true;

            try {
                const cuotas = await cachedFetch(
                    CUOTAS_KEY,
                    () => axios.get("/api/cuotas").then((res) => res.data),
                    { ttl: 86400, forceRefresh: force }
                );

                this.cuotasDisponibles = Array.isArray(cuotas)
                    ? cuotas.map((cuota) => ({
                          ...cuota,
                          label: this.formatCuotaLabel(cuota),
                      }))
                    : [];
            } catch (error) {
                console.error("Error al cargar las cuotas:", error);
                this.cuotasDisponibles = [];
            } finally {
                this.loadingCuotas = false;
            }
        },
        formatCuotaLabel(cuota) {
            if (!cuota) return "Sin cuotas";
            const cantidad = Number(cuota.cantidad_cuotas) || 0;
            const tipo = cuota.es_con_interes ? "con interés" : "sin interés";
            const factor = Number(cuota.factor_total || 0).toFixed(2);
            const plural = cantidad === 1 ? "" : "s";
            return `${cantidad} cuota${plural} ${tipo} (x${factor})`;
        },
        formatCuotasList(cuotas) {
            if (!Array.isArray(cuotas) || !cuotas.length) {
                return "Sin cuotas";
            }
            return cuotas.map((c) => this.formatCuotaLabel(c)).join(", ");
        },
        formatCurrency(valor) {
            const numero = Number(valor || 0);
            return numero.toLocaleString("es-AR", {
                minimumFractionDigits: 2,
                maximumFractionDigits: 2,
            });
        },
        redondearPrecio(valor) {
            const numero = Number(valor || 0);
            if (!numero) return 0;
            return Math.round(numero / 500) * 500;
        },
        calcularPreciosDesdeCosto(costo) {
            const base = Number(costo || 0);

            if (!base) {
                return {
                    efectivo: 0,
                    transferencia: 0,
                };
            }

            let precioEfectivo = 0;
            let precioTransferencia = 0;

            if (base >= 25000) {
                precioEfectivo = base * 1.74;
                precioTransferencia = base * 1.89;
            } else if (base < 15750) {
                precioEfectivo = base * 1.8;
                precioTransferencia = base * 1.95;
            } else {
                precioEfectivo = base * 1.74;
                precioTransferencia = base * 1.89;
            }

            precioEfectivo = this.redondearPrecio(precioEfectivo);
            precioTransferencia = this.redondearPrecio(precioTransferencia);

            return {
                efectivo: precioEfectivo,
                transferencia: precioTransferencia,
            };
        },
        actualizarPreciosCalculados(costo) {
            const precios = this.calcularPreciosDesdeCosto(costo);
            this.preciosCalculados = { ...precios };
            this.form.precio = Number(precios.transferencia || 0);
        },
        calcularTotalCuota(base, cuota) {
            const montoBase = Number(base || 0);
            const factor = Number(cuota?.factor_total || 0);

            if (!montoBase || !factor) {
                return 0;
            }

            return this.redondearPrecio(montoBase * factor);
        },
        calcularImporteCuota(base, cuota) {
            const total = this.calcularTotalCuota(base, cuota);
            const cantidad = Number(cuota?.cantidad_cuotas || 0);

            if (!total || !cantidad) {
                return 0;
            }

            return this.redondearPrecio(total / cantidad);
        },
        resetCuotaForm() {
            this.cuotaForm = {
                id: null,
                cantidad_cuotas: 1,
                factor_total: 1,
                es_con_interes: false,
            };
        },
        openCuotaDialog(cuota = null) {
            if (cuota) {
                this.isEditCuota = true;
                this.cuotaForm = {
                    id: cuota.id,
                    cantidad_cuotas: Number(cuota.cantidad_cuotas || 1),
                    factor_total: Number(cuota.factor_total || 1),
                    es_con_interes: Boolean(cuota.es_con_interes),
                };
            } else {
                this.isEditCuota = false;
                this.resetCuotaForm();
            }

            this.dialogCuota = true;
        },
        closeCuotaDialog() {
            this.dialogCuota = false;
            this.resetCuotaForm();
        },
        async saveCuota() {
            const payload = {
                cantidad_cuotas: Number(this.cuotaForm.cantidad_cuotas || 0),
                factor_total: Number(this.cuotaForm.factor_total || 0),
                es_con_interes: Boolean(this.cuotaForm.es_con_interes),
            };

            if (!payload.cantidad_cuotas || !payload.factor_total) {
                showToast("Completá los datos del plan", "error");
                return;
            }

            try {
                this.loadingCuotas = true;
                if (this.isEditCuota && this.cuotaForm.id) {
                    await axios.put(
                        `/api/cuotas/${this.cuotaForm.id}`,
                        payload
                    );
                    showToast("Plan de cuotas actualizado", "success");
                } else {
                    await axios.post("/api/cuotas", payload);
                    showToast("Plan de cuotas creado", "success");
                }

                this.closeCuotaDialog();
                await this.fetchCuotas(true);
                notifyCacheChange(CUOTAS_KEY);
            } catch (error) {
                console.error("Error al guardar el plan de cuotas:", error);
                showToast("No se pudo guardar el plan de cuotas", "error");
            } finally {
                this.loadingCuotas = false;
            }
        },
        async deleteCuota(cuota) {
            if (!cuota) return;

            const confirmado = confirm(
                "¿Seguro que querés eliminar este plan de cuotas?"
            );

            if (!confirmado) {
                return;
            }

            try {
                this.loadingCuotas = true;
                await axios.delete(`/api/cuotas/${cuota.id}`);
                showToast("Plan de cuotas eliminado", "success");
                await this.fetchCuotas(true);
                notifyCacheChange(CUOTAS_KEY);
            } catch (error) {
                console.error("Error al eliminar el plan de cuotas:", error);
                showToast("No se pudo eliminar el plan de cuotas", "error");
            } finally {
                this.loadingCuotas = false;
            }
        },
        handleCacheSync(e) {
            if (e.detail === ARTICULOS_KEY) {
                this.fetchArticulos();
            }
            if (e.detail === CUOTAS_KEY) {
                this.fetchCuotas(true);
            }
        },

        async initArticulosConFrescura() {
            this.loading = true;

            try {
                // Verificar si el backend tiene una versión más nueva
                const { data } = await axios.get(
                    "/api/articulos/ultima-actualizacion"
                );
                const backendLastUpdate = Number(data.last_update || 0);
                const localLastUpdate = getCacheLastUpdate(ARTICULOS_KEY);

                if (backendLastUpdate > localLastUpdate) {
                    console.warn(
                        "♻️ Backend tiene data más nueva. Reseteando caché."
                    );
                    localStorage.removeItem(ARTICULOS_KEY);
                    localStorage.removeItem(`${ARTICULOS_KEY}_time`);
                    localStorage.removeItem(`${ARTICULOS_KEY}_last_update`);
                }

                const dataCache = await cachedFetch(
                    ARTICULOS_KEY,
                    () => axios.get("/api/articulos").then((res) => res.data),
                    { ttl: 86400 }
                );

                this.articulos = Array.isArray(dataCache)
                    ? dataCache
                    : Array.isArray(dataCache?.articulos)
                    ? dataCache.articulos
                    : Array.isArray(dataCache?.data)
                    ? dataCache.data
                    : [];
            } catch (err) {
                console.error("❌ Error al inicializar artículos:", err);
                this.articulos = [];
            } finally {
                this.loading = false;
            }
        },
        async fetchArticulos(force = false) {
            this.loading = true;
            try {
                const data = await cachedFetch(
                    ARTICULOS_KEY,
                    () => axios.get("/api/articulos").then((res) => res.data),
                    { ttl: 86400, forceRefresh: force }
                );

                this.articulos = Array.isArray(data)
                    ? data
                    : Array.isArray(data?.articulos)
                    ? data.articulos
                    : Array.isArray(data?.data)
                    ? data.data
                    : [];
            } catch (error) {
                console.error("Error al cargar los artículos:", error);
                this.articulos = [];
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
                cuotas: [],
            };
            this.preciosCalculados = {
                efectivo: 0,
                transferencia: 0,
            };
            this.actualizarPreciosCalculados(this.form.costo_original);
            this.dialog = true;
        },
        openEditDialog(item) {
            this.isEdit = true;
            this.form = {
                id: item.id,
                numero: item.numero,
                nombre: item.nombre,
                precio: item.precio,
                costo_original: item.costo_original,
                cuotas: Array.isArray(item.cuotas)
                    ? item.cuotas.map((c) => c.id)
                    : [],
            };
            this.preciosCalculados = {
                efectivo: Number(item.precio_efectivo || 0),
                transferencia: Number(item.precio_transferencia || 0),
            };
            this.actualizarPreciosCalculados(this.form.costo_original);
            this.dialog = true;
        },
        saveArticulo() {
            if (!this.validateForm()) return;
            this.loading = true;

            this.form.precio = Number(
                this.preciosCalculados.transferencia || 0
            );

            const payload = {
                numero: Number(this.form.numero),
                nombre: this.form.nombre,
                precio: Number(this.form.precio),
                costo_original: Number(this.form.costo_original),
                cuotas: this.form.cuotas,
            };

            const request = this.isEdit
                ? axios.put(`/api/articulo/${this.form.id}`, payload)
                : axios.post("/api/articulo", payload);

            request
                .then((res) => {
                    const nuevo = res.data.articulo;

                    // Usamos append o modify y luego recuperamos el array actualizado
                    const updated = this.isEdit
                        ? modifyInCache(ARTICULOS_KEY, (articulos) =>
                              articulos.map((a) =>
                                  a.id === nuevo.id ? { ...nuevo } : a
                              )
                          )
                        : appendToCache(ARTICULOS_KEY, nuevo);

                    this.articulos = updated || [];
                    notifyCacheChange(ARTICULOS_KEY);
                    this.dialog = false;
                    this.searchNombre = "";
                    this.searchNumero = "";
                    this.loading = false;
                    showToast(
                        this.isEdit
                            ? "Artículo actualizado"
                            : "Artículo agregado",
                        "success"
                    );
                })
                .catch((err) => {
                    this.loading = false;
                    if (err.response?.status === 422) {
                        showToast(
                            "Ya existe un artículo con ese número",
                            "error"
                        );
                    } else {
                        console.error("❌ Error inesperado:", err);
                        showToast(
                            "Ocurrió un error al guardar el artículo",
                            "error"
                        );
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
                    showToast("Artículo eliminado", "success");
                });
        },
        recalcularPrecios() {
            this.loading = true;
            axios.put("/api/articulos/recalcular-precios").then((res) => {
                const articulosActualizados = Array.isArray(res.data.articulos)
                    ? res.data.articulos
                    : [];

                this.articulos = articulosActualizados;
                updateCache(ARTICULOS_KEY, {
                    articulos: articulosActualizados,
                });

                notifyCacheChange(ARTICULOS_KEY);
                this.loading = false;
                showToast("Precios recalculados correctamente", "success");
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
                    const articulosActualizados = Array.isArray(
                        res.data.articulos
                    )
                        ? res.data.articulos
                        : [];

                    this.articulos = articulosActualizados;
                    updateCache(ARTICULOS_KEY, {
                        articulos: articulosActualizados,
                    });

                    notifyCacheChange(ARTICULOS_KEY);
                    this.dialogoAumento = false;
                    this.loading = false;
                    showToast("Precios recalculados correctamente", "success");
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
                { header: "Planes de cuotas", key: "cuotas", width: 40 },
            ];

            this.articulosFiltrados.forEach((item) => {
                worksheet.addRow({
                    numero: item.numero,
                    nombre: item.nombre,
                    precio: item.precio,
                    costo_original: item.costo_original,
                    efectivo: item.precio_efectivo,
                    transferencia: item.precio_transferencia,
                    cuotas: this.formatCuotasList(item.cuotas),
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
.cuotas-chips {
    display: flex;
    flex-wrap: wrap;
    gap: 6px;
}

.cuotas-chips .v-chip {
    margin: 0;
}

.cuotas-preview__table th,
.cuotas-preview__table td,
.planes-table th,
.planes-table td {
    white-space: nowrap;
}

.planes-table {
    border-radius: 8px;
    overflow: hidden;
}
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
