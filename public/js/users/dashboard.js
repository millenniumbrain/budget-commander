/*global _*/

var floatToDecimal = function(number) {
  // parse return floats with scientific notation
  var numberFloated = parseFloat(number);

  return numberFloated;
};

var addTransactions = function(data) {
  var transactionActivity = document.querySelector("#activity tbody");

  data.map(function(transaction) {
    var row = document.createElement("tr");
    row.setAttribute("class", "transaction");
    var date = document.createElement("td");
    var amount = document.createElement("td");
    var description = document.createElement("td");
    var tags = document.createElement("td");
    var accountName = document.createElement("td");
    if (transaction.amount < 0) {
      amount.innerHTML = floatToDecimal(transaction.amount);
      amount.setAttribute("class", "expense");
      amount.innerHTML = floatToDecimal(transaction.amount);
    } else if(transaction.amount > 0) {
      amount.setAttribute("class", "income");
      amount.innerHTML = "+" + floatToDecimal(transaction.amount);
    } else {
      amount.innerHTML = floatToDecimal(transaction.amount);
    }
    date.setAttribute("class", "date");
    date.innerHTML = transaction.created_at;
    description.setAttribute("class", "description");
    description.innerHTML = transaction.description;
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

(function() {

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

var addTotals = function(data) {
  var sumTotals = document.querySelector(".sum-total");
  _.forEach(data, function(value, key) {
    var total = document.createElement("h2");
    var label = document.createElement("h3");
    var flexCell = document.createElement("div");

    flexCell.setAttribute("class", "flex-cell");

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

(function() {

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
