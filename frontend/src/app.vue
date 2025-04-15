<template>
    <v-app>
        <!-- App bar con botón hamburguesa -->
        <v-app-bar app color="white" elevate-on-scroll v-if="!esLogin">
            <v-app-bar-nav-icon @click="drawer = !drawer" />
            <v-toolbar-title>El Mensual</v-toolbar-title>
        </v-app-bar>

        <!-- Drawer responsive -->
        <v-navigation-drawer
            v-model="drawer"
            app
            :temporary="isMobile"
            :permanent="!isMobile"
        >
            <v-list-item title="El Mensual" />
            <v-divider />
            <v-list>
                <v-list-item to="/" link exact-active-class="active-list-item">
                    <v-list-item-title>Inventario</v-list-item-title>
                </v-list-item>
                <v-list-item
                    to="/clientes"
                    link
                    exact-active-class="active-list-item"
                >
                    <v-list-item-title>Clientes</v-list-item-title>
                </v-list-item>
                <v-list-item
                    to="/comprascalendario"
                    link
                    exact-active-class="active-list-item"
                >
                    <v-list-item-title>Calendario</v-list-item-title>
                </v-list-item>
                <v-list-item
                    to="/managearticulos"
                    link
                    exact-active-class="active-list-item"
                >
                    <v-list-item-title>Artículos</v-list-item-title>
                </v-list-item>
                <v-list-item
                    to="/managepedidos"
                    link
                    exact-active-class="active-list-item"
                >
                    <v-list-item-title>Pedidos</v-list-item-title>
                </v-list-item>
                <v-list-item
                    to="/localidades"
                    link
                    exact-active-class="active-list-item"
                >
                    <v-list-item-title>Localidades</v-list-item-title>
                </v-list-item>
                <v-list-item
                    to="/ventas"
                    link
                    exact-active-class="active-list-item"
                >
                    <v-list-item-title>Ventas</v-list-item-title>
                </v-list-item>
                <v-divider />
                <v-list-item link @click="logout">
                    <v-list-item-title>Cerrar sesión</v-list-item-title>
                </v-list-item>
            </v-list>
        </v-navigation-drawer>

        <v-main style="background-color: #eeeeee">
            <v-container fluid>
                <router-view />
            </v-container>
        </v-main>
    </v-app>
</template>

<script>
export default {
    data() {
        return {
            drawer: true,
            isMobile: false,
        };
    },
    computed: {
        esLogin() {
            return this.$route.path === "/login";
        },
    },
    mounted() {
        this.isMobile = window.innerWidth < 768;
        window.addEventListener("resize", this.checkSize);
    },
    beforeUnmount() {
        window.removeEventListener("resize", this.checkSize);
    },
    methods: {
        checkSize() {
            this.isMobile = window.innerWidth < 768;
        },
        logout() {
            axios.post("/logout").finally(() => {
                localStorage.removeItem("auth_token");
                this.$router.push("/login");
            });
        },
    },
};
</script>

<!-- Estilos CSS para el ítem activo -->
<style scoped>
.active-list-item {
    background-color: #e0e0e0; /* Color de fondo cuando el ítem está seleccionado */
    font-weight: bold; /* Poner en negrita el texto */
}

.v-list-item--active {
    background-color: #e0e0e0 !important; /* Color de fondo del ítem activo */
    font-weight: bold !important; /* Negrita en el ítem activo */
}
</style>
