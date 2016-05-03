/// <reference path="./jquery.d.ts" />

import $ = require("jquery");
import {Helper} from "./Helper";

export default class Total {
    public getAllTotals() {
        $.get('/totals', this.parseAllTotals)
        .fail( () => {
            
        })
        .done( () => {
            $('#totalsSpinner').hide();    
        });
    }
  
    private parseAllTotals = (data: any) => {
        const networth: HTMLElement = document.getElementById("networthTotal");
        const budgetBalance: HTMLElement = document.getElementById("budgetBalance");
        const incomeTotal: HTMLElement = document.getElementById("incomeTotal");
        const expenseTotal: HTMLElement = document.getElementById("expenseTotal");
        
        this.parseTotal(networth, data.networth);
        this.parseTotal(budgetBalance, data.budget_balance);
        this.parseTotal(incomeTotal, data.income);
        this.parseTotal(expenseTotal, data.expense);
    }
  
    private parseTotal(el: HTMLElement, amount: any) {
        if (amount >= "0") {
            el.setAttribute("class", "green-amount total-amount");
            el.innerHTML = "+" + " " + Helper.floatToDecimal(amount).toString();
        } else {
            let absAmount: string = Math.abs(amount).toString(); 
            el.setAttribute("class", "red-amount total-amount");
            el.innerHTML = "-" + " " + absAmount;         
        }
      }
}