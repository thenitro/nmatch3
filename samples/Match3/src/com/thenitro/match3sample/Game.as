package com.thenitro.match3sample {
	import com.thenitro.match3sample.items.Blue;
	import com.thenitro.match3sample.items.Cyan;
	import com.thenitro.match3sample.items.Green;
	import com.thenitro.match3sample.items.Red;
	import com.thenitro.match3sample.items.Yellow;
	import nmatch3.Match3Logic;
	import nmatch3.controllers.Controller;
	import nmatch3.generators.BFSGenerator;
	
	import ngine.collections.grid.interfaces.IGridObject;
	import ngine.display.gridcontainer.GridContainer;
	import ngine.display.gridcontainer.animation.TweenGridAnimator;
	
	import starling.display.Sprite;
	import starling.events.Event;
	
	public final class Game extends Sprite {
		private static const TYPES:Vector.<Class> = new <Class>[ Red, Blue, Green, Yellow, Cyan ];
		
		private static const FIELD_X:uint = 10;
		private static const FIELD_Y:uint = 10;
		
		//Maybe you want make match4 or match5, just change the value below
		private static const WAVE_DEPTH:uint = 3;
		
		private var _cellWidth:uint;
		private var _cellHeight:uint;
		
		private var _grid:GridContainer;
		private var _generator:BFSGenerator;
		
		private var _logic:Match3Logic;
		
		private var _controller:Controller;
		
		private var _index:uint;
		private var _selected:Array;
		
		private var _newDropped:Boolean;
		
		public function Game() {
			super();
			addEventListener(Event.ADDED_TO_STAGE, addedToStageEventHandler);
		};
		
		private function addedToStageEventHandler(pEvent:Event):void {
			removeEventListener(Event.ADDED_TO_STAGE, addedToStageEventHandler);
			init();
			start();
		};
		
		private function init():void {
			_cellWidth  = stage.stageWidth  / FIELD_X;
			_cellHeight = stage.stageHeight / FIELD_Y;
			
			_grid      = new GridContainer(_cellWidth, _cellHeight);
			
			_generator = new BFSGenerator();
			_generator.setWaveDepth(WAVE_DEPTH);
			
			_logic = new Match3Logic(TYPES);
			
			_logic.init(_cellWidth, _cellHeight, _generator, new TweenGridAnimator());
			_logic.itemsNum = TYPES.length;//If you want make progress that depends on levels change this value to lower
			
			_controller = new Controller();
			
			addChild(_grid.canvas);
		};
		
		/**
		 * Use this method for game start
		 * Grid generation 
		 * 
		 */		
		private function start():void {
			_logic.clean();
			
			_generator.generateGrid(_grid, TYPES, 
									FIELD_X, FIELD_Y, 
									_cellWidth, _cellHeight);
			_grid.update();
			
			_logic.addEventListener(Match3Logic.FLOOD_EVENT, floodEventHandler);

			_controller.addEventListener(Controller.START_PICKED, startPickedEventHandler);
			_controller.addEventListener(Controller.START_RESET,  startResetEventHandler);
			
			_controller.addEventListener(Controller.END_PICKED, endPickedEventHandler);
			_controller.addEventListener(Controller.END_RESET,  endResetEventHandler);
			
			_controller.addEventListener(Controller.EXECUTE, executeEventHandler);
			
			_controller.addListener(_grid);
		};
			
		/**
		 * Use this method to stop game 
		 * Its clean-up stuff
		 * 
		 */		
		private function stop():void {
			_grid.clean();
			
			_logic.removeEventListener(Match3Logic.FLOOD_EVENT, floodEventHandler);
			
			_controller.removeEventListener(Controller.START_PICKED, startPickedEventHandler);
			_controller.removeEventListener(Controller.START_RESET,  startResetEventHandler);
			
			_controller.removeEventListener(Controller.END_PICKED, endPickedEventHandler);
			_controller.removeEventListener(Controller.END_RESET,  endResetEventHandler);
			
			_controller.removeEventListener(Controller.EXECUTE, executeEventHandler);
			
			_controller.removeListener();
		};
		
		private function findItem():void {
			var item:IGridObject = _selected[_index];	
			
			_logic.addEventListener(Match3Logic.ITEM_FINDED, itemFindedEventHandler);
			_logic.findItem(item.indexX, item.indexY, _grid, WAVE_DEPTH);
		};
		
		private function findGrid():void {
			_newDropped = false;
			
			_logic.addEventListener(Match3Logic.GRID_FINDED, gridFindedEventHandler);
			_logic.findGrid(_grid, WAVE_DEPTH);
		};
		
		/**
		 * 
		 * @param pEvent use pEvent.data to access selected items
		 * 
		 * And use/reuse Match3Logic class to work with items
		 * 
		 */		
		private function executeEventHandler(pEvent:Event):void {
			_index    = 0;
			_selected = pEvent.data as Array;
			
			var start:IGridObject = _selected[0] as IGridObject;
			var end:IGridObject   = _selected[1] as IGridObject;
			
			//Logic is animation-depend
			_logic.animator.addEventListener(Match3Logic.SWAP_ANIMATION, 
											 swapAnimationCompleteEventHandler);
			_logic.swap(start.indexX, start.indexY, end.indexX, end.indexY, _grid);
		};
		
		private function swapAnimationCompleteEventHandler(pEvent:Event):void {
			//never forget clean-up mess
			_logic.animator.removeEventListener(Match3Logic.SWAP_ANIMATION, 
											 swapAnimationCompleteEventHandler);
			
			//first we need to find selected items it will be looks natural and user-friendly
			findItem();
		};
		
		private function itemFindedEventHandler(pEvent:Event):void {
			_logic.removeEventListener(Match3Logic.ITEM_FINDED, itemFindedEventHandler);
			
			_index++;
			
			if (_index >= _selected.length) {
				findGrid();
				return;
			}
			
			findItem();
		};
		
		/**
		 * 
		 * @param pEvent
		 * 
		 * if any new drops of items we need to check it again
		 * if no any drops: turn is over
		 * 
		 */		
		
		private function gridFindedEventHandler(pEvent:Event):void {
			_logic.removeEventListener(Match3Logic.GRID_FINDED, gridFindedEventHandler);
			
			if (_newDropped) {
				findGrid();
			} else {
				_controller.clear();
			}
		};
		
		/**
		 * 
		 * @param pEvent.data - vacant item position 
		 * 
		 * fill item with new, when its drops down
		 * 
		 */		
		private function floodEventHandler(pEvent:Event):void {
			_newDropped = true;
			
			_logic.dropNew(pEvent.data.indexX, pEvent.data.indexY, _grid);
		};
		
		/**
		 * Do with items what you need
		 * Change alpha or run other methods
		 * 
		 */
		private function startPickedEventHandler(pEvent:Event):void {
			pEvent.data.alpha = 0.5;
		};
		
		private function startResetEventHandler(pEvent:Event):void {
			pEvent.data.alpha = 1.0;
		};
		
		private function endPickedEventHandler(pEvent:Event):void {
			pEvent.data.alpha = 0.5;
		};
		
		private function endResetEventHandler(pEvent:Event):void {
			pEvent.data.alpha = 1.0;
		};
	};
}