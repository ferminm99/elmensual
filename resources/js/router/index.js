import { createRouter, createWebHistory } from "vue-router";
import home from "../components/HomePage.vue";
import managearticulos from "../components/ManageArticulos.vue";
import ventas from "../components/Ventas.vue";
import notFound from "../components/NotFoundPage.vue";

const routes = [
    {
        path: "/",
        component: home,
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
