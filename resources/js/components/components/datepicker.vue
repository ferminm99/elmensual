<template>
    <v-col cols="12">
        <v-text-field
            v-model="formattedDate"
            prepend-icon="mdi-calendar"
            label="Seleccione una fecha"
            readonly
            @click="openDatePicker = true"
        ></v-text-field>

        <!-- Diálogo que contiene el v-date-picker -->
        <v-dialog
            v-model="openDatePicker"
            max-width="400px"
            persistent
            scrollable
        >
            <v-card>
                <v-card-text>
                    <v-date-picker
                        v-model="selectedDate"
                        @update:modelValue="handleDateChange"
                    ></v-date-picker>
                </v-card-text>
                <v-btn icon @click="openDatePicker = false" class="close-btn">
                    <v-icon color="grey">mdi-close</v-icon>
                </v-btn>
            </v-card>
        </v-dialog>
    </v-col>
</template>
<script>
import moment from "moment";

export default {
    props: {
        modelValue: {
            type: String,
            default: null, // Es importante que el formato de fecha esté correcto
        },
    },
    data() {
        return {
            openDatePicker: false,
            selectedDate: this.modelValue
                ? moment(this.modelValue).toDate() // Convertimos la fecha a local
                : moment().toDate(), // Si no hay fecha, tomamos la fecha actual
        };
    },
    computed: {
        formattedDate() {
            return this.selectedDate
                ? moment(this.selectedDate).format("DD-MM-YYYY")
                : "";
        },
    },
    watch: {
        modelValue(newValue) {
            if (newValue) {
                this.selectedDate = moment(newValue).toDate(); // Convertimos la fecha al formato local
            }
        },
    },
    methods: {
        handleDateChange(date) {
            this.openDatePicker = false;
            // Emitimos la fecha en formato "YYYY-MM-DD" para que el backend la entienda correctamente
            this.$emit("update:modelValue", moment(date).format("YYYY-MM-DD"));
        },
    },
    mounted() {
        if (this.modelValue) {
            this.selectedDate = moment(this.modelValue).toDate(); // Convertimos la fecha al formato correcto
        }
    },
};
</script>

<style scoped>
.v-card {
    max-height: 100%;
    overflow-y: hidden;
}
.close-btn {
    position: absolute;
    top: 10px;
    right: 10px;
}
:deep(.v-date-picker__title) {
    display: none !important;
}
</style>
