<template>
    <v-app>
        <!-- Navegación lateral -->
        <v-navigation-drawer app>
            <v-list-item
                title="My Application"
                subtitle="Vuetify"
            ></v-list-item>
            <v-divider></v-divider>
            <v-list>
                <v-list-item
                    link
                    title="Home"
                    @click="$router.push('/')"
                ></v-list-item>
                <v-list-item
                    link
                    title="Articulos"
                    @click="$router.push('/managearticulos')"
                ></v-list-item>
                <v-list-item
                    link
                    title="Ventas"
                    @click="$router.push('/ventas')"
                ></v-list-item>
            </v-list>
        </v-navigation-drawer>

        <!-- Contenido principal -->
        <v-main>
            <v-container>
                <router-view />
            </v-container>
        </v-main>
    </v-app>
</template>

<script>
export default {
    name: "MainLayout",
};
</script>

<style scoped>
.v-application {
    overflow: hidden;
}
</style>
