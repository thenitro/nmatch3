package com.thenitro.match3sample {
	import com.thenitro.match3sample.items.Blue;
	import com.thenitro.match3sample.items.Green;
	import com.thenitro.match3sample.items.Red;
	import com.thenitro.match3sample.items.Yellow;
	import com.thenitro.ngine.grid.GridContainer;
	import com.thenitro.ngine.match3.generators.BFSGenerator;
	
	import starling.display.Sprite;
	import starling.events.Event;
	
	public final class Game extends Sprite {
		private static const TYPES:Vector.<Class> = new <Class>[ Red, Blue, Green, Yellow ];
		
		private static const FIELD_X:uint = 10;
		private static const FIELD_Y:uint = 10;
		
		private static const WAVE_DEPTH:uint = 3;
		
		private var _cellWidth:uint;
		private var _cellHeight:uint;
		
		private var _grid:GridContainer;
		private var _generator:BFSGenerator;
		
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
			
			addChild(_grid.canvas);
		};
		
		private function start():void {
			_generator.generateGrid(_grid, TYPES, FIELD_X, FIELD_Y, _cellWidth, _cellHeight);
			_grid.update();
		};
		
		private function stop():void {
			_grid.clean();
		};
	};
}