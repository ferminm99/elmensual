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
        component: home,
    },
    {
        path: "/clientes",
        component: clientes,
    },
    {
        path: "/managearticulos",
        component: managearticulos,
    },
    {
        path: "/ventas",
        component: ventas,
    },
    {
        path: "/comprascalendario",
        component: calendario,
    },
    {
        path: "/:pathMatch(.*)*",
        component: notFound,
    },
];

const router = createRouter({
    history: createWebHistory(),
    linkExactActiveClass: "active",
    routes,
});

export default router;
