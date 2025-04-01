import { defineConfig } from "vite";
import laravel from "laravel-vite-plugin";
import vue from "@vitejs/plugin-vue";

export default defineConfig({
    base: "/",
    plugins: [vue()],
    build: {
        outDir: "dist",
        rollupOptions: {
            output: {
                manualChunks: {
                    vue: ["vue", "vue-router"],
                    vuetify: ["vuetify"],
                },
            },
        },
        chunkSizeWarningLimit: 1600,
    },
    // server: {
    //     watch: {
    //         usePolling: true, // Si estás trabajando en contenedores, esto puede ser necesario
    //     },
    //     host: "0.0.0.0", // Escuchar en todas las interfaces
    //     port: 5173, // Forzar el puerto 5173
    //     strictPort: true, // Asegurarse de que siempre use el puerto 5173
    //     hmr: {
    //         host: "localhost", // Hot Module Replacement (HMR) en localhost
    //     },
    // },
});
