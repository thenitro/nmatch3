package com.thenitro.ngine.match3.bonuses {
	import com.thenitro.ngine.bonuses.IBonus;
	import com.thenitro.ngine.grid.interfaces.IGridContainer;
	import com.thenitro.ngine.match3.Match3Logic;
	
	import starling.events.Event;
	import starling.events.EventDispatcher;
	
	public final class Match3BonusExecuter extends EventDispatcher implements IMatch3BonusExecuter {
		public static const BONUS_EXECUTED:String = 'bonus_executed';
		
		private var _grid:IGridContainer;
		private var _logic:Match3Logic;
		
		private var _depth:uint;
		
		public function Match3BonusExecuter() {
			super();
		};
		
		public function init(pGrid:IGridContainer, pLogic:Match3Logic, pDepth:uint):void {
			_grid  = pGrid;
			_logic = pLogic;
			
			_depth = pDepth;
		};
		
		public function executeTo(pX:uint, pY:uint, pBonus:IMatch3Bonus):void {
			trace("Match3BonusExecuter.executeTo(pX, pY, pBonus)");
			
			pBonus.init(_grid, _logic, _depth);
			pBonus.setCoords(pX, pY);
			
			(pBonus as AbstractBonus).addEventListener(AbstractBonus.COMPLETED, 
													   bonusCompletedEventHandler);
			
			execute(pBonus);
			
		};
		
		public function execute(pBonus:IBonus):void {
			pBonus.execute();
		};
		
		private function bonusCompletedEventHandler(pEvent:Event):void {
			dispatchEventWith(BONUS_EXECUTED, false, pEvent.data);
		};
	}
}