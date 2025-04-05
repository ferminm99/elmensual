<template>
  <div>
    <!-- Título -->
    <v-row>
      <v-col>
        <h1 class="title font-weight-bold">Gestión de Clientes</h1>
      </v-col>
    </v-row>

    <!-- Buscador -->
    <v-row class="mb-4">
      <v-col>
        <v-text-field
          v-model="search"
          label="Buscar Cliente"
          append-icon="mdi-magnify"
          single-line
          hide-details
          variant="solo"
        ></v-text-field>
      </v-col>
    </v-row>

    <!-- Botón para agregar clientes -->
    <v-row class="d-flex align-center mb-4">
      <v-btn color="black" class="ml-3" @click="openAddDialog">
        <v-icon left>mdi-plus-box</v-icon> Agregar Cliente
      </v-btn>
    </v-row>

    <!-- Tabla para listar clientes -->
    <v-data-table
      :headers="headers"
      :items="clientes"
      :search="search"
      class="elevation-1 mt-2"
      dense
    >
      <template v-slot:item.totalVentas="{ item }">
        <span>{{ item.totalVentas || 0 }}</span>
      </template>

      <template v-slot:item.totalPago="{ item }">
        <span>${{ formatCurrency(item.totalPago || 0) }}</span>
      </template>

      <template v-slot:item.actions="{ item }">
        <v-btn flat icon @click="openEditDialog(item)">
          <v-icon color="black">mdi-pencil-outline</v-icon>
        </v-btn>
        <v-btn flat icon @click="openDeleteConfirm(item)">
          <v-icon color="black">mdi-trash-can-outline</v-icon>
        </v-btn>
      </template>
    </v-data-table>

    <!-- Diálogo para agregar/editar clientes -->
    <v-dialog v-model="dialog" max-width="600px">
      <v-card>
        <v-card-title class="d-flex justify-space-between align-center">
          {{ isEdit ? "Editar" : "Agregar" }} Cliente
          <v-btn flat icon @click="dialog = false">
            <v-icon color="red">mdi-close</v-icon>
          </v-btn>
        </v-card-title>
        <v-card-text>
          <v-form ref="formCliente" v-model="valid" lazy-validation>
            <v-text-field
              v-model="form.nombre"
              label="Nombre"
              required
              :rules="[(v) => !!v || 'Nombre es requerido']"
            ></v-text-field>
            <v-text-field
              v-model="form.apellido"
              label="Apellido"
              required
              :rules="[(v) => !!v || 'Apellido es requerido']"
            ></v-text-field>
            <v-text-field v-model="form.cuit" label="CUIT"></v-text-field>
            <v-text-field v-model="form.cbu" label="CBU"></v-text-field>
          </v-form>
        </v-card-text>
        <v-card-actions>
          <v-btn text @click="dialog = false">Cancelar</v-btn>
          <v-btn color="black" text @click="saveCliente">{{
            isEdit ? "Guardar" : "Agregar"
          }}</v-btn>
        </v-card-actions>
      </v-card>
    </v-dialog>

    <!-- Diálogo de confirmación para eliminar -->
    <v-dialog v-model="confirmDeleteDialog" max-width="400px">
      <v-card>
        <v-card-title class="d-flex justify-space-between align-center">
          Confirmar eliminación
          <v-btn flat icon @click="confirmDeleteDialog = false">
            <v-icon color="red">mdi-close</v-icon>
          </v-btn>
        </v-card-title>
        <v-card-text>
          ¿Estás seguro de que deseas eliminar al cliente
          {{ clienteAEliminar.nombre }}
          {{ clienteAEliminar.apellido }}?
        </v-card-text>
        <v-card-actions>
          <v-btn text @click="confirmDeleteDialog = false">Cancelar</v-btn>
          <v-btn color="red" text @click="deleteCliente">Eliminar</v-btn>
        </v-card-actions>
      </v-card>
    </v-dialog>
  </div>
</template>

