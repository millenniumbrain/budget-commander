DropdownMenu = require './dropdown'
Overlay = require './overlay'
Total = require './total'
Transaction = require './transaction'
TransactionForm = require './transactionForm'
AccountForm = require './accountForm'
$ = require 'jquery'

'use strict'

transactionTable = new Transaction()
transactionTable.getTransactions()

totalList = new Total()
totalList.getTotals()

addItemMenu = new DropdownMenu("addButton", "addOptions")
addItemMenu.init()


newAccountOverlay = new Overlay("newAccountOverlay", "addAccountButton", "closeNewAccount")
newAccountOverlay.init()

newTransactionOverlay = new Overlay("newTransactionOverlay", "addTransactionButton",
  "closeNewTransaction");
newTransactionOverlay.init()

newBudgetOverlay = new Overlay("newBudgetOverlay", "addBudgetButton",
"closeNewBudget");
newBudgetOverlay.init()

newAccount = new AccountForm("#newAccount")
newAccount.submit()

newTransaction = new TransactionForm("#newTransaction")
newTransaction.init()
newTransaction.submit()
