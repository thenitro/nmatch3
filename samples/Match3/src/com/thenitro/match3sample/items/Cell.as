package com.thenitro.match3sample.items {
	import flash.errors.IllegalOperationError;
	
	import ngine.collections.grid.interfaces.IGridObject;
	import ngine.display.gridcontainer.interfaces.IVisualGridObject;
	
	import starling.display.Quad;
	import starling.display.Sprite;
	
	public class Cell extends Sprite implements IGridObject, IVisualGridObject {
		private var _indexX:uint;
		private var _indexY:uint;
		
		public function Cell(pColor:uint, pWidth:uint, pHeight:uint) {
			super();
			addChild(new Quad(pWidth, pHeight, pColor));
		};
		
		public function get indexX():uint {
			return _indexX;
		};
		
		public function get indexY():uint {
			return _indexY;
		};
		
		public function get reflection():Class {
			throw new IllegalOperationError("Must be overriden");
			return null;
		};
		
		public function updateIndex(pX:uint, pY:uint):void {
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