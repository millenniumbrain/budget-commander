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
    let closeMessage: Element = document.querySelector("#messageBox span");
    let messageBox: HTMLElement = document.getElementById("messageBox");
    closeMessage.addEventListener("click", () => {
      this.parentElement.removeChild(messageBox);
    }, false);
    let remove = () => {
      this.parentElement.removeChild(messageBox);
    }
    setTimeout(remove, delay * 1000);
  }

  private generateMessage = (className: string) : void => {
    let messageClose: HTMLElement = document.createElement("span");
    messageClose.setAttribute("id", "closeMessage")
    messageClose.setAttribute("class", "fa fa-close");
    let messageBox: HTMLElement = document.createElement("div");
    messageBox.setAttribute("id", "messageBox");
    messageBox.setAttribute("class", className);
    messageBox.innerHTML = this.msg;
    messageBox.appendChild(messageClose);
    this.parentElement.insertBefore(messageBox, this.parentElement.firstChild);
  }
}
