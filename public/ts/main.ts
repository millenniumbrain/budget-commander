/// <reference path="./jquery.d.ts" />
import $ = require("jquery");
import TransactionTable from "./TransactionTable";
import Total from "./Total";
import Overlay from "./Overlay";
import Dropdown from "./Dropdown";

$(document).ready(() => {
  const addButton = new Dropdown("addButton", "addOptions");
  addButton.init();
  
  const totalsWidget = new Total();
  totalsWidget.getAllTotals();

  const transactionWidget = new TransactionTable();
  transactionWidget.getTransactions(); 

  const accountOverlay = new Overlay("newAccountOverlay");
  accountOverlay.openToggle("addAccountButton");
  accountOverlay.closeToggle("closeNewAccount");
});