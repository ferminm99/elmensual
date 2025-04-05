<template>
  <div>
    <v-row class="mb-3">
      <v-col cols="12" md="4">
        <v-text-field
          v-model="search"
          label="Buscar localidad"
          solo
          dense
          clearable
        ></v-text-field>
      </v-col>
      <v-col cols="auto">
        <v-btn color="primary" @click="openDialog">Agregar Localidad</v-btn>
      </v-col>
      <v-col cols="auto">
        <v-btn color="orange" @click="exportarExcel">
          <v-icon left>mdi-download</v-icon> Exportar Excel
        </v-btn>
      </v-col>
    </v-row>

    <v-data-table :headers="headers" :items="localidadesFiltradas" dense>
      <template v-slot:item.disponibilidad="{ item }">
        <v-chip
          :color="item.disponibilidad ? 'green lighten-4' : 'red lighten-4'"
        >
          <v-icon left>
            {{ item.disponibilidad ? "mdi-check-circle" : "mdi-close-circle" }}
          </v-icon>
          {{ item.disponibilidad ? "Disponible" : "No disponible" }}
        </v-chip>
      </template>

      <template v-slot:item.actions="{ item }">
        <v-btn icon @click="editLocalidad(item)"
          ><v-icon>mdi-pencil</v-icon></v-btn
        >
        <v-btn icon @click="deleteLocalidad(item.id)"
          ><v-icon color="red">mdi-delete</v-icon></v-btn
        >
      </template>
    </v-data-table>

    <!-- Diálogo para agregar/editar -->
    <v-dialog v-model="dialog" max-width="500px">
      <v-card>
        <v-card-title
          >{{ isEdit ? "Editar" : "Agregar" }} Localidad</v-card-title
        >
        <v-card-text>
          <v-text-field v-model="form.nombre" label="Nombre"></v-text-field>
          <v-switch v-model="form.disponibilidad" label="Disponible"></v-switch>
        </v-card-text>
        <v-card-actions>
          <v-btn text @click="dialog = false">Cancelar</v-btn>
          <v-btn color="primary" @click="saveLocalidad">Guardar</v-btn>
        </v-card-actions>
      </v-card>
    </v-dialog>
  </div>
</template>

<script>
import ExcelJS from "exceljs";

function normalize(text) {
  return text
    .normalize("NFD")
    .replace(/[\u0300-\u036f]/g, "")
    .toLowerCase();
}

export default {
  data() {
    return {
      dialog: false,
      isEdit: false,
      localidades: [],
      search: "",
      form: {
        id: null,
        nombre: "",
        disponibilidad: false,
      },
      headers: [
        { title: "Nombre", key: "nombre" },
        { title: "Disponibilidad", key: "disponibilidad" },
        {
          title: "Acciones",
          key: "actions",
          sortable: false,
          align: "end",
        },
      ],
    };
  },
  computed: {
    localidadesFiltradas() {
      const palabras = normalize(this.search).split(" ").filter(Boolean);
      return this.localidades.filter((loc) =>
        palabras.every((p) => normalize(loc.nombre).includes(p))
      );
    },
  },

  created() {
    this.fetchLocalidades();
  },
  methods: {
    fetchLocalidades() {
      axios.get("/api/api/localidades").then((res) => {
        console.log("PREPARANDO:");
        this.localidades = res.data;
      });
    },
    openDialog() {
      this.isEdit = false;
      this.form = { id: null, nombre: "", disponibilidad: false };
      this.dialog = true;
    },
    editLocalidad(item) {
      this.isEdit = true;
      this.form = { ...item };
      this.dialog = true;
    },
    saveLocalidad() {
      const req = this.isEdit
        ? axios.put(`/api/localidad/${this.form.id}`, this.form)
        : axios.post("/api/localidad", this.form);

      req.then(() => {
        this.dialog = false;
        this.fetchLocalidades();
      });
    },
    deleteLocalidad(id) {
      if (confirm("¿Eliminar esta localidad?")) {
        axios
          .delete(`/api/localidad/${id}`)
          .then(() => this.fetchLocalidades());
      }
    },
    async exportarExcel() {
      const workbook = new ExcelJS.Workbook();
      const sheet = workbook.addWorksheet("Localidades");
      sheet.columns = [
        { header: "Nombre", key: "nombre", width: 30 },
        { header: "Disponibilidad", key: "disponibilidad", width: 20 },
      ];

      this.localidadesFiltradas.forEach((loc) => {
        sheet.addRow({
          nombre: loc.nombre,
          disponibilidad: loc.disponibilidad ? "Sí" : "No",
        });
      });

      const buffer = await workbook.xlsx.writeBuffer();
      const blob = new Blob([buffer], {
        type: "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet",
      });
      const link = document.createElement("a");
      link.href = URL.createObjectURL(blob);
      link.download = "localidades.xlsx";
      link.click();
    },
  },
};
</script>

<style scoped>
.v-chip {
  font-weight: 500;
  border-radius: 20px;
}
</style>