<script>
export default {
  data() {
    return {
      dialog: false,
      confirmDeleteDialog: false,
      isEdit: false,
      clienteAEliminar: null,
      search: "", // Campo para el buscador
      valid: true,
      form: {
        id: null,
        nombre: "",
        apellido: "",
        cuit: "",
        cbu: "",
      },
      ventas: [],
      clientes: [],
      datosCargados: {
        clientes: false,
        ventas: false,
      },
      headers: [
        { title: "Nombre", key: "nombre", sortable: true },
        { title: "Apellido", key: "apellido", sortable: true },
        { title: "CUIT", key: "cuit", sortable: true },
        { title: "CBU", key: "cbu" },
        { title: "Total Ventas", key: "totalVentas", sortable: true },
        { title: "Total Pagado", key: "totalPago", sortable: true },
        {
          title: "Acciones",
          key: "actions",
          align: "center",
          sortable: false,
        },
      ],
    };
  },
  created() {
    this.fetchClientes();
    this.fetchVentas();
  },
  methods: {
    fetchClientes() {
      return axios.get("/api/clientes/listar").then((response) => {
        this.clientes = response.data || [];
        this.datosCargados.clientes = true; // Marcar clientes como cargados
        this.verificarYCalcularTotales();
      });
    },
    fetchVentas() {
      return axios.get("/api/ventas/listar").then((response) => {
        this.ventas = response.data || [];
        this.datosCargados.ventas = true; // Marcar ventas como cargadas
        this.verificarYCalcularTotales();
      });
    },
    verificarYCalcularTotales() {
      if (this.datosCargados.clientes && this.datosCargados.ventas) {
        this.calculateTotals();
      }
    },
    calculateTotals() {
      // Reinicia los totales en cada cliente
      this.clientes.forEach((cliente) => {
        cliente.totalVentas = 0;
        cliente.totalPago = 0;
      });

      // Suma las ventas y el total pagado para cada cliente
      this.ventas.forEach((venta) => {
        const cliente = this.clientes.find((c) => c.id === venta.cliente_id);
        if (cliente) {
          cliente.totalVentas += 1;
          cliente.totalPago += parseFloat(venta.precio);
        }
      });
    },
    formatCurrency(value) {
      return value.toLocaleString("es-AR", {
        minimumFractionDigits: 2,
        maximumFractionDigits: 2,
      });
    },
    openAddDialog() {
      this.isEdit = false;
      this.form = {
        id: null,
        nombre: "",
        apellido: "",
        cuit: "",
        cbu: "",
      }; // Limpiar el formulario
      this.dialog = true;
    },
    openEditDialog(item) {
      this.isEdit = true;
      this.form = { ...item }; // Cargar los datos del cliente a editar
      this.dialog = true;
    },
    saveCliente() {
      // Validar que nombre y apellido no estén vacíos
      if (!this.form.nombre || !this.form.apellido) {
        alert("Por favor ingresa nombre y apellido.");
        return;
      }

      // Capitalizamos el nombre y apellido
      this.form.nombre = this.capitalizarPalabras(this.form.nombre);
      this.form.apellido = this.capitalizarPalabras(this.form.apellido);

      // Si estamos editando
      if (this.isEdit) {
        axios.put(`/api/cliente/${this.form.id}`, this.form).then(() => {
          this.fetchClientes();
          this.dialog = false;
        });
      } else {
        // Si estamos creando un cliente nuevo
        axios.post("/api/cliente", this.form).then(() => {
          this.fetchClientes();
          this.dialog = false;
        });
      }
    },
    openDeleteConfirm(item) {
      this.clienteAEliminar = item;
      this.confirmDeleteDialog = true;
    },
    deleteCliente() {
      axios.delete(`/api/cliente/${this.clienteAEliminar.id}`).then(() => {
        this.fetchClientes();
        this.confirmDeleteDialog = false;
      });
    },
    // Método de validación
    validateForm() {
      return (
        this.form.nombre &&
        this.form.apellido &&
        this.form.cuit &&
        this.form.cbu
      );
    },
    capitalizarPalabras(texto) {
      return texto
        .toLowerCase()
        .split(" ")
        .map((palabra) => palabra.charAt(0).toUpperCase() + palabra.slice(1))
        .join(" ");
    },
  },
};
</script>

<style scoped>
@import url("https://fonts.googleapis.com/css2?family=Nunito:wght@300;400;600;700&display=swap");
* {
  font-family: "Nunito", sans-serif;
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

.v-icon {
  color: #555;
}

.v-icon:hover {
  color: black;
}

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

.v-card-title {
  font-size: 24px;
}
</style>
