<template>
    <div>
        <!-- Calendario -->
        <FullCalendar :options="calendarOptions" />

        <!-- Diálogo para crear/editar una compra -->
        <v-dialog v-model="dialog" max-width="600px">
            <v-card>
                <v-card-title class="headline">
                    {{ isEditMode ? "Editar Compra" : "Agendar Compra" }}
                </v-card-title>
                <v-card-text>
                    <v-form ref="formCompra">
                        <!-- Selección de artículo -->
                        <v-select
                            v-model="form.articulo_id"
                            :items="articulos"
                            :item-title="(item) => `${item.nombre}`"
                            item-value="id"
                            label="Selecciona un artículo"
                            @update:modelValue="loadTallesYColores"
                            required
                        ></v-select>

                        <!-- Selección de talle -->
                        <v-select
                            v-model="form.talleSeleccionado"
                            :items="tallesDisponibles"
                            item-title="talle"
                            item-value="talle"
                            label="Selecciona un talle"
                            @update:modelValue="onTalleChange"
                            required
                        ></v-select>

                        <!-- Selección de color -->
                        <v-select
                            v-model="form.colorSeleccionado"
                            :items="coloresDisponibles"
                            item-title="title"
                            item-value="value"
                            label="Selecciona un color"
                            clearable
                            required
                        ></v-select>

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
                    <v-btn
                        v-if="isEditMode"
                        color="red"
                        text
                        @click="eliminarCompra"
                    >
                        Eliminar
                    </v-btn>

                    <v-btn text @click="dialog = false">Cancelar</v-btn>
                    <v-btn
                        color="green"
                        text
                        @click="
                            isEditMode ? actualizarCompra() : agendarCompra()
                        "
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
                articulo_id: null,
                talleSeleccionado: null,
                colorSeleccionado: null,
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
                articulo_id: null,
                talleSeleccionado: null,
                colorSeleccionado: null,
                fecha: "",
                hora_inicio: "",
                hora_fin: "",
            };
        },
        async actualizarCompra() {
            try {
                await axios.put(`/comprascalendario/${this.form.id}`, {
                    nombre_persona: this.form.nombre_persona,
                    articulo_id: this.form.articulo_id,
                    talle: this.form.talleSeleccionado,
                    color: this.form.colorSeleccionado,
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
            console.log("FECHAS!");
            console.log(arg);
            console.log(moment(arg.date).local().format("YYYY-MM-DD"));
            this.form.fecha = moment(arg.date).local().format("YYYY-MM-DD");
            console.log(this.form.fecha);
            this.dialog = true;
            this.isEditMode = false; // Modo creación
        },
        handleEventClick(info) {
            const compraId = info.event.id;
            const compra = this.calendarOptions.events.find(
                (event) => parseInt(event.id) === parseInt(compraId)
            );

            const titleParts = info.event.title.split(" - ");
            const nombrePersona = titleParts[0];
            const articuloNombre = titleParts[1];
            const talle = titleParts[2].split(" ")[1]; // Ej: "Talle 38" -> 38
            const color = titleParts[3];

            const articulo = this.articulos.find(
                (item) => item.nombre === articuloNombre
            );

            if (articulo) {
                this.form.id = info.event.id;
                this.form.nombre_persona = nombrePersona;
                this.form.articulo_id = articulo.id;
                this.form.talleSeleccionado = talle;
                this.form.colorSeleccionado = color;
                this.form.fecha = moment(info.event.start).format("YYYY-MM-DD");
                console.log(info);
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
            const response = await axios.post("/comprascalendario", {
                nombre_persona: this.form.nombre_persona,
                articulo_id: this.form.articulo_id,
                talle: this.form.talleSeleccionado,
                color: this.form.colorSeleccionado,
                fecha: moment(this.form.fecha).format("YYYY-MM-DD"),
                hora_inicio: this.form.hora_inicio,
                hora_fin: this.form.hora_fin,
            });

            // Actualiza el calendario con el nuevo evento
            const articulo = this.articulos.find(
                (item) => parseInt(item.id) === parseInt(this.form.articulo_id)
            );

            const nuevoEvento = {
                id: response.data.id,
                title: `${this.form.nombre_persona} - ${
                    articulo.nombre
                } - Talle ${this.form.talleSeleccionado} - ${
                    this.form.colorSeleccionado
                } - de ${moment(this.form.hora_inicio, "HH:mm:ss").format(
                    "HH:mm"
                )} a ${moment(this.form.hora_fin, "HH:mm:ss").format("HH:mm")}`,
                start: this.form.fecha,
                backgroundColor: moment(this.form.fecha).isBefore(
                    moment(),
                    "day"
                )
                    ? "#5CB85C"
                    : "#007BFF", // Verde si la fecha ha pasado, azul si no
                borderColor: "black",
                extendedProps: {
                    articulo_id: this.form.articulo_id,
                    talle: this.form.talleSeleccionado,
                    color: this.form.colorSeleccionado,
                    hora_inicio: this.form.hora_inicio,
                    hora_fin: this.form.hora_fin,
                },
            };
            this.calendarOptions.events.push(nuevoEvento);
            this.dialog = false;
        },
        // Método para cargar los talles y colores disponibles
        loadTallesYColores() {
            this.form.talleSeleccionado = null;
            this.form.colorSeleccionado = null;

            const articuloSeleccionado = this.articulos.find(
                (item) => item.id === this.form.articulo_id
            );

            this.tallesDisponibles = articuloSeleccionado.talles;
            console.log(this.tallesDisponibles);
        },

        // Método para cargar los colores según el talle seleccionado
        onTalleChange(talleSeleccionado) {
            const articuloSeleccionado = this.articulos.find(
                (item) => item.id === this.form.articulo_id
            );

            if (articuloSeleccionado) {
                const talleObj = this.tallesDisponibles.find(
                    (talle) =>
                        parseInt(talle.talle) === parseInt(talleSeleccionado)
                );

                if (talleObj) {
                    this.form.colorSeleccionado = null; // Reiniciar el color antes de cargar los nuevos

                    // Cargar los colores disponibles basados en el stock del talle
                    this.coloresDisponibles = Object.keys(talleObj)
                        .filter(
                            (color) =>
                                !["id", "articulo_id", "talle"].includes(color)
                        )
                        .map((color) => {
                            const stock = talleObj[color];
                            return {
                                title: color,
                                value: color,
                                props: {
                                    disabled: parseInt(stock) === 0, // Deshabilitar si el stock es 0
                                },
                            };
                        });
                }
            }
        },
        async fetchCompras() {
            try {
                const response = await axios.get("/comprascalendario/listar");

                this.calendarOptions.events = response.data.map((compra) => {
                    const articulo = this.articulos.find(
                        (item) =>
                            parseInt(item.id) === parseInt(compra.articulo_id)
                    );

                    return {
                        id: compra.id,
                        title: `${compra.nombre_persona} - ${
                            articulo.nombre
                        } - Talle ${compra.talle} - ${
                            compra.color
                        } - de ${moment(compra.hora_inicio, "HH:mm:ss").format(
                            "HH:mm"
                        )} a ${moment(compra.hora_fin, "HH:mm:ss").format(
                            "HH:mm"
                        )}`,
                        start: compra.fecha,
                        backgroundColor: moment(compra.fecha).isBefore(
                            moment(),
                            "day"
                        )
                            ? "#5CB85C"
                            : "#007BFF", // Verde si la fecha ha pasado, azul si no
                        borderColor: "black",
                        extendedProps: {
                            articulo_id: compra.articulo_id,
                            talle: compra.talle,
                            color: compra.color,
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
                        this.form.articulo_id =
                            compra.extendedProps.articulo_id;
                        this.form.talleSeleccionado =
                            compra.extendedProps.talle;
                        this.form.colorSeleccionado =
                            compra.extendedProps.color;
                        this.form.fecha = moment(compra.start).format(
                            "YYYY-MM-DD"
                        );
                        this.form.hora_inicio =
                            compra.extendedProps.hora_inicio;
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
                    axios.delete(`/comprascalendario/${this.selectedCompraId}`);
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
                const response = await axios.get("/articulo/listar/talles");
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
::v-deep .fc-daygrid-event {
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

::v-deep .fc-daygrid-event .fc-event-title {
    white-space: normal;
    overflow: hidden;
    text-overflow: ellipsis;
    word-break: break-word;
    font-size: 12px;
    line-height: 1.2; /* Ajustar el espaciado entre líneas */
}

::v-deep .fc-daygrid {
    min-height: auto !important; /* Asegura que las celdas no se expandan innecesariamente */
}
</style>
