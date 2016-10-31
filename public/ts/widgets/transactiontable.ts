/// <reference path="../jquery.d.ts" />
/// <refrence path="superagent.d.ts" />
import $ = require("jquery");
import TransactionForm from "../forms/transactionform";
import Transaction from "../models/transaction";

export default class TransactionTable {
    public tranTable: Element = document.querySelector("#transactionActivity tbody");

    public init  = () : void => {
      this.getTransactions();
      this.tranTable.addEventListener("click", (event) => {
        // cast to HTMLElement to allow for HTMLElement methods
        const arrow = <HTMLTableRowElement>event.target
        if (arrow.tagName === "i" || arrow.tagName === "I") {
          this.showControls(arrow);
        }

      }, false);
    }

    public showControls(arrow: HTMLElement) {
      let dataId = arrow.getAttribute("data-id");
      let row: HTMLElement = <HTMLElement>document.getElementById(arrow.getAttribute("data-id"));
      let controlsRow: HTMLTableRowElement = document.createElement("tr");

      controlsRow.setAttribute("class", "controls-row");
      controlsRow.setAttribute("data-id", dataId);

      let editCell: HTMLTableDataCellElement = document.createElement("td");
      let editButton: HTMLElement = document.createElement("button");
      editButton.setAttribute("value", dataId);
      editButton.setAttribute("class", "button");
      editButton.innerHTML = "Edit";
      editCell.appendChild(editButton);

      let deleteCell: HTMLTableCellElement = document.createElement("td");
      let deleteButton: HTMLElement = document.createElement("button");
      deleteButton.setAttribute("class", "important");
      deleteButton.setAttribute("value", dataId);
      deleteButton.innerHTML = "Delete";
      deleteCell.appendChild(deleteButton);

      controlsRow.appendChild(editCell);
      controlsRow.appendChild(deleteCell);
      // HACK: allow for multiple transction controls
      if(!document.querySelector(`tr.controls-row[data-id="${dataId}"]`)) {
        arrow.setAttribute("class", "fa fa-chevron-up table-arrow");
        row.insertAdjacentElement('afterend', controlsRow);
        // add eventListener to edit button to that transaction row
        this.editTransaction(editButton, dataId);
        this.deleteTransaction(deleteButton, dataId)
      } else {
        // get first instance of controls row and then remove it
        // set $arrow back to a down arrow
        document.getElementsByClassName("controls-row")[0].remove();
        arrow.setAttribute("class", "fa fa-chevron-down table-arrow");
      }
    }

    public editTransaction(button: HTMLElement, elementId: string) :void {
      button.addEventListener("click", () => {
        const transaction = this.transactionRow(elementId);
        const editTransactionForm = new TransactionForm("#newTransaction");
        editTransactionForm.init(transaction);
      }, false);
    }

    public deleteTransaction(button: HTMLElement, elementId: string) : void{
      let transactionRow = document.getElementById(elementId);
      button.addEventListener("click", () => {
        $.ajax({
          url: `/transactions/${elementId}`,
          method: "DELETE"
        })
        .fail( () => {
          
        })
        .done( () => {
          
        });
      }, false);
    }

    public getTransactions() : void {
        $.get("/transactions", this.parseData)
        .fail( () => {

        })
        .done( () => {
            $("#transactionSpinner").hide();
        });
    }

    private transactionRow(elementId: string) : Object {
      const transactionRow: HTMLElement = <HTMLElement>document.getElementById(elementId);
      const columns = <NodeListOf<HTMLElement>>transactionRow.getElementsByTagName("td");
      let transaction = new Transaction();
      transaction.id = elementId;
      transaction.date = columns[0].innerHTML;
      transaction.type = <string>columns[1].getAttribute("data-type");
      transaction.amount = <string>columns[1].getAttribute("data-amount");
      transaction.desc = columns[2].innerHTML;
      const tags = <NodeListOf<HTMLTableDataCellElement>>document.querySelectorAll(`tr[id='${elementId}'] span.table-tag`);
      for (let tag of tags) {
        transaction.tags.push(tag.innerHTML);
      }
      transaction.accountName = columns[4].innerHTML;
      return transaction;
    }

    private parseData = (data: any) : void => {

        const showTransactionsNum: HTMLElement = <HTMLElement>document.getElementById("shownSize");
        const transacitonNum: HTMLElement = <HTMLElement>document.getElementById("totalSize");
        for (let transaction of data) {
            let transactionRow: HTMLTableRowElement = document.createElement("tr");
            transactionRow.setAttribute("id", transaction.uid);
            let dateCell: HTMLTableDataCellElement = document.createElement("td");
            let amountCell: HTMLTableDataCellElement = document.createElement("td");
            let descCell: HTMLTableDataCellElement = document.createElement("td");
            let tagsCell: HTMLTableDataCellElement = document.createElement("td");
            let accountNameCell: HTMLTableDataCellElement = document.createElement("td");
            let arrowCell: HTMLTableDataCellElement = document.createElement("td");

            dateCell.innerHTML = transaction.date;
            dateCell.setAttribute("class", "date-cell");

            this.parseAmount(amountCell, transaction.type, transaction.amount);
            amountCell.setAttribute("data-type", transaction.type);
            amountCell.setAttribute("data-amount", transaction.amount);

            descCell.innerHTML = transaction.description;
            descCell.setAttribute("class", "description-cell");

            tagsCell.setAttribute("class", "tags-cell");
            if (transaction.tags_data === undefined) {
              tagsCell.innerHTML = "";
            } else {
              // add all tags related to transaction
              for (let tag of transaction.tags_data) {
                  let currentTag: HTMLElement = document.createElement("span");
                  currentTag.setAttribute("class", "table-tag");
                  currentTag.innerHTML = tag["name"];
                  tagsCell.appendChild(currentTag);
              }
            }

            accountNameCell.setAttribute("class", "account-cell");
            accountNameCell.innerHTML = transaction.account_id;

            arrowCell.setAttribute("class", "arrow-cell");
            let downArrow: HTMLElement = document.createElement("i");
            downArrow.setAttribute("class", "fa fa-chevron-down table-arrow");
            downArrow.setAttribute("data-id", transaction.uid);
            arrowCell.appendChild(downArrow);

            transactionRow.appendChild(dateCell);
            transactionRow.appendChild(amountCell);
            transactionRow.appendChild(descCell);
            transactionRow.appendChild(tagsCell);
            transactionRow.appendChild(accountNameCell);
            transactionRow.appendChild(arrowCell);
            this.tranTable.appendChild(transactionRow);
        }
        $.get('/transactions?count=true', (data) => {
            transacitonNum.innerHTML = data
        });
        showTransactionsNum.innerHTML = data.length;
    }
    
    public parseAmount = (el: HTMLElement, type: string, amount: string) : void  => {
        switch(type) {
            case "income":
                el.setAttribute("class", "green-amount amount-cell");
                el.innerHTML = `+ ${amount}`;
                break;
            case "expense":
                el.setAttribute("class", "red-amount amount-cell");
                el.innerHTML = `- ${amount}`;
                break;
            default:
                el.setAttribute("class", "amount-cell");
                el.innerHTML = amount
                break;
        }
    }
}
