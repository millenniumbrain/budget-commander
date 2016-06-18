/// <reference path="./jquery.d.ts" />
import $ = require("jquery");
import Message from "./Message";
class Login {
  public $form: JQuery = $("#login");
  private url: string;

  constructor(url: string) {
    this.url = url;
  }

  public submit() : void {
    //let loader: HTMLElement = document.getElementById("accountLoader");

    this.$form.on("submit", (event: Event) => {
      event.preventDefault();
      //loader.style.visibility = "visible";
      let formData: string = JSON.stringify($(this.$form).serializeArray());
      console.log(formData);
      $.post(this.url, formData)
      .fail( (req) => {
      //  loader.style.visibility = "hidden";
      })
      .done( (response) => {
      //  loader.style.visibility = "hidden";
        console.log(response);
      })
    });
  }
}

let loginForm = new Login("/login");
loginForm.submit();
