budgetFilter = (data) ->
  budgetLabels = [];
  budgetValues = [];
  for i in [0...data.length]
    budgetLabels.push(data[i].name);
    budgetValues.push(data[i].spending_limit);

  budgets =
    labels: budgetLabels
    series: budgetValues

  options =
    labelInterpolationFnc: (value) ->
      value
    chartPadding: 30
    labelDirection: 'explode'
    labelOffset: 50
    donut: true


  new Chartist.Pie('#overallBudgetChart', budgets, options);

$.get("/api/v1/totals/budgets", budgetFilter)
