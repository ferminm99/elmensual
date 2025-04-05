<template>
  <div>
    <!-- Calendario -->
    <v-card>
      <v-card-text>
        <FullCalendar ref="fullCalendar" :options="calendarOptions" />
      </v-card-text>
    </v-card>

    <!-- Diálogo para crear/editar una compra -->
    <v-dialog v-model="dialog" max-width="600px">
      <v-card>
        <v-card-title class="headline">
          {{ isEditMode ? "Editar Compra" : "Agendar Compra" }}
        </v-card-title>
        <v-card-text>
          <v-form ref="formCompra">
            <!-- Descripción -->
            <v-textarea
              v-model="form.descripcion"
              label="Descripción"
              placeholder="Escribe que productos compra"
              rows="3"
            ></v-textarea>

            <!-- Nombre de la persona -->
            <v-text-field
              v-model="form.nombre_persona"
              label="Nombre de la Persona"
              required
            ></v-text-field>

            <!-- Selección de fecha -->
            <Datepicker
              v-model="form.fecha"
              label="Fecha de la compra"
            ></Datepicker>

            <!-- Selección de hora de inicio y fin -->
            <v-text-field
              v-model="form.hora_inicio"
              label="Hora Inicio"
              type="time"
              required
            ></v-text-field>
            <v-text-field
              v-model="form.hora_fin"
              label="Hora Fin"
              type="time"
              required
            ></v-text-field>
          </v-form>
        </v-card-text>
        <v-card-actions>
          <v-spacer></v-spacer>

          <!-- Botón de eliminar solo visible en modo edición -->
          <v-btn v-if="isEditMode" color="red" text @click="eliminarCompra">
            Eliminar
          </v-btn>

          <v-btn text @click="dialog = false">Cancelar</v-btn>
          <v-btn
            color="green"
            text
            @click="isEditMode ? actualizarCompra() : agendarCompra()"
          >
            {{ isEditMode ? "Actualizar" : "Guardar" }}
          </v-btn>
        </v-card-actions>
      </v-card>
    </v-dialog>
  </div>
</template>

<script>
import FullCalendar from "@fullcalendar/vue3"; // Importa el componente de FullCalendar
import dayGridPlugin from "@fullcalendar/daygrid"; // Vista de calendario en cuadrícula
import interactionPlugin from "@fullcalendar/interaction"; // Permite la interacción (clic en días)
import Datepicker from "./components/datepicker.vue"; // Importar tu Datepicker personalizado
import moment from "moment";

export default {
  components: {
    FullCalendar,
    Datepicker,
  },
  data() {
    return {
      dialog: false,
      isEditMode: false,
      selectedCompraId: null, // Variable para almacenar el ID de la compra seleccionada
      form: {
        id: null, // Se añade un ID para poder actualizar
        nombre_persona: "",
        descripcion: "",
        fecha: "",
        hora_inicio: "",
        hora_fin: "",
      },
      articulos: [], // Lista de artículos cargados desde el backend
      tallesDisponibles: [], // Lista de talles disponibles
      coloresDisponibles: [], // Lista de colores disponibles
      articuloActual: null, // Artículo actualmente seleccionado
      calendarOptions: {
        plugins: [dayGridPlugin, interactionPlugin],
        initialView: "dayGridMonth",
        dateClick: this.handleDateClick,
        eventClick: this.handleEventClick, // Manejador para clic en eventos
        events: [], // Aquí se cargarán los eventos (compras))
        timeZone: "local",
        contentHeight: "auto",
      },
    };
  },
  methods: {
    resetForm() {
      this.form = {
        id: null,
        nombre_persona: "",
        descripcion: "",
        fecha: "",
        hora_inicio: "",
        hora_fin: "",
      };
    },
    async actualizarCompra() {
      try {
        await axios.put(`/api/comprascalendario/${this.form.id}`, {
          nombre_persona: this.form.nombre_persona,
          descripcion: this.form.descripcion,
          fecha: moment(this.form.fecha).format("YYYY-MM-DD"),
          hora_inicio: this.form.hora_inicio,
          hora_fin: this.form.hora_fin,
        });

        this.dialog = false;
        this.resetForm();
        this.fetchCompras(); // Recargar las compras actualizadas
      } catch (error) {
        console.error("Error al actualizar compra:", error);
      }
    },

    handleDateClick(arg) {
      // Resetear el formulario para nueva compra
      this.resetForm();
      this.form.fecha = moment(arg.date).local().format("YYYY-MM-DD");
      this.dialog = true;
      this.isEditMode = false; // Modo creación
    },
    handleEventClick(info) {
      const compraId = info.event.id;
      const compra = this.calendarOptions.events.find(
        (event) => parseInt(event.id) === parseInt(compraId)
      );

      if (compra) {
        this.form.id = compra.id;
        this.form.nombre_persona = info.event.title.split(" - ")[0]; // El nombre de la persona es la primera parte
        this.form.descripcion = info.event.extendedProps.descripcion; // Cargamos la descripción desde extendedProps
        this.form.fecha = moment(info.event.start).format("YYYY-MM-DD");

        // Aquí extraemos las horas desde extendedProps
        this.form.hora_inicio =
          info.event.extendedProps.hora_inicio ||
          moment(info.event.start).format("HH:mm");
        this.form.hora_fin =
          info.event.extendedProps.hora_fin ||
          moment(info.event.end).format("HH:mm");

        this.dialog = true;
        this.isEditMode = true;
      }
    },
    async agendarCompra() {
      try {
        const response = await axios.post("/api/comprascalendario", {
          nombre_persona: this.form.nombre_persona,
          descripcion: this.form.descripcion, // Solo la descripción
          fecha: moment(this.form.fecha).format("YYYY-MM-DD"),
          hora_inicio: this.form.hora_inicio,
          hora_fin: this.form.hora_fin,
        });

        // Actualiza el calendario con el nuevo evento
        const nuevoEvento = {
          id: response.data.id,
          title: `${this.form.nombre_persona} - ${
            this.form.descripcion
          } - de ${moment(this.form.hora_inicio, "HH:mm:ss").format(
            "HH:mm"
          )} a ${moment(this.form.hora_fin, "HH:mm:ss").format("HH:mm")}`,
          start: this.form.fecha,
          backgroundColor: moment(this.form.fecha).isBefore(moment(), "day")
            ? "#5CB85C"
            : "#007BFF", // Verde si la fecha ha pasado, azul si no
          borderColor: "black",
          extendedProps: {
            descripcion: this.form.descripcion,
            hora_inicio: this.form.hora_inicio,
            hora_fin: this.form.hora_fin,
          },
        };
        this.fetchCompras(); // Recargar las compras

        this.dialog = false;
      } catch (error) {
        console.error("Error al agendar compra:", error);
      }
    },
    // // Método para cargar los talles y colores disponibles
    // loadTallesYColores() {
    //     this.form.talleSeleccionado = null;
    //     this.form.colorSeleccionado = null;

    //     const articuloSeleccionado = this.articulos.find(
    //         (item) => item.id === this.form.articulo_id
    //     );

    //     this.tallesDisponibles = articuloSeleccionado.talles;
    //     console.log(this.tallesDisponibles);
    // },

    // // Método para cargar los colores según el talle seleccionado
    // onTalleChange(talleSeleccionado) {
    //     const articuloSeleccionado = this.articulos.find(
    //         (item) => item.id === this.form.articulo_id
    //     );

    //     if (articuloSeleccionado) {
    //         const talleObj = this.tallesDisponibles.find(
    //             (talle) =>
    //                 parseInt(talle.talle) === parseInt(talleSeleccionado)
    //         );

    //         if (talleObj) {
    //             this.form.colorSeleccionado = null; // Reiniciar el color antes de cargar los nuevos

    //             // Cargar los colores disponibles basados en el stock del talle
    //             this.coloresDisponibles = Object.keys(talleObj)
    //                 .filter(
    //                     (color) =>
    //                         !["id", "articulo_id", "talle"].includes(color)
    //                 )
    //                 .map((color) => {
    //                     const stock = talleObj[color];
    //                     return {
    //                         title: color,
    //                         value: color,
    //                         props: {
    //                             disabled: parseInt(stock) === 0, // Deshabilitar si el stock es 0
    //                         },
    //                     };
    //                 });
    //         }
    //     }
    // },
    async fetchCompras() {
      try {
        const response = await axios.get("/api/comprascalendario/listar");

        this.calendarOptions.events = response.data.map((compra) => {
          return {
            id: compra.id,
            title: `${compra.nombre_persona} - ${
              compra.descripcion
            } - de ${moment(compra.hora_inicio, "HH:mm:ss").format(
              "HH:mm"
            )} a ${moment(compra.hora_fin, "HH:mm:ss").format("HH:mm")}`,
            start: compra.fecha,
            backgroundColor: moment(compra.fecha).isBefore(moment(), "day")
              ? "#5CB85C"
              : "#007BFF", // Verde si la fecha ha pasado, azul si no
            borderColor: "black",
            extendedProps: {
              descripcion: compra.descripcion,
              hora_inicio: compra.hora_inicio,
              hora_fin: compra.hora_fin,
              compraId: compra.id, // Aseguramos que compraId esté presente
            },
          };
        });

        // Manejamos el click para editar
        this.calendarOptions.eventClick = (info) => {
          const compraId = info.event.id;
          this.selectedCompraId = compraId;

          // Cargar datos del evento para edición
          const compra = this.calendarOptions.events.find(
            (event) => parseInt(event.id) === parseInt(compraId)
          );

          if (compra) {
            // Abres el diálogo de edición con los datos
            this.form.id = compra.id;
            this.form.nombre_persona = compra.title.split(" - ")[0];
            this.form.descripcion = compra.extendedProps.descripcion;
            this.form.fecha = moment(compra.start).format("YYYY-MM-DD");
            this.form.hora_inicio = compra.extendedProps.hora_inicio;
            this.form.hora_fin = compra.extendedProps.hora_fin;
            this.dialog = true;
            this.isEditMode = true;
          }
        };
        // Configurar el renderizado del contenido del evento
        this.calendarOptions.eventContent = (arg) => {
          const eliminarBtn = document.createElement("button");
          eliminarBtn.innerHTML = "🗑"; // Icono de tacho
          eliminarBtn.style.marginLeft = "10px";
          eliminarBtn.style.cursor = "pointer";

          const compraId = arg.event.id;

          eliminarBtn.onclick = (event) => {
            event.stopPropagation(); // Evitamos que el click cierre el evento y active la edición
            this.eliminarCompra(this.selectedCompraId); // Ejecutar la eliminación usando la variable global
          };

          const titleDiv = document.createElement("div");
          titleDiv.innerText = arg.event.title;
          titleDiv.style.display = "inline-block";

          const contentDiv = document.createElement("div");
          contentDiv.appendChild(titleDiv);
          contentDiv.appendChild(eliminarBtn);

          return { domNodes: [contentDiv] };
        };
      } catch (error) {
        console.error("Error al cargar las compras:", error);
      }
    },

    eliminarCompra() {
      //compraId = parseInt(compraId);
      console.log(this.selectedCompraId);
      if (confirm("¿Estás seguro de que deseas eliminar esta compra?")) {
        try {
          axios.delete(`/api/comprascalendario/${this.selectedCompraId}`);
          this.dialog = false;
          this.resetForm();
          this.fetchCompras(); // Recargar las compras
        } catch (error) {
          console.error("Error al eliminar compra:", error);
        }
      }
    },
    async fetchArticulos() {
      try {
        const response = await axios.get("/api/articulo/listar/talles");
        this.articulos = response.data;
      } catch (error) {
        console.error("Error al cargar los artículos:", error);
      }
    },
  },
  mounted() {
    this.fetchArticulos(); // Cargar los artículos disponibles
    this.fetchCompras(); // Cargar las compras al montar el componente
  },
};
</script>

<style scoped>
.v-dialog {
  max-height: 800px;
}
:deep(.fc-daygrid-event) {
  display: block;
  padding: 5px;
  white-space: normal;
  word-wrap: break-word;
  max-width: 100%;
  overflow: visible;
  height: auto; /* Asegura que el evento solo ocupe el espacio necesario */
  line-height: 1.2; /* Ajusta la altura de la línea para que el texto no ocupe demasiado espacio */
  align-items: center; /* Asegura que el contenido se centre verticalmente */
}

:deep(.fc-daygrid-event .fc-event-title) {
  white-space: normal;
  overflow: hidden;
  text-overflow: ellipsis;
  word-break: break-word;
  font-size: 12px;
  line-height: 1.2; /* Ajustar el espaciado entre líneas */
}

:deep(.fc-daygrid) {
  min-height: auto !important; /* Asegura que las celdas no se expandan innecesariamente */
}
</style>
