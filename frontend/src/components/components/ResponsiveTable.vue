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
                        class="mb-2"
                    >
                        <div class="label">
                            <strong>{{ header.title }}</strong>
                        </div>
                        <div class="value">
                            <slot
                                :name="`item.${header.key}`"
                                v-bind="{ item }"
                                v-if="$slots[`item.${header.key}`]"
                            />
                            <span v-else>{{ item[header.key] }}</span>
                        </div>
                        <v-divider class="my-2" />
                    </div>
                </v-card-text>

                <v-card-actions
                    v-if="$slots['item.actions']"
                    class="d-flex justify-end"
                >
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
.label {
    color: #555;
    font-size: 14px;
}
.value {
    font-size: 15px;
    margin-top: 2px;
}
</style>
