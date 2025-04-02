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
                // 1. Obtener cookie CSRF (esto genera la cookie `XSRF-TOKEN`)
                await axios.get("/csrf-token");

                // 2. Obtener la cookie manualmente (si estás en frontend puro)
                const token = this.getCookie("XSRF-TOKEN");

                // 3. Enviar login con header X-XSRF-TOKEN
                const response = await axios.post(
                    "https://elmensual-production.up.railway.app/login",
                    {
                        email: this.email,
                        password: this.password,
                    },
                    {
                        withCredentials: true,
                        headers: {
                            "X-XSRF-TOKEN": decodeURIComponent(token),
                        },
                    }
                );

                if (response.status === 204 || response.data.success) {
                    localStorage.setItem("auth", true);
                    this.$router.push("/");
                } else {
                    alert("Credenciales incorrectas");
                }
            } catch (error) {
                console.error(error);
                alert("Error al iniciar sesión");
            }
        },
        getCookie(name) {
            const match = document.cookie.match(
                new RegExp("(^| )" + name + "=([^;]+)")
            );
            if (match) return match[2];
        },
    },
};
</script>
