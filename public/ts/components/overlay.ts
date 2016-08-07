interface JSONCallback {
  () : void
}

export default class Overlay {

    public overlay: HTMLElement;

    constructor(overlay: string) {
      this.overlay = document.getElementById(overlay);
    }

    public openToggle(openEl: string, callback: () => any ) : void {
      if (openEl !== "" || false) {
        const openElement: HTMLElement = document.getElementById(openEl);
        openElement.addEventListener("click", () => {
          this.overlay.style.visibility = "visible";
          callback();
        }, false);
      } else {
        this.overlay.style.visibility = "visible";
        callback();
      }
    }

    public closeToggle(el: string, callback: () => any) : void {
        const closeElement: HTMLElement = document.getElementById(el);
        closeElement.addEventListener("click", () => {
          if (callback() !== null) {
            callback();
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
