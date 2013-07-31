package com.thenitro.ngine.match3 {
	import com.thenitro.monsterinarow.global.Global;
	import com.thenitro.monsterinarow.global.monsters.Monster;
	import com.thenitro.ngine.grid.GridAnimator;
	import com.thenitro.ngine.grid.GridContainer;
	import com.thenitro.ngine.grid.IGridContainer;
	import com.thenitro.ngine.grid.IGridGenerator;
	import com.thenitro.ngine.grid.IGridObject;
	import com.thenitro.ngine.math.GraphUtils;
	import com.thenitro.ngine.pool.Pool;
	
	import starling.animation.Tween;
	import starling.core.Starling;
	import starling.events.Event;
	import starling.events.EventDispatcher;
	
	public class Match3Logic extends EventDispatcher {
		public static const MATCH_FINDED:String    = 'matchFindedEvent';
		public static const ITEM_FINDED:String     = 'itemFindedEvent';
		public static const ITEM_REMOVED:String    = 'itemRemovedEventHandler'
		public static const ROW_FINDED:String      = 'rowFindedEvent';
		public static const COL_FINDED:String      = 'colFindedEvent';
		public static const GRID_FINDED:String     = 'gridFindedEvent';
		public static const FLOOD_EVENT:String     = 'floodEvent';
		public static const TURNS_CHANGED:String   = 'turnsChangedEvent';
		public static const GAME_OVER_EVENT:String = 'gameOverEvent';
		
		public static const ANIMATION_TIME:Number  = 0.35;
		public static const FLOOD_TIME:Number      = 0.35;
		public static const FLOOD_DELAY:Number     = 0.25;
		
		protected static var _pool:Pool = Pool.getInstance();
		
		protected var _animator:GridAnimator;
		protected var _generator:IGridGenerator;
		
		protected var _cellWidth:uint;
		protected var _cellHeight:uint;		
		
		private var _gemsNum:uint;
		
		private var _itemsRemoved:uint = 0;
		
		private var _colIndex:uint;
		private var _rowIndex:uint;
		private var _depth:uint;
		
		private var _grid:IGridContainer;
		
		private var _availableMonsters:Vector.<Class>;
		
		public function Match3Logic(pMonsterSizeX:uint, pMonsterSizeY:uint, pGenerator:IGridGenerator) {
			_cellWidth  = pMonsterSizeX;
			_cellHeight = pMonsterSizeY;
			
			_generator  = pGenerator;
			
			_animator   = new GridAnimator();
			
			super();
		};
		
		public function get removed():uint {
			return _itemsRemoved;
		};
		
		public function get availableMonsters():Vector.<Class> {
			return _availableMonsters;
		};
		
		public function get animator():GridAnimator {
			return _animator;
		};
		
		public function get gemsNum():uint {
			return _gemsNum;
		};

		public function set gemsNum(pValue:uint):void {
			_availableMonsters = Global.MONSTERS.slice(0, pValue);
			_gemsNum           = pValue;
		};
		
		public function findGrid(pGrid:GridContainer, pDepth:uint):void {
			_rowIndex = 0;
			_grid     = pGrid;
			_depth    = pDepth;
			
			nextSample();
		};
		
		public function findRow(pRow:uint, pGrid:IGridContainer, pDepth:uint):void {
			_colIndex = 0;
			_rowIndex = pRow;
			_grid     = pGrid;
			_depth    = pDepth;
			
			nextItem();
		};
		
		public function findItem(pX:uint, pY:uint, pGrid:IGridContainer, pDepth:uint):Boolean {
			var samples:Array = GraphUtils.bfs(pX, pY, pGrid);
			
			if (samples.length >= pDepth) {
				for each (var monster:Monster in samples) {					
					pGrid.remove(monster.indexX, monster.indexY);
					pGrid.removeVisual(monster);
					
					_animator.remove(monster);
					
					_itemsRemoved++;
					
					dispatchEventWith(ITEM_REMOVED, false, { 
						positionX: monster.x, positionY: monster.y, 
						deadTextureID: monster.deadTextureID });
					
					flood(monster.indexX, monster.indexY, pGrid);
				}
				
				for each (monster in samples) {
					_pool.put(monster);
				}
				
				_animator.addEventListener(ITEM_FINDED, itemFindedEventHandler);
				_animator.start(ITEM_FINDED);
				
				dispatchEventWith(MATCH_FINDED);
				
				return true;
			}
			
			dispatchEventWith(ITEM_FINDED);
			
			return false;
		};
		
		public function pushTop(pX:uint, pY:uint, pGrid:IGridContainer):void {
			var animate:Boolean;
			
			for (var i:int = pY; i > 0; i--) {
				var objectA:Monster = pGrid.take(pX, i) as Monster; 
				var objectB:Monster = pGrid.take(pX, i - 1) as Monster; 
				
				pGrid.swap(pX, i, pX, i - 1);
				
				_animator.add(objectA, pX * _cellWidth, (i - 1) * _cellHeight, FLOOD_TIME);
				_animator.add(objectB, pX * _cellWidth,      i  * _cellHeight, FLOOD_TIME);
			}
		};
		
		public function dropNew(pIndexX:uint, pIndexY:uint, pGrid:GridContainer):void {
			var newGem:IGridObject = _generator.generateOne(pIndexX, 0, pGrid, _availableMonsters, _cellWidth, _cellHeight);
				newGem.alpha = 0.0;
			
			var tween:Tween = new Tween(newGem, ANIMATION_TIME);
				tween.delay = FLOOD_DELAY * 1.5;
				tween.animate('alpha', 1.0);
			
			Starling.juggler.add(tween);
			
			pGrid.addVisual(pGrid.add(pIndexX, 0, newGem));
		};
		
		public function clean():void {
			_animator.clean();
			_itemsRemoved = 0;		
		};
		
		private function flood(pIndexX:uint, pIndexY:uint, pGrid:IGridContainer):void {
			pushTop(pIndexX, pIndexY, pGrid);
			dispatchEventWith(FLOOD_EVENT, false, { indexX: pIndexX, indexY: pIndexY });
		};
		
		private function updateRowIndex(pEvent:Event):void {
			removeEventListener(ROW_FINDED, updateRowIndex);
			
			_rowIndex++;
			
			if (_rowIndex < _grid.sizeY) {
				nextSample();
				return;
			}
			
			dispatchEventWith(GRID_FINDED);
		};
		
		private function nextSample():void {
			addEventListener(ROW_FINDED, updateRowIndex);
			findRow(_rowIndex, _grid, _depth);
		};
		
		private function updateColIndex(pEvent:Event):void {
			removeEventListener(ITEM_FINDED, updateRowIndex);
			
			_colIndex++;
			
			if (_colIndex < _grid.sizeX) {
				nextItem();
				return;
			}
			dispatchEventWith(ROW_FINDED);
		};
		
		private function nextItem():void {
			addEventListener(ITEM_FINDED, updateColIndex);
			findItem(_colIndex, _rowIndex, _grid, _depth);
		};
		
		private function itemFindedEventHandler(pEvent:Event):void {
			_animator.removeEventListener(ITEM_FINDED, itemFindedEventHandler);
			
			dispatchEventWith(ITEM_FINDED);
		};
	};
}