package nmatch3.analytics {
	import ngine.collections.grid.interfaces.IGridObject;
	import ngine.display.gridcontainer.interfaces.IVisualGridObject;
	import ngine.pool.IReusable;
	import ngine.pool.Pool;
	
	
	public class AnalyticsGridElement implements IGridObject, IVisualGridObject, IReusable {
		private static var _pool:Pool = Pool.getInstance();
		
		private var _indexX:uint;
		private var _indexY:uint;
		
		private var _reflection:Class;
		
		private var _locked:Boolean;
		
		public function AnalyticsGridElement() {
		}
		
		public function set alpha(pValue:Number):void {};
		public function get alpha():Number { return 0; };
		
		public function get x():Number { return 0; };
		
		public function get y():Number { return 0; };
		
		public function set x(pValue:Number):void {};
		
		public function set y(pValue:Number):void {};
		
		public function get indexX():uint {
			return _indexX;
		};
		
		public function get indexY():uint {
			return _indexY;
		};
		
		public function get locked():Boolean {
			return _locked;
		};
		
		public function get reflection():Class {
			return _reflection;
		};
		
		public function setReflection(pClass:Class):void {
			_reflection = pClass;
		};
		
		public function updateIndex(pX:uint, pY:uint):void {
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