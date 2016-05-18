/// <reference path="./jquery.d.ts" />
import $ = require("jquery");
import Form from "./Form";

export default class AccountForm extends Form {
  constructor(public form: string) {
      super(form);
  }

  public retrieveData(url: string) {
    $.get(url, (data) => {

    })
    .fail( () => {

    })
    .done( () => {

    });
  }
}
