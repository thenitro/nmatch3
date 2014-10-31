package nmatch3.bonuses {
	import flash.errors.IllegalOperationError;
	
	import ncollections.grid.Grid;
	
	import nmatch3.Match3Logic;
	
	import starling.events.EventDispatcher;
	
	public class AbstractBonus extends EventDispatcher implements IMatch3Bonus {
		public static const COMPLETED:String = 'complete';

        private var _disposed:Boolean;
		
		protected var _grid:Grid;
		protected var _logic:Match3Logic;
		
		protected var _collectorMethod:Function;
		
		protected var _x:uint;
		protected var _y:uint;
		
		protected var _depth:uint;
		
		public function AbstractBonus() {
			super();
		};
		
		public function get reflection():Class {
			throw new IllegalOperationError('AbstractBonus.reflection: must be overriden!');
			return null;
		};

        public function get disposed():Boolean {
            return _disposed;
        };
		
		public function init(pGrid:Grid, pLogic:Match3Logic, pDepth:uint, 
							 pCollectorMethod:Function):void {
			_grid  = pGrid;
			_logic = pLogic;
			
			_depth = pDepth;
			
			_collectorMethod = pCollectorMethod;
		};
		
		public function setCoords(pX:uint, pY:uint):void {
			_x = pX;
			_y = pY;
		};
		
		public function execute():void {
			throw new IllegalOperationError('AbstractBonus.execute: must be overriden!');
		};
		
		public function poolPrepare():void {
			_grid  = null;
			_logic = null;
		};
		
		public function dispose():void {
            _disposed = true;

			_grid  = null;
			_logic = null;
		};
		
		protected final function completed():void {
			dispatchEventWith(COMPLETED, false, this);
		};
	};
}