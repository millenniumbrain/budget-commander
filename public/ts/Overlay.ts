interface JSONCallback {
  () : void
}

export default class Overlay {

    public overlay: HTMLElement;

    constructor(overlay: string) {
      this.overlay = document.getElementById(overlay);
    }

    public openToggle(el: string, loadForm: JSONCallback) : void {
      const openElement: HTMLElement = document.getElementById(el);
      openElement.addEventListener("click", () => {
        this.toggle();
        loadForm();
      }, false);
    }

    public closeToggle(el: string) : void {
        const closeElement: HTMLElement = document.getElementById(el);
        closeElement.addEventListener("click", () => {
          this.toggle();
        }, false);
    }

    public toggle = () : void => {
        if (this.overlay.style.visibility === "visible") {
          this.overlay.style.visibility = "hidden";
        } else {
          this.overlay.style.visibility = "visible";
        }
    }

}
