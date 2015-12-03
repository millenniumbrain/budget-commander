addTotals = (data) ->
  sumTotals = document.querySelector(".sum-total")
  # we want the key and the value to create a label and display data
  for v, k in data
    console.log(k, v)

$.get("/users/total", addTotals)
