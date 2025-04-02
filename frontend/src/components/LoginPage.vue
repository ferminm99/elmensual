<template>
    <v-container
        class="d-flex justify-center align-center"
        style="height: 100vh"
    >
        <v-card class="pa-4" width="400">
            <v-card-title class="text-h6">Iniciar sesión</v-card-title>
            <v-card-text>
                <v-form @submit.prevent="login">
                    <v-text-field
                        label="Email"
                        v-model="email"
                        type="email"
                        required
                    />
                    <v-text-field
                        label="Contraseña"
                        v-model="password"
                        type="password"
                        required
                    />
                    <v-btn type="submit" color="primary" block>Entrar</v-btn>
                </v-form>
            </v-card-text>
        </v-card>
    </v-container>
</template>

<script>
import axios from "axios";

export default {
    name: "LoginPage",
    data() {
        return {
            email: "",
            password: "",
        };
    },
    methods: {
        async login() {
            try {
                // Paso 1: Disparar la petición para que Laravel genere la cookie XSRF-TOKEN
                await axios.get("/csrf-token", { withCredentials: true });

                // Paso 2: Leer la cookie XSRF-TOKEN
                const token = this.getCookie("XSRF-TOKEN");

                if (!token) {
                    alert("No se pudo obtener el token CSRF.");
                    return;
                }

                // Paso 3: Establecerlo en el header correcto
                axios.defaults.headers.common["X-XSRF-TOKEN"] =
                    decodeURIComponent(token);

                // Paso 4: Hacer el login
                const response = await axios.post(
                    "/login",
                    {
                        email: this.email,
                        password: this.password,
                    },
                    {
                        withCredentials: true,
                    }
                );

                if (response.data.success) {
                    localStorage.setItem("auth", true);
                    this.$router.push("/");
                } else {
                    alert("Credenciales incorrectas");
                }
            } catch (error) {
                console.error("Error al iniciar sesión", error);
                alert("Error al iniciar sesión");
            }
        },
        getCookie(name) {
            const match = document.cookie.match(
                new RegExp("(^| )" + name + "=([^;]+)")
            );
            return match ? match[2] : null;
        },
    },
};
</script>
