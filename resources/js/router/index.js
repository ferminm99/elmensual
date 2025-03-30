import { createRouter, createWebHistory } from "vue-router";
import home from "../components/HomePage.vue";
import managearticulos from "../components/ManageArticulos.vue";
import clientes from "../components/Clientes.vue";
import ventas from "../components/Ventas.vue";
import notFound from "../components/NotFoundPage.vue";
import calendario from "../components/Calendario.vue";

const routes = [
    {
        path: "/",
        component: () => import("../components/HomePage.vue"),
    },
    {
        path: "/clientes",
        component: () => import("../components/Clientes.vue"),
    },
    {
        path: "/managearticulos",
        component: () => import("../components/ManageArticulos.vue"),
    },
    {
        path: "/ventas",
        component: () => import("../components/Ventas.vue"),
    },
    {
        path: "/comprascalendario",
        component: () => import("../components/Calendario.vue"),
    },
    {
        path: "/localidades",
        component: () => import("../components/ManageLocalidades.vue"),
    },
    {
        path: "/:pathMatch(.*)*",
        component: () => import("../components/NotFoundPage.vue"),
    },
];

const router = createRouter({
    history: createWebHistory(),
    linkExactActiveClass: "active",
    routes,
});

export default router;
