interface JSONCallback {
  () : any;
}
export default class Overlay {
    constructor(public overlay: string) {
    }

    public openToggle(el: string, loadForm: JSONCallback) : void {
      const openElement: HTMLElement = document.getElementById(el);
      openElement.addEventListener("click", () => {
        this.toggleOverlay();
        loadForm();
      }, false);
    }

    public closeToggle(el: string) : void {
        const closeElement: HTMLElement = document.getElementById(el);
        closeElement.addEventListener("click", () => {
          this.toggleOverlay();
        }, false);
    }

    public toggleOverlay = () : void => {
        const overlay: HTMLElement = document.getElementById(this.overlay);
        if (overlay.style.visibility === "visible") {
          overlay.style.visibility = "hidden";
        } else {
          overlay.style.visibility = "visible";
        }
    }

}
