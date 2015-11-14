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
