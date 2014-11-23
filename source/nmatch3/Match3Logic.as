package nmatch3 {
	import ncollections.grid.Grid;
	import ncollections.grid.IGridObject;
	
	import ngine.display.gridcontainer.GridContainer;
	import ngine.display.gridcontainer.animation.GridAnimator;
	import ngine.display.gridcontainer.interfaces.IGridContainer;
	import ngine.display.gridcontainer.interfaces.IVisualGridObject;
	
	import nmatch3.generators.IGenerator;
	
	import npooling.Pool;
	
	import starling.animation.Tween;
	import starling.core.Starling;
	import starling.events.Event;
	import starling.events.EventDispatcher;
	
	public class Match3Logic extends EventDispatcher {
		public static const MATCH_FINDED:String    = 'matchFindedEvent';
		public static const ITEM_FINDED:String     = 'itemFindedEvent';
		public static const ITEM_REMOVED:String    = 'itemRemovedEventHandler'
		public static const ROW_FINDED:String      = 'rowFindedEvent';
		public static const GRID_FINDED:String     = 'gridFindedEvent';
		public static const FLOOD_EVENT:String     = 'floodEvent';
		public static const SWAP_ANIMATION:String  = 'swapAnimatedEvent';
		
		public static const ANIMATION_TIME:Number  = 0.35;
		
		public static const FLOOD_TIME:Number      = 0.35;
		public static const FLOOD_DELAY:Number     = 0.25;
		
		public static const SWAP_TIME:Number       = 0.15;
		
		protected static var _pool:Pool = Pool.getInstance();
		
		public var availableTypes:Array;
		
		protected var _animator:GridAnimator;
		protected var _generator:IGenerator;
		
		protected var _cellWidth:uint;
		protected var _cellHeight:uint;		
		
		private var _itemsRemoved:uint = 0;
		
		private var _colIndex:uint;
		private var _rowIndex:uint;
		private var _depth:uint;
		
		private var _grid:Grid;
		
		private var _itemsCollector:Function;
		
		public function Match3Logic() {
			super();
		};
		
		public function get removed():uint {
			return _itemsRemoved;
		};
		
		public function get animator():GridAnimator {
			return _animator;
		};
		
		public function get turns():int {
			return -1;
		};
		
		public function init(pCellWidth:uint, pCellHeight:uint, 
							 pGenerator:IGenerator, pAnimator:GridAnimator):void {
			_cellWidth  = pCellWidth;
			_cellHeight = pCellHeight;
			
			_generator  = pGenerator;
			_animator   = pAnimator;
		};
		
		public function findGrid(pGrid:Grid, pDepth:uint, pItemsCollector:Function):void {
			_rowIndex = 0;
			_grid     = pGrid;
			_depth    = pDepth;
			
			_itemsCollector = pItemsCollector; 
			
			nextSample();
		};
		
		public function findRow(pRow:uint, pGrid:Grid, pDepth:uint, pItemsCollector:Function):void {
			_colIndex = 0;
			_rowIndex = pRow;
			_grid     = pGrid;
			_depth    = pDepth;
			
			_itemsCollector = pItemsCollector; 
			
			nextItem();
		};
		
		public function findItem(pX:uint, pY:uint, pGrid:Grid, pDepth:uint, pCollector:Function):Boolean {
			var samples:Array = pCollector(pX, pY, pGrid) as Array;
			
			if (samples.length >= pDepth) {	
				dispatchEventWith(MATCH_FINDED, false, samples);
				
				for each (var item:IGridObject in samples) {					
					removeItem(item, pGrid);
				}
				
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
		
		public function removeItem(pItem:IGridObject, pGrid:Grid):void {			
			if (!pItem) {
				return;
			}
			
			pGrid.remove(pItem.indexX, pItem.indexY);
			
			_animator.remove(pItem);
			_itemsRemoved++;
			
			dispatchEventWith(ITEM_REMOVED, false, { 
													positionX: pItem.indexX, 
													positionY: pItem.indexY, 
													object: pItem });
			
			flood(pItem.indexX, pItem.indexY, pGrid);
		};
		
		public function pushTop(pX:uint, pY:uint, pGrid:Grid):void {
			var animate:Boolean;
			
			for (var i:int = pY; i > 0; i--) {
				var objectA:IGridObject = pGrid.take(pX, i) as IGridObject; 
				var objectB:IGridObject = pGrid.take(pX, i - 1) as IGridObject; 
				
				pGrid.swap(pX, i, pX, i - 1);
				
				_animator.add(objectA, pX * _cellWidth, (i - 1) * _cellHeight, FLOOD_TIME);
				_animator.add(objectB, pX * _cellWidth,      i  * _cellHeight, FLOOD_TIME);
			}
		};
		
		public function dropNew(pIndexX:uint, pIndexY:uint, pGrid:GridContainer, 
								pObject:IVisualGridObject = null):void {
			if (!pObject) {
				pObject = _generator.generateOne(pIndexX, 0, pGrid, 
												 availableTypes, 
												 _cellWidth, _cellHeight) as IVisualGridObject;
			}
			
			pObject.alpha = 0.0;
			
			var tween:Tween = new Tween(pObject, ANIMATION_TIME);
				tween.delay = FLOOD_DELAY * 1.5;
				tween.animate('alpha', 1.0);
			
			Starling.juggler.add(tween);
			
			pGrid.addVisual(pGrid.add(pIndexX, 0, pObject));
		};
		
		public function swap(pAX:uint, pAY:uint, pBX:uint, pBY:uint, pGrid:IGridContainer):void {
			var objectA:IGridObject = pGrid.take(pAX, pAY) as IGridObject; 
			var objectB:IGridObject = pGrid.take(pBX, pBY) as IGridObject; 
			
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
		
		private function flood(pIndexX:uint, pIndexY:uint, pGrid:Grid):void {
			dispatchEventWith(FLOOD_EVENT, false, { indexX: pIndexX, indexY: pIndexY });
		};
		
		private function updateRowIndex(pEvent:Event):void {
			removeEventListener(ROW_FINDED, updateRowIndex);
			
			_rowIndex++;
			
			if (_rowIndex < _grid.maxY) {
				nextSample();
				return;
			}
			
			dispatchEventWith(GRID_FINDED);
		};
		
		private function nextSample():void {
			addEventListener(ROW_FINDED, updateRowIndex);
			findRow(_rowIndex, _grid, _depth, _itemsCollector);
		};
		
		private function updateColIndex(pEvent:Event):void {
			removeEventListener(ITEM_FINDED, updateRowIndex);
			
			_colIndex++;
			
			if (_colIndex < _grid.maxX) {
				nextItem();
				return;
			}
			
			dispatchEventWith(ROW_FINDED);
		};
		
		private function nextItem():void {
			addEventListener(ITEM_FINDED, updateColIndex);
			findItem(_colIndex, _rowIndex, _grid, _depth, _itemsCollector);
		};
		
		private function itemFindedEventHandler(pEvent:Event):void {
			_animator.removeEventListener(ITEM_FINDED, itemFindedEventHandler);
			
			dispatchEventWith(ITEM_FINDED);
		};
	};
}