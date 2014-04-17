package nmatch3.bonuses {
	import ncollections.grid.Grid;
	
	import ngine.display.gridcontainer.interfaces.IGridContainer;
	
	import nmatch3.Match3Logic;
	
	import starling.events.Event;
	import starling.events.EventDispatcher;
	
	public final class Match3BonusExecuter extends EventDispatcher implements IMatch3BonusExecuter {
		public static const BONUS_EXECUTED:String = 'bonus_executed';
		
		private var _grid:Grid;
		private var _logic:Match3Logic;
		
		private var _depth:uint;
		
		private var _collectorMethod:Function;
		
		public function Match3BonusExecuter() {
			super();
		};
		
		public function init(pGrid:Grid, pLogic:Match3Logic, pDepth:uint, 
							 pCollectorMethod:Function):void {
			_grid  = pGrid;
			_logic = pLogic;
			
			_depth = pDepth;
			
			_collectorMethod = pCollectorMethod;
		};
		
		public function executeTo(pX:uint, pY:uint, pBonus:IMatch3Bonus):void {
			trace("Match3BonusExecuter.executeTo(pX, pY, pBonus)");
			
			pBonus.init(_grid, _logic, _depth, _collectorMethod);
			pBonus.setCoords(pX, pY);
			
			(pBonus as AbstractBonus).addEventListener(AbstractBonus.COMPLETED, 
													   bonusCompletedEventHandler);
			
			execute(pBonus);
			
		};
		
		public function execute(pBonus:IMatch3Bonus):void {
			pBonus.execute();
		};
		
		private function bonusCompletedEventHandler(pEvent:Event):void {
			dispatchEventWith(BONUS_EXECUTED, false, pEvent.data);
		};
	}
}