/// <reference path="../jquery.d.ts" />
import $ = require("jquery");

export default class ItemList {
  public button: HTMLElement;
  public list: HTMLElement;
  public listTitle: HTMLElement;
  public editMode: boolean;
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
          this.button.setAttribute("class", "active");
          this.list.setAttribute("class", "slide-right");
        })
      }

    }, false);
  }

  public createItem(callback?: () => any) : void {
    let addItem = <HTMLElement>document.getElementById(this.addButtonId);
    let addItemContainer = <HTMLElement>document.getElementById(this.addButtonId).parentElement;
    // when clicked set content to editable
    addItem.addEventListener("click", () => {
      let newItem = document.createElement("li");
      newItem.setAttribute("class", "list-item");
      let itemName = document.createElement("span");
       itemName.setAttribute("class", "item-name");
      let itemTotal = document.createElement("span")
      itemTotal.setAttribute("class", "item-total");
      newItem.appendChild(itemName);
      newItem.appendChild(itemTotal);
      
      itemName.setAttribute("contenteditable", "true");
      itemName.focus();
      // when the "Enter/Return" is pressed (keyCode 8) set content editable to false
      itemName.addEventListener("keydown", (event: KeyboardEvent) => {
        if (itemName.innerHTML.length > 0 && event.keyCode == 9) {
          itemName.setAttribute("contenteditable", "false");
          itemTotal.setAttribute("contenteditable", "true");
          itemTotal.focus();
          event.preventDefault();
        } else if (event.keyCode == 13) {
          itemName.setAttribute("contenteditable", "false");
          itemTotal.setAttribute("contenteditable", "true");
          itemTotal.focus();
          event.preventDefault();         
        }
      }, false);
      
      itemTotal.addEventListener("keydown", (event: KeyboardEvent) => {
        itemTotal.setAttribute("contenteditable", "true");
        if (itemTotal.innerHTML.length > 0 && event.keyCode == 9) {
            if (/([+-]?([0-9]*[.])?[0-9])/.test(itemTotal.innerHTML)) {
              itemTotal.setAttribute("contenteditable", "false");
              this.parseAmount(itemTotal, itemTotal.innerHTML);
              itemTotal.blur();
            } else {
              itemTotal.setAttribute("style", "border: 1px solid red; outline: 0px solid transparent;");
              itemTotal.innerHTML = "";
            }
        } else if (event.keyCode == 13) {
            if (/([+-]?([0-9]*[.])?[0-9])/.test(itemTotal.innerHTML)) {
              itemTotal.setAttribute("contenteditable", "false");
              this.parseAmount(itemTotal, itemTotal.innerHTML);
              itemTotal.blur();
            } else {
              itemTotal.setAttribute("style", "border: 1px solid red; outline: 0px solid transparent;");
              itemTotal.innerHTML.replace(/\\u000D/g,'');
              itemTotal.innerHTML = "";
            }
        }
      }, false);
      addItemContainer.insertAdjacentElement('beforebegin', newItem);
    }, false);
  }
  
  public parseAmount(el: HTMLSpanElement, amount: any) : void  {
      if (amount >= "0") {
          el.setAttribute("class", "green-amount item-total");
          // will return a number like + 23.45
          el.innerHTML = `+ ${amount}`
      } else {
          let absAmount: string = Math.abs(amount).toString();
          el.setAttribute("class", "red-amount item-total");
          // will return a number like - 30.30
          el.innerHTML = `- ${absAmount}`;
      }
  }
  
  public editItems() : void {
    
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
