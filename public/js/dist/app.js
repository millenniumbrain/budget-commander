var Helpers;

Helpers = (function() {
  function Helpers() {}

  Helpers.setAmountClass = function(el, amount) {
    if (amount >= 0) {
      el.setAttribute("class", "income");
      return el.innerHTML = "+" + amount;
    } else {
      el.setAttribute("class", "expense");
      return el.innerHTML = amount;
    }
  };

  Helpers.floatToDecimal = function(number) {
    var decimalNumber;
    return decimalNumber = parseFloat(number);
  };

  Helpers.parseAmount = function(el, type, amount) {
    if (type === "expense") {
      el.setAttribute("class", "amount expense");
      return el.innerHTML = Helpers.floatToDecimal(amount);
    } else {
      el.setAttribute("class", "amount income");
      return el.innerHTML = "+" + Helpers.floatToDecimal(amount);
    }
  };

  return Helpers;

})();

var ActivityTable, tranActivity,
  bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

ActivityTable = (function() {
  function ActivityTable() {
    this.getTableData = bind(this.getTableData, this);
    this.filterToTable = bind(this.filterToTable, this);
  }

  ActivityTable.prototype.filterToTable = function(data) {
    var tranActivity;
    tranActivity = document.querySelector("#activity tbody");
    return data.map(function(transaction) {
      var accountName, amount, date, description, row, tags;
      row = document.createElement("tr");
      row.setAttribute("class", "trasanaction");
      date = document.createElement("td");
      amount = document.createElement("td");
      description = document.createElement("td");
      tags = document.createElement("td");
      accountName = document.createElement("td");
      Helpers.parseAmount(amount, transaction.type, transaction.amount);
      date.setAttribute("class", "date");
      date.innerHTML = transaction.date;
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
      return tranActivity.appendChild(row);
    });
  };

  ActivityTable.prototype.getTableData = function(url) {
    return $.get(url, this.filterToTable);
  };

  return ActivityTable;

})();

tranActivity = new ActivityTable();

tranActivity.getTableData("/users/transactions");

var Overlay, addAccountItem, addBudgetItem, addTranItem,
  bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

Overlay = (function() {
  function Overlay(overlay, openTrigger, closeTrigger) {
    this.init = bind(this.init, this);
    this.triggerOverlay = bind(this.triggerOverlay, this);
    this.overlay = document.getElementById(overlay);
    this.openTrigger = document.getElementById(openTrigger);
    this.closeTrigger = document.getElementById(closeTrigger);
  }

  Overlay.prototype.triggerOverlay = function() {
    if (this.overlay.style.visibility === "visible") {
      return this.overlay.style.visibility = "hidden";
    } else {
      return this.overlay.style.visibility = "visible";
    }
  };

  Overlay.prototype.init = function() {
    this.openTrigger.addEventListener("click", this.triggerOverlay, false);
    this.closeTrigger.addEventListener("click", this.triggerOverlay, false);
    return true;
  };

  return Overlay;

})();

addTranItem = new Overlay("transactionOverlay", "addTransactionItem", "closeTranOverlay");

addTranItem.init();

addAccountItem = new Overlay("accountOverlay", "addAccountItem", "closeAccountOverlay");

addAccountItem.init();

addBudgetItem = new Overlay("budgetOverlay", "addBudgetItem", "closeBudgetOverlay");

addBudgetItem.init();

var ButtonClick, addButton,
  bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

ButtonClick = (function() {
  function ButtonClick(button, elTarget) {
    this.init = bind(this.init, this);
    this.click = bind(this.click, this);
    this.button = document.getElementById(button);
    this.elTarget = document.getElementById(elTarget);
    this.buttonClicked = false;
  }

  ButtonClick.prototype.click = function() {
    if (this.buttonClicked === false) {
      this.elTarget.style.display = "block";
      this.buttonClicked = true;
      return true;
    } else if (this.buttonClicked === true) {
      this.elTarget.style.display = "none";
      this.buttonClicked = false;
      return true;
    }
  };

  ButtonClick.prototype.init = function() {
    return this.button.addEventListener("click", this.click, false);
  };

  return ButtonClick;

})();

addButton = new ButtonClick("addButton", "addOptions");

addButton.init();

var budgetFilter;

budgetFilter = function(data) {
  var budgetLabels, budgetValues, budgets, i, j, options, ref;
  budgetLabels = [];
  budgetValues = [];
  for (i = j = 0, ref = data.length; 0 <= ref ? j < ref : j > ref; i = 0 <= ref ? ++j : --j) {
    budgetLabels.push(data[i].name);
    budgetValues.push(data[i].spending_limit);
  }
  budgets = {
    labels: budgetLabels,
    series: budgetValues
  };
  options = {
    labelInterpolationFnc: function(value) {
      return value;
    },
    chartPadding: 30,
    labelDirection: 'explode',
    labelOffset: 50,
    donut: true
  };
  return new Chartist.Pie('#overallBudgetChart', budgets, options);
};

$.get("/users/budgets", budgetFilter);

var Form, tranForm,
  bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

Form = (function() {
  function Form(form) {
    this.submit = bind(this.submit, this);
    this.form = $(form);
  }

  Form.prototype.submit = function() {
    this.form.on("submit", function(event) {
      var formData;
      event.preventDefault();
      formData = JSON.stringify($(this).serializeArray());
      console.log(formData);
      $.post("/users/transactions", formData).success(function(formData) {
        console.log("Successfully Loaded!");
        return true;
      });
      return true;
    });
    return true;
  };

  return Form;

})();

tranForm = new Form("#formTransactions");

tranForm.submit();

var addTotals;

addTotals = function(data) {
  var sumTotals;
  sumTotals = document.querySelector(".sum-total");
  return _.forEach(data, function(value, key) {
    var flexCell, label, total;
    total = document.createElement("h2");
    label = document.createElement("h3");
    flexCell = document.createElement("div");
    flexCell.setAttribute("class", "flex-cell");
    if (key === "expense") {
      label.innerHTML = "Monthly Expense";
      Helpers.setAmountClass(total, value);
      flexCell.appendChild(label);
      flexCell.appendChild(total);
      return sumTotals.appendChild(flexCell);
    } else if (key === "income") {
      label.innerHTML = "Monthly Income";
      Helpers.setAmountClass(total, value);
      flexCell.appendChild(label);
      flexCell.appendChild(total);
      return sumTotals.appendChild(flexCell);
    } else if (key === "networth") {
      label.innerHTML = "Net Worth";
      Helpers.setAmountClass(total, value);
      flexCell.appendChild(label);
      flexCell.appendChild(total);
      return sumTotals.appendChild(flexCell);
    } else if (key === "budget_balance") {
      label.innerHTML = "Budget Balance";
      Helpers.setAmountClass(total, value);
      flexCell.appendChild(label);
      flexCell.appendChild(total);
      return sumTotals.appendChild(flexCell);
    } else {
      label.innerHTML = key;
      Helpers.setAmountClass(total, value);
      flexCell.appendChild(label);
      flexCell.appendChild(total);
      return sumTotals.appendChild(flexCell);
    }
  });
};

$.get("/totals", addTotals);

//# sourceMappingURL=app.js.map
