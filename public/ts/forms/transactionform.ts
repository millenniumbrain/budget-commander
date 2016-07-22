/// <reference path="../jquery.d.ts" />
import $ = require("jquery");
import Overlay from "../components/overlay";
import MessageBox from "../components/messagebox";

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
      this.overlay.openToggle(this.openTrigger, this.getAccounts);
      this.submitTransaction();
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
      // add accounts and select account associated with transaction
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
      // append tags to transaction form
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
      this.$form.attr("data-id", values.id);
    }
  }

  /*
  * submits transaction and displays if action successful or not
  *
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
        // close overlay display and show message
        this.overlay.toggle();
        const error = new MessageBox("dashboardContainer", req.responseJSON["msg"]);
        error.showError();
        error.close(5);
      })
      .done( (response) => {
        loader.style.visibility = "hidden";
        // close display and show message
        this.overlay.toggle();
        const success = new MessageBox("dashboardContainer", response["msg"]);
        success.showSuccess();
        success.close(5);
      })
    });
  }

  private editTransaction = () : any => {
    let loader: HTMLElement = document.getElementById("transactionLoader");
    this.$form.on("submit", (event) => {
      loader.style.visibility = "visible";
      $.ajax({
        url: "/transactions",
        type: "PUT",
      })
      .fail( (req) => {
      })
      .done( () => {
      });
    });

  }

  private getAccounts = () : void => {
    $.get('/accounts', (data: any) => {
      const selectAccount = document.getElementById("tranAccounts");
      const accounts = selectAccount.getElementsByTagName('option');
      // prevent additional option nodes when accounts are not updated/added/removed
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

  // TODO: Move to Form base class
  private clear = () : void =>  {
    const inputs = <NodeListOf<HTMLInputElement>>document.getElementById(this.form)
      .getElementsByTagName("input");
    const accounts = document.getElementById("tranAccounts").getElementsByTagName("option");
    for (let i = 0; i < accounts.length; i++) {
      // remove selection for form
      accounts[i].setAttribute("selected", "false");
    }

    for (let i = 0; i < inputs.length; i++) {
      inputs[i].value = "";
    }
    const tranButton = <HTMLButtonElement>document.getElementById("tranButton");
    tranButton.innerHTML = "Add Transaction";
  }
}
