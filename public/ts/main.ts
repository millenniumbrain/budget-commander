/// <reference path="./jquery.d.ts" />
import $ = require("jquery");
import TagList from "./TagList";
import TransactionTable from "./TransactionTable";
import Total from "./Total";
import Overlay from "./Overlay";
import Dropdown from "./Dropdown";
import BudgetWidget from "./BudgetWidget";

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
  accountOverlay.openToggle("addAccountButton");
  accountOverlay.closeToggle("closeNewAccount");

  const transactionOverlay = new Overlay("newTransactionOverlay");
  transactionOverlay.openToggle("addTransactionButton");
  transactionOverlay.closeToggle("closeNewTransaction");

  const budgetOverlay = new Overlay("newBudgetOverlay");
  budgetOverlay.openToggle("addBudgetButton");
  budgetOverlay.closeToggle("closeNewBudget");

  const budgetWidget = new BudgetWidget("budgetPieChart");
  budgetWidget
});
