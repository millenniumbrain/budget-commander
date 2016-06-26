/// <reference path="./jquery.d.ts" />
import $ = require("jquery");
import { Helper } from "./Helper";

export default class TagList {
  constructor() {}

  public openTagList() {
    const tagList: HTMLElement = document.getElementById("tagList");

    tagList.addEventListener("click", () => {

      const tagsList: HTMLElement = document.getElementById("tagsList");
      if (tagsList.getAttribute("class") === "slide-right") {
        tagList.setAttribute("class", "");
        tagsList.setAttribute("class", "slide-left");
      } else {
        $("#tagListSpinner").css( "display", "block !important");
        $.get('/tags', this.generateTags)
        .fail( () => {

        })
        .done( () => {

          $("#tagListSpinner").hide();
        })
        tagList.setAttribute("class", "active");
        tagsList.setAttribute("class", "slide-right");
      }

    }, false);

  }

  public updateTags() {
    const tagList: HTMLElement = document.getElementById("tagList");
  }

  private generateTags(tags: any) {
    const tagTitle: Element = document.querySelector(".tag-list-title");
    const tagItems = document.getElementById("tagsList").getElementsByTagName('li');
    if (tags.length > tagItems.length) {
      for (let i = 0; i < tags.length; i++) {
        let tagItem = document.createElement("li");
        tagItem.setAttribute("item-id", tags[i]["_id"]);
        tagItem.innerHTML = tags[i]["name"];
        Helper.insertAfter(tagItem, tagTitle);
      }
    }
  }
}
