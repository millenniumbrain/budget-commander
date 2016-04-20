export default class Dropdown {
  private clicked: boolean = false;
  
  constructor(private el: any, private menu: any) {
    this.el = document.getElementById(el);
    this.menu = document.getElementById(menu);
  }
  
 public init() {
   this.el.addEventListener("click", this.toggle, false);
 }
  
  private toggle = () => {
    if ( this.clicked === false ) {
      this.menu.style.display = "block";
      this.clicked = true;
    } else {
      this.menu.style.display = "none";
      this.clicked = false;
    }
  }
}