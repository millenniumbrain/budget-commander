/// <reference path="../jquery.d.ts" />
import $ = require("jquery");
import { Helper } from "../helper";

export default class ItemList {
  public button: HTMLElement;
  public list: HTMLElement;
  public listTitle: HTMLElement;
  public addButtonId: string;

  constructor(buttonId: string, listId: string, titleId: string) {
    this.button = <HTMLElement>document.getElementById(buttonId);
    this.list = <HTMLElement>document.getElementById(listId);
    this.listTitle = <HTMLElement>document.getElementById(titleId);
  }

  public openList(url: string) : void {
    this.button.addEventListener("click", () => {
      // set slide animations depending on list state
      if (this.list.getAttribute("class") === "slide-right") {
        this.list.setAttribute("class", "");
        this.button.setAttribute("class", "");
        this.list.setAttribute("class", "slide-left");
      } else {
        $.get(url, (data) =>{
          this.generateItems(data);
        })
        .fail( () => {

        })
        .done( () => {
        })

        this.button.setAttribute("class", "active");
        this.list.setAttribute("class", "slide-right");
      }

    }, false);
  }

  public createItem() : void {
    let addItem = <HTMLElement>document.getElementById(this.addButtonId);
    let addItemContainer = <HTMLElement>document.getElementById(this.addButtonId).parentElement;
    // when clicked set content to editable
    addItem.addEventListener("click", () => {
      let newItem = document.createElement("li");
      newItem.setAttribute("contenteditable", "true");
      newItem.setAttribute("class", "list-item");
      // when the "Enter/Return" is pressed (keyCode 8) set content editable to false
      newItem.addEventListener("keydown", (event: KeyboardEvent) => {
        if (event.keyCode == 13) {
          newItem.setAttribute("contenteditable", "false");
          // TODO: add ajax post event here
        }
      });
      addItemContainer.insertAdjacentElement('beforebegin', newItem);
    });
  }

  public generateItems(items: any) : void {
    const nodes = <NodeListOf<HTMLElement>>this.list.getElementsByTagName('li');
    // add more nodes if new tags are created do not
    // count title and button as anode
    if (items.length > nodes.length - 2) {
      for (let i = 0; i < items.length; i++) {
        let item = document.createElement("li");
        let itemName = document.createElement("span");
        itemName.setAttribute("class", "item-name");
        let total = document.createElement("span");
        total.setAttribute("class", "item-total");
        itemName.innerHTML = items[i]["name"];
        if (items[i]["transaction_total"] >= 0) {
          total.innerHTML = `+ ${items[i]["transaction_total"]}`
          total.setAttribute("class", "item-total green-amount");
        } else if (items[i]["transaction_total"] === undefined || null) {
          total.innerHTML = "";
        } else {
          total.innerHTML = `- ${Math.abs(items[i]["transaction_total"])}`
          total.setAttribute("class", "item-total red-amount");
        }
        item.appendChild(itemName);
        item.appendChild(total);
        item.setAttribute("class", "list-item")
        item.setAttribute("item-id", items[i]["uid"]);
        this.listTitle.insertAdjacentElement('afterend', item);
      }
    }
    // HACK: rescope JavaScript's `this` keyword
    () => {
      this.generateItems(items);
    }
  }
}
