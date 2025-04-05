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
    <v-data-table
      :headers="headers"
      :items="articulosFiltrados"
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
          <v-btn color="green" text @click="aumentarCostos"> Aplicar </v-btn>
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
          <v-btn color="black" text @click="saveArticulo">
            {{ isEdit ? "Guardar" : "Agregar" }}
          </v-btn>
        </v-card-actions>
      </v-card>
    </v-dialog>
  </div>
</template>

<script>
import ExcelJS from "exceljs";
export default {
  data() {
    return {
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
      },
      articulos: [],
      headers: [
        { title: "Número", key: "numero" },
        { title: "Nombre", key: "nombre" },
        { title: "Precio", key: "precio" },
        { title: "Costo Original", key: "costo_original" },
        { title: "Efectivo", key: "precio_efectivo" },
        { title: "Transferencia", key: "precio_transferencia" },
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
      const palabrasNombre = this.searchNombre
        .toLowerCase()
        .split(" ")
        .filter((p) => p.trim() !== "");
      const textoNumero = this.searchNumero.toLowerCase().trim();

      return this.articulos.filter((art) => {
        const nombre = art.nombre.toLowerCase();
        const numero = String(art.numero).toLowerCase();

        const coincideNombre = palabrasNombre.every((palabra) =>
          nombre.includes(palabra)
        );
        const coincideNumero =
          textoNumero === "" || numero.includes(textoNumero);

        return coincideNombre && coincideNumero;
      });
    },
  },
  created() {
    this.fetchArticulos();
  },
  methods: {
    async exportarExcel() {
      const workbook = new ExcelJS.Workbook();
      const worksheet = workbook.addWorksheet("Artículos");

      // Encabezados
      worksheet.columns = [
        { header: "Número", key: "numero", width: 15 },
        { header: "Nombre", key: "nombre", width: 40 },
        { header: "Precio", key: "precio", width: 15 },
        { header: "Costo Original", key: "costo_original", width: 20 },
        { header: "Efectivo", key: "efectivo", width: 15 },
        { header: "Transferencia", key: "transferencia", width: 20 },
      ];

      // Agregar datos
      this.articulosFiltrados.forEach((item) => {
        worksheet.addRow({
          numero: item.numero,
          nombre: item.nombre,
          precio: item.precio,
          costo_original: item.costo_original,
          efectivo: item.precio_efectivo,
          transferencia: item.precio_transferencia,
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
    },
    fetchArticulos() {
      axios.get("/api/articulos").then((res) => {
        this.articulos = res.data;
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
      };
      this.dialog = true;
    },
    openEditDialog(item) {
      this.isEdit = true;
      this.form = { ...item };
      this.dialog = true;
    },
    saveArticulo() {
      if (!this.validateForm()) return;
      this.form.precio = parseInt(this.form.precio);
      this.form.costo_original = parseInt(this.form.costo_original);

      const request = this.isEdit
        ? axios.put(`/api/articulo/${this.form.id}`, this.form)
        : axios.post("/api/articulo", this.form);

      request.then(() => {
        this.fetchArticulos();
        this.dialog = false;
      });
    },
    openDeleteConfirm(item) {
      this.articuloAEliminar = item;
      this.confirmDeleteDialog = true;
    },
    deleteArticulo() {
      axios.delete(`/api/articulo/${this.articuloAEliminar.id}`).then(() => {
        this.fetchArticulos();
        this.confirmDeleteDialog = false;
      });
    },
    recalcularPrecios() {
      axios.put("/api/articulos/recalcular-precios").then(() => {
        this.fetchArticulos();
        alert("Precios recalculados correctamente.");
      });
    },
    abrirDialogoAumento() {
      this.porcentajeAumento = 0;
      this.dialogoAumento = true;
    },
    aumentarCostos() {
      //usar 0.01 % si reste y quiero sumar algo, por ej 1% seria 1.01% y asi sale bien calculado nose porque
      axios
        .put("/api/articulos/aumentar-costos", {
          porcentaje: this.porcentajeAumento,
        })
        .then(() => {
          this.fetchArticulos();
          this.dialogoAumento = false;
          alert("Costos actualizados correctamente.");
        });
    },
    validateForm() {
      if (!this.form.numero || String(this.form.numero).trim() === "")
        return false;
      if (!this.form.nombre || this.form.nombre.trim() === "") return false;
      if (!this.form.precio || isNaN(this.form.precio)) return false;
      if (!this.form.costo_original || isNaN(this.form.costo_original))
        return false;
      return true;
    },
  },
};
</script>
