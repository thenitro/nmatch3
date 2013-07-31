package com.thenitro.ngine.match3.bonuses {
	import com.thenitro.ngine.bonuses.IBonus;
	import com.thenitro.ngine.grid.interfaces.IGridContainer;
	import com.thenitro.ngine.match3.Match3Logic;
	import com.thenitro.ngine.pool.IReusable;
	
	public interface IMatch3Bonus extends IBonus, IReusable {
		function init(pGrid:IGridContainer, pLogic:Match3Logic, pDepth:uint):void;
		function setCoords(pX:uint, pY:uint):void;
	}
}