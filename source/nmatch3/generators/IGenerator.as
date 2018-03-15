package nmatch3.generators {
	import nmatch3.models.LocationShapeVO;

	import ncollections.grid.Grid;
	import ncollections.grid.IGridObject;
	
	public interface IGenerator {
		
		function generateGrid(pGrid:Grid, 
							  pElements:Array, 
							  pEndX:uint, pEndY:uint, 
							  pCellWidth:Number, pCellHeight:Number,
							  pShape:LocationShapeVO):void;
		
		function generateOne(pI:uint, pJ:uint, 
							 pGrid:Grid, 
							 pElements:Array,
							 pCellWidth:Number, pCellHeight:Number):IGridObject;
	};
}