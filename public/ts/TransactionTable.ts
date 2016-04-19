/// <reference path="./jquery.d.ts" />
import $ = require("jquery");
import {Helper} from "./Helper";

export class TransactionTable {
    
    public getTransactions() {
        $.get('/transactions', this.parseData)
        .fail( () => {
            
        })
        .done( () => {
            $("#transactionSpinner").hide();
        });    
    }
    
    private parseData(data: any) {
         const tranTable: Element = document.querySelector("#transactionActivity tbody");
        data.forEach( (transaction: any) => {
            const transactionRow: HTMLTableRowElement = document.createElement("tr");
            const dateCell: HTMLTableDataCellElement = document.createElement("td");
            const amountCell: HTMLTableDataCellElement = document.createElement("td");
            const descCell: HTMLTableDataCellElement = document.createElement("td");
            const tagsCell: HTMLTableDataCellElement = document.createElement("td");
            const accountNameCell: HTMLTableDataCellElement = document.createElement("td");
            
            accountNameCell.setAttribute("class", "account-cell");
            dateCell.innerHTML = transaction.date;
            dateCell.setAttribute("class", "date-cell");
            Helper.parseAmount(amountCell, transaction.type, transaction.amount);
            descCell.innerHTML = transaction.description;
            descCell.setAttribute("class", "description-cell");
            tagsCell.setAttribute("class", "tags-cell");
            for (let i = 0; i < transaction.tag_names.length; i++) {
                const currentTag: HTMLElement = document.createElement("span");
                currentTag.innerHTML = transaction.tag_names[i];
                tagsCell.appendChild(currentTag);
            }
            accountNameCell.innerHTML = transaction.account_id
            
            transactionRow.appendChild(dateCell);
            transactionRow.appendChild(amountCell);
            transactionRow.appendChild(descCell);
            transactionRow.appendChild(tagsCell);
            transactionRow.appendChild(accountNameCell);
            
            tranTable.appendChild(transactionRow);
        });
        
    }  
}