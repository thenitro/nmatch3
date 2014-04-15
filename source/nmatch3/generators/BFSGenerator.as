package nmatch3.generators {
	import ncollections.grid.Grid;
	import ncollections.grid.IGridObject;
	
	import ngine.math.GraphUtils;
	
	import npooling.Pool;
	
	public final class BFSGenerator implements IGenerator {
		private static var _pool:Pool = Pool.getInstance();
		
		private var _waveSize:uint;
		private var _playerSkill:uint;
		
		public function BFSGenerator() {
			_playerSkill = 0;
		};
		
		public function setWaveDepth(pSize:uint):void {
			_waveSize = pSize;
		};
		
		public function setPlayerSkill(pSkill:Number):void {
			_playerSkill = pSkill;
		};
		
		public function setMultiplier(pValue:Number):void {
			
		};
		
		public function generateGrid(pGrid:Grid, 
									 pElements:Array, 
									 pEndX:uint, pEndY:uint, 
									 pCellWidth:Number, pCellHeight:Number):void {
			for (var i:uint = 0; i < pEndX; i++) {
				for (var j:uint = 0; j < pEndY; j++) {
					generateOne(i, j, pGrid, pElements, pCellWidth, pCellHeight);
				}
			}
		};
		
		public function generateOne(pI:uint, pJ:uint, 
									pGrid:Grid, 
									pElements:Array,
									pCellWidth:Number, pCellHeight:Number):IGridObject {
			var item:IGridObject = generateItem(pElements, pCellWidth, pCellHeight);
			
			pGrid.add(pI, pJ, item);
			
			while (GraphUtils.bfs(pI, pJ, pGrid, 
				   GraphUtils.addNeighborsVerticalHorizintal).length >= _waveSize - _playerSkill) {
				item = generateItem(pElements, pCellWidth, pCellHeight);
				
				pGrid.remove(pI, pJ);
				pGrid.add(pI, pJ, item);
			}
						
			return item;
		};
		
		private function generateItem(pElements:Array,
									  pCellWidth:Number, pCellHeight:Number):IGridObject {
			var index:uint = Math.floor(pElements.length * Math.random());
			var Type:Class = pElements[index];		
			
			var instance:Object = _pool.get(Type);
			
			if (!instance) {
				_pool.allocate(Type, 1);
				instance = new Type(pCellWidth, pCellHeight);
			}
			
			return instance as IGridObject;
		};
	}
}