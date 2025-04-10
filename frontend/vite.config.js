import { defineConfig } from "vite";
import vue from "@vitejs/plugin-vue";
import path from "node:path";

export default defineConfig({
    plugins: [vue()],
    resolve: {
        alias: {
            "@": path.resolve(__dirname, "src"), // 👈 apunta a tu carpeta "src"
        },
    },
    build: {
        outDir: "dist", // 👈 Vercel espera esto
        emptyOutDir: true,
        manifest: true,
        rollupOptions: {
            input: "index.html", // ⚠️ Usá el path real de tu app
        },
    },
    // server: {
    //   host: "localhost",
    //   port: 5173,
    //   proxy: {
    //     "/api": "http://localhost:8000",
    //   },
    // },
});
