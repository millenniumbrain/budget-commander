export default class Overlay {

    public overlay: HTMLElement;

    constructor(overlay: string) {
      this.overlay = <HTMLElement>document.getElementById(overlay);
    }

    public openToggle(openEl: string, callback: () => any ) : void {
      // don't remember why I did this lol!
      if (openEl !== "" || false) {
        const openElement: HTMLElement = <HTMLElement>document.getElementById(openEl);
        openElement.addEventListener("click", () => {
          this.overlay.style.visibility = "visible";
          if (callback != undefined) {
            callback();
          }
        }, false);
      } else {
        this.overlay.style.visibility = "visible";
        callback();
      }
    }

    public closeToggle(el: string, callback: () => any) : void {
        const closeElement: HTMLElement = <HTMLElement>document.getElementById(el);
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
