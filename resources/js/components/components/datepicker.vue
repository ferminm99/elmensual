<template>
    <VueDatepicker v-model="date" :type="'date'" :format="'dd/MM/yyyy'" />
</template>

<script>
import Datepicker from "@vuepic/vue-datepicker";
import "@vuepic/vue-datepicker/dist/main.css";
import { format } from "date-fns";

export default {
    components: {
        VueDatepicker: Datepicker,
    },
    data() {
        return {
            date: null,
        };
    },
    methods: {
        formatDate(date) {
            return format(date, "dd/MM/yyyy");
        },
    },
};
</script>
