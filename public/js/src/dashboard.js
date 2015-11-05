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