function Overlay(overlayElement, openTrigger, closeTrigger) {
  this.overlayElement = document.getElementById(overlayElement);
  this.openTrigger = document.getElementById(openTrigger);
  this.closeTrigger = document.getElementById(closeTrigger);
}

Overlay.prototype = {
  constructor: Overlay,
  triggerOverlay: function() {
    if(this.overlayElement.style.visibility === "visible") {
      this.overlayElement.style.visibility = "hidden"; 
    } else {
      this.overlayElement.style.visibility = "visible";
    }
  },
  init: function() {
    this.openTrigger.addEventListener("click", this.triggerOverlay.bind(this), false);
    this.closeTrigger.addEventListener("click", this.triggerOverlay.bind(this), false);
  }
}

var addTranItem = new Overlay("transactionOverlay", "addTransactionItem", "closeTranOverlay");
addTranItem.init();

var addAccountItem = new Overlay("accountOverlay", "addAccountItem", "closeAccountOverlay");
addAccountItem.init();

var addBudgetItem = new Overlay("budgetOverlay","addBudgetItem", "closeBudgetOverlay");
addBudgetItem.init();

function budgetFilter(data) {
  var budgetLabels = [];
  var budgetValues = [];
  for (var i = 0; i < data.length; i++) {
    budgetLabels.push(data[i].name);
    budgetValues.push(data[i].spending_limit);
  }

  var budgets = {
    labels: budgetLabels,
    series: budgetValues
  };

  var options = {
    labelInterpolationFnc: function(value) {
      return value
    },
    chartPadding: 30,
    labelDirection: 'explode',
    labelOffset: 50,
    donut: true
  };
  

  new Chartist.Pie('#overallBudgetChart', budgets, options);
}

get("/users/budgets", budgetFilter);

/*global _*/
'use strict';

(function() {
  // get add button and option list
  var addButton = document.getElementById("addButton");
  var addOptionsList = document.getElementById("addOptions");
  // set button to clicked
  var addButtonClicked = false;
  addButton.addEventListener("click", function() {
    // remove the addOptionsList when clicked again
    if (addButtonClicked === false) {
      addOptionsList.style.display = "block";
      addButtonClicked = true;
    } else if (addButtonClicked === true) {
      addOptionsList.style.display = "none";
      addButtonClicked = false;
    }
  }, false);
})();

(function() {
  var addTotals = function(data) {
    var sumTotals = document.querySelector(".sum-total");
    // we want the key and the value to create a label and display data
    _.forEach(data, function(value, key) {
      var total = document.createElement("h2");
      var label = document.createElement("h3");
      var flexCell = document.createElement("div");

      flexCell.setAttribute("class", "flex-cell");
      // get the value and output what we want the user to see instead of the key
      if(value < 0) {
        label.innerHTML = "Monthly Expenses";
        total.setAttribute("class", "expense");
        total.innerHTML = value;
        flexCell.appendChild(label);
        flexCell.appendChild(total);
        sumTotals.appendChild(flexCell);
      } else if (key === "networth") {
        label.innerHTML = "Net Worth";
        total.setAttribute("class", "income");
        total.innerHTML = "+" + value;
        flexCell.appendChild(label);
        flexCell.appendChild(total);
        sumTotals.appendChild(flexCell);
      } else if (key === "budget_balance") {
        label.innerHTML = "Budget Balance";
        if(value >= 0) {
          total.setAttribute("class", "income");
          total.innerHTML = "+" + value;
        } else {
          total.setAttribute("class", "expense");
          total.innerHTML = value;
        }
        flexCell.appendChild(label);
        flexCell.appendChild(total);
        sumTotals.appendChild(flexCell);
      } else if (key == "income") {
        label.innerHTML = "Monthly Income";
        total.setAttribute("class", "income");
        total.innerHTML = "+" + value;
        flexCell.appendChild(label);
        flexCell.appendChild(total);
        sumTotals.appendChild(flexCell);
      } else {
        label.innerHTML = key;
        total.setAttribute("class", "income");
        total.innerHTML = "+" + value;
        flexCell.appendChild(label);
        flexCell.appendChild(total);
        sumTotals.appendChild(flexCell);
      }
    });
  };
  
  get("/users/total", addTotals);
})();

function Helpers() {
}

Helpers.prototype = {
  consructor: Helpers,
  floatToDecimal: function (number) {
   var decimalNumber = parseFloat(number);
   return decimalNumber;
  },
  checkAmountNumber: function (el, amount) {
    if (amount < 0) { 
      el.setAttribute("class", "amount expense");
      el.innerHTML = this.floatToDecimal(amount);
    } else {
      el.setAttribute("class", "amount income");
      el.innerHTML = "+" + this.floatToDecimal(amount);
    }
  }
}

appHelpers = new Helpers();

function get(url, callback) {
  var request = new XMLHttpRequest();

  request.open("GET", url, true);
  request.onload = function(e) {
    if (request.readyState === 4) {
      if (request.status >= 200 && request.status < 400) {
        var data = JSON.parse(request.responseText);
        if (typeof callback === "function") {
          callback(data);
        }
        else {

        }
      }
    }
    else {
      console.log(request.statusText);
    }
  };

  request.onerror = function() {};
  request.send(null);
}
/*
function networthChart(data) {
  
  function createArray(data) {
      var array = [];
      for (var i = 0; i < data.length; i++) {
        array.push(appHelpers.floatToDecimal(data[i]amount));
      }
      
      return array;
  }
  var networthLabel = ['Jan', 'Feb', 'Mar', 'Apr', 'Mai', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
  var networthIncome = [];
  var networthExpenses = [];
  
}
*/
/* global appHelpers */
/* global HTTPClient */
function ActivityTable() {
}

ActivityTable.prototype = {
  constructor: ActivityTable,
  filterToTable: function (data) {
    var tranActivity = document.querySelector("#activity tbody");
    // map the transaction array
    data.map(function(transaction) {
      var row = document.createElement("tr");
      row.setAttribute("class", "transaction");
      var date = document.createElement("td");
      var amount = document.createElement("td");
      var description = document.createElement("td");
      var tags = document.createElement("td");
      var accountName = document.createElement("td");
      // add classes to change table alignments
      appHelpers.checkAmountNumber(amount, transaction.amount); 
      date.setAttribute("class", "date");
      date.innerHTML = transaction.created_at;
      description.setAttribute("class", "description");
      description.innerHTML = transaction.description;
      tags.setAttribute("class", "tag");
      tags.innerHTML = "Entertaiment";
      accountName.setAttribute("class", "account");
      accountName.innerHTML = transaction.account_id;
      // append columns to rows
      row.appendChild(date);
      row.appendChild(amount);
      row.appendChild(description);
      row.appendChild(tags);
      row.appendChild(accountName);
      tranActivity.appendChild(row);
    });  
  },
  getTableData: function (url) {
      get(url, this.filterToTable);
  }
}

var tranActivity = new ActivityTable();
tranActivity.getTableData("/users/accounts/transactions");

//# sourceMappingURL=app.js.map
