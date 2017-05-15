export default class Transaction {
  public id: string;
  public date: string;
  public type: string;
  public amount: string;
  public desc: string;
  public tags: Array<String> = [];
  public accountName: string

  constructor() {

  }
}
