<template>
    <v-col cols="12">
        <v-text-field
            v-model="formattedDate"
            prepend-icon="mdi-calendar"
            :label="label"
            :placeholder="placeholder"
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
            type: [String, Date],
            default: null, // Es importante que el formato de fecha esté correcto
        },
        label: {
            type: String,
            default: "Seleccione una fecha",
        },
        placeholder: {
            type: String,
            default: "",
        },
    },
    data() {
        return {
            openDatePicker: false,
            selectedDate: this.normalizeDate(this.modelValue), // Siempre string YYYY-MM-DD
        };
    },
    computed: {
        formattedDate() {
            const fecha = moment(this.selectedDate, "YYYY-MM-DD", true);
            return fecha.isValid() ? fecha.format("DD-MM-YYYY") : "";
        },
    },
    watch: {
        modelValue(newValue) {
            this.selectedDate = this.normalizeDate(newValue);
        },
    },
    methods: {
        normalizeDate(value) {
            if (!value) {
                return null;
            }
            if (value instanceof Date) {
                const parsedDate = moment(value);
                return parsedDate.isValid()
                    ? parsedDate.format("YYYY-MM-DD")
                    : null;
            }

            if (typeof value === "string") {
                const parsed = moment(
                    value,
                    [
                        "YYYY-MM-DD",
                        "YYYY-MM-DDTHH:mm:ss.SSSZ",
                        "YYYY-MM-DDTHH:mm:ssZ",
                        "YYYY-MM-DDTHH:mm:ss",
                        "DD-MM-YYYY",
                    ],
                    true,
                );

                if (parsed.isValid()) {
                    return parsed.format("YYYY-MM-DD");
                }

                const fallback = moment(value);
                return fallback.isValid()
                    ? fallback.format("YYYY-MM-DD")
                    : null;
            }

            return null;
        },
        handleDateChange(date) {
            this.openDatePicker = false;
            const normalized = this.normalizeDate(date);
            this.selectedDate = normalized;
            this.$emit("update:modelValue", normalized);
        },
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
