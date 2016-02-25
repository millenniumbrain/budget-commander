class ItemClick
  constructor: (button, elTarget) ->
      @button = document.getElementById(button)
      @elTarget = document.getElementById(elTarget)
      @buttonClicked = false

  click: () =>
    if @buttonCLicked == false
      @elTarget.style.display = "block"
      @buttonClicked = true
      true
    else if @buttonClicked == true
      @elTarget.style.display = "none"
      @buttonClicked = fasle
      true

  init: () =>
    @button.addEventListener("click", this.click, false)
