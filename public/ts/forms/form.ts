/// <reference path="../jquery.d.ts" />
import $ = require("jquery");

import MessageBox from "../components/messagebox";

export default class Form {
  public $form: JQuery;
  public form: HTMLFormElement;

  constructor(form: string) {
    this.$form = $(form);
    this.form = <HTMLFormElement>document.getElementById(form.slice(1, form.length));
  }

  submit(url: string, overlay: Overlay) : void {
    this.$form.on("submit", (event: Event) => {
      event.preventDefault();
      //loader.style.visibility = "visible";
      let formData: string = JSON.stringify($(this.$form).serializeArray());
      $.post(url, formData)
      .fail( (req) => {
        const error = new MessageBox("dashboardContainer", req.responseJSON["msg"]);
        error.showError();
        error.close(5);
        overlay.toggle();
      })
      .done( (response) => {
      //  loader.style.visibility = "hidden";
        const success = new MessageBox("dashboardContainer", response["msg"]);
        success.showSuccess();
        success.close(5);
        overlay.close();
      })
    });
  }

  }
}
