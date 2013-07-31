package com.thenitro.ngine.match3.bonuses {
	import com.thenitro.monsterinarow.global.monsters.Monster;
	import com.thenitro.ngine.grid.Grid;
	import com.thenitro.ngine.grid.interfaces.IGridContainer;
	import com.thenitro.ngine.grid.interfaces.IGridObject;
	import com.thenitro.ngine.match3.Match3Logic;
	
	import flash.errors.IllegalOperationError;
	
	import starling.events.EventDispatcher;
	
	public class AbstractBonus extends EventDispatcher implements IMatch3Bonus {
		public static const COMPLETED:String = 'complete';
		
		protected var _grid:IGridContainer;
		protected var _logic:Match3Logic;
		
		protected var _x:uint;
		protected var _y:uint;
		
		protected var _depth:uint;
		
		public function AbstractBonus() {
			super();
		};
		
		public function get reflection():Class {
			throw new IllegalOperationError('AbstractBonus.reflection: must be overriden!');
			return null;
		};
		
		public function init(pGrid:IGridContainer, pLogic:Match3Logic, pDepth:uint):void {
			_grid  = pGrid;
			_logic = pLogic;
			
			_depth = pDepth;
		};
		
		public function setCoords(pX:uint, pY:uint):void {
			_x = pX;
			_y = pY;
		};
		
		public function execute():void {
			throw new IllegalOperationError('AbstractBonus.execute: must be overriden!');
		};
		
		public function poolPrepare():void {
			_grid  = null;
			_logic = null;
		};
		
		public function dispose():void {
			_grid  = null;
			_logic = null;
		};
		
		protected final function completed():void {
			dispatchEventWith(COMPLETED, false, this);
		};
	};
}