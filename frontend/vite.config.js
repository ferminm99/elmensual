import { defineConfig } from "vite";
import laravel from "laravel-vite-plugin";
import vue from "@vitejs/plugin-vue";

export default defineConfig({
    plugins: [
        laravel({
            input: ["resources/js/app.js"], // O el archivo principal que estés usando
            refresh: true,
        }),
        vue(),
    ],
    server: {
        host: "localhost",
        port: 5173,
        proxy: {
            "/api": process.env.APP_URL || "http://localhost:8000",
        },
    },
});
