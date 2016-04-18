module Helper {
    export function floatToDecimal(float: string) {
        const decimalNumber:string = parseFloat(float).toFixed(2);
        return decimalNumber;
    }
    
    export function parseAmount(el: HTMLElement, type: string, amount: string) {
        switch(type) {
            case "income":
                el.setAttribute("class", "green-amount amount-cell");
                el.innerHTML = "-" + this.floatToDecimal(amount);
                break;
            case "expense":
                el.setAttribute("class", "red-amount amount-cell");
                el.innerHTML = "-" + this.floatToDecimal(amount);
                break;
            default:
                el.setAttribute("class", "amount-cell");
                el.innerHTML = this.floatToDecimal(amount);
                break;
        }
    }
    
    export function parseTotal(el: HTMLElement, amount: string) {
        if (amount >= "0") {
            el.setAttribute("class", "green-amount total-amount");
            el.innerHTML = "+" + this.floatToDecimal(amount);
        } else {
            el.setAttribute("class", "red-amount total-amount");
            el.innerHTML = "-" + this.floatToDecimal(amount);         
        }
    }
}