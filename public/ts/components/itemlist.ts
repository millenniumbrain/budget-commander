/// <reference path="../jquery.d.ts" />
import $ = require("jquery");
import { Helper } from "../helper";

export default class ItemList {
  public button: HTMLElement;
  public list: HTMLElement;
  public listTitle: HTMLElement;
  public addButton: HTMLElement;

  constructor(buttonId: string, listId: string, titleId: string) {
    this.button = <HTMLElement>document.getElementById(buttonId);
    this.list = <HTMLElement>document.getElementById(listId);
    this.listTitle = <HTMLElement>document.getElementById(titleId);
  }

  public init() {

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

  public createItems(addButtonId: string) : void {
    this.addButton = <HTMLElement>document.getElementById(addButtonId);
  }

  public generateItems(items: any) : void {
    const nodes = <NodeListOf<HTMLElement>>this.list.getElementsByTagName('li');
    if (items.length > nodes.length - 2) {
      for (let i = 0; i < items.length; i++) {
        let item = document.createElement("li");
        item.setAttribute("class", "list-item")
        item.setAttribute("item-id", items[i]["uid"]);
        item.innerHTML = items[i]["name"];
        Helper.insertAfter(item, this.listTitle);
      }
    }
    // HACK: rescope JavaScript's `this` keyword
    () => {
      this.generateItems(items);
    }
  }
}
