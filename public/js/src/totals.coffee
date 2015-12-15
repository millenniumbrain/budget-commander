addTotals = (data) ->
  sumTotals = document.querySelector(".sum-total")
  # we want the key and the value to create a label and display data
  _.forEach(data, (value, key) ->
      total = document.createElement("h2");
      label = document.createElement("h3");
      flexCell = document.createElement("div");

      flexCell.setAttribute("class", "flex-cell");

      # collect and append totals
      if key == "expense"
        label.innerHTML = "Monthly Expense"
        Helpers.setAmountClass(total, value)
        flexCell.appendChild(label)
        flexCell.appendChild(total)
        sumTotals.appendChild(flexCell)
      else if key == "income"
        label.innerHTML = "Monthly Income"
        Helpers.setAmountClass(total, value)
        flexCell.appendChild(label)
        flexCell.appendChild(total)
        sumTotals.appendChild(flexCell)
      else if key == "networth"
        label.innerHTML = "Net Worth"
        Helpers.setAmountClass(total, value)
        flexCell.appendChild(label)
        flexCell.appendChild(total)
        sumTotals.appendChild(flexCell)
      else if key == "budget_balance"
        label.innerHTML = "Budget Balance"
        Helpers.setAmountClass(total, value)
        flexCell.appendChild(label)
        flexCell.appendChild(total)
        sumTotals.appendChild(flexCell)
      else
        label.innerHTML = key
        Helpers.setAmountClass(total, value)
        flexCell.appendChild(label)
        flexCell.appendChild(total)
        sumTotals.appendChild(flexCell)
  );

$.get("/totals", addTotals)
