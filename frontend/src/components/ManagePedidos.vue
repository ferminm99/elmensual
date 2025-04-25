<template>
    <div class="pedido-container">
        <v-row class="justify-space-between align-center mb-4">
            <h2 class="text-h5 font-weight-bold">Registro de Pedidos</h2>
        </v-row>

        <v-row class="formulario-pedido" dense>
            <v-col cols="12" md="4">
                <v-text-field
                    v-model="form.nombre"
                    label="Nombre y Apellido"
                    dense
                    outlined
                />
            </v-col>
            <v-col cols="12" md="4">
                <v-autocomplete
                    v-model="form.articulo_id"
                    :items="articulos"
                    :item-title="(item) => `${item.numero} - ${item.nombre}`"
                    item-value="id"
                    label="Artículo"
                    @update:modelValue="cargarTalles"
                    dense
                    outlined
                />
            </v-col>
            <v-col cols="6" md="2">
                <v-select
                    v-model="form.talle"
                    :items="talles"
                    label="Talle"
                    dense
                    outlined
                />
            </v-col>
            <v-col cols="6" md="2">
                <v-select
                    v-model="form.colores"
                    :items="colores"
                    label="Colores"
                    multiple
                    chips
                    dense
                    outlined
                />
            </v-col>
        </v-row>

        <v-row class="botones-pedido mb-4">
            <v-col cols="12" md="auto">
                <v-btn color="success" block @click="exportarExcel">
                    <v-icon left>mdi-file-excel</v-icon> Exportar Excel
                </v-btn>
            </v-col>
            <v-col cols="12" md="auto">
                <v-btn color="grey" block @click="copiarComoTexto">
                    <v-icon left>mdi-content-copy</v-icon> Copiar como texto
                </v-btn>
            </v-col>
            <v-col cols="12" md="auto">
                <v-btn color="primary" block @click="agregarPedido">
                    <v-icon left>mdi-plus</v-icon> Agregar Pedido
                </v-btn>
            </v-col>
        </v-row>

        <ResponsiveTable
            :headers="headers"
            :items="pedidos"
            class="elevation-1"
            v-model:options="options"
        >
            <template #item.colores="{ item }">
                {{ item.colores.join(" / ") }}
            </template>
            <template #item.actions="{ item }">
                <v-btn icon @click="editarPedido(item)">
                    <v-icon color="blue">mdi-pencil</v-icon>
                </v-btn>
                <v-btn icon @click="eliminarPedido(item)">
                    <v-icon color="red">mdi-delete</v-icon>
                </v-btn>
            </template>
        </ResponsiveTable>

        <v-row class="mt-4">
            <v-col cols="12" class="text-left">
                <v-btn color="red" @click="confirmarReinicio">
                    <v-icon left>mdi-trash-can</v-icon> Reiniciar Pedidos
                </v-btn>
                <v-btn
                    color="secondary"
                    class="ml-4"
                    @click="importarDesdeExcel"
                >
                    <v-icon left>mdi-upload</v-icon> Importar desde Excel
                </v-btn>
                <input
                    type="file"
                    ref="fileInput"
                    class="d-none"
                    @change="procesarArchivoExcel"
                />
            </v-col>
        </v-row>

        <v-dialog v-model="dialogReinicio" max-width="400px">
            <v-card>
                <v-card-title>¿Reiniciar todos los pedidos?</v-card-title>
                <v-card-actions>
                    <v-spacer />
                    <v-btn text @click="dialogReinicio = false">Cancelar</v-btn>
                    <v-btn color="red" text @click="reiniciarPedidos"
                        >Confirmar</v-btn
                    >
                </v-card-actions>
            </v-card>
        </v-dialog>
        <v-dialog v-model="dialogEditar" max-width="600px">
            <v-card>
                <v-card-title>Editar Pedido</v-card-title>
                <v-card-text>
                    <v-form>
                        <v-text-field
                            v-model="form.nombre"
                            label="Nombre y Apellido"
                            dense
                            outlined
                        />
                        <v-autocomplete
                            v-model="form.articulo_id"
                            :items="articulos"
                            :item-title="
                                (item) => `${item.numero} - ${item.nombre}`
                            "
                            item-value="id"
                            label="Artículo"
                            @update:modelValue="cargarTalles"
                            dense
                            outlined
                        />
                        <v-select
                            v-model="form.talle"
                            :items="talles"
                            label="Talle"
                            dense
                            outlined
                        />
                        <v-select
                            v-model="form.colores"
                            :items="colores"
                            label="Colores"
                            multiple
                            chips
                            dense
                            outlined
                        />
                    </v-form>
                </v-card-text>
                <v-card-actions>
                    <v-spacer />
                    <v-btn text @click="dialogEditar = false">Cancelar</v-btn>
                    <v-btn color="primary" text @click="guardarEdicionPedido"
                        >Guardar</v-btn
                    >
                </v-card-actions>
            </v-card>
        </v-dialog>
    </div>
</template>
<script>
import ExcelJS from "exceljs";
import axios from "axios";
import { getMemoryCache, updateCache } from "@/utils/cacheFetch";
import { PEDIDOS_KEY, ARTICULOS_KEY } from "@/utils/cacheKeys";
import { onCacheChange, notifyCacheChange } from "@/utils/cacheEvents";

export default {
    data() {
        return {
            page: 1,
            itemsPerPage: 10,
            dialogEditar: false,
            pedidoEditIndex: null,
            options: {
                page: 1,
                itemsPerPage: 10,
            },
            form: {
                nombre: "",
                articulo_id: null,
                talle: null,
                colores: [],
            },
            pedidoEditIndex: null, // Nuevo: índice si estamos editando
            articulos: [],
            talles: [],
            colores: [
                "verde",
                "azul",
                "negro",
                "marron",
                "celeste",
                "blanco/beige",
            ],
            pedidos: [],
            dialogReinicio: false,
            headers: [
                { title: "Nombre", key: "nombre" },
                { title: "Artículo", key: "articulo_nombre" },
                { title: "Talle", key: "talle" },
                { title: "Colores", key: "colores" },
                { title: "Acciones", key: "actions", sortable: false },
            ],
        };
    },
    mounted() {
        const pedidosCache = getMemoryCache(PEDIDOS_KEY);
        this.pedidos =
            pedidosCache ?? JSON.parse(localStorage.getItem("pedidos") || "[]");

        const articulosCache = getMemoryCache(ARTICULOS_KEY);
        if (articulosCache) {
            this.articulos = articulosCache;
        } else {
            axios.get("/api/articulos/listar").then((res) => {
                this.articulos = res.data;
            });
        }

        onCacheChange((key) => {
            if (key === PEDIDOS_KEY) {
                const nueva = getMemoryCache(PEDIDOS_KEY);
                if (nueva) {
                    this.pedidos = nueva;
                }
            }
        });
    },
    beforeUnmount() {
        window.removeEventListener("notifyCacheChange", this.handleCacheSync);
    },
    methods: {
        obtenerIndiceGlobal(indexLocal) {
            const { page, itemsPerPage } = this.options;
            return indexLocal + (page - 1) * itemsPerPage;
        },
        cargarTalles() {
            const art = this.articulos.find(
                (a) => a.id === this.form.articulo_id
            );
            if (!art) return;
            const matches = art.nombre.match(/(\d+)/g);
            if (matches && matches.length >= 2) {
                const min = parseInt(matches[0]);
                const max = parseInt(matches[1]);
                this.talles = [];
                for (let i = min; i <= max; i++) {
                    this.talles.push(i);
                }
            } else {
                this.talles = [];
            }
            this.form.talle = null;
        },
        agregarPedido() {
            if (
                !this.form.nombre ||
                !this.form.articulo_id ||
                !this.form.talle ||
                !this.form.colores.length
            )
                return;

            const articulo = this.articulos.find(
                (a) => a.id === this.form.articulo_id
            );

            const nuevoPedido = {
                nombre: this.form.nombre,
                articulo_nombre: `${articulo.numero} - ${articulo.nombre}`,
                talle: this.form.talle,
                colores: [...this.form.colores],
            };

            if (this.pedidoEditIndex !== null) {
                // Modo edición
                this.pedidos.splice(this.pedidoEditIndex, 1, nuevoPedido);
                this.pedidoEditIndex = null;
            } else {
                // Modo creación
                this.pedidos.push(nuevoPedido);
            }

            updateCache(PEDIDOS_KEY, this.pedidos);
            localStorage.setItem("pedidos", JSON.stringify(this.pedidos));
            notifyCacheChange(PEDIDOS_KEY);

            this.form = {
                nombre: "",
                articulo_id: null,
                talle: null,
                colores: [],
            };
        },
        editarPedido(pedido) {
            const index = this.pedidos.findIndex(
                (p) =>
                    p.nombre === pedido.nombre &&
                    p.articulo_nombre === pedido.articulo_nombre &&
                    p.talle === pedido.talle
            );

            if (index === -1) {
                console.warn("❌ Pedido no encontrado");
                return;
            }

            const articulo = this.articulos.find(
                (a) => `${a.numero} - ${a.nombre}` === pedido.articulo_nombre
            );

            this.form = {
                nombre: pedido.nombre,
                articulo_id: articulo ? articulo.id : null,
                talle: pedido.talle,
                colores: [...pedido.colores],
            };

            this.cargarTalles();
            this.pedidoEditIndex = index;
            this.dialogEditar = true;
        },
        guardarEdicionPedido() {
            const articulo = this.articulos.find(
                (a) => a.id === this.form.articulo_id
            );

            const actualizado = {
                nombre: this.form.nombre,
                articulo_nombre: `${articulo.numero} - ${articulo.nombre}`,
                talle: this.form.talle,
                colores: [...this.form.colores],
            };

            this.pedidos.splice(this.pedidoEditIndex, 1, actualizado);
            updateCache(PEDIDOS_KEY, this.pedidos);
            localStorage.setItem("pedidos", JSON.stringify(this.pedidos));
            notifyCacheChange(PEDIDOS_KEY);

            this.dialogEditar = false;
            this.pedidoEditIndex = null;
            this.form = {
                nombre: "",
                articulo_id: null,
                talle: null,
                colores: [],
            };
        },
        eliminarPedido(pedido) {
            const index = this.pedidos.findIndex(
                (p) =>
                    p.nombre === pedido.nombre &&
                    p.articulo_nombre === pedido.articulo_nombre &&
                    p.talle === pedido.talle
            );
            if (index !== -1) {
                this.pedidos.splice(index, 1);
                updateCache(PEDIDOS_KEY, this.pedidos);
                localStorage.setItem("pedidos", JSON.stringify(this.pedidos));
                notifyCacheChange(PEDIDOS_KEY);
            }
        },
        confirmarReinicio() {
            this.dialogReinicio = true;
        },
        reiniciarPedidos() {
            this.pedidos = [];
            updateCache(PEDIDOS_KEY, []);
            localStorage.removeItem("pedidos");
            notifyCacheChange(PEDIDOS_KEY);
            this.dialogReinicio = false;
        },
        copiarComoTexto() {
            const pedidosOrdenados = [...this.pedidos].sort((a, b) => {
                const codA = parseInt(a.articulo_nombre.split(" - ")[0]);
                const codB = parseInt(b.articulo_nombre.split(" - ")[0]);
                return codB - codA || a.nombre.localeCompare(b.nombre);
            });

            const texto = pedidosOrdenados
                .map((p, i) => {
                    const [codigo] = p.articulo_nombre.split(" - ");
                    return `Pedido ${i + 1}: Código ${codigo} - talle ${
                        p.talle
                    } - color ${p.colores.join(" / ")} de ${p.nombre}`;
                })
                .join("\n");

            navigator.clipboard
                .writeText(texto)
                .then(() => alert("Texto copiado al portapapeles"))
                .catch(() => alert("Error al copiar el texto"));
        },
        async exportarExcel() {
            const workbook = new ExcelJS.Workbook();
            const sheet = workbook.addWorksheet("Pedidos");

            sheet.columns = [
                { header: "Nombre", key: "nombre", width: 35 },
                { header: "Artículo", key: "articulo", width: 50 },
                { header: "Talle", key: "talle", width: 10 },
                { header: "Colores", key: "colores", width: 25 },
            ];

            [...this.pedidos]
                .sort((a, b) => {
                    const codA = parseInt(a.articulo_nombre.split(" - ")[0]);
                    const codB = parseInt(b.articulo_nombre.split(" - ")[0]);
                    return codB - codA || a.nombre.localeCompare(b.nombre);
                })
                .forEach((p) => {
                    sheet.addRow({
                        nombre: p.nombre,
                        articulo: p.articulo_nombre,
                        talle: p.talle,
                        colores: p.colores.join(" / "),
                    });
                });

            const buffer = await workbook.xlsx.writeBuffer();
            const blob = new Blob([buffer]);
            const url = URL.createObjectURL(blob);
            const a = document.createElement("a");
            a.href = url;
            a.download = "pedidos.xlsx";
            a.click();
            URL.revokeObjectURL(url);
        },
        importarDesdeExcel() {
            this.$refs.fileInput.click();
        },
        async procesarArchivoExcel(event) {
            const file = event.target.files[0];
            if (!file) return;

            const workbook = new ExcelJS.Workbook();
            await workbook.xlsx.load(await file.arrayBuffer());
            const sheet = workbook.getWorksheet(1);

            const nuevasFilas = [];
            sheet.eachRow((row, idx) => {
                if (idx === 1) return;
                const [nombre, articulo, talle, colores] = row.values.slice(1);
                nuevasFilas.push({
                    nombre,
                    articulo_nombre: articulo,
                    talle,
                    colores: colores.split(" / "),
                });
            });

            this.pedidos.push(...nuevasFilas);
            updateCache(PEDIDOS_KEY, this.pedidos);
            localStorage.setItem("pedidos", JSON.stringify(this.pedidos));
            notifyCacheChange(PEDIDOS_KEY);
        },
    },
};
</script>

<style scoped>
.pedido-container {
    max-width: 1200px;
    margin: auto;
    padding: 24px;
}
.formulario-pedido {
    margin-bottom: 16px;
}
@media (max-width: 768px) {
    .pedido-container {
        padding: 12px;
    }

    h2.text-h5 {
        font-size: 24px !important;
        margin-bottom: 16px;
    }

    .formulario-pedido .v-col {
        padding-bottom: 12px;
    }

    .formulario-pedido .v-text-field,
    .formulario-pedido .v-select,
    .formulario-pedido .v-autocomplete {
        font-size: 18px;
    }

    .v-btn {
        font-size: 18px;
        min-height: 44px;
    }

    .v-btn .v-icon {
        font-size: 20px;
    }

    .v-row > .v-col[cols="auto"] {
        width: 100% !important;
        padding-bottom: 12px;
    }

    .v-row > .v-col[cols="auto"] .v-btn {
        width: 100%;
        justify-content: center;
    }

    .mt-4 {
        margin-top: 16px !important;
    }

    .v-row .ml-4 {
        margin-left: 0 !important;
        margin-top: 12px;
    }

    .v-row .v-btn {
        width: 100%;
    }
}
</style>
