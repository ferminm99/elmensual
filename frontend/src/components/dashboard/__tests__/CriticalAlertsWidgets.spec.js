import { mount, flushPromises } from "@vue/test-utils";
import CriticalAlertsWidget from "../CriticalAlertWidget.vue";
import axios from "axios";
import { describe, beforeEach, it, expect, vi } from "vitest";

const pushMock = vi.fn();

vi.mock("axios", () => ({
    default: {
        get: vi.fn(),
        post: vi.fn(),
    },
}));

vi.mock("vue-router", () => ({
    useRouter: () => ({
        push: pushMock,
    }),
}));

const mountWidget = async () => {
    const wrapper = mount(CriticalAlertsWidget, {
        global: {
            stubs: {
                "v-card": {
                    template: '<div class="v-card"><slot /></div>',
                },
                "v-card-title": {
                    template: '<div class="v-card-title"><slot /></div>',
                },
                "v-card-text": {
                    template: '<div class="v-card-text"><slot /></div>',
                },
                "v-divider": {
                    template: "<hr />",
                },
                "v-alert": {
                    template: '<div class="v-alert"><slot /></div>',
                },
                "v-skeleton-loader": {
                    template: '<div class="skeleton"></div>',
                },
                "v-table": {
                    template: "<table><slot /></table>",
                },
                "v-chip": {
                    template: '<span class="chip"><slot /></span>',
                },
                "v-btn": {
                    props: ["disabled", "loading"],
                    emits: ["click"],
                    template:
                        '<button :disabled="disabled" @click="$emit(\'click\')"><slot /></button>',
                },
                "v-icon": {
                    template: "<span><slot /></span>",
                },
                "v-select": {
                    props: ["modelValue", "items"],
                    emits: ["update:modelValue"],
                    template: `
                        <select :value="modelValue" @change="$emit('update:modelValue', $event.target.value)">
                            <option v-for="item in items" :key="item.value" :value="item.value">
                                {{ item.label }}
                            </option>
                        </select>
                    `,
                },
            },
        },
    });
    await flushPromises();
    return wrapper;
};

describe("CriticalAlertsWidget", () => {
    beforeEach(() => {
        pushMock.mockReset();
        axios.get.mockReset();
        axios.post.mockReset();
        axios.get.mockResolvedValue({
            data: [
                {
                    id: 1,
                    articulo_id: 10,
                    articulo: { numero: "200", nombre: "Clasica" },
                    talle: 40,
                    total_stock: 0,
                    criticidad: 4,
                    estado_reposicion: "pendiente",
                    ultimo_detectado_en: "2024-09-20T10:00:00Z",
                    pedido_referencia: null,
                },
                {
                    id: 2,
                    articulo_id: 11,
                    articulo: { numero: "150", nombre: "Básica" },
                    talle: 38,
                    total_stock: 0,
                    criticidad: 2,
                    estado_reposicion: "pendiente",
                    ultimo_detectado_en: "2024-09-21T09:00:00Z",
                    pedido_referencia: null,
                },
            ],
        });
        axios.post.mockResolvedValue({ data: {} });
    });

    it("muestra las alertas ordenadas por criticidad", async () => {
        const wrapper = await mountWidget();

        expect(axios.get).toHaveBeenCalledWith("/api/alertas/criticas", {
            params: { sort: "criticidad" },
        });

        const rows = wrapper.findAll("tbody tr");
        expect(rows).toHaveLength(2);
        expect(rows[0].text()).toContain("200 - Clasica");
        expect(rows[1].text()).toContain("150 - Básica");

        const select = wrapper.find("select");
        axios.get.mockResolvedValue({ data: [] });
        await select.setValue("fecha");
        await flushPromises();

        expect(axios.get).toHaveBeenLastCalledWith("/api/alertas/criticas", {
            params: { sort: "fecha" },
        });
    });

    it("vincula el pedido y navega al gestor", async () => {
        const wrapper = await mountWidget();
        const firstRowButton = wrapper.findAll("tbody tr")[0].find("button");

        await firstRowButton.trigger("click");
        await flushPromises();

        expect(axios.post).toHaveBeenCalledTimes(1);
        const [[url, payload]] = axios.post.mock.calls;
        expect(url).toBe("/api/alertas/1/vincular-pedido");
        expect(payload.pedido_referencia).toMatch(/^ALERTA-1-/);

        expect(pushMock).toHaveBeenCalledWith({
            path: "/managepedidos",
            query: expect.objectContaining({
                alertId: 1,
                articuloId: 10,
                talle: 40,
            }),
        });

        expect(firstRowButton.attributes("disabled")).toBeDefined();
    });
});
