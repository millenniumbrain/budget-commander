/// <reference path="./jquery.d.ts" />
import $ = require("jquery");
import TagList from "./components/taglist";
import TransactionTable from "./widgets/transactiontable";
import Total from "./widgets/total";
import Dropdown from "./components/dropdown";
import TransactionForm from "./forms/transactionform";
import AccountForm from "./forms/accountform";

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


  const accountForm = new AccountForm("#newAccount");
  accountForm.init("addAccountButton", "closeNewAccount");
  accountForm.submitAccount();
});
