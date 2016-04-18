/// <reference path="jquery.d.ts" />

export class TransactionTable {
    
    parseTransactions(data: any) {
        const tranTable = document.querySelector("#transactionActivity tbody");
        let transaction: HTMLTableRowElement = document.createElement("tr");
        let date: HTMLTableDataCellElement = document.createElement("td");
        let amount: HTMLTableDataCellElement = document.createElement("td");
        let desc: HTMLTableDataCellElement = document.createElement("td");
        let tags: HTMLTableDataCellElement = document.createElement("td");
        let accountName: HTMLTableDataCellElement = document.createElement("td");
        
        
        
    }  
}