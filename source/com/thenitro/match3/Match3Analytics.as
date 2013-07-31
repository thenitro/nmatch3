package com.thenitro.ngine.match3 {
	import com.thenitro.ngine.grid.GridContainer;
	import com.thenitro.ngine.grid.IGridContainer;
	import com.thenitro.ngine.grid.IGridObject;
	import com.thenitro.ngine.math.GraphUtils;
	import com.thenitro.ngine.pool.Pool;
	
	import flash.utils.getTimer;
	
	public class Match3Analytics {
		protected static var _pool:Pool = Pool.getInstance(); 
		
		private static const EMPTY_ARRAY:Array = [];
		
		private var _startTime:uint;
		private var _thinkTime:uint;
		
		protected var _prevTurns:uint;
		protected var _currTurns:uint;
		
		private var _waveDepth:uint;
		
		private var _multiplier:Number;
		
		public function Match3Analytics() {
			
		};
		
		public final function getStartTime():uint {
			return _startTime;
		};
		
		public final function setWaveDepth(pValue:uint):void {
			_waveDepth = pValue;
		};
		
		public final function calculatePlayerSkill(pRemovedMobs:uint):Number {
			pRemovedMobs = pRemovedMobs ? pRemovedMobs : 1;
			
			var turnsDelta:Number   = Math.abs(_prevTurns - _currTurns ? _prevTurns - _currTurns : 1);
			var turnsToThink:Number = turnsDelta / (_thinkTime / 1000);
			var waveDelta:Number    = pRemovedMobs / _waveDepth;
			
			trace("Match3Analytics.calculatePlayerSkill(pRemovedMobs) turns delta", turnsDelta);
			trace("Match3Analytics.calculatePlayerSkill(pRemovedMobs) turns think", turnsToThink, _thinkTime);
			trace("Match3Analytics.calculatePlayerSkill(pRemovedMobs) removed", pRemovedMobs);
			trace("Match3Analytics.calculatePlayerSkill(pRemovedMobs) delta", waveDelta);
			trace("Match3Analytics.calculatePlayerSkill(pRemovedMobs)", turnsToThink * waveDelta);
			
			return turnsToThink * waveDelta;
		};
		
		public final function findElementMatches(pElement:IGridObject, pGrid:IGridContainer):Array {
			if (!pElement) {
				return EMPTY_ARRAY;
			}
			
			return GraphUtils.bfs(pElement.indexX, pElement.indexY, pGrid);
		};
		
		public final function start():void {
			_startTime = getTimer();
		};
		
		public final function stop():uint {
			_thinkTime = getTimer() - _startTime;
			
			return _thinkTime;
		};
	};
}