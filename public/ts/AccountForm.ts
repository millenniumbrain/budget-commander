/// <reference path="./jquery.d.ts" />
import $ = require("jquery");
import Overlay from "./Overlay";
import Message from "./MessageBox";

export default class AccountForm {
  public $form: JQuery;
  private overlay: Overlay = new Overlay("newAccountOverlay");

  constructor(form: string) {
    this.$form = $(form);
  }

  init(openTrigger: string, closeTrigger: string) : void {
    this.overlay.openToggle(openTrigger, () => {});
    this.overlay.closeToggle(closeTrigger);
  }

  public submitAccount() : void {
    let loader: HTMLElement = document.getElementById("accountLoader");

    this.$form.on("submit", (event) => {
      event.preventDefault();
      loader.style.visibility = "visible";
      let formData : string = JSON.stringify($(this.$form).serializeArray());
      $.post("/transactions", formData)
      .fail( (req) => {
        loader.style.visibility = "hidden";
        this.overlay.toggle();
        let error = new Message("dashboardContainer", req.responseJSON["msg"]);
        error.showError();
        error.close(5000);
      })
      .done( (response) => {
        loader.style.visibility = "hidden";
        this.overlay.toggle();
        let success = new Message("dashboardContainer", response["msg"]);
        success.showSuccess();
        success.close(5000);
      })
    });
  }
}
