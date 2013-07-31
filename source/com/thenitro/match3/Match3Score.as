package com.thenitro.ngine.match3 {
	import com.thenitro.monsterinarow.utils.SoundManager;
	
	import starling.events.EventDispatcher;
	
	public final class Match3Score extends EventDispatcher {
		public static const SCORE_CHANGE:String  = 'score_change';
		public static const LEVEL_UP:String      = 'level_up';
		public static const ENCOURAGEMENT:String = 'encouragement';
		
		private static const ENCOURAGEMENTS:Object = {
			2: 'Nice',
			3: 'Good!',
			4: 'Super',
			5: 'Fantastic',
			6: 'Wow!',
			7: 'Amazing!',
			8: 'Outstanding',
			9: 'Impossible!',
		   10: 'Unbelivable',
		   11: 'Too nice!'
		};
			
		private static var _sounds:SoundManager = SoundManager.getInstance();
		
		private var _levels:Array;
		private var _waveDepth:uint;
		
		private var _turnRemoved:uint;
		private var _score:uint;
		private var _level:uint;
		
		public function Match3Score(pDepth:uint, pLevels:Array) {
			_score     = 0;
			_waveDepth = pDepth;
			_levels    = pLevels;
			
			super();
		};
		
		public function get level():uint {
			return _level;
		};
		
		public function get score():uint {
			return _score;
		};
		
		public function get turnRemoved():uint {
			return _turnRemoved;
		};
		
		public function track(pPositionX:uint, pPositionY:uint, pDeadTextureID:String):void {
			_turnRemoved++;
			
			var currentGemScore:uint = _turnRemoved * 10;
			_score += currentGemScore;
			
			var currentLevel:uint  = searchLevel();
			
			if (currentLevel != _level) {
				_level = currentLevel;
				
				dispatchEventWith(LEVEL_UP, false, _level);
			}
			
			dispatchEventWith(SCORE_CHANGE, false, { score:   _score, 
												     current:  currentGemScore, 
												     count:   _turnRemoved, 
												     positionX:  pPositionX,
												     positionY:  pPositionY,
												     deadTextureID: pDeadTextureID } );
		};
		
		public function encouragement():void {
			var showID:uint = uint(_turnRemoved / _waveDepth);
			var data:String = ENCOURAGEMENTS[showID.toString()];
			
			if (!data) {
				return;
			}
			
			_sounds.playSound(SoundManager.ENCOURAGEMENT_SOUND);
			
			dispatchEventWith(ENCOURAGEMENT, false, data);
		};
		
		public function complete():void {
			_turnRemoved = 0;
		};
		
		public function clean():void {
			_score = 0;
			_level = 0;
		};
		
		private function searchLevel():uint {
			for each (var current:uint in _levels) {
				if (!(_score >= current)) {
					return _levels.indexOf(current) - 1;
				}
			}
			
			return 0;
		};
	};
}