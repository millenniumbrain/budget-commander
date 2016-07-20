interface JSONCallback {
  () : void
}

export default class Overlay {

    public overlay: HTMLElement;

    constructor(overlay: string) {
      this.overlay = document.getElementById(overlay);
    }

    public openToggle(openEl: string, loadForm: JSONCallback, closeEl: string = "") : void {
      if (openEl !== "" || false) {
        const openElement: HTMLElement = document.getElementById(openEl);
        openElement.addEventListener("click", () => {
          this.overlay.style.visibility = "visible";
          loadForm();
        }, false);
      } else {
        this.overlay.style.visibility = "visible";
        loadForm();
      }
    }

    public closeToggle(el: string, clearForm: JSONCallback = null) : void {
        const closeElement: HTMLElement = document.getElementById(el);
        closeElement.addEventListener("click", () => {
          if (clearForm !== null) {
            clearForm();
          }
          this.overlay.style.visibility = "hidden";
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
