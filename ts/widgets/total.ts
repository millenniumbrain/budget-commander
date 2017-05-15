
export default class Total {
    public getAllTotals() : void {
        $.get('/totals', this.parseAllTotals)
        .fail( () => {

        })
        .done( () => {
        });
    }

    private parseAllTotals = (data: any) : void => {
        const networth: HTMLElement = <HTMLElement>document.getElementById("networthTotal");
        const incomeTotal: HTMLElement = <HTMLElement>document.getElementById("incomeTotal");
        const expenseTotal: HTMLElement = <HTMLElement>document.getElementById("expenseTotal");

        this.parseTotal(networth, data.networth);
        this.parseTotal(incomeTotal, data.income);
        this.parseTotal(expenseTotal, data.expense);
    }

    // parse total and format it
    private parseTotal(el: HTMLElement, amount: any) {
        if (amount >= "0") {
            el.setAttribute("class", "green-amount total-amount");
            // will return a number like + 23.45
            el.innerHTML = `+ ${amount}`
        } else {
            let absAmount: string = Math.abs(amount).toString();
            el.setAttribute("class", "red-amount total-amount");
            // will return a number like - 30.30
            el.innerHTML = `- ${absAmount}`;
        }
      }
}
