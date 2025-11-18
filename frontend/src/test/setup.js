import { config } from "@vue/test-utils";

if (typeof window !== "undefined") {
    if (!window.ResizeObserver) {
        window.ResizeObserver = class {
            observe() {}
            unobserve() {}
            disconnect() {}
        };
    }
}

config.global.mocks = {
    $t: (msg) => msg,
};
