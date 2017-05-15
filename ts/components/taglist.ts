import ItemList from "./itemlist";

export default class TagList extends ItemList {
  public button: HTMLElement;
  public list: HTMLElement;
  public listTitle: HTMLElement;
  public addButtonId: string = "addTag";

  constructor(buttonId: string, listId: string, titleId: string) {
    super(buttonId, listId, titleId);
  }

  public openList(url: string) : void {
    super.openList(url);
  }
  
  public createItem() : void {
    super.createItem();    
  }

  public generateItems(items: any) : void  {
    super.generateItems(items);
  }
}
