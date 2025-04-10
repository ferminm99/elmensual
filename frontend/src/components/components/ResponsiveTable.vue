<template>
    <div>
        <!-- Desktop -->
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
        <div v-else>
            <v-card
                v-for="item in filteredItems"
                :key="item.id"
                class="mb-3"
                elevation="2"
            >
                <v-card-text>
                    <div
                        v-for="header in headers"
                        :key="header.key"
                        v-if="header.key !== 'actions'"
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
                </v-card-text>
                <v-card-actions v-if="$slots['item.actions']">
                    <slot name="item.actions" v-bind="{ item }" />
                </v-card-actions>
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
            isMobile: false,
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
    },
    mounted() {
        this.isMobile = window.innerWidth < 768;
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
