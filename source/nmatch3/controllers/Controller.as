package nmatch3.controllers {
	import ncollections.grid.IGridObject;

	import ngine.display.gridcontainer.GridContainer;
	import ngine.display.gridcontainer.animation.DummyGridAnimator;

	import nmatch3.Match3Logic;
	import nmatch3.generators.IGenerator;

	import npooling.Pool;

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

		private static var _pool:Pool = Pool.getInstance();
		
		private var _container:GridContainer;
		
		private var _start:IGridObject;
		private var _end:IGridObject;
		
		private var _blocked:Boolean;

        private var _startTouch:Touch;

		private var _testLogic:Match3Logic;

		private var _waveDepth:int;

		private var _itemsCollector:Function;
		
		public function Controller() {
			super();
		};

		public function init(pWidth:Number, pHeight:Number,
							 pGenerator:IGenerator, pWaveDepth:int,
							 pCollector:Function):void {
			_testLogic = new Match3Logic();
			_testLogic.init(pWidth, pHeight, pGenerator, new DummyGridAnimator());

			_waveDepth = pWaveDepth;
			_itemsCollector = pCollector;
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
		
		private function findEnd(pTouch:Touch):void {
			if (!_start) {
				return;
			}

            resetEnd();

            var diffX:Number = pTouch.globalX - _startTouch.globalX;
            var diffY:Number = pTouch.globalY - _startTouch.globalY;

            if (Math.abs(diffX) >= Math.abs(diffY)) {
                diffY = 0;
            } else {
                diffX = 0;
            }
			
			var signDx:Number = normalize(diffX);
			var signDy:Number = normalize(diffY);

			if (Math.abs(signDx) == Math.abs(signDy)) {
				return;
			}
			
			var item:IGridObject = _container.take(_start.indexX + signDx,
												   _start.indexY + signDy) as IGridObject;
			
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

		private function validateTurn(pTurn:Vector.<IGridObject>):Boolean {
			var copy:GridContainer = _container.clone() as GridContainer;
				copy.swap(pTurn[0].indexX, pTurn[0].indexY, pTurn[1].indexX, pTurn[1].indexY);

			for (var i:int = 0; i < pTurn.length; i++) {
				if (_testLogic.findItem(pTurn[i].indexX, pTurn[i].indexY, copy,
										_waveDepth, _itemsCollector)) {
					_pool.put(copy);

					return true;
				}
			}

			_pool.put(copy);

			return false;
		};

		private function touchEventHandler(pEvent:TouchEvent):void {
			if (_blocked) {
				return;
			}

			var touch:Touch = pEvent.touches[0];

			if (touch) {
				if (touch.phase == TouchPhase.BEGAN) {
					_startTouch = touch.clone();
					_start = touch.target.parent as IGridObject;

					dispatchEventWith(START_PICKED, false, _start);
				}

				if ((touch.phase == TouchPhase.HOVER ||
						touch.phase == TouchPhase.MOVED) && _start) {

					findEnd(touch);
				}

				if (touch.phase == TouchPhase.ENDED && _start && _end) {
					_blocked = true;

					var turn:Vector.<IGridObject> = new <IGridObject>[ _start, _end ];

					if (!validateTurn(turn)) {
						clear();
						return;
					}

					dispatchEventWith(EXECUTE, false, turn);

					resetStart();
					resetEnd();
				}
			}
		};
	};
}