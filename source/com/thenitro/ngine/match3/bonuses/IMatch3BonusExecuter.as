package com.thenitro.ngine.match3.bonuses {
	import com.thenitro.ngine.match3.Match3Logic;
	
	import ngine.display.gridcontainer.interfaces.IGridContainer;
	
	public interface IMatch3BonusExecuter {
		function execute(pBonus:IMatch3Bonus):void;
		function init(pGrid:IGridContainer, pLogic:Match3Logic, pDepth:uint):void;
		function executeTo(pX:uint, pY:uint, pBonus:IMatch3Bonus):void;
	}
}