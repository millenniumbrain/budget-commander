
export default class Overlay {
    constructor(private overlay: any) {
        this.overlay = document.getElementById(overlay);
    }
    
    public openToggle(el: string) {
      const openElement: HTMLElement = document.getElementById(el);
      openElement.addEventListener("click", this.toggleOverlay, false);
    }
    
    public closeToggle(el: string) {
        const closeElement: HTMLElement = document.getElementById(el);
        closeElement.addEventListener("click", this.toggleOverlay, false);  
    }
    
    private toggleOverlay() {
        if (this.overlay.style.visibility === "visible") {
          this.overlay.style.visibility = "hidden";
        } else {
          this.overlay.style.visibility = "visible";
        }
    }
    
}