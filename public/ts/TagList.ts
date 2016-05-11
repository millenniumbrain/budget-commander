/// <reference path="./jquery.d.ts" />
import $ = require("jquery");

export default class TagList {
  constructor() {

  }

  public openTagList() {
    const tagList: HTMLElement = document.getElementById("tagList");
    tagList.addEventListener("click", () => {

      const tagsList: HTMLElement = document.getElementById("tagsList");
      if (tagsList.getAttribute("class") === "slide-right") {
        tagList.setAttribute("class", "");
        tagsList.setAttribute("class", "slide-left");
      } else {
        $("#tagListSpinner").show().css( "display", "block !important");
        $.get('/totals/budgets', this.generateTags)
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
    let tagList: HTMLElement = document.getElementById("tagList");
  }

  private generateTags() {
    let tagsList: HTMLElement = document.getElementById("tagsList");
  }
}
