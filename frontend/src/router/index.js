import { createRouter, createWebHistory } from "vue-router";
import home from "../components/HomePage.vue";
import login from "../components/LoginPage.vue"; // AÑADIR
import managearticulos from "../components/ManageArticulos.vue";
import managepedidos from "../components/ManagePedidos.vue";
import clientes from "../components/Clientes.vue";
import ventas from "../components/Ventas.vue";
import calendario from "../components/Calendario.vue";
import localidades from "../components/ManageLocalidades.vue";
import notFound from "../components/NotFoundPage.vue";

const routes = [
    { path: "/login", component: login },
    { path: "/", component: home, meta: { requiresAuth: true } },
    { path: "/clientes", component: clientes, meta: { requiresAuth: true } },
    {
        path: "/managearticulos",
        component: managearticulos,
        meta: { requiresAuth: true },
    },
    {
        path: "/managepedidos",
        component: managepedidos,
        meta: { requiresAuth: true },
    },
    { path: "/ventas", component: ventas, meta: { requiresAuth: true } },
    {
        path: "/comprascalendario",
        component: calendario,
        meta: { requiresAuth: true },
    },
    {
        path: "/localidades",
        component: localidades,
        meta: { requiresAuth: true },
    },
    { path: "/:pathMatch(.*)*", component: notFound },
];

const router = createRouter({
    history: createWebHistory(),
    linkExactActiveClass: "active",
    routes,
});

router.beforeEach(async (to, from, next) => {
    const token = localStorage.getItem("auth_token");
    console.log("➡️ Navegando a:", to.path, "con token:", token);

    if (to.meta.requiresAuth) {
        if (!token) {
            console.log("❌ No token, redirigiendo a login");
            return next("/login");
        }

        try {
            const res = await axios.get("/api/check-auth");
            if (!res.data.user) {
                console.log("❌ Usuario no válido, redirigiendo a login");
                localStorage.removeItem("auth_token");
                return next("/login");
            }
        } catch (err) {
            console.warn("⚠️ Error en check-auth", err);
            localStorage.removeItem("auth_token");
            return next("/login");
        }
    }

    if (to.path === "/login" && token) {
        return next("/");
    }

    next();
});

export default router;
