<template>
  <div>
    <!-- Card para todo el contenido -->
    <!-- <v-card class="pa-4" elevation="2"> -->
    <!-- Título de la página -->
    <v-row>
      <v-col>
        <h2 class="text-h4">Inventario de Bombachas</h2>
      </v-col>
    </v-row>

    <!-- Selector de artículos y botones -->
    <v-row>
      <v-col cols="12" md="8">
        <v-autocomplete
          v-model="selectedArticulo"
          :items="articulos"
          :item-title="(item) => `${item.numero} - ${item.nombre}`"
          item-value="id"
          label="Selecciona un artículo"
          @update:modelValue="onArticuloChange"
          clearable
          filterable
          variant="solo"
          :class="{ 'rojo-text': esAlpargatas }"
        />
      </v-col>
      <v-col cols="12" md="4" class="d-flex justify-end">
        <v-btn color="#6E7E8E" @click="exportarAExcel" outlined>
          <v-icon left>mdi-file-excel</v-icon>
          Exportar a Excel
        </v-btn>
        <v-btn
          color="#4A4A4A"
          @click="exportAndUploadToDrive"
          class="ml-2"
          outlined
        >
          <v-icon left>mdi-google-drive</v-icon>
          Exportar y Subir a Drive
        </v-btn>
      </v-col>
    </v-row>

    <!-- Botón para agregar y eliminar bombachas -->
    <v-row class="mt-4">
      <v-col cols="12">
        <v-btn color="#4A4A4A" @click="openDialog('agregar')" outlined>
          <v-icon left>mdi-plus</v-icon>
          Agregar Bombachas
        </v-btn>
        <v-btn
          color="#E57373"
          @click="openDialog('eliminar')"
          class="ml-2"
          outlined
        >
          <v-icon left>mdi-delete</v-icon>
          Eliminar Bombachas
        </v-btn>
      </v-col>
    </v-row>

    <!-- Tabla de talles y colores -->
    <v-data-table
      :key="selectedArticulo"
      :headers="headers"
      :items="talles"
      class="elevation-1 mt-4"
    >
      <!-- Personalización de las celdas -->
      <template v-slot:item.marron="{ item }">
        <span class="marron-text">{{ item.marron }}</span>
      </template>
      <template v-slot:item.negro="{ item }">
        <span class="negro-text">{{ item.negro }}</span>
      </template>
      <template v-slot:item.verde="{ item }">
        <span class="verde-text">{{ item.verde }}</span>
      </template>
      <template v-slot:item.azul="{ item }">
        <span class="azul-text">{{ item.azul }}</span>
      </template>
      <template v-slot:item.celeste="{ item }">
        <span
          :class="{
            'celeste-text': !esAlpargatas,
            'rojo-text': esAlpargatas,
          }"
          >{{ item.celeste }}</span
        >
      </template>

      <template v-slot:item.blancobeige="{ item }">
        <span class="blanco-text">{{ item.blancobeige }}</span>
      </template>
      <template v-slot:item.total_bombachas="{ item }">
        {{ getTotalBombachas(item) }}
      </template>
      <!-- Botones de acciones con íconos más estilizados -->
      <template v-slot:item.actions="{ item }">
        <v-btn flat icon @click="openEditDialog(item)">
          <v-icon color="#4A4A4A">mdi-pencil-outline</v-icon>
        </v-btn>
        <v-btn flat icon @click="openDeleteFullConfirm(item.talle)">
          <v-icon color="#E57373">mdi-trash-can-outline</v-icon>
        </v-btn>
      </template>
    </v-data-table>
    <!-- </v-card> -->

    <!-- Diálogo para agregar bombachas -->
    <v-dialog v-model="dialog" max-width="600px">
      <v-card>
        <v-card-title class="d-flex justify-space-between align-center">
          <span class="headline"
            >{{ isAgregar ? "Agregar" : "Eliminar" }} Bombachas al
            Artículo</span
          >
          <v-btn flat icon @click="dialog = false">
            <v-icon color="red">mdi-close</v-icon>
          </v-btn>
        </v-card-title>

        <v-card-text>
          <v-form ref="form">
            <v-row
              ><v-autocomplete
                v-model="selectedArticuloDialog"
                :items="articulos"
                :item-title="(item) => `${item.numero} - ${item.nombre}`"
                item-value="id"
                label="Selecciona un artículo"
                @update:modelValue="tallesCorrectos"
                clearable
                filterable
            /></v-row>
            <v-row
              ><v-select
                v-model="selectedTalles"
                :items="tallesDisponiblesSeleccionados"
                item-title="talle"
                item-value="talle"
                label="Selecciona los talles"
                multiple
                chips
                clearable
            /></v-row>

            <v-row>
              <v-col cols="4">
                <v-text-field
                  v-model="newQuantities.verde"
                  label="Verde"
                  type="number"
                  class="verde-text"
                  min="0"
                ></v-text-field>
              </v-col>
              <v-col cols="4">
                <v-text-field
                  v-model="newQuantities.azul"
                  label="Azul"
                  type="number"
                  class="azul-text"
                  min="0"
                ></v-text-field>
              </v-col>
              <v-col cols="4">
                <v-text-field
                  v-model="newQuantities.marron"
                  label="Marrón"
                  type="number"
                  class="marron-text"
                  min="0"
                ></v-text-field>
              </v-col>
            </v-row>
            <v-row>
              <v-col cols="4">
                <v-text-field
                  v-model="newQuantities.negro"
                  label="Negro"
                  type="number"
                  class="negro-text"
                  min="0"
                ></v-text-field>
              </v-col>

              <v-col cols="4">
                <v-text-field
                  v-model="newQuantities.celeste"
                  label="Celeste (rojo en alpargata)"
                  type="number"
                  class="celeste-text"
                  min="0"
                ></v-text-field>
              </v-col>
              <v-col cols="4">
                <v-text-field
                  v-model="newQuantities.blancobeige"
                  label="Blanco/Beige"
                  type="number"
                  class="blancobeige-text"
                  min="0"
                ></v-text-field>
              </v-col>
            </v-row>
            <!-- Más colores... -->
          </v-form>
        </v-card-text>

        <v-card-actions>
          <v-btn text @click="dialog = false">Cancelar</v-btn>
          <v-btn
            color="blue darken-1"
            text
            @click="isAgregar ? openAddConfirm() : openDeleteConfirm()"
          >
            {{ isAgregar ? "Agregar" : "Eliminar" }}
          </v-btn>
        </v-card-actions>
      </v-card>
    </v-dialog>

    <!-- Diálogo para editar bombachas -->
    <v-dialog v-model="editDialog" max-width="500px">
      <v-card>
        <v-card-title class="d-flex justify-space-between align-center"
          >Editar Cantidades del Talle {{ currentTalle.talle
          }}<v-btn flat icon @click="editDialog = false">
            <v-icon color="red">mdi-close</v-icon>
          </v-btn>
        </v-card-title>
        <v-card-text>
          <!-- Formulario para editar las cantidades -->
          <v-row>
            <v-col cols="6">
              <v-text-field
                label="Marrón"
                v-model="currentTalle.marron"
                class="marron-text"
              ></v-text-field>
            </v-col>
            <v-col cols="6">
              <v-text-field
                label="Negro"
                v-model="currentTalle.negro"
                class="negro-text"
              ></v-text-field>
            </v-col>
            <v-col cols="6">
              <v-text-field
                label="Verde"
                v-model="currentTalle.verde"
                class="verde-text"
              ></v-text-field>
            </v-col>
            <v-col cols="6">
              <v-text-field
                label="Azul"
                v-model="currentTalle.azul"
                class="azul-text"
              ></v-text-field>
            </v-col>
            <v-col cols="6">
              <v-text-field
                label="Celeste"
                v-model="currentTalle.celeste"
                class="celeste-text"
              ></v-text-field>
            </v-col>
            <v-col cols="6">
              <v-text-field
                label="Blanco/Beige"
                v-model="currentTalle.blancobeige"
                class="blancobeige-text"
              ></v-text-field>
            </v-col>
          </v-row>
        </v-card-text>

        <v-card-actions>
          <v-spacer></v-spacer>
          <v-btn color="grey" text @click="editDialog = false">Cancelar</v-btn>
          <v-btn color="black" text @click="saveChanges">Guardar</v-btn>
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
        <v-card-text
          >¿Estás seguro de que deseas eliminar esas bombachas? ?</v-card-text
        >
        <v-card-actions>
          <v-spacer></v-spacer>
          <v-btn color="grey" text @click="confirmDeleteDialog = false"
            >Cancelar</v-btn
          >
          <v-btn color="red" text @click="removeQuantities">Eliminar</v-btn>
        </v-card-actions>
      </v-card>
    </v-dialog>

    <!-- Diálogo de confirmación para eliminar -->
    <v-dialog v-model="confirmFullDeleteDialog" max-width="400px">
      <v-card>
        <v-card-title class="d-flex justify-space-between align-center"
          >Confirmar eliminación<v-btn
            flat
            icon
            @click="confirmFullDeleteDialog = false"
          >
            <v-icon color="red">mdi-close</v-icon>
          </v-btn></v-card-title
        >
        <v-card-text
          >¿Estás seguro de que deseas eliminar todas las bombachas de este
          talle {{ talleAEliminar }}?</v-card-text
        >
        <v-card-actions>
          <v-spacer></v-spacer>
          <v-btn color="grey" text @click="confirmFullDeleteDialog = false"
            >Cancelar</v-btn
          >
          <v-btn color="red" text @click="deleteCompleteTalle">Eliminar</v-btn>
        </v-card-actions>
      </v-card>
    </v-dialog>

    <!-- Diálogo de confirmación para agregar bombachas -->
    <v-dialog v-model="confirmAddDialog" max-width="400px">
      <v-card>
        <v-card-title class="d-flex justify-space-between align-center"
          >Confirmar adición<v-btn flat icon @click="confirmAddDialog = false">
            <v-icon color="red">mdi-close</v-icon>
          </v-btn></v-card-title
        >
        <v-card-text
          >¿Estás seguro de que deseas agregar estas bombachas?</v-card-text
        >
        <v-card-actions>
          <v-spacer></v-spacer>
          <v-btn color="grey" text @click="confirmAddDialog = false"
            >Cancelar</v-btn
          >
          <v-btn color="green" text @click="addQuantities">Agregar</v-btn>
        </v-card-actions>
      </v-card>
    </v-dialog>
  </div>
