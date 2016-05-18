/// <reference path="./jquery.d.ts" />
import $ = require("jquery");

export default class Form {
  constructor(public form: string) {

  }

  public retrieveData(url: string) {
    let $form: JQuery = $(this.form);
  }

  public sendData(url: string) {
    let $form: JQuery = $(this.form);
  }

}
