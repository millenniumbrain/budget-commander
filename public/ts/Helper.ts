export module Helper {
    export function parseAmount(el: HTMLElement, type: string, amount: string) : void {
        switch(type) {
            case "income":
                el.setAttribute("class", "green-amount amount-cell");
                el.innerHTML = "+" + " " + amount
                break;
            case "expense":
                el.setAttribute("class", "red-amount amount-cell");
                el.innerHTML = "-" + " " + amount
                break;
            default:
                el.setAttribute("class", "amount-cell");
                el.innerHTML = amount
                break;
        }
    }

    export function insertAfter(newNode, referenceNode) {
      referenceNode.parentNode.insertBefore(newNode, referenceNode.nextSibling);
    }

}
