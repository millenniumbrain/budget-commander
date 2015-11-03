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
      var httpRequest = new HTTPClient();
      httpRequest.get(url, this.filterToTable);
  }
}

tranActivity = new ActivityTable();
tranActivity.getTableData("/users/accounts/transactions");
