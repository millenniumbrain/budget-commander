
export default class Overlay {
    constructor(private overlay: string) {
    }

    public openToggle(el: string) {
      const openElement: HTMLElement = document.getElementById(el);
      openElement.addEventListener("click", this.toggleOverlay, false);
    }

    public closeToggle(el: string) {
        const closeElement: HTMLElement = document.getElementById(el);
        closeElement.addEventListener("click", this.toggleOverlay, false);
    }

    private toggleOverlay = () => {
        const overlay: HTMLElement = document.getElementById(this.overlay);
        if (overlay.style.visibility === "visible") {
          overlay.style.visibility = "hidden";
        } else {
          overlay.style.visibility = "visible";
        }
    }

}
