package nmatch3.controllers {
	import ndatas.grid.IGridObject;
	
	import ngine.display.gridcontainer.GridContainer;
	
	import starling.events.EventDispatcher;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	
	public final class Controller extends EventDispatcher {
		public static const START_PICKED:String = 'start_picked';
		public static const START_RESET:String  = 'start_reset';
		
		public static const END_PICKED:String = 'end_picked';
		public static const END_RESET:String  = 'end_reset';
		
		public static const EXECUTE:String = 'execute';
		
		private var _container:GridContainer;
		
		private var _start:IGridObject;
		private var _end:IGridObject;
		
		private var _blocked:Boolean;
		
		public function Controller() {			
			super();
		};
		
		public function addListener(pContainer:GridContainer):void {			
			_container = pContainer;
			_container.canvas.addEventListener(TouchEvent.TOUCH, touchEventHandler);
		};
		
		public function removeListener():void {
			clear();
			
			_container.canvas.removeEventListener(TouchEvent.TOUCH, touchEventHandler);
		};
		
		public function clear():void {
			resetStart();
			resetEnd();
			
			_blocked = false;
		};
		
		private function touchEventHandler(pEvent:TouchEvent):void {
			if (_blocked) {
				return;
			}
			
			var touch:Touch = pEvent.getTouch(_container.canvas);
			
			if (touch) {
				if (touch.phase == TouchPhase.BEGAN) {
					_start       = touch.target.parent as IGridObject;
					
					dispatchEventWith(START_PICKED, false, _start);
				}
				
				if (touch.phase == TouchPhase.HOVER ||
					touch.phase == TouchPhase.MOVED) {
					
					findEnd(touch);
				}
				
				if (touch.phase == TouchPhase.ENDED && _start && _end) {
					_blocked = true;
					
					dispatchEventWith(EXECUTE, false, [ _start, _end ]);
				}
			}
		};
		
		private function findEnd(pTouch:Touch):void {
			if (!_start) {
				return;
			}
			
			var indexX:uint = Math.round((pTouch.globalX - _container.canvas.x - _container.cellWidth / 2) / _container.cellWidth);
			var indexY:uint = Math.round((pTouch.globalY - _container.canvas.y - _container.cellHeight / 2) / _container.cellHeight);
			
			var dx:Number = _start.indexX - indexX;
			var dy:Number = _start.indexY - indexY;
			
			var signDx:Number = normalize(dx);
			var signDy:Number = normalize(dy);
			
			if (Math.abs(signDx) == Math.abs(signDy)) {
				resetEnd();
				return;
			}
			
			var item:IGridObject = _container.take(_start.indexX - signDx, 
												   _start.indexY - signDy) as IGridObject;
			
			if (!item) {
				return;
			}
			
			_end = item;
			
			dispatchEventWith(END_PICKED, false, _end);
		};
		
		
		private function normalize(pInput:Number):Number {
			if (pInput > 0) {
				return  1;
			} else if (pInput < 0) {
				return -1;
			}
			
			return 0;
		};
		
		private function resetStart():void {
			if (!_start) {
				return;
			}
			
			dispatchEventWith(START_RESET, false, _start);
			
			_start = null;
		};		
		
		private function resetEnd():void {
			if (!_end) {
				return;
			}
			
			dispatchEventWith(END_RESET, false, _end);
			
			_end = null;
		};
	};
}