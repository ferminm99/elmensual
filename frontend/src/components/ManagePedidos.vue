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

        <v-row>
            <v-col cols="auto">
                <v-btn color="success" @click="exportarExcel">
                    <v-icon left>mdi-file-excel</v-icon> Exportar Excel
                </v-btn>
            </v-col>
            <v-col cols="auto">
                <v-btn color="grey" @click="copiarComoTexto">
                    <v-icon left>mdi-content-copy</v-icon> Copiar como texto
                </v-btn>
            </v-col>
            <v-col cols="auto">
                <v-btn color="primary" @click="agregarPedido">
                    <v-icon left>mdi-plus</v-icon> Agregar Pedido
                </v-btn>
            </v-col>
            <div style="padding-bottom: 120px"></div>
        </v-row>

        <v-data-table :headers="headers" :items="pedidos" class="elevation-1">
            <template #item.colores="{ item }">
                {{ item.colores.join(" / ") }}
            </template>
            <template #item.actions="{ item, index }">
                <v-btn icon @click="eliminarPedido(index)">
                    <v-icon color="red">mdi-delete</v-icon>
                </v-btn>
            </template>
        </v-data-table>

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
    </div>
</template>

<script>
import ExcelJS from "exceljs";
import axios from "axios";

export default {
    data() {
        return {
            form: {
                nombre: "",
                articulo_id: null,
                talle: null,
                colores: [],
            },
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
            pedidos: JSON.parse(localStorage.getItem("pedidos")) || [],
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
        axios.get("/api/articulos/listar").then((res) => {
            this.articulos = res.data;
        });
    },
    methods: {
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
            this.pedidos.push({
                nombre: this.form.nombre,
                articulo_nombre: `${articulo.numero} - ${articulo.nombre}`,
                talle: this.form.talle,
                colores: [...this.form.colores],
            });
            localStorage.setItem("pedidos", JSON.stringify(this.pedidos));
            this.form = {
                nombre: "",
                articulo_id: null,
                talle: null,
                colores: [],
            };
        },
        eliminarPedido(index) {
            this.pedidos.splice(index, 1);
            localStorage.setItem("pedidos", JSON.stringify(this.pedidos));
        },
        confirmarReinicio() {
            this.dialogReinicio = true;
        },
        reiniciarPedidos() {
            this.pedidos = [];
            localStorage.removeItem("pedidos");
            this.dialogReinicio = false;
        },
        copiarComoTexto() {
            const pedidosOrdenados = [...this.pedidos].sort((a, b) => {
                const codA = parseInt(a.articulo_nombre.split(" - ")[0]);
                const codB = parseInt(b.articulo_nombre.split(" - ")[0]);

                if (codA !== codB) return codB - codA; // Mayor a menor
                return a.nombre.localeCompare(b.nombre); // Orden alfabético
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
                    if (codA !== codB) return codB - codA;
                    return a.nombre.localeCompare(b.nombre);
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
            localStorage.setItem("pedidos", JSON.stringify(this.pedidos));
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
</style>
