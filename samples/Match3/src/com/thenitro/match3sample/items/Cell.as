package com.thenitro.match3sample.items {
	import flash.errors.IllegalOperationError;
	
	import ncollections.grid.IGridObject;
	
	import ngine.display.gridcontainer.interfaces.IVisualGridObject;
	
	import starling.display.Quad;
	import starling.display.Sprite;
	
	public class Cell extends Sprite implements IGridObject, IVisualGridObject {
		private var _indexX:uint;
		private var _indexY:uint;
		
		public function Cell(pColor:uint, pWidth:int, pHeight:int) {
			super();
			addChild(new Quad(pWidth, pHeight, pColor));
		};
		
		public function get indexX():int {
			return _indexX;
		};
		
		public function get indexY():int {
			return _indexY;
		};
		
		public function get reflection():Class {
			throw new IllegalOperationError("Must be overriden");
			return null;
		};
		
		public function updateIndex(pX:int, pY:int):void {
			_indexX = pX;
			_indexY = pY;
		};
		
		public function clone():IGridObject {
			throw new IllegalOperationError("Must be overriden");
			return null;
		};
		
		public function poolPrepare():void {
			throw new IllegalOperationError("Must be overriden for using with Pool");
		};
	}
}