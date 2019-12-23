export declare class Draggable {
    private element;
    dragX: boolean;
    dragY: boolean;
    private isDragging;
    private lastPageX;
    private lastPageY;
    private globalListeners;
    constructor(element: HTMLElement);
    start(dragEventTarget: MouseEvent | TouchEvent): void;
    destroy(): void;
    onMousedown(event: MouseEvent | TouchEvent): void;
    onMousemove(event: MouseEvent | TouchEvent): void;
    onMouseup(event: MouseEvent | TouchEvent): void;
    addEventListeners(event: MouseEvent | TouchEvent): void;
    removeEventListeners(): void;
    initDrag(pageX: number, pageY: number): void;
    onDrag(pageX: number, pageY: number): void;
    endDrag(): void;
}
