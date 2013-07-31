package com.thenitro.ngine.match3.bonuses {
	import com.thenitro.ngine.bonuses.IBonusExecuter;
	import com.thenitro.ngine.grid.interfaces.IGridContainer;
	import com.thenitro.ngine.match3.Match3Logic;
	
	public interface IMatch3BonusExecuter extends IBonusExecuter {
		function init(pGrid:IGridContainer, pLogic:Match3Logic, pDepth:uint):void;
		function executeTo(pX:uint, pY:uint, pBonus:IMatch3Bonus):void;
	}
}