package nmatch3.bonuses {
	import ncollections.grid.Grid;
	
	import nmatch3.Match3Logic;
	
	public interface IMatch3BonusExecuter {
		function execute(pBonus:IMatch3Bonus):void;
		function init(pGrid:Grid, pLogic:Match3Logic, pDepth:uint, 
					  pCollectorMethod:Function):void;
		function executeTo(pX:uint, pY:uint, pBonus:IMatch3Bonus):void;
	}
}