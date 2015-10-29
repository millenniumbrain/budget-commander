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
  var triggerOverlay = function(element) {
    var el = document.getElementById(element);
    // if overlay is invisibe make visible, if visible make invisible
    el.style.visibility = (el.style.visibility == "visible") ? "hidden" : "visible";
  };

  var addTransactionItem = document.getElementById("addTransactionItem");
  addTransactionItem.addEventListener("click", function() {
    triggerOverlay("transactionOverlay");
  }, false);

  var closeTranOverlay = document.getElementById("closeTranOverlay");
  closeTranOverlay.addEventListener("click", function() {
    triggerOverlay("transactionOverlay");
  }, false);

  var addAccountItem = document.getElementById("addAccountItem");
  addAccountItem.addEventListener("click", function() {
    triggerOverlay("accountOverlay");
  }, false);
})();


(function() {
  var floatToDecimal = function(number) {
    // parse return floats with scientific notation
    var numberFloated = parseFloat(number);

    return numberFloated;
  };

  var addTransactions = function(data) {
    var transactionActivity = document.querySelector("#activity tbody");

    // map the transaction array
    data.map(function(transaction) {
      var row = document.createElement("tr");
      row.setAttribute("class", "transaction");
      var date = document.createElement("td");
      var amount = document.createElement("td");
      var description = document.createElement("td");
      var tags = document.createElement("td");
      var accountName = document.createElement("td");
      if (transaction.amount < 0) {
        // change amount color if expense
        amount.innerHTML = floatToDecimal(transaction.amount);
        amount.setAttribute("class", "amount expense");
      } else if(transaction.amount > 0) {
        // add a plus symbol to amount if positive number
        amount.setAttribute("class", "amount income");
        amount.innerHTML = "+" + floatToDecimal(transaction.amount);
      } else {
        amount.innerHTML = floatToDecimal(transaction.amount);
      }
      // add classes to change table alignments
      date.setAttribute("class", "date");
      date.innerHTML = transaction.created_at;
      description.setAttribute("class", "description");
      description.innerHTML = transaction.description;
      tags.setAttribute("class", "tag");
      tags.innerHTML = "Entertaiment";
      accountName.setAttribute("class", "account");
      accountName.innerHTML = transaction.account_id;
      row.appendChild(date);
      row.appendChild(amount);
      row.appendChild(description);
      row.appendChild(tags);
      row.appendChild(accountName);
      transactionActivity.appendChild(row);
    });
  };

  var request = new XMLHttpRequest();

  request.open("GET", "/users/accounts/transactions", true);

  request.onload = function() {
    if (request.status >= 200 && request.status < 400) {
      var data = JSON.parse(request.responseText);
      addTransactions(data);
    }
    else {

    }
  };

  request.onerror = function() {

  };
  request.send();
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
        label.innerHTML = key;
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

  var request = new XMLHttpRequest();

  request.open("GET", "/users/accounts/transactions/total", true);

  request.onload = function() {
    if (request.status >= 200 && request.status < 400) {
      var data = JSON.parse(request.responseText);
      addTotals(data);
    }
    else {

    }
  };

  request.onerror = function() {

  };
  request.send();
})();
