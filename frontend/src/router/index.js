import { createRouter, createWebHistory } from "vue-router";
import home from "../components/HomePage.vue";
import login from "../components/LoginPage.vue"; // AÑADIR
import managearticulos from "../components/ManageArticulos.vue";
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

router.beforeEach((to, from, next) => {
    const isAuthenticated = localStorage.getItem("auth");
    if (to.meta.requiresAuth && !isAuthenticated) {
        next("/login");
    } else if (to.path === "/login" && isAuthenticated) {
        next("/");
    } else {
        next();
    }
});

export default router;
