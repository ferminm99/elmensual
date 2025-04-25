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
    <!-- Overlay de carga -->
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
import FullCalendar from "@fullcalendar/vue3"; // Importa el componente de FullCalendar
import dayGridPlugin from "@fullcalendar/daygrid"; // Vista de calendario en cuadrícula
import interactionPlugin from "@fullcalendar/interaction"; // Permite la interacción (clic en días)
import Datepicker from "./components/datepicker.vue"; // Importar tu Datepicker personalizado
import moment from "moment";
import {
    cachedFetch,
    updateCache,
    removeFromCache,
    getMemoryCache,
    modifyInCache,
} from "@/utils/cacheFetch";
import { notifyCacheChange, onCacheChange } from "@/utils/cacheEvents";
import { useSyncedCache } from "@/utils/useSyncedCache";

export default {
    components: {
        FullCalendar,
        Datepicker,
    },
    data() {
        return {
            loading: false,
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
    mounted() {
        this.loading = true;

        useSyncedCache({
            key: "compras_calendario",
            apiPath: "/calendario/actualizados-desde",
            fetchFn: () =>
                axios.get("/api/comprascalendario/listar").then((r) => r.data),
            onData: () => this.fetchCompras(),
            setLoading: (val) => (this.loading = val),
        });
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
            this.loading = true;
            try {
                await axios.put(`/api/comprascalendario/${this.form.id}`, {
                    nombre_persona: this.form.nombre_persona,
                    descripcion: this.form.descripcion,
                    fecha: moment(this.form.fecha).format("YYYY-MM-DD"),
                    hora_inicio: this.form.hora_inicio,
                    hora_fin: this.form.hora_fin,
                });

                // Actualiza en cache
                modifyInCache("compras_calendario", (compras) => {
                    console.log("💾 compras antes de map:", compras);
                    return compras.map((c) =>
                        c.id === this.form.id
                            ? {
                                  ...c,
                                  nombre_persona: this.form.nombre_persona,
                                  descripcion: this.form.descripcion,
                                  fecha: this.form.fecha,
                                  hora_inicio: this.form.hora_inicio,
                                  hora_fin: this.form.hora_fin,
                              }
                            : c
                    );
                });

                const calendarApi = this.$refs.fullCalendar.getApi();
                const evento = calendarApi.getEventById(this.form.id);
                if (evento) {
                    evento.setProp(
                        "title",
                        `${this.form.nombre_persona} - ${this.form.descripcion} - de ${this.form.hora_inicio} a ${this.form.hora_fin}`
                    );
                    evento.setStart(this.form.fecha);
                    evento.setExtendedProp(
                        "descripcion",
                        this.form.descripcion
                    );
                    evento.setExtendedProp(
                        "hora_inicio",
                        this.form.hora_inicio
                    );
                    evento.setExtendedProp("hora_fin", this.form.hora_fin);
                }

                this.dialog = false;
                this.resetForm();
                this.fetchCompras();
            } catch (error) {
                console.error("Error al actualizar compra:", error);
            } finally {
                this.loading = false;
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
            this.loading = true;
            try {
                const response = await axios.post("/api/comprascalendario", {
                    nombre_persona: this.form.nombre_persona,
                    descripcion: this.form.descripcion,
                    fecha: moment(this.form.fecha).format("YYYY-MM-DD"),
                    hora_inicio: this.form.hora_inicio,
                    hora_fin: this.form.hora_fin,
                });

                const nuevoEvento = {
                    id: response.data.id,
                    title: `${this.form.nombre_persona} - ${
                        this.form.descripcion
                    } - de ${moment(this.form.hora_inicio, "HH:mm:ss").format(
                        "HH:mm"
                    )} a ${moment(this.form.hora_fin, "HH:mm:ss").format(
                        "HH:mm"
                    )}`,
                    start: this.form.fecha,
                    backgroundColor: moment(this.form.fecha).isBefore(
                        moment(),
                        "day"
                    )
                        ? "#5CB85C"
                        : "#007BFF",
                    borderColor: "black",
                    extendedProps: {
                        descripcion: this.form.descripcion,
                        hora_inicio: this.form.hora_inicio,
                        hora_fin: this.form.hora_fin,
                    },
                };

                updateCache("compras_calendario", (arr) => [
                    ...arr,
                    {
                        id: response.data.id,
                        ...nuevoEvento.extendedProps,
                        fecha: nuevoEvento.start,
                        nombre_persona: this.form.nombre_persona,
                    },
                ]);

                this.$refs.fullCalendar.getApi().addEvent(nuevoEvento);

                this.dialog = false;
                this.resetForm();
            } catch (error) {
                console.error("Error al agendar compra:", error);
            } finally {
                this.loading = false;
            }
        },

        async fetchCompras() {
            const ttl = 3600;
            try {
                let compras = getMemoryCache("compras_calendario", ttl);
                if (!compras) {
                    compras = await cachedFetch(
                        "compras_calendario",
                        () =>
                            axios
                                .get("/api/comprascalendario/listar")
                                .then((res) => res.data),
                        { ttl }
                    );
                }

                if (!Array.isArray(compras))
                    throw new Error("Datos inválidos en cache");

                const eventos = compras.map((compra) => ({
                    id: compra.id.toString(),
                    title: `${compra.nombre_persona} - ${
                        compra.descripcion
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
                        : "#007BFF",
                    borderColor: "black",
                    extendedProps: {
                        descripcion: compra.descripcion,
                        hora_inicio: compra.hora_inicio,
                        hora_fin: compra.hora_fin,
                        compraId: compra.id.toString(),
                    },
                }));

                // Reasignar handlers
                this.calendarOptions.eventClick = (info) => {
                    const event = info.event;
                    this.selectedCompraId = Number(event.id);

                    this.form = {
                        id: Number(event.id),
                        nombre_persona: event.title.split(" - ")[0],
                        descripcion: event.extendedProps.descripcion,
                        fecha: moment(event.start).format("YYYY-MM-DD"),
                        hora_inicio:
                            event.extendedProps.hora_inicio ||
                            moment(event.start).format("HH:mm"),
                        hora_fin:
                            event.extendedProps.hora_fin ||
                            moment(event.end).format("HH:mm"),
                    };

                    this.dialog = true;
                    this.isEditMode = true;
                };

                this.calendarOptions.eventContent = (arg) => {
                    const eliminarBtn = document.createElement("button");
                    eliminarBtn.innerHTML = "🗑";
                    eliminarBtn.style.marginLeft = "10px";
                    eliminarBtn.style.cursor = "pointer";

                    eliminarBtn.onclick = (event) => {
                        event.stopPropagation();
                        const id = arg.event.id;
                        if (!id) return console.warn("❌ Evento sin ID:", arg);
                        this.eliminarCompra(id);
                    };

                    const titleDiv = document.createElement("div");
                    titleDiv.innerText = arg.event.title;
                    titleDiv.style.display = "inline-block";

                    const contentDiv = document.createElement("div");
                    contentDiv.appendChild(titleDiv);
                    contentDiv.appendChild(eliminarBtn);

                    return { domNodes: [contentDiv] };
                };

                // Limpia y vuelve a cargar los eventos en el calendario usando la API de FullCalendar
                const calendarApi = this.$refs.fullCalendar.getApi();
                calendarApi.removeAllEvents();
                eventos.forEach((evento) => {
                    calendarApi.addEvent(evento);
                });
            } catch (error) {
                console.error("Error al cargar compras:", error);
            }
        },
        async eliminarCompra(compraId) {
            if (!compraId) return;

            if (confirm("¿Estás seguro de que deseas eliminar esta compra?")) {
                this.loading = true;
                try {
                    await axios.delete(`/api/comprascalendario/${compraId}`);

                    // Eliminar del cache
                    removeFromCache(
                        "compras_calendario",
                        (c) => Number(c.id) === Number(compraId)
                    );

                    // Eliminar visualmente del calendario
                    const calendarApi = this.$refs.fullCalendar.getApi();
                    const evento = calendarApi.getEventById(
                        compraId.toString()
                    );
                    if (evento) {
                        evento.remove();
                        console.log("EVENTO REMOVIDO DEL CALENDARIO");
                    } else {
                        console.warn("No se encontró el evento con ese ID");
                    }

                    this.dialog = false;
                    this.resetForm();
                } catch (error) {
                    console.error(
                        "Error al eliminar compra:",
                        error.response?.data || error
                    );
                } finally {
                    this.loading = false;
                }
            } else {
                console.log("ELIMINACIÓN CANCELADA");
            }
        },
        async fetchArticulos() {
            const ttl = 86400;
            try {
                const articulos = await cachedFetch(
                    "articulos_con_talles",
                    () =>
                        axios
                            .get("/api/articulo/listar/talles")
                            .then((res) => res.data),
                    { ttl }
                );
                this.articulos = articulos;
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
:deep(.v-overlay) {
    z-index: 9999 !important;
    position: fixed !important;
}

:deep(.v-overlay__scrim) {
    background-color: rgba(255, 255, 255, 0.5) !important;
    position: fixed !important;
    z-index: 9999 !important;
}

:deep(.v-overlay__content) {
    z-index: 10000 !important;
    position: fixed !important;
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
