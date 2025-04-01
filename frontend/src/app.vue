<template>
    <v-app>
        <!-- Navegación lateral -->
        <v-navigation-drawer v-if="!esLogin" app>
            <v-list-item title="El Mensual"></v-list-item>
            <v-divider></v-divider>
            <v-list>
                <!-- Home -->
                <v-list-item
                    link
                    exact
                    exact-active-class="active-list-item"
                    to="/"
                >
                    <v-list-item-title>Inventario</v-list-item-title>
                </v-list-item>

                <!-- Home -->
                <v-list-item
                    link
                    exact
                    exact-active-class="active-list-item"
                    to="/clientes"
                >
                    <v-list-item-title>Clientes</v-list-item-title>
                </v-list-item>

                <!-- Calendario -->
                <v-list-item
                    link
                    exact-active-class="active-list-item"
                    to="/comprascalendario"
                >
                    <v-list-item-title>Calendario</v-list-item-title>
                </v-list-item>

                <!-- Articulos -->
                <v-list-item
                    link
                    exact-active-class="active-list-item"
                    to="/managearticulos"
                >
                    <v-list-item-title>Articulos</v-list-item-title>
                </v-list-item>

                <v-list-item
                    link
                    exact-active-class="active-list-item"
                    to="/localidades"
                >
                    <v-list-item-title>Localidades</v-list-item-title>
                </v-list-item>

                <!-- Ventas -->
                <v-list-item
                    link
                    exact-active-class="active-list-item"
                    to="/ventas"
                >
                    <v-list-item-title>Ventas</v-list-item-title>
                </v-list-item>

                <v-divider></v-divider>

                <v-list-item link @click="logout">
                    <v-list-item-title>Cerrar sesión</v-list-item-title>
                </v-list-item>
            </v-list>
        </v-navigation-drawer>

        <!-- Contenido principal -->
        <v-main style="background-color: #eeeeee">
            <v-container fluid>
                <router-view />
            </v-container>
        </v-main>
    </v-app>
</template>

<script>
export default {
    name: "MainLayout",
    computed: {
        esLogin() {
            return this.$route.path === "/login";
        },
    },
    methods: {
        logout() {
            axios.post("/logout").finally(() => {
                localStorage.removeItem("auth");
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
