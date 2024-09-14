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
            type: Date,
            default: null,
        },
    },
    data() {
        return {
            openDatePicker: false,
            selectedDate: this.modelValue
                ? new Date(this.modelValue)
                : new Date(),
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
        // Escuchar cambios en el modelValue
        modelValue(newValue) {
            console.log("Nuevo valor de modelValue:", newValue);
            if (newValue) {
                this.selectedDate = new Date(newValue);
            }
        },
    },
    methods: {
        handleDateChange(date) {
            this.openDatePicker = false;
            this.$emit("update:modelValue", date); // Emitir el cambio
        },
    },
    mounted() {
        console.log("Valor inicial en mounted:", this.modelValue);
        if (this.modelValue) {
            this.selectedDate = new Date(this.modelValue);
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
::v-deep .v-date-picker__title {
    display: none !important;
}
</style>
