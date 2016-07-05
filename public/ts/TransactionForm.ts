/// <reference path="./jquery.d.ts" />
import $ = require("jquery");
import Overlay from "./Overlay";
import Message from "./MessageBox";

export default class TransactionForm {

  public $form: JQuery;
  public overlay: Overlay = new Overlay("newTransactionOverlay");
  public openTrigger: string = "addTransactionButton";
  public closeTrigger: string = "closeNewTransaction";

  constructor(form: string) {
    this.$form = $(form);
  }

  public init(values: Object = null) : void {
    if (values === null) {
      this.overlay.openToggle(this.openTrigger, this.getTransaction);
    } else {

    }
  }

  /*
  * validates and then submits transaction generating an error or success Message
  * upon completion
  */
  public submitTransaction() : void {
    let loader: HTMLElement = document.getElementById("transactionLoader");

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
        error.close(5);
      })
      .done( (response) => {
        loader.style.visibility = "hidden";
        this.overlay.toggle();
        let success = new Message("dashboardContainer", response["msg"]);
        success.showSuccess();
        success.close(5);
      })
    });
  }

  private getTransaction = () : void => {
    $.get('/accounts', (data: any) => {
      const selectAccount = document.getElementById("tranAccounts");
      const accounts = selectAccount.getElementsByTagName('option');
      if (data.length > accounts.length) {
        data.forEach( (account: any) => {
          let accountName: HTMLElement = document.createElement("option");
          accountName.innerHTML = account.name;
          selectAccount.appendChild(accountName);
        });
      }
    })
    .fail( () => {
    })
    .done( () => {
      this.overlay.closeToggle(this.closeTrigger);
    });
  }
}
