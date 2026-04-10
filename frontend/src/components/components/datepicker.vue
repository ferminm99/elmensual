<template>
    <v-col cols="12">
        <v-text-field
            v-model="inputDate"
            prepend-icon="mdi-calendar"
            :label="label"
            :placeholder="placeholder"
            type="date"
            :max="max"
            :min="min"
            @update:modelValue="handleInput"
        ></v-text-field>
    </v-col>
</template>

<script>
import moment from "moment";

export default {
    props: {
        modelValue: {
            type: [String, Date],
            default: null,
        },
        label: {
            type: String,
            default: "Seleccione una fecha",
        },
        placeholder: {
            type: String,
            default: "",
        },
        min: {
            type: String,
            default: null,
        },
        max: {
            type: String,
            default: null,
        },
    },
    data() {
        return {
            inputDate: this.normalizeDate(this.modelValue),
        };
    },
    watch: {
        modelValue(newValue) {
            this.inputDate = this.normalizeDate(newValue);
        },
    },
    methods: {
        normalizeDate(value) {
            if (!value) return null;

            if (value instanceof Date) {
                const parsed = moment(value);
                return parsed.isValid() ? parsed.format("YYYY-MM-DD") : null;
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

                if (parsed.isValid()) return parsed.format("YYYY-MM-DD");

                const fallback = moment(value);
                return fallback.isValid()
                    ? fallback.format("YYYY-MM-DD")
                    : null;
            }

            return null;
        },
        handleInput(value) {
            const normalized = this.normalizeDate(value);
            this.inputDate = normalized;
            this.$emit("update:modelValue", normalized);
        },
    },
};
</script>