</template>

<script>
import { toRaw } from "vue";
import { shallowReactive } from "vue";
import ExcelJS from "exceljs";
export default {
  data() {
    return {
      //dialogs confirmar
      confirmDeleteDialog: false,
      confirmAddDialog: false,
      confirmFullDeleteDialog: false,
      //para editar bombachas segun talle
      editDialog: false,
      currentTalle: {
        marron: 0,
        negro: 0,
        verde: 0,
        azul: 0,
        celeste: 0,
        blancobeige: 0,
        talle: null,
      },
      articulosCompletos: [],
      //para agregar o borrar
      dialog: false,
      selected: null,
      isAgregar: true, // Determina si se agrega o elimina
      selectedArticulo: null,
      selectedArticuloDialog: null,
      articulos: shallowReactive([]),
      talles: [],
      selectedTalles: [], // Almacena los talles seleccionados
      tallesDisponiblesSeleccionados: [],
      tallesDisponibles: [
        { talle: 0 },
        { talle: 2 },
        { talle: 4 },
        { talle: 6 },
        { talle: 8 },
        { talle: 10 },
        { talle: 12 },
        { talle: 14 },
        { talle: 16 },
        { talle: 32 },
        { talle: 34 },
        { talle: 36 },
        { talle: 38 },
        { talle: 40 },
        { talle: 42 },
        { talle: 44 },
        { talle: 46 },
        { talle: 48 },
        { talle: 50 },
        { talle: 52 },
        { talle: 54 },
        { talle: 56 },
        { talle: 58 },
        { talle: 60 },
        { talle: 62 },
        { talle: 64 },
        { talle: 66 },
        { talle: 68 },
        { talle: 70 },
      ], // Los talles disponibles para seleccionar
      newQuantities: {
        verde: 0,
        azul: 0,
        marron: 0,
        negro: 0,
        celeste: 0,
        blancobeige: 0,
      },
    };
  },
  created() {
    this.fetchArticulos();
  },
  computed: {
    headers() {
      return [
        { title: "Talle", key: "talle", align: "center" },
        {
          title: "Marrón",
          key: "marron",
          align: "center",
          sortable: false,
          class: "marron-text",
        },
        {
          title: "Negro",
          key: "negro",
          sortable: false,
          align: "center",
          class: "negro-text",
        },
        {
          title: "Verde",
          key: "verde",
          sortable: false,
          align: "center",
          class: "verde-text",
        },
        {
          title: "Azul",
          key: "azul",
          sortable: false,
          align: "center",
          class: "azul-text",
        },
        {
          title: this.esAlpargatas ? "Rojo" : "Celeste", // Aquí se cambia dinámicamente el título
          key: "celeste",
          sortable: false,
          align: "center",
          class: this.esAlpargatas ? "rojo-text" : "celeste-text",
        },
        {
          title: "Blanco/Beige",
          key: "blancobeige",
          sortable: false,
          align: "center",
          headerClass: "blancobeige-text",
        },
        { title: "Total", key: "total_bombachas", align: "center" },
        { title: "Acciones", key: "actions", align: "center" },
      ];
    },

    esAlpargatas() {
      const articuloSeleccionado = this.articulos.find(
        (articulo) => articulo.id === this.selectedArticulo
      );
      return articuloSeleccionado
        ? articuloSeleccionado.nombre.toUpperCase().includes("ALPARGATA")
        : false;
    },
  },
  methods: {
    exportarAExcel() {
      const workbook = new ExcelJS.Workbook();
      const worksheet = workbook.addWorksheet("Bombachas");

      // Definir el ancho de las columnas
      worksheet.columns = [
        { header: "Artículo", key: "articulo", width: 50 },
        { header: "Talle", key: "talle", width: 10 },
        { header: "Marrón", key: "marron", width: 10 },
        { header: "Negro", key: "negro", width: 10 },
        { header: "Verde", key: "verde", width: 10 },
        { header: "Azul", key: "azul", width: 10 },
        { header: "Celeste", key: "celeste", width: 10 },
        { header: "Blanco/Beige", key: "blancobeige", width: 15 },
        { header: "Total", key: "total", width: 10 },
      ];

      let articuloAnterior = null;

      this.articulosCompletos.forEach((articulo) => {
        const tallesFiltrados = articulo.talles.filter(
          (talle) =>
            talle.marron > 0 ||
            talle.negro > 0 ||
            talle.verde > 0 ||
            talle.azul > 0 ||
            talle.celeste > 0 ||
            talle.blancobeige > 0
        );

        if (!tallesFiltrados.length) return;

        if (articuloAnterior && articuloAnterior !== articulo.numero) {
          worksheet.addRow(["", "", "", "", "", "", "", "", ""]); // Espacio vacío
        }

        tallesFiltrados.forEach((talle) => {
          const row = worksheet.addRow({
            articulo: `${articulo.numero} - ${articulo.nombre}`,
            talle: talle.talle,
            marron: talle.marron,
            negro: talle.negro,
            verde: talle.verde,
            azul: talle.azul,
            celeste: talle.celeste,
            blancobeige: talle.blancobeige,
            total: this.getTotalBombachas(talle),
          });

          // Aplicar colores a las celdas
          if (talle.marron > 0)
            row.getCell("marron").font = {
              color: { argb: "8B4513" },
            };
          if (talle.negro > 0)
            row.getCell("negro").font = {
              color: { argb: "000000" },
            };
          if (talle.verde > 0)
            row.getCell("verde").font = {
              color: { argb: "228B22" },
            };
          if (talle.azul > 0)
            row.getCell("azul").font = {
              color: { argb: "0000FF" },
            };
          if (talle.celeste > 0)
            row.getCell("celeste").font = {
              color: { argb: "87CEEB" },
            }; // Asegurar celeste
          if (talle.blancobeige > 0)
            row.getCell("blancobeige").font = {
              color: { argb: "7A7A7A" },
            }; // Asegurar blanco/beige

          row.getCell("articulo").font = { bold: true, size: 14 };
        });

        articuloAnterior = articulo.numero;
      });

      workbook.xlsx.writeBuffer().then((buffer) => {
        const blob = new Blob([buffer], {
          type: "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet",
        });
        const link = document.createElement("a");
        link.href = URL.createObjectURL(blob);
        link.download = "listado_bombachas.xlsx";
        link.click();
      });

      console.log("Exportación completada con ExcelJS");
    },
    //dialogs para confirmar agregados y borrados
    openDeleteConfirm(talle) {
      this.talleAEliminar = talle;
      this.confirmDeleteDialog = true;
    },

    openDeleteFullConfirm(talle) {
      this.talleAEliminar = talle;
      this.confirmFullDeleteDialog = true;
    },
    openAddConfirm() {
      this.confirmAddDialog = true;
    },

    //dialog editar cantidad bombachas por talle
    openEditDialog(item) {
      this.currentTalle = { ...item }; // Copia los datos del talle actual
      this.editDialog = true;
    },
    //guardar editar cantidades bombachas por talle
    saveChanges() {
      axios
        .post(`/api/articulo/${this.selectedArticulo}/editar-bombachas`, {
          cantidades: {
            marron: this.currentTalle.marron,
            negro: this.currentTalle.negro,
            verde: this.currentTalle.verde,
            azul: this.currentTalle.azul,
            celeste: this.currentTalle.celeste,
            blancobeige: this.currentTalle.blancobeige,
          },
          talle: this.currentTalle.talle,
        })
        .then((response) => {
          console.log(response.data.message);
          this.editDialog = false;
          this.fetchTalles(); // Actualiza la tabla después de guardar los cambios
        })
        .catch((error) => {
          console.error(error);
        });
    },
    openDialog(action) {
      this.isAgregar = action === "agregar";
      this.dialog = true;
    },

    fetchArticulos() {
      fetch("/api/articulos/listar")
        .then((response) => response.json())
        .then((data) => {
          this.articulos = data;
          console.log(this.articulos);
        });
      fetch("/api/articulo/listar/talles")
        .then((response) => response.json())
        .then((data) => {
          this.articulosCompletos = data;
        });
    },
    onArticuloChange() {
      this.fetchTalles();
    },
    fetchTalles() {
      if (!this.selectedArticulo) {
        console.error("No hay artículo seleccionado para obtener los talles");
        return;
      }

      fetch(`/api/articulo/${this.selectedArticulo}`)
        .then((response) => response.json())
        .then((data) => {
          this.talles = data.talles;
          console.log(this.talles);
        });
    },
    getTotalBombachas(talle) {
      return (
        talle.marron +
        talle.negro +
        talle.verde +
        talle.azul +
        talle.celeste +
        talle.blancobeige
      );
    },
    addQuantities() {
      this.selectedTalles.forEach((talle) => {
        axios
          .post(
            `/api/articulo/${this.selectedArticuloDialog}/agregar-bombachas`,
            {
              cantidades: this.newQuantities,
              talle: talle, // Talle actual en la iteración
            }
          )
          .then((response) => {
            console.log(response.data.message);
            this.dialog = false;
            this.confirmAddDialog = false;
            this.fetchTalles(); // Actualiza la tabla
            this.resetQuantities();
          })
          .catch((error) => {
            console.error(error);
          });
      });
    },
    removeQuantities() {
      this.selectedTalles.forEach((talle) => {
        axios
          .post(
            `/api/articulo/${this.selectedArticuloDialog}/eliminar-bombachas`,
            {
              cantidades: this.newQuantities,
              talle: talle, // Talle actual en la iteración
            }
          )
          .then((response) => {
            console.log(response.data.message);
            this.dialog = false;
            this.confirmDeleteDialog = false;
            this.fetchTalles(); // Actualiza la tabla
            this.resetQuantities();
          })
          .catch((error) => {
            console.error(error);
          });
      });
    },

    resetQuantities() {
      this.newQuantities = {
        verde: 0,
        azul: 0,
        marron: 0,
        negro: 0,
        celeste: 0,
        blancobeige: 0,
      };
      this.selectedTalles = [];
      this.selectedArticuloDialog = null; // Reiniciar selección del artículo
    },

    deleteCompleteTalle() {
      axios
        .post(
          `/api/articulo/${this.selectedArticulo}/eliminar-talle-completo`,
          {
            talle: this.talleAEliminar,
          }
        )
        .then((response) => {
          console.log(response.data.message);
          this.confirmFullDeleteDialog = false;
          this.fetchTalles(); // Actualiza la tabla después de eliminar
        })
        .catch((error) => {
          console.error(error);
        });
    },
    getRangoTalles(nombre) {
      // Busca los números en el nombre del artículo
      const matches = nombre.match(/\d+/g);

      // Si encontramos dos números, los convertimos en el rango de talles
      if (matches && matches.length >= 2) {
        const minTalle = parseInt(matches[0], 10);
        const maxTalle = parseInt(matches[1], 10);
        return { minTalle, maxTalle };
      }

      // Si no hay números, devolvemos un rango predeterminado o vacío
      return { minTalle: null, maxTalle: null };
    },
    tallesCorrectos() {
      this.selectedTalles = [];
      this.tallesDisponiblesSeleccionados = this.tallesDisponibles;
      const articuloSeleccionado = this.articulos.find(
        (articulo) => articulo.id === this.selectedArticuloDialog
      );

      if (articuloSeleccionado) {
        const { minTalle, maxTalle } = this.getRangoTalles(
          articuloSeleccionado.nombre
        );

        if (minTalle != null && maxTalle != null) {
          // Si el artículo incluye "ALPARGATAS", generamos la lista completa de talles consecutivos
          if (articuloSeleccionado.nombre.toUpperCase().includes("ALPARGATA")) {
            this.tallesDisponiblesSeleccionados = [];
            for (let i = minTalle; i <= maxTalle; i++) {
              this.tallesDisponiblesSeleccionados.push({
                talle: i,
              });
            }
          } else {
            // Si no es "ALPARGATAS", sigue seleccionando los talles de dos en dos
            this.tallesDisponiblesSeleccionados = this.tallesDisponibles.filter(
              (talleObj) =>
                talleObj.talle >= minTalle &&
                talleObj.talle <= maxTalle &&
                talleObj.talle % 2 === 0
            );
          }
        }

        console.log(this.tallesDisponiblesSeleccionados); // Imprime para depuración
      }
    },
    exportAndUploadToDrive() {
      // if (someCondition) {
      //     // Alguna lógica aquí
      // }

      axios
        .get("/api/google/callback")
        .then((response) => {
          if (response.data.isAuthenticated) {
            // Si está autenticado, procede a subir el archivo
            return axios.get("/api/upload-to-drive");
          } else {
            // Si no está autenticado, redirige a Google
            window.location.href = "/api/auth/google";
          }
        })
        .then((response) => {
          console.log(response.data.message);
        })
        .catch((error) => {
          console.error(error);
        });
    },
  },
};
</script>

<style scoped>
@import url("https://fonts.googleapis.com/css2?family=Nunito:wght@300;400;600;700&display=swap");

.marron-text {
  color: #8b4513; /* Marrón */
  font-weight: bold;
}
.negro-text {
  color: #000000; /* Negro */
  font-weight: bold;
}
.verde-text {
  color: #228b22; /* Verde */
  font-weight: bold;
}
.azul-text {
  color: #0000ff; /* Azul */
  font-weight: bold;
}
.celeste-text {
  color: #87ceeb; /* Celeste */
  font-weight: bold;
}
.blanco-text {
  color: #7a7a7a; /* Blanco/Beige */
  font-weight: bold;
}

.rojo-text {
  color: #ff0000; /* Rojo */
  font-weight: bold;
}

/* Aplica la fuente moderna a todo */
* {
  font-family: "Nunito", sans-serif;
}

.v-btn {
  font-weight: 600;
  border-radius: 12px;
  transition: background-color 0.3s ease;
}

.v-btn:hover {
  background-color: #ececec;
}

.v-card {
  border-radius: 16px;
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.05);
}
</style>
