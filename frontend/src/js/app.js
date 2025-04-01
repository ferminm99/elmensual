import "./bootstrap";
import { createApp } from "vue";
import App from "../app.vue";
import router from "../router";

// Import Vuetify
import { createVuetify } from "vuetify";
import "vuetify/styles"; // Importar los estilos globales de Vuetify
import * as components from "vuetify/components";
import * as directives from "vuetify/directives";
import { aliases, mdi } from "vuetify/iconsets/mdi"; // Para los iconos (opcional)
import "@mdi/font/css/materialdesignicons.css";
import axios from "axios";
import { es } from "vuetify/locale";
// Esto establece el token CSRF de Laravel de forma global en Axios
axios.defaults.headers.common["X-CSRF-TOKEN"] = document.querySelector(
    'meta[name="csrf-token"]'
)?.content;

axios.defaults.withCredentials = true;
axios.defaults.baseURL = "http://localhost:8000"; // Si lo deseás

// Crear la instancia de Vuetify
const vuetify = createVuetify({
    components,
    directives,
    icons: {
        defaultSet: "mdi", // Usa los iconos de Material Design
        aliases,
        sets: { mdi },
    },
    locale: {
        locale: "es", // Establece español como idioma predeterminado
        messages: { es }, // Define los mensajes en español
    },
});

// Crear la aplicación Vue
createApp(App)
    .use(router)
    .use(vuetify) // Usar Vuetify en la aplicación
    .mount("#app");
