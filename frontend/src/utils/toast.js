export function showToast(text, color = "success") {
    window.dispatchEvent(
        new CustomEvent("show-toast", { detail: { text, color } })
    );
}
