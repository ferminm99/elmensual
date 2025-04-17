<template>
    <div>
        <!-- Escritorio -->
        <v-data-table
            v-if="!isMobile"
            :headers="headers"
            :items="items"
            :search="search"
            class="elevation-1 mt-2"
            dense
        >
            <template v-for="(_, slotName) in $slots" #[slotName]="slotProps">
                <slot :name="slotName" v-bind="slotProps" />
            </template>
        </v-data-table>

        <!-- Mobile -->
        <div v-else v-if="filteredItems.length">
            <!-- <transition-group name="fade" tag="div"> -->
            <v-card
                v-for="item in filteredItems"
                :key="item.id"
                class="mb-3 pa-3"
                elevation="2"
            >
                <v-card-text>
                    <div
                        v-for="(header, index) in headers"
                        :key="header?.key || index"
                        class="mb-2"
                    >
                        <template v-if="header.key !== 'actions'">
                            <div
                                class="label font-weight-medium grey--text text--darken-1"
                            >
                                {{ header.title }}
                            </div>
                            <div class="value black--text">
                                <slot
                                    :name="`item.${header.key}`"
                                    v-bind="{ item }"
                                    v-if="$slots[`item.${header.key}`]"
                                />
                                <span v-else>{{ item[header.key] }}</span>
                            </div>
                            <v-divider class="my-2" />
                        </template>
                    </div>
                </v-card-text>

                <v-card-actions
                    v-if="$slots['item.actions']"
                    class="d-flex justify-end"
                >
                    <slot name="item.actions" v-bind="{ item }" />
                </v-card-actions>
            </v-card>
            <!-- </transition-group> -->
        </div>
        <p>Items: {{ items.length }}</p>
        <p>Filtered: {{ filteredItems.length }}</p>
    </div>
</template>

<script>
import { useDisplay } from "vuetify";

export default {
    props: {
        headers: Array,
        items: Array,
        search: String,
    },
    computed: {
        isMobile() {
            const { mdAndDown } = useDisplay();
            const isMobile = mdAndDown.value;
            console.log("📱 isMobile:", isMobile);
            return isMobile;
        },
        filteredItems() {
            console.log("📦 items recibidos:", this.items);
            console.log("🔍 search:", this.search);

            if (!this.search) return this.items;

            const searchLower = this.search.toLowerCase();
            const result = this.items.filter((item) =>
                Object.values(item).some((val) =>
                    String(val).toLowerCase().includes(searchLower)
                )
            );
            console.log("🔎 Resultado filtrado:", result);
            return result;
        },
    },
};
</script>

<style scoped>
.label {
    color: #555;
    font-size: 14px;
}
.value {
    font-size: 15px;
    margin-top: 2px;
}
.fade-enter-active,
.fade-leave-active {
    transition: opacity 0.4s;
}
.fade-enter-from,
.fade-leave-to {
    opacity: 0;
}
</style>
