package com.thenitro.ngine.match3.analytics {
	import com.thenitro.ngine.grid.Grid;
	import com.thenitro.ngine.grid.IGridContainer;
	
	public class AnalyticsGrid extends Grid {
		
		public function AnalyticsGrid() {
			super();
		};
		
		override public function clone():IGridContainer {
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