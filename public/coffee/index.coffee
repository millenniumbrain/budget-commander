Transaction = require './transaction'
Total = require './total'
Overlay = require './overlay'

'use strict'

transactionTable = new Transaction()
transactionTable.getTransactions()

totalList = new Total()
totalList.getTotals()
