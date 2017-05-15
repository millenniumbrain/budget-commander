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

  public init(transaction?: any) : void {
    //  remove input values if a transaction is undefined
    if (transaction === undefined) {
      this.clear();
      this.tranButton.innerHTML = "Add Transaction";
      this.getAccounts();
      this.overlay.openToggle(this.openTrigger, null);
      this.submit();
    } else {
      this.clear();
      this.$form.attr("data-id", transaction.id);
      this.overlay.openToggle("", this.getAccounts);
      this.setAccount(transaction);
      this.setType(transaction);
      this.setInputs(transaction);
      this.tranButton.innerHTML = "Edit Transaction"
      this.editTransaction();
    }
  }

  public setAccount = (transaction: any) : void => {
    // add accounts and select account associated with transaction
    for (let i = 0; i < this.tranAccounts.length; i++) {
      if (this.tranAccounts[i].innerHTML === transaction.accountName) {
        this.tranAccounts[i].setAttribute("selected", "true");
      }
    }
  }
  public setType = (transaction: any) : void => {
    switch (transaction.type) {
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

  public setInputs(transaction: any) : void {
    const tranDate = <HTMLInputElement>document.getElementById("tranDate");
    tranDate.value = transaction.date;
    const tranAmount = <HTMLInputElement>document.getElementById("tranAmount");
    tranAmount.value = transaction.amount;
    const tranDesc = <HTMLInputElement>document.getElementById("tranDesc");
    tranDesc.value = transaction.desc
    // add comma seperated tags to input field
    const tranTags = <HTMLInputElement>document.getElementById("tranTags");
    for (let i = 0; i < transaction.tags.length; i++) {
      if (transaction.tags.length - 1 !== i) {
        tranTags.value = tranTags.value + `${transaction.tags[i]},`;
      } else {
        tranTags.value = tranTags.value + `${transaction.tags[i]}`;
      }
    }
  }

  public submit() : void {
    super.submit("/transactions", this.overlay);
  }


  private editTransaction = () : any => {
    const tranId = this.$form.attr("data-id");
    this.$form.on("submit", (event) => {
      event.preventDefault();
      $.ajax({
        url: `/transactions/${tranId}`,
        type: "PUT",
        data: JSON.stringify($(this.$form).serializeArray())
      })
      .fail( (req) => {
      })
      .done( () => {
        this.overlay.toggle();
      });
    });

  }

  private getAccounts = () : void => {
    $.get('/accounts', (data: any) => {
      const selectAccount = document.getElementById("tranAccounts");
      const accounts = <NodeListOf<HTMLOptionElement>>selectAccount.getElementsByTagName('option');
      // prevent additional option nodes when accounts are not updated/added/removed
      if (data.length > accounts.length) {
        for (let account of data) {
          let accountName: HTMLElement = document.createElement("option");
          accountName.innerHTML = account.name;
          selectAccount.appendChild(accountName);
        };
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
    // reset all input values except for radio buttons
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
    this.$form.off("submit")
  }
}
