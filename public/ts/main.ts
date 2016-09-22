/// <reference path="./jquery.d.ts" />
import $ = require("jquery");
import TagList from "./components/taglist";
import TransactionTable from "./widgets/transactiontable";
import Total from "./widgets/total";
import Dropdown from "./components/dropdown";
import TransactionForm from "./forms/transactionform";
import AccountList from "./components/accountlist";

$(document).ready(() => {
  const tagList = new TagList("tagListButton", "tagList", "tagListTitle");
  tagList.openList("/tags");
  tagList.createItem();

  const accountList = new AccountList("accountListButton", "accountList", "accountListTitle");
  accountList.openList("/accounts")
  accountList.createItem();

  const addButton = new Dropdown("addButton", "addOptions");
  addButton.init();

  const totalsWidget = new Total();
  totalsWidget.getAllTotals();

  const transactionWidget = new TransactionTable();
  transactionWidget.init();

  const transactionForm = new TransactionForm("#newTransaction");
  transactionForm.init();

});
