/// <reference path="./jquery.d.ts" />
import $ = require("jquery");
import TagList from "./TagList";
import TransactionTable from "./TransactionTable";
import Total from "./Total";
import Overlay from "./Overlay";
import Dropdown from "./Dropdown";
import TransactionForm from "./TransactionForm";
import AccountForm from "./AccountForm";

$(document).ready(() => {
  const tagListWidget = new TagList();
  tagListWidget.openTagList();

  const addButton = new Dropdown("addButton", "addOptions");
  addButton.init();

  const totalsWidget = new Total();
  totalsWidget.getAllTotals();

  const transactionWidget = new TransactionTable();
  transactionWidget.getTransactions();

  const accountOverlay = new Overlay("newAccountOverlay");
  accountOverlay.openToggle("addAccountButton", () => {

  });
  accountOverlay.closeToggle("closeNewAccount");

  const transactionForm = new TransactionForm("#newTransaction");

  const transactionOverlay = new Overlay("newTransactionOverlay");
  transactionOverlay.openToggle("addTransactionButton", () => {
    transactionForm.init("addLoader");
  });
  transactionForm.submitTransaction("/transactions",
  transactionOverlay.overlay,
  "transactionLoader");

  transactionOverlay.closeToggle("closeNewTransaction");

  const accountForm = new AccountForm("#newAccount");
  accountForm.submitAccount("/accounts", accountOverlay.overlay, "accountLoader");

  const budgetOverlay = new Overlay("newBudgetOverlay");
  budgetOverlay.openToggle("addBudgetButton", () => {

  });
  budgetOverlay.closeToggle("closeNewBudget");
});
