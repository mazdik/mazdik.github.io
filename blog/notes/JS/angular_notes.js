/* tslint.json */
"use-host-property-decorator": false,
"no-inferrable-types": [
  false,
  "ignore-params"
],

// Загрузка файла
@Component({
  selector: 'my-app',
  template: `
    <div>
      <input type="file" (change)="onChange($event)"/>
    </div>
  `,
  providers: [ UploadService ]
})
export class AppComponent {
  onChange(event) {
    var files = event.srcElement.files;
    console.log(files);
  }
}
// Получить файл в виде blob
this.http.get(url, {responseType: ResponseContentType.Blob})
		.toPromise()
		.then((response) => {
			let blob = new Blob([(<any> response)._body], { type: response.headers.get("Content-Type") });
			if (blob) {
				console.log(blob);
			}
		})
		.catch((error) => console.log(error));

/* Модель [(value)]="name" */
export class TsComponent {
  _model: string;

  @Output()
  valueChange: EventEmitter<string> = new EventEmitter<string>();

  @Input('value')
  set model(value: string) {
    this._model = value;
    this.valueChange.emit(this._model);
  }

  get model() {
    return this._model;
  }
}

// How to pass multiple parameter to @Directives or @Component
selector: '[selectable]'
@Input('selectable') option:any;   
@Input('first') f;
@Input('second') s;
`
<div
    [selectable] = 'opt' 
    [first]='YourParameterHere'
    [second]='YourParameterHere'>
</div>
`
// Property does not exist on type 'Element'
let nextColumn = <HTMLElement>this.element.nextElementSibling;

// ng-content without selector container
`
<modal>
  <ng-container header>Hello world!</ng-container>
  <ng-container class="summary">A  message</ng-container>
</modal>

<ng-content select="[header]"></ng-content>
<ng-content select=".summary"></ng-content>
`

// один observable надо прокинуть в несколько дочерних
`
<div *ngIf="data$ | async as data">
  <child-one
    [data]="data.propOne">
  </child-one>
  <child-two
    [data]="data.propTwo">
  </child-two>
</div>
`

// interval
import {Subscription, interval} from 'rxjs';
private subInterval: Subscription;
ngOnInit() {
  this.subInterval = interval(1000 * 10).subscribe(x => {
    this.getJobState();
  });
}
ngOnDestroy() {
  this.subInterval.unsubscribe();
}

// Binding select element to object in Angular
// [value]="..." only supports string values
// [ngValue]="..." supports any type
`
<select [(ngModel)]="selectedValue">
  <option *ngFor="let c of countries" [ngValue]="c.id">{{c.name}}</option>
</select>
`

// res = {'class1': true, 'class2': true}
export function addClass(cls: string, res: any): string {
  if (typeof res === 'string') {
    cls += ' ' + res;
  } else if (typeof res === 'object') {
    Object.keys(res).forEach(k => cls += (res[k] === true) ? ` ${k}` : '');
  }
  return cls;
}

/* Анг2 цикл по цифрам */
// *ngFor поддерживает только массивы, и это один из способов решения проблемы:
function getStarValues(maxValue: number): number[] {
  return new Array(maxValue).fill().map((item, index) => index + 1);
}

/* После *ngFor (после того, как элементы появились в DOM) */
`
<div [customScroll]>
    <p *ngFor="let item of items" #listItems>{{item}}</p>
</div>
`
class SomeComponent implements AfterViewInit {
  @ViewChild(CustomScrollDirective) scroll: CustomScrollDirective;
  @ViewChildren('listItems') listItems: QueryList<any>;
  private sub: Subscription;
  
  ngAfterViewInit() {
    this.sub = this.listItems.changes.subscribe(() => this.scroll.update());
  }
}

/* createEmbeddedView */
import { VERSION, Component, ViewChild, TemplateRef, ViewContainerRef } from '@angular/core';

@Component({
  selector: 'my-app',
  template: `
      <ng-container #vc></ng-container>
      <ng-template #tpl>
          <h1>Hello, {{name}}</h1>
      </ng-template>
  `,
})
export class AppComponent {
  name = `Angular! v${VERSION.full}`;

  @ViewChild('tpl', {read: TemplateRef}) tpl: TemplateRef<any>;
  @ViewChild('vc', {read: ViewContainerRef}) vc: ViewContainerRef;

  ngOnInit() {
    this.vc.createEmbeddedView(this.tpl);
  }
}

/* Хелпер тестирования */
export class PageObjectBase {

  constructor(private root: HTMLDivElement) { }
  // Упрощаем доступ к input элементам компонентов
  _inputValue(cssSelector: string, value: string) { 
    if (value) {
      this.root.querySelector<HTMLInputElement>(cssSelector).value = value;
      this.root.querySelector<HTMLInputElement>(cssSelector).dispatchEvent(new Event('input'));
    }
    else {
      return this.root.querySelector<HTMLInputElement>(cssSelector).value
    }
  }
  // Теперь достаточно вызвать метод и передать селектор кнопки для клика
  _buttonClick(cssSelector: string) {
    this.root.querySelector<HTMLButtonElement>(cssSelector).dispatchEvent(new Event('click'));
  }

}

/* Виртуальный скрол с помощью прокрутки мыши */
this.wheelListener = this.onWheel.bind(this);
this.table.nativeElement.addEventListener('wheel', this.wheelListener);

onWheel(event) {
  if (this.scroller.items.length > this.scroller.itemsPerRow) {
    event.preventDefault();
    this.scroller.setOffsetY(this.scroller.scrollYPos + event.deltaY);
  }
}