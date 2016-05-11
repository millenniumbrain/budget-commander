/// <reference path="./jquery.d.ts" />
/// <reference path="./chart.d.ts" />
import $ = require("jquery");

export default class BudgetWidget {
    constructor(private context: string) {
        const budgetData: JQueryPromise<any> = $.get('/totals/budgets', this.generateData)
         .fail()
         .done();
    }

    private generateData(data: any) {
        //console.log(data);

        let dataset: Object = {};
        for (let i = 0; i < data.length; i++) {
            dataset = {

            }
        }
    }

    private generateLabels(data: any) {
        let labels: string[] = [];
        for (let i = 0; i < data.length; i++) {
            labels.push(data[i]);
        }

        return labels;
    }


    public drawChart() {
        let ctx: HTMLCanvasElement =  <HTMLCanvasElement>document.getElementById(this.context);
    }

}
