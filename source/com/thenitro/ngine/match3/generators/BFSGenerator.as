package com.thenitro.ngine.match3.generators {
	import com.thenitro.match3sample.items.Cell;
	import com.thenitro.ngine.grid.interfaces.IGridContainer;
	import com.thenitro.ngine.grid.interfaces.IGridGenerator;
	import com.thenitro.ngine.grid.interfaces.IGridObject;
	import com.thenitro.ngine.math.GraphUtils;
	
	public final class BFSGenerator implements IGridGenerator {
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
		
		public function generateGrid(pGrid:IGridContainer, 
									 pElements:Vector.<Class>, 
									 pEndX:uint, pEndY:uint, 
									 pCellWidth:Number, pCellHeight:Number):void {
			for (var i:uint = 0; i < pEndX; i++) {
				for (var j:uint = 0; j < pEndY; j++) {
					generateOne(i, j, pGrid, pElements, pCellWidth, pCellHeight);
				}
			}
		};
		
		public function generateOne(pI:uint, pJ:uint, 
									pGrid:IGridContainer, 
									pElements:Vector.<Class>,
									pCellWidth:Number, pCellHeight:Number):IGridObject {
			var item:Cell = generateItem(pElements, pCellWidth, pCellHeight);
			
			pGrid.add(pI, pJ, item);
			
			while (GraphUtils.bfs(pI, pJ, pGrid).length >= _waveSize - _playerSkill) {
				item = generateItem(pElements, pCellWidth, pCellHeight);
				
				pGrid.add(pI, pJ, item);
			}
						
			return item;
		};
		
		private function generateItem(pElements:Vector.<Class>,
									  pCellWidth:Number, pCellHeight:Number):Cell {
			var index:uint = Math.floor(pElements.length * Math.random());
			var Type:Class = pElements[index];
			
			return new Type(pCellWidth, pCellHeight);
		};
	}
}