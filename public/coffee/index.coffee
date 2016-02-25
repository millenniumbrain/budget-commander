DropdownMenu = require './dropdown'
Overlay = require './overlay'
Total = require './total'
Transaction = require './transaction'



'use strict'

transactionTable = new Transaction()
transactionTable.getTransactions()

totalList = new Total()
totalList.getTotals()

addItemMenu = new DropdownMenu("addButton", "addOptions")
addItemMenu.init()


newAccountOverlay = new Overlay("accountOverlay", "addAccountButton", "closeNewAccount")
newAccountOverlay.init()
