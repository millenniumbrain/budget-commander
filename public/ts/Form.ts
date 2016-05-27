/// <reference path="./jquery.d.ts" />
import $ = require("jquery");
import Message from "./Message";

interface FormCallback {
  () : void;
}
export default class Form {
  constructor(public form: string) {

  }

  public retrieveData(url: string) : void {
    let $form: JQuery = $(this.form);
  }

  public submit(url: string, overlay : any, loaderId: string) : void {
    const $form: JQuery = $(this.form);
    const loader : HTMLElement = document.getElementById(loaderId);
    const currentOverlay : HTMLElement = document.getElementById(overlay);
    $form.on("submit", (event) => {
      event.preventDefault();
      loader.style.visibility = "visible";
      let formData : string = JSON.stringify($($form).serializeArray());
      $.post(url, formData)
      .fail( (req) => {
        loader.style.visibility = "hidden";
        currentOverlay.style.visibility = "hidden";
        let error = new Message(req.responseJSON["msg"]);
        error.showError();
        error.close(5000);
      })
      .done( (response) => {
        loader.style.visibility = "hidden";
        currentOverlay.style.visibility = "hidden";
        let success = new Message(response["msg"]);
        success.showSuccess();
        success.close(5000);
      })
    });
  }
}
