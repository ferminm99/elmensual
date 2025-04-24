<template>
    <div>
        <!-- Escritorio -->
        <v-data-table
            v-if="!isMobile"
            :headers="headers"
            :items="items"
            :search="search"
            :custom-filter="customFilter"
            class="elevation-1 mt-2"
            dense
        >
            <template v-for="(_, slotName) in $slots" #[slotName]="slotProps">
                <slot :name="slotName" v-bind="slotProps" />
            </template>
        </v-data-table>

        <!-- Mobile -->
        <div v-else v-if="filteredItems.length" class="mobile-container">
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
    </div>
</template>

<script>
import { useDisplay } from "vuetify";

export default {
    props: {
        headers: Array,
        items: Array,
        search: String,
        customFilter: Function,
    },
    computed: {
        isMobile() {
            const { mdAndDown } = useDisplay();
            const isMobile = mdAndDown.value;
            return isMobile;
        },
        filteredItems() {
            if (!this.search) return [...this.items];

            const searchLower = this.search.toLowerCase();

            if (this.customFilter) {
                // Usar el filtro que pasaron desde el padre
                return this.items.filter((item) =>
                    this.customFilter(null, this.search, item)
                );
            }

            // Fallback si no pasaron customFilter
            return this.items.filter((item) =>
                Object.values(item).some((val) =>
                    String(val).toLowerCase().includes(searchLower)
                )
            );
        },
    },
    watch: {
        items: {
            deep: true, // 🔍 Importante para detectar cambios internos
        },
    },
};
</script>

<style scoped>
.label {
    font-size: 14px;
    font-weight: 600;
    color: #666;
    margin-bottom: 2px;
    text-transform: uppercase;
    letter-spacing: 0.5px;
}

.value {
    font-size: 16px;
    color: #222;
    margin-top: 1px;
    line-height: 1.4;
    word-wrap: break-word;
}

.v-card {
    border-radius: 10px;
    margin-left: 4px;
    margin-right: 4px;
}

/* Responsive refinado */
@media (max-width: 1024px) {
    .v-card {
        padding: 16px 18px;
    }

    .label {
        font-size: 13px;
        font-weight: 500;
        color: #777;
        margin-bottom: 3px;
        text-transform: uppercase;
    }

    .value {
        font-size: 17px;
        font-weight: 600;
        color: #111;
        margin-bottom: 12px;
    }

    .v-icon {
        font-size: 22px;
    }

    .v-card-actions {
        padding-top: 8px;
        padding-bottom: 4px;
    }
}
.label + .value {
    margin-bottom: 12px;
}
</style>
