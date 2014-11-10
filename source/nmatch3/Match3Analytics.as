package nmatch3 {
    import flash.events.TimerEvent;
    import flash.utils.Timer;
    import flash.utils.getTimer;

    import ncollections.grid.Grid;
    import ncollections.grid.IGridObject;

    import nmath.GraphUtils;

    import npooling.Pool;

    import starling.events.EventDispatcher;

    public class Match3Analytics extends EventDispatcher {
		public static const TIME_OUT_EVENT:String     = 'think_too_much';
		public static const TURNS_FINDED_EVENT:String = 'turns_finded';
		
		protected static var _pool:Pool = Pool.getInstance(); 
		
		private static const WAIT_TIME:uint    = 5000;
		private static const EMPTY_ARRAY:Array = [];
		
		private var _timer:Timer;
		
		private var _startTime:uint;
		private var _thinkTime:uint;
		
		protected var _prevTurns:uint;
		protected var _currTurns:uint;
		
		private var _waveDepth:uint;
		
		private var _multiplier:Number;
		
		public function Match3Analytics() {
			super();
			
			_timer = new Timer(WAIT_TIME, 1);
			_timer.addEventListener(TimerEvent.TIMER_COMPLETE, timerEventHandler);
		};
		
		public final function get turnsCount():uint {
			return _currTurns;
		};
		
		public final function getStartTime():uint {
			return _startTime;
		};
		
		public final function setWaveDepth(pValue:uint):void {
			_waveDepth = pValue;
		};
		
		public function findPossibleMoves(pGrid:Grid, 
										  pNextObject:IGridObject = null):void {
			
		};
		
		public final function calculatePlayerSkill(pRemovedMobs:uint):Number {
			pRemovedMobs = pRemovedMobs ? pRemovedMobs : 1;
			
			var turnsDelta:Number   = Math.abs(_prevTurns - _currTurns ? _prevTurns - _currTurns : 1); //turns 
			var turnsToThink:Number = turnsDelta / (_thinkTime / 1000); //time
			var waveDelta:Number    = pRemovedMobs / _waveDepth; //combinations
			
			return turnsToThink * waveDelta;
		};
		
		public final function findElementMatches(pElement:IGridObject, pGrid:Grid):Array {
			if (!pElement) {
				return EMPTY_ARRAY;
			}
			
			return GraphUtils.bfs(pElement.indexX, pElement.indexY, pGrid, GraphUtils.addNeighborsVerticalHorizintal);
		};
		
		public final function start():void {
			_startTime = getTimer();
			
			_timer.start();
		};
		
		public final function stop():uint {
			_thinkTime = getTimer() - _startTime;
			
			_timer.stop();
			_timer.reset();
			
			return _thinkTime;
		};
		
		private function timerEventHandler(pEvent:TimerEvent):void {
			dispatchEventWith(TIME_OUT_EVENT);
		};
	};
}