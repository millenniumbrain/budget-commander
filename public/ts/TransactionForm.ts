/// <reference path="./jquery.d.ts" />
import $ = require("jquery");
import Form from "./Form";

export default class TransactionForm extends Form {
  constructor(public form: string) {
      super(form);
  }

  public init(loader: string) : void {
    $.get('/accounts', (data) => {
      const selectAccount : HTMLElement = document.getElementById("addTransactionAccounts");
      if (data.length > selectAccount.childNodes.length) {
        data.forEach( (account : any) => {
          let accountName : HTMLElement = document.createElement("option");
          accountName.innerHTML = account.name;
          selectAccount.appendChild(accountName);
        });
      }
    })
    .fail( () => {
    })
    .done( () => {
    });
  }

  public submitTransaction(url: string, overlay : any, loader: string) : void {
    let $form : JQuery = $(this.form);
    this.submit(url, overlay, loader)
  }

  public appendTable() {

  }

  private validateNumber() {

  }

  private validateSelection() {

  }
}
