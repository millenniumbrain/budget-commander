/// <reference path="../jquery.d.ts" />
import $ = require("jquery");
import { Helper } from "../helper";
import ItemList from "./itemlist";

export default class AccountList extends ItemList {
  public addButtonId: string = "addAccount";
  
  constructor(buttonId: string, listId: string, titleId: string) {
    super(buttonId, listId, titleId);
  }

  public openList(url: string) : void {
    super.openList(url);
  }
  
  public createItem() : void {
    super.createItem();
  }

  public generateItems(items: any) : void  {
    super.generateItems(items);
  }
}
