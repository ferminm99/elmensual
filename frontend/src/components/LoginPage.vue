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
            axios.defaults.withCredentials = true;
            try {
                const csrfResponse = await axios.get("/csrf-token", {
                    withCredentials: true,
                });
                const token = csrfResponse.data.token; // Usá el token del JSON directamente
                console.log("📦 TOKEN CSRF:", token);

                if (!token) {
                    alert("No se pudo obtener el token CSRF.");
                    return;
                }

                axios.defaults.headers.common["X-XSRF-TOKEN"] = token;

                console.log(document.cookie);
                // Axios se encargará de leer la cookie y enviarla
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

                if (error.response) {
                    console.error("💥 Backend dijo:", error.response.data);
                    alert(
                        "Error del servidor: " +
                            JSON.stringify(error.response.data)
                    );
                } else {
                    alert("Error al iniciar sesión");
                }
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
