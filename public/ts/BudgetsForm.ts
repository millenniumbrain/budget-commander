/// <reference path="./jquery.d.ts" />
import $ = require("jquery");
import Overlay from "./Overlay";
import Message from "./Message";

// TODO: switch from jQuery serialize JSON form to vanillasJS
export default class BudgetsForm {
  public $form: JQuery;
  public form: string;
  private overlay: Overlay = new Overlay("newBudgetOverlay");

  constructor(form: string) {
    this.$form = $(form);
    this.form = form;
  }

  public init(openTrigger: string, closeTrigger: string) : void {
    this.overlay.openToggle(openTrigger, () => {
      $.get("/totals/budgets", (data: any) => {
        let form = document.getElementById(this.form.substr(1));
        let fieldset = form.childNodes[1]; // TODO: remove duplicate fieldsets
        
        // fieldset contains 15 nodes we only want to check against 13 of them
        // because two nodes the save button and another node are not important
        if (data.length > fieldset.childNodes.length - 13) {
          data.forEach( (budget : any) => {
            this.addBudget(budget.name, budget.spending_limit);
          })
        }
      })
      .fail( () => {

      })
      .done(() => {
        this.overlay.closeToggle(closeTrigger);
      })
    });

  }

  public addBudget(name: string, spendingLimit: string) {
    let form = document.getElementById(this.form.substr(1));
    let fieldset = form.childNodes[1]; // TODO: remove duplicate fieldsets
    let container = document.createElement("div");
    container.setAttribute("class", "form-control-group flex-grid flex-1-3");
    for (let i = 0; i < 3; i++) {
      let cell = document.createElement("div");
      cell.setAttribute("class", "flex-cell");
      let label = document.createElement("label");
      let input = document.createElement("input");
      input.setAttribute("type", "text");
      input.value = spendingLimit;
      switch(i) {
        case 0:
          label.innerHTML = "Budget Name";
          cell.appendChild(label);
          cell.appendChild(input);
          break;
        case 1:
          label.innerHTML = "Spending Limit";
          cell.appendChild(label);
          cell.appendChild(input);
          break;
        case 2:
          label.innerHTML = "&nbsp;";
          let rollover = document.createElement("label");
          rollover.innerHTML = "Rollover";
          input.setAttribute("type", "checkbox");
          rollover.appendChild(input);
          cell.appendChild(label);
          cell.appendChild(rollover);
          break;
        default:
          break;
      }
      container.appendChild(cell);
      let fieldsetLength = fieldset.childNodes.length - 4;
      fieldset.insertBefore(container, fieldset.childNodes[fieldsetLength]);
    }
  }
}
