/// <reference path="./jquery.d.ts" />
import $ = require("jquery");
import Form from "./Form";

export default class AccountForm extends Form {
  constructor(public form: string) {
      super(form);
  }

  public submitAccount(url: string, overlay : any, loader: string) : void {
    let $form : JQuery = $(this.form);
    this.submit(url, overlay, loader);
  }
}
