/// <reference path="../jquery.d.ts" />
import $ = require("jquery");
import Overlay from "../components/overlay";
import MessageBox from "../components/messagebox";
import Form from "./form";

export default class TransactionForm extends Form {
  public overlay: Overlay = new Overlay("newTransactionOverlay");
  public openTrigger: string = "addTransactionButton";
  public closeTrigger: string = "closeNewTransaction";
  private tranAccounts = <NodeListOf<HTMLOptionElement>>document.getElementById("tranAccounts").getElementsByTagName("option");
  private tranTypeExpense = <HTMLInputElement>document.getElementById("tranTypeExpense");
  private tranTypeIncome  = <HTMLInputElement>document.getElementById("tranTypeIncome");
  private tranButton = <HTMLButtonElement>document.getElementById("tranButton");

  constructor(form: string) {
    super(form);
  }

  public init(values: any = null) : void {
    if (values === null) {
      this.clear();
      this.tranButton.innerHTML = "Add Transaction";
      this.overlay.openToggle(this.openTrigger, this.getAccounts);
      this.submit();
    } else {
      this.clear();
      this.$form.attr("data-id", values.id);
      this.overlay.openToggle("", this.getAccounts);
      this.setAccount(values);
      this.setType(values);
      this.setInputs(values);
      this.tranButton.innerHTML = "Edit Transaction"
      this.editTransaction();
    }
  }

  public setAccount = (values: any) : void => {
    // add accounts and select account associated with transaction
    for (let i = 0; i < this.tranAccounts.length; i++) {
      if (this.tranAccounts[i].innerHTML === values.accountName) {
        this.tranAccounts[i].setAttribute("selected", "true");
      }
    }
  }
  public setType = (values: any) : void => {
    switch (values.type) {
      case "income":
        this.tranTypeIncome.checked = true;
        break;
      case "expense":
        this.tranTypeExpense.checked = true;
        break;
      default:
        break;
    }
  }

  public setInputs(values: any) : void {
    const tranDate = <HTMLInputElement>document.getElementById("tranDate");
    tranDate.value = values.date;
    const tranAmount = <HTMLInputElement>document.getElementById("tranAmount");
    tranAmount.value = values.amount;
    const tranDesc = <HTMLInputElement>document.getElementById("tranDesc");
    tranDesc.value = values.desc
    // add comma seperated tags to input field
    const tranTags = <HTMLInputElement>document.getElementById("tranTags");
    for (let i = 0; i < values.tags.length; i++) {
      if (values.tags.length - 1 !== i) {
        tranTags.value = tranTags.value + `${values.tags[i]},`;
      } else {
        tranTags.value = tranTags.value + `${values.tags[i]}`;
      }
    }
  }

  public submit() : void {
    super.submit("/transactions", this.overlay);
  }


  private editTransaction = () : any => {
    const tranId = this.$form.attr("data-id");
    this.$form.on("submit", (event) => {
      $.ajax({
        url: `/transactions/${tranId}`,
        type: "PUT",
        data: JSON.stringify($(this.$form).serializeArray())
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
      const accounts = <NodeListOf<HTMLOptionElement>>selectAccount.getElementsByTagName('option');
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

  public clear = () : void => {
    const inputs = <NodeListOf<HTMLInputElement>>this.form.getElementsByTagName("input");
    for (let i = 0; i < inputs.length; i++) {
      if (inputs[i].getAttribute("type") != "radio") {
        inputs[i].value = "";
      }
    }
    this.tranTypeExpense.checked = false;
    this.tranTypeIncome.checked = false;
    for (let i = 0; i < this.tranAccounts.length; i++) {
      // remove selection for form
      this.tranAccounts[i].setAttribute("selected", "false");
    }
  }
}