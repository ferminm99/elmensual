import { defineConfig } from "vite";
import vue from "@vitejs/plugin-vue";

export default defineConfig({
    plugins: [vue()],
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
