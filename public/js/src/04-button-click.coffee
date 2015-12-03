
class ButtonClick
  constructor: (button, elTarget) ->
    @button = document.getElementById(button)
    @elTarget = document.getElementById(elTarget)
    @buttonClicked = false

  click: () =>
    if @buttonClicked == false
      @elTarget.style.display = "block"
      @buttonClicked = true
      true
    else if @buttonClicked == true
      @elTarget.style.display = "none"
      @buttonClicked = false
      true

  init: () =>
    @button.addEventListener("click", this.click, false)

addButton = new ButtonClick("addButton", "addOptions")
addButton.init()
