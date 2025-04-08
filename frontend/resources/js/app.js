import "./bootstrap";
import { createApp } from "vue";
import App from "../../src/app.vue";
import router from "../../src/router";

// Import Vuetify
import { createVuetify } from "vuetify";
import "vuetify/styles"; // Importar los estilos globales de Vuetify
import * as components from "vuetify/components";
import * as directives from "vuetify/directives";
import { aliases, mdi } from "vuetify/iconsets/mdi"; // Para los iconos (opcional)
import "@mdi/font/css/materialdesignicons.css";

import axios from "axios";
import { es } from "vuetify/locale";

// Configuración base de Axios
axios.defaults.baseURL = import.meta.env.VITE_APP_URL;
axios.defaults.withCredentials = true;
axios.defaults.headers.common["X-Requested-With"] = "XMLHttpRequest";

// 👉 Recuperar token guardado para que Axios lo use en cada request
const token = localStorage.getItem("auth_token");
if (token) {
    axios.defaults.headers.common["Authorization"] = `Bearer ${token}`;
}

// 👉 Interceptor para agregar automáticamente el token Bearer
axios.interceptors.response.use(
    (response) => response,
    (error) => {
        if (error.response && error.response.status === 401) {
            localStorage.removeItem("auth_token");
            delete axios.defaults.headers.common["Authorization"];
            router.push("/login");
        }
        return Promise.reject(error);
    }
);

// Crear la instancia de Vuetify
const vuetify = createVuetify({
    components,
    directives,
    icons: {
        defaultSet: "mdi",
        aliases,
        sets: { mdi },
    },
    locale: {
        locale: "es",
        messages: { es },
    },
});

// Crear la aplicación Vue
createApp(App).use(router).use(vuetify).mount("#app");
