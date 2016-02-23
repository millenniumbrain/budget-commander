$ = require 'jquery'

class TransactionForm
  constructor() ->
    @dateRegExp = /(?:[A-Z]{1}[a-z]{2}\s\d{2}\s\d{4})/
    @amountRegUSD = /(?:\d+\.\d{2})/

  

module.exports = TransactionForm
