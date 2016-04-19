/// <reference path="./jquery.d.ts" />
import $ = require("jquery");
import { TransactionTable } from "./TransactionTable";
import { Total } from "./Total";

const TotalWidget = new Total();
TotalWidget.getAllTotals();

const transactionWidget = new TransactionTable();
transactionWidget.getTransactions(); 