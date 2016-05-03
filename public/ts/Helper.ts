export module Helper {
    export function floatToDecimal(float: string) {
        const decimalNumber:string = parseFloat(float).toFixed(2);
        return decimalNumber;
    }
    
    export function parseAmount(el: HTMLElement, type: string, amount: string) {
        switch(type) {
            case "income":
                el.setAttribute("class", "green-amount amount-cell");
                el.innerHTML = "+" + " " + this.floatToDecimal(amount).toString();
                break;
            case "expense":
                el.setAttribute("class", "red-amount amount-cell");
                el.innerHTML = "-" + " " + this.floatToDecimal(amount).toString();
                break;
            default:
                el.setAttribute("class", "amount-cell");
                el.innerHTML = this.floatToDecimal(amount).toString();
                break;
        }
    }
    
}