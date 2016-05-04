/// <reference path="./jquery.d.ts" />
import $ = require("jquery");

export default class Receipt {
    constructor() {
        
    }
    
    public getData() {
        $.get('/api/v1/receipts' this.parseData)
        .fail( () => {
            
        })
        .done( () => {
            
        });
    }
    
    private parseData(data: any) {
        
    }
}