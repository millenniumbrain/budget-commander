/*global _*/
'use strict';

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
      if(key == "expenses") {
        label.innerHTML = "Monthly Expenses";
        total.setAttribute("class", "expense");
        total.innerHTML = value;
        flexCell.appendChild(label);
        flexCell.appendChild(total);
        sumTotals.appendChild(flexCell);
      } else if (key === "networth") {
        if(value > 0) {
          label.innerHTML = "Net Worth";
          total.setAttribute("class", "income");
          total.innerHTML = "+" + value;
          flexCell.appendChild(label);
          flexCell.appendChild(total);
          sumTotals.appendChild(flexCell);
        } else {
          label.innerHTML = "Net Worth";
          total.setAttribute("class", "expense");
          total.innerHTML =  value;
          flexCell.appendChild(label);
          flexCell.appendChild(total);
          sumTotals.appendChild(flexCell);
        }
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
