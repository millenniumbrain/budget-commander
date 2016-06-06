export default class Message {
  private msg: string;
  private dashboard: HTMLElement = document.getElementById("dashboardContainer");
  
  constructor(msg: string) {
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
      this.dashboard.removeChild(messageBox);
    }, false);
    let remove = () => {
      this.dashboard.removeChild(messageBox);
    }
    setTimeout(remove, delay);
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
    this.dashboard.insertBefore(messageBox, this.dashboard.firstChild);
  }
}
