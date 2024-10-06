import { defineConfig } from "vite";
import laravel from "laravel-vite-plugin";
import vue from "@vitejs/plugin-vue";

export default defineConfig({
    plugins: [
        laravel({
            input: ["resources/css/app.css", "resources/js/app.js"],
            refresh: true,
        }),
        vue(),
    ],
    build: {
        rollupOptions: {
            output: {
                manualChunks: {
                    vue: ["vue", "vue-router"], // Separar Vue y Vue Router en su propio chunk
                    vuetify: ["vuetify"], // Separar Vuetify en su propio chunk
                },
            },
        },
        chunkSizeWarningLimit: 1000,
    },
});
