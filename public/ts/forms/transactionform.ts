/// <reference path="../jquery.d.ts" />
import $ = require("jquery");
import Overlay from "../components/overlay";
import Message from "../components/messagebox";

export default class TransactionForm {

  public $form: JQuery;
  public overlay: Overlay = new Overlay("newTransactionOverlay");
  public openTrigger: string = "addTransactionButton";
  public closeTrigger: string = "closeNewTransaction";
  private closed: boolean = false;
  public form: string;

  constructor(form: string) {
    this.$form = $(form);
    this.form = form.slice(1, form.length);
  }

  public init(values: any = null) : void {
    if (values === null) {
      const tranButton = <HTMLButtonElement>document.getElementById("tranButton");
      tranButton.innerHTML = "Add Transaction"
      this.overlay.openToggle(this.openTrigger, this.getAccounts);
    } else {
      this.overlay.openToggle("", this.getAccounts);
      const tranTypeExpense = <HTMLInputElement>document.getElementById("tranTypeExpense");
      const tranTypeIncome  = <HTMLInputElement>document.getElementById("tranTypeIncome");
      tranTypeExpense.checked = false;
      tranTypeIncome.checked = false;
      switch (values.type) {
        case "income":
          tranTypeIncome.checked = true;
          break;
        case "expense":
          tranTypeExpense.checked = true;
          break;
        default:
          break;
      }
      const tranAccounts = <NodeListOf<HTMLOptionElement>>document.getElementById("tranAccounts").getElementsByTagName("option");
      for (let i = 0; i < tranAccounts.length; i++) {
        if (tranAccounts[i].innerHTML === values.accountName) {
          tranAccounts[i].setAttribute("selected", "true");
        }
      }
      const tranDate = <HTMLInputElement>document.getElementById("tranDate");
      tranDate.value = values.date;
      const tranAmount = <HTMLInputElement>document.getElementById("tranAmount");
      tranAmount.value = values.amount;
      const tranDesc = <HTMLInputElement>document.getElementById("tranDesc");
      tranDesc.value = values.desc
      const tranTags = <HTMLInputElement>document.getElementById("tranTags");
      for (let i = 0; i < values.tags.length; i++) {
        if (values.tags.length - 1 !== i) {
          tranTags.value = tranTags.value + `${values.tags[i]},`;
        } else {
          tranTags.value = tranTags.value + `${values.tags[i]}`;
        }
      }
      const tranButton = <HTMLButtonElement>document.getElementById("tranButton");
      tranButton.innerHTML = "Edit Transaction"
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

  private editTransaction = () : any => {
  }

  private getAccounts = () : void => {
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
      this.overlay.closeToggle(this.closeTrigger, this.clear);
    });
  }

  private clear = () : void =>  {
    console.log(this.form);
    const inputs = <NodeListOf<HTMLInputElement>>document.getElementById(this.form)
      .getElementsByTagName("input");
    const accounts = document.getElementById("tranAccounts").getElementsByTagName("option");
    for (let i = 0; i < accounts.length; i++) {
      accounts[i].setAttribute("selected", "false");
    }
    for (let i = 0; i < inputs.length; i++) {
      inputs[i].value = "";
    }
    console.log(inputs);
  }
}
