export default class MessageBox {
  private msg: string;
  private parentElement: HTMLElement;

  constructor(parentId: string, msg: string) {
    this.parentElement = document.getElementById(parentId);
    this.msg = msg;
  }

  public showSuccess() : void {
    this.generateMessage("success");
  }

  public showError() : void {
    this.generateMessage("error");
  }

  public showWarning() : void {
    this.generateMessage("warning");
  }

  public close = (delay: number) : void => {
    const closeMessage: Element = document.querySelector("#messageBox span");
    const messageBox: HTMLElement = document.getElementById("messageBox");
    // allow message box to be removed when clicked
    closeMessage.addEventListener("click", () => {
      this.parentElement.removeChild(messageBox);
    }, false);
    let remove = () => {
      try {
        this.parentElement.removeChild(messageBox);
      } catch (err) {
      }
    }
    // if left open for more then delay (in seconds) close message
    setTimeout(remove, delay * 1000);
  }

  private generateMessage = (className: string) : void => {
    const messageClose: HTMLElement = document.createElement("span");
    messageClose.setAttribute("id", "closeMessage")
    messageClose.setAttribute("class", "fa fa-close");
    const messageBox: HTMLElement = document.createElement("div");
    messageBox.setAttribute("id", "messageBox");
    messageBox.setAttribute("class", className);
    messageBox.innerHTML = this.msg;
    messageBox.appendChild(messageClose);
    this.parentElement.insertBefore(messageBox, this.parentElement.firstChild);
  }
}
