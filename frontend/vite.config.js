import { defineConfig } from "vite";
import vue from "@vitejs/plugin-vue";

export default defineConfig({
    plugins: [vue()],
    build: {
        outDir: "dist", // Donde Vercel espera los archivos generados
    },
    // server: {
    //     host: "localhost",
    //     port: 5173,
    //     proxy: {
    //         "/api": process.env.APP_URL || "http://localhost:8000",
    //     },
    // },
});
