import { defineConfig } from "vite";
import vue from "@vitejs/plugin-vue";

export default defineConfig({
    plugins: [vue()],
    base: "/build/", // ⚠️ Esto es CLAVE
    build: {
        outDir: "../backend/public/build", // 👈 apunta al public del backend
        emptyOutDir: true,
        manifest: true,
        rollupOptions: {
            input: "resources/js/app.js", // o tu archivo de entrada real
        },
    },
    // server: {
    //     host: "localhost",
    //     port: 5173,
    //     proxy: {
    //         "/api": process.env.APP_URL || "http://localhost:8000",
    //     },
    // },
});
