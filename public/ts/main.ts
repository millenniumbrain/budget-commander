/// <reference path="./jquery.d.ts" />
import $ = require("jquery");
import TagList from "./TagList";
import TransactionTable from "./TransactionTable";
import Total from "./Total";
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
  transactionWidget.init();

  const transactionForm = new TransactionForm("#newTransaction");
  transactionForm.init();
  transactionForm.submitTransaction();


  const accountForm = new AccountForm("#newAccount");
  accountForm.init("addAccountButton", "closeNewAccount");
  accountForm.submitAccount();
});
