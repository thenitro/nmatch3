package nmatch3.analytics {
	import ncollections.grid.IGridObject;
	
	import ngine.display.gridcontainer.interfaces.IVisualGridObject;
	
	import npooling.IReusable;
	import npooling.Pool;
	
	public class AnalyticsGridElement implements IGridObject, IVisualGridObject, IReusable {
		private static var _pool:Pool = Pool.getInstance();
		
		private var _indexX:int;
		private var _indexY:int;
		
		private var _reflection:Class;
        private var _disposed:Boolean;
		
		private var _locked:Boolean;
		
		public function AnalyticsGridElement() {
		}
		
		public function set alpha(pValue:Number):void {};
		public function get alpha():Number { return 0; };
		
		public function get x():Number { return 0; };
		
		public function get y():Number { return 0; };
		
		public function set x(pValue:Number):void {};
		
		public function set y(pValue:Number):void {};
		
		public function get indexX():int {
			return _indexX;
		};
		
		public function get indexY():int {
			return _indexY;
		};
		
		public function get locked():Boolean {
			return _locked;
		};
		
		public function get reflection():Class {
			return _reflection;
		};

        public function get disposed():Boolean {
            return _disposed;
        };
		
		public function setReflection(pClass:Class):void {
			_reflection = pClass;
		};
		
		public function updateIndex(pX:int, pY:int):void {
			_indexX = pX;
			_indexY = pY;
		};
		
		public function lock():void {
			_locked = true;
		};
		
		public function clone():IGridObject {
			var copy:AnalyticsGridElement = _pool.get(AnalyticsGridElement) as AnalyticsGridElement;
			
			if (!copy) {
				copy = new AnalyticsGridElement();
				_pool.allocate(AnalyticsGridElement, 1);
			}
			
				copy.updateIndex(indexX, indexY);
				copy.setReflection(reflection);
				
				if (locked) {
					lock();
				}
			
			return copy;
		};
		
		public function restoreReflection():void {
			_reflection = AnalyticsGridElement;
		};
		
		public function poolPrepare():void {
			_indexX = NaN;
			_indexY = NaN;
		};
		
		public function dispose():void {
			_indexX = NaN;
			_indexY = NaN;
		};
		
		public function toString():String {
			return '[ AnalyticsGridElement: reflection=' + _reflection + ' x=' + _indexX + ' y=' + _indexY + ' ]';  
		};
	};
}