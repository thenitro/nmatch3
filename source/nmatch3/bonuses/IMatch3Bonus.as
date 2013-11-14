package nmatch3.bonuses {
	import ngine.display.gridcontainer.interfaces.IGridContainer;
	
	import nmatch3.Match3Logic;
	
	import npooling.IReusable;
	
	public interface IMatch3Bonus extends IReusable {
		function execute():void;
		function init(pGrid:IGridContainer, pLogic:Match3Logic, pDepth:uint):void;
		function setCoords(pX:uint, pY:uint):void;
	}
}