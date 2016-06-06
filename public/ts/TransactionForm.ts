/// <reference path="./jquery.d.ts" />
import $ = require("jquery");
import Overlay from "./Overlay";
import Message from "./Message";

export default class TransactionForm {

  public $form: JQuery;
  public overlay: Overlay = new Overlay("newTransactionOverlay");

  constructor(form: string) {
    this.$form = $(form);
  }

  public init(openTrigger: string, closeTrigger: string) : void {
    this.overlay.openToggle(openTrigger, () =>{
      $.get('/accounts', (data: any) => {
        const selectAccount: HTMLElement = document.getElementById("addTransactionAccounts");
        if (data.length > selectAccount.childNodes.length) {
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
        this.overlay.closeToggle(closeTrigger);
      });
    });
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
        let error = new Message(req.responseJSON["msg"]);
        error.showError();
        error.close(5000);
      })
      .done( (response) => {
        loader.style.visibility = "hidden";
        this.overlay.toggle();
        let success = new Message(response["msg"]);
        success.showSuccess();
        success.close(5000);
      })
    });
  }

  public appendTable() {

  }

  private validateNumber() {

  }

  private validateSelection() {

  }
}
