/// <reference path="../jquery.d.ts" />
import $ = require("jquery");
import Overlay from "../components/overlay";
import Message from "../components/messagebox";

export default class AccountForm {
  public $form: JQuery;
  private overlay: Overlay = new Overlay("newAccountOverlay");

  constructor(form: string) {
    this.$form = $(form);
  }

  init(openTrigger: string, closeTrigger: string) : void {
    this.overlay.openToggle(openTrigger, () => {});
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
        // close and show message
        this.overlay.toggle();
        let error = new Message("dashboardContainer", req.responseJSON["msg"]);
        error.showError();
        error.close(5);
      })
      .done( (response) => {
        loader.style.visibility = "hidden";
        this.overlay.toggle();
        // close and show message
        let success = new Message("dashboardContainer", response["msg"]);
        success.showSuccess();
        success.close(5);
      })
    });
  }
}
