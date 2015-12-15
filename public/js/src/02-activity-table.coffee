class ActivityTable
    filterToTable: (data) =>
      tranActivity = document.querySelector("#activity tbody")
      # map transaction array
      data.map((transaction) ->
        row = document.createElement("tr")
        row.setAttribute("class", "trasanaction")
        date = document.createElement("td")
        amount = document.createElement("td")
        description = document.createElement("td")
        tags = document.createElement("td")
        accountName = document.createElement("td")
        # add classes to change table alignments
        Helpers.parseAmount(amount, transaction.type, transaction.amount)
        date.setAttribute("class", "date")
        date.innerHTML = transaction.date
        description.setAttribute("class", "description")
        description.innerHTML = transaction.description
        tags.setAttribute("class", "tag")
        tags.innerHTML = "Entertaiment"
        accountName.setAttribute("class", "account");
        accountName.innerHTML = transaction.account_id
        # append columns to rows
        row.appendChild(date)
        row.appendChild(amount)
        row.appendChild(description)
        row.appendChild(tags)
        row.appendChild(accountName)
        tranActivity.appendChild(row)
      );

    getTableData: (url) =>
      $.get(url, this.filterToTable)

tranActivity = new ActivityTable()
tranActivity.getTableData("/api/v1/transactions")
