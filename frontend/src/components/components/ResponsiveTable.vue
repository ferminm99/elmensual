<template>
    <div>
        <!-- Escritorio -->
        <v-data-table
            v-if="!isMobile"
            :headers="headers"
            :items="items"
            :search="search"
            dense
            class="elevation-1 mt-2"
        >
            <template v-for="(_, slotName) in $slots" #[slotName]="slotProps">
                <slot :name="slotName" v-bind="slotProps" />
            </template>
        </v-data-table>

        <!-- Móvil -->
        <div v-else class="d-flex flex-column gap-2 mt-2">
            <v-card
                v-for="item in filteredItems"
                :key="item.id"
                class="pa-3"
                elevation="2"
            >
                <v-card-text>
                    <div
                        v-for="header in headers"
                        :key="header.key"
                        v-if="header.key !== 'actions'"
                        class="d-flex justify-space-between mb-2"
                    >
                        <strong>{{ header.title }}:</strong>
                        <span>
                            <slot
                                :name="`item.${header.key}`"
                                v-bind="{ item }"
                                v-if="$slots[`item.${header.key}`]"
                            />
                            <span v-else>{{ item[header.key] }}</span>
                        </span>
                    </div>

                    <!-- Acciones al final -->
                    <div
                        v-if="hasActionsSlot"
                        class="d-flex justify-end mt-3 gap-2"
                    >
                        <slot :name="'item.actions'" v-bind="{ item }" />
                    </div>
                </v-card-text>
            </v-card>
        </div>
    </div>
</template>

<script>
export default {
    props: {
        headers: Array,
        items: Array,
        search: String,
    },
    data() {
        return {
            isMobile: window.innerWidth < 768,
        };
    },
    computed: {
        filteredItems() {
            if (!this.search) return this.items;
            const searchLower = this.search.toLowerCase();
            return this.items.filter((item) =>
                Object.values(item).some((val) =>
                    String(val).toLowerCase().includes(searchLower)
                )
            );
        },
        hasActionsSlot() {
            return !!this.$slots["item.actions"];
        },
    },
    mounted() {
        window.addEventListener("resize", this.handleResize);
    },
    beforeUnmount() {
        window.removeEventListener("resize", this.handleResize);
    },
    methods: {
        handleResize() {
            this.isMobile = window.innerWidth < 768;
        },
    },
};
</script>

<style scoped>
/* Para spacing en mobile */
@media (max-width: 767px) {
    .gap-2 > * + * {
        margin-top: 8px;
    }
}
</style>
