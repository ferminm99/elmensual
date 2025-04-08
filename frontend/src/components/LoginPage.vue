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
        // Supongamos que este es tu método login en el frontend:
        async login() {
            try {
                const response = await axios.post("/api/login", {
                    email: this.email,
                    password: this.password,
                });

                const token = response.data.token;

                if (token) {
                    // Guardamos el token en localStorage
                    localStorage.setItem("auth_token", token);
                    this.$router.push("/");
                } else {
                    alert("Error al obtener el token");
                }
            } catch (error) {
                console.error("Error al iniciar sesión", error);
                alert("Credenciales incorrectas o error de servidor");
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
