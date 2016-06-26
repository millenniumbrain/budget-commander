/// <reference path="./jquery.d.ts" />
import $ = require("jquery");
import {Helper} from "./Helper";

export default class TransactionTable {
    public tranTable: Element = document.querySelector("#transactionActivity tbody");

    public init  = () : void => {
      this.getTransactions();
      this.tranTable.addEventListener("click", (event) => {
        // HACK: event.target is an event in TypeScript but in JavaScript
        // it is also a DOM Object
        let $arrow: JQuery = $(event.target);
        if($arrow.prop("tagName") === "i" || $arrow.prop("tagName") === "I") {
          this.showControls($arrow)
        }

      }, false)
    }

    public showControls($element: JQuery) {
      let $arrow: JQuery = $element;
      let row: HTMLElement = document.getElementById($arrow.data("id"));
      let transactionId: string = "/transactions/" + $arrow.data("id");
      let controlsRow: HTMLTableRowElement = document.createElement("tr");

      controlsRow.setAttribute("class", "controls-row");
      controlsRow.setAttribute("data-id", $arrow.data("id"));

      let editCell: HTMLTableDataCellElement = document.createElement("td");
      let editButton: HTMLElement = document.createElement("button");
      editButton.setAttribute("value", transactionId)
      editButton.setAttribute("class", "button");
      editButton.innerHTML = "Edit";
      editCell.appendChild(editButton);

      let deleteCell: HTMLTableCellElement = document.createElement("td");
      let deleteButton: HTMLElement = document.createElement("button");
      deleteButton.setAttribute("class", "important");
      deleteButton.setAttribute("value", transactionId)
      deleteButton.innerHTML = "Delete";
      deleteCell.appendChild(deleteButton);

      controlsRow.appendChild(editCell);
      controlsRow.appendChild(deleteCell);
      // HACK: allow for multiple transction controls
      if(!document.querySelector("tr.controls-row[data-id='" +$arrow.data("id") +"']")) {
        $arrow.attr("class", "button fa fa-chevron-up table-arrow");
        Helper.insertAfter(controlsRow, row);
      } else {
        // get first instance of controls row and then remove it
        // set $arrow back to a down arrow
        document.getElementsByClassName("controls-row")[0].remove();
        $arrow.attr("class", "button fa fa-chevron-down table-arrow");
      }
    }

    public getTransactions() : void {
        $.get("/transactions", this.parseData)
        .fail( () => {

        })
        .done( () => {
            $("#transactionSpinner").hide();
        });
    }

    private parseData = (data: any) : void => {

        const showTransactionsNum : HTMLElement = document.getElementById("shownSize");
        const transacitonNum : HTMLElement = document.getElementById("totalSize");
        data.forEach( (transaction: any) => {
            let transactionRow: HTMLTableRowElement = document.createElement("tr");
            transactionRow.setAttribute("id", transaction._id);
            let dateCell: HTMLTableDataCellElement = document.createElement("td");
            let amountCell: HTMLTableDataCellElement = document.createElement("td");
            let descCell: HTMLTableDataCellElement = document.createElement("td");
            let tagsCell: HTMLTableDataCellElement = document.createElement("td");
            let accountNameCell: HTMLTableDataCellElement = document.createElement("td");
            let arrowCell: HTMLTableDataCellElement = document.createElement("td");


            dateCell.innerHTML = transaction.date;
            dateCell.setAttribute("class", "date-cell");

            Helper.parseAmount(amountCell, transaction.type, transaction.amount);

            descCell.innerHTML = transaction.description;
            descCell.setAttribute("class", "description-cell");

            tagsCell.setAttribute("class", "tags-cell");
            if (transaction.tags_data === undefined) {
              tagsCell.innerHTML = "";
            } else {
              // add all tags related to transaction
              for (let i = 0; i < transaction.tags_data.length; i++) {
                  let currentTag: HTMLElement = document.createElement("span");
                  currentTag.setAttribute("data-tag", transaction.tags_data[i]["id"]);
                  currentTag.setAttribute("class", "table-tag");
                  currentTag.innerHTML = transaction.tags_data[i]["name"];
                  tagsCell.appendChild(currentTag);
              }
            }

            accountNameCell.setAttribute("class", "account-cell");
            accountNameCell.innerHTML = transaction.account_id;

            arrowCell.setAttribute("class", "arrow-cell");
            let downArrow: HTMLElement = document.createElement("i");
            downArrow.setAttribute("class", "button fa fa-chevron-down table-arrow");
            downArrow.setAttribute("data-id", transaction._id);
            arrowCell.appendChild(downArrow);

            transactionRow.appendChild(dateCell);
            transactionRow.appendChild(amountCell);
            transactionRow.appendChild(descCell);
            transactionRow.appendChild(tagsCell);
            transactionRow.appendChild(accountNameCell);
            transactionRow.appendChild(arrowCell);
            this.tranTable.appendChild(transactionRow);
        });
        $.get('/transactions?count=true', (data) => {
            transacitonNum.innerHTML = data
        });
        showTransactionsNum.innerHTML = data.length;
    }
}
