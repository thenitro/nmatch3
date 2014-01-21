package nmatch3.analytics {
	import ncollections.MatrixMxN;
	import ncollections.grid.Grid;
	
	import ngine.display.gridcontainer.interfaces.IGridContainer;
	
	public class AnalyticsGrid extends Grid implements IGridContainer {
		
		public function AnalyticsGrid() {
			super();
		};
		
		public function get cellWidth():Number { return 0; };
		public function get cellHeight():Number { return 0; };
		
		public function addVisual(pObject:Object, pUpdatePosition:Boolean = false):void {};
		public function removeVisual(pObject:Object):void {};
		
		public function update():void {};
		public function updateIndexes():void {};
		
		override public function clone():MatrixMxN {
			var grid:AnalyticsGrid = _pool.get(AnalyticsGrid) as AnalyticsGrid;
			
			if (!grid) {
				grid = new AnalyticsGrid();
				_pool.allocate(AnalyticsGrid, 1);
			}
			
			for (var i:uint = 0; i < sizeX; i++) {
				for (var j:uint = 0; j < sizeY; j++) {
					if (take(i, j)) {
						grid.add(i, j, take(i, j).clone());
					}
				}
			}
			
			return grid;
		};
		
		override public function clean():void {
			for (var i:uint = 0; i < sizeX; i++) {
				for (var j:uint = 0; j < sizeY; j++) {
					if (!take(i, j)) {
						continue;	
					}
					
					var child:AnalyticsGridElement = take(i, j) as AnalyticsGridElement;
						child.restoreReflection();
					
					remove(i, j);
					
					_pool.put(child);
				}
			}
			
			super.clean();
		};
	};
}