<!-- components/ResponsiveTable.vue -->
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
        <v-card
            v-else
            class="mb-3"
            v-for="item in filteredItems"
            :key="item.id"
        >
            <v-card-text>
                <div v-for="header in headers" :key="header.key" class="mb-1">
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
            </v-card-text>
            <v-divider></v-divider>
        </v-card>
    </div>
</template>

<script>
export default {
    props: {
        headers: Array,
        items: Array,
        search: String,
    },
    computed: {
        isMobile() {
            return window.innerWidth < 768;
        },
        filteredItems() {
            if (!this.search) return this.items;
            const searchLower = this.search.toLowerCase();
            return this.items.filter((item) =>
                Object.values(item).some((val) =>
                    String(val).toLowerCase().includes(searchLower)
                )
            );
        },
    },
};
</script>

<style scoped>
@media (max-width: 767px) {
    .v-data-table {
        display: none;
    }
}
</style>
