package com.thenitro.ngine.match3 {
	import com.thenitro.ngine.grid.GridContainer;
	import com.thenitro.ngine.grid.animation.GridAnimator;
	import com.thenitro.ngine.grid.interfaces.IGridContainer;
	import com.thenitro.ngine.grid.interfaces.IGridGenerator;
	import com.thenitro.ngine.grid.interfaces.IGridObject;
	import com.thenitro.ngine.grid.interfaces.IVisualGridObject;
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
		public static const SWAP_ANIMATION:String  = 'swapAnimatedEvent';
		
		public static const ANIMATION_TIME:Number  = 0.35;
		
		public static const FLOOD_TIME:Number      = 0.35;
		public static const FLOOD_DELAY:Number     = 0.25;
		
		public static const SWAP_TIME:Number       = 0.15;
		
		protected static var _pool:Pool = Pool.getInstance();
		
		protected var _animator:GridAnimator;
		protected var _generator:IGridGenerator;
		
		protected var _cellWidth:uint;
		protected var _cellHeight:uint;		
		
		private var _itemsNum:uint;
		
		private var _itemsRemoved:uint = 0;
		
		private var _colIndex:uint;
		private var _rowIndex:uint;
		private var _depth:uint;
		
		private var _grid:IGridContainer;
		
		private var _types:Vector.<Class>;
		private var _availableTypes:Vector.<Class>;
		
		public function Match3Logic(pTypes:Vector.<Class>) {
			_types = pTypes;
			
			super();
		};
		
		public function get removed():uint {
			return _itemsRemoved;
		};
		
		public function get availableMonsters():Vector.<Class> {
			return _availableTypes;
		};
		
		public function get animator():GridAnimator {
			return _animator;
		};
		
		public function get itemsNum():uint {
			return _itemsNum;
		};
		
		public function get turns():int {
			return -1;
		};

		public function set itemsNum(pValue:uint):void {
			_availableTypes = _types.slice(0, pValue);
			_itemsNum        = pValue;
		};
		
		public function init(pCellWidth:uint, pCellHeight:uint, 
							 pGenerator:IGridGenerator, pAnimator:GridAnimator):void {
			_cellWidth  = pCellWidth;
			_cellHeight = pCellHeight;
			
			_generator  = pGenerator;
			_animator   = pAnimator;
		};
		
		public function findGrid(pGrid:IGridContainer, pDepth:uint):void {
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
				for each (var item:IGridObject in samples) {					
					removeItem(item, pGrid);
				}
				
				dispatchEventWith(MATCH_FINDED, false, samples);
				
				for each (item in samples) {
					_pool.put(item);
				}
				
				_animator.addEventListener(ITEM_FINDED, itemFindedEventHandler);
				_animator.start(ITEM_FINDED);
				
				return true;
			}
			
			dispatchEventWith(ITEM_FINDED);
			
			return false;
		};
		
		public function removeItem(pItem:IGridObject, pGrid:IGridContainer):void {			
			if (!pItem) {
				return;
			}
			
			pGrid.remove(pItem.indexX, pItem.indexY);
			pGrid.removeVisual(pItem);
			
			_animator.remove(pItem);
			
			_itemsRemoved++;
			
			dispatchEventWith(ITEM_REMOVED, false, { 
													positionX: pItem.indexX, 
													positionY: pItem.indexY, 
													object: pItem });
			
			flood(pItem.indexX, pItem.indexY, pGrid);
		};
		
		public function pushTop(pX:uint, pY:uint, pGrid:IGridContainer):void {
			var animate:Boolean;
			
			for (var i:int = pY; i > 0; i--) {
				var objectA:IGridObject = pGrid.take(pX, i); 
				var objectB:IGridObject = pGrid.take(pX, i - 1); 
				
				pGrid.swap(pX, i, pX, i - 1);
				
				_animator.add(objectA, pX * _cellWidth, (i - 1) * _cellHeight, FLOOD_TIME);
				_animator.add(objectB, pX * _cellWidth,      i  * _cellHeight, FLOOD_TIME);
			}
		};
		
		public function dropNew(pIndexX:uint, pIndexY:uint, pGrid:GridContainer):void {
			var newGem:IVisualGridObject = _generator.generateOne(pIndexX, 0, pGrid, 
																  _availableTypes, _cellWidth, _cellHeight) as IVisualGridObject;
				newGem.alpha = 0.0;
			
			var tween:Tween = new Tween(newGem, ANIMATION_TIME);
				tween.delay = FLOOD_DELAY * 1.5;
				tween.animate('alpha', 1.0);
			
			Starling.juggler.add(tween);
			
			pGrid.addVisual(pGrid.add(pIndexX, 0, newGem));
		};
		
		public function swap(pAX:uint, pAY:uint, pBX:uint, pBY:uint, pGrid:IGridContainer):void {
			var objectA:IGridObject = pGrid.take(pAX, pAY); 
			var objectB:IGridObject = pGrid.take(pBX, pBY); 
			
			pGrid.swap(pAX, pAY, pBX, pBY);
			
			_animator.add(objectA, pBX * _cellWidth, pBY * _cellHeight, SWAP_TIME);
			_animator.add(objectB, pAX * _cellWidth, pAY * _cellHeight, SWAP_TIME);
			
			_animator.start(SWAP_ANIMATION);
		};
		
		public function checkTurns():void {
			
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