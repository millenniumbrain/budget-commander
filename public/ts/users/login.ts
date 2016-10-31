/// <reference path="../jquery.d.ts" />
import $ = require("jquery");
import MessageBox from "../components/messagebox";

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
      $.ajax({
        headers: {
          'Content-Type': 'application/json;charset=utf-8'
        }
        url: this.url, 
        type: "POST", 
        data: formData
      })
      .fail( (req) => {
        const error = new MessageBox("login", req.responseJSON["msg"]);
        error.showError();
        error.close(5);
      })
      .done( (response) => {
      //  loader.style.visibility = "hidden";
        const success = new MessageBox("login", response["msg"]);
        success.showSuccess();
        success.close(5);
        window.location.href = "/dashboard";
      })
    });
  }
}

let loginForm = new Login("/login");
loginForm.submit();
