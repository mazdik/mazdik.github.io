export interface ResizableEvent {
    width: number;
    height: number;
    event?: MouseEvent | Touch;
    direction?: 'horizontal' | 'vertical';
}
export declare class Resizable {
    private element;
    south: boolean;
    east: boolean;
    southEast: boolean;
    ghost: boolean;
    private newWidth;
    private newHeight;
    private resizingS;
    private resizingE;
    private resizingSE;
    private minWidth;
    private maxWidth;
    private minHeight;
    private maxHeight;
    private startListeners;
    private globalListeners;
    constructor(element: HTMLElement);
    viewInit(): void;
    destroy(): void;
    addEventListeners(): void;
    removeEventListeners(): void;
    onMousedown(event: MouseEvent | TouchEvent): void;
    onMove(width: number, height: number, screenX: number, screenY: number, event: MouseEvent | TouchEvent): void;
    onMouseup(event: MouseEvent | TouchEvent): void;
    private createHandle;
    initResize(event: MouseEvent | TouchEvent, isSouth: boolean, isEast: boolean, isSouthEast: boolean): void;
    endResize(event: MouseEvent | TouchEvent): void;
    resizeWidth(event: MouseEvent | Touch): void;
    resizeHeight(event: MouseEvent | Touch): void;
}
