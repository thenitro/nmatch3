package nmatch3.bonuses {
	import nmatch3.Match3Logic;
	
	import ngine.display.gridcontainer.interfaces.IGridContainer;
	import ngine.pool.IReusable;
	
	public interface IMatch3Bonus extends IReusable {
		function execute():void;
		function init(pGrid:IGridContainer, pLogic:Match3Logic, pDepth:uint):void;
		function setCoords(pX:uint, pY:uint):void;
	}
}