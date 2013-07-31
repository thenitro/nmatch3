package com.thenitro.ngine.match3 {
	import com.thenitro.monsterinarow.games.abstract.bonuses.Clean3x3Bonus;
	import com.thenitro.monsterinarow.games.abstract.bonuses.CleanLineBonus;
	import com.thenitro.monsterinarow.global.monsters.Monster;
	import com.thenitro.monsterinarow.net.Player;
	import com.thenitro.monsterinarow.net.Server;
	import com.thenitro.monsterinarow.net.requests.BonusAchieved;
	import com.thenitro.monsterinarow.utils.SoundManager;
	
	import starling.events.EventDispatcher;
	
	public final class Match3Score extends EventDispatcher {
		public static const SCORE_CHANGE:String  = 'score_change';
		public static const LEVEL_UP:String      = 'level_up';
		public static const ENCOURAGEMENT:String = 'encouragement';
		public static const WIN:String           = 'win';
		
		private static const GROUP_BONUS_MIN_COUNT:uint = 5;
		
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
		private var _mana:uint;
		
		private var _level:uint;
		
		private var _enemies:Vector.<Player>;
		private var _enemy:Player;
		
		private var _pickedMonster:Monster;
		
		private var _groupColor:Class;
		private var _prevGroupColor:Class;
		
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
		
		public function get enemy():Player {
			return _enemy;
		};
		
		public function pick(pMonster:Monster):void {
			_prevGroupColor = _groupColor;
			_groupColor     = null; 
			
			_pickedMonster = pMonster;
		};
		
		public function track(pGroup:Array):void {
			_turnRemoved++;
			
			var groupScore:uint = 0;
			var groupMana:uint  = 0;
			
			var scoreMul:Number = Math.max(1, Math.max(0, pGroup.length - GROUP_BONUS_MIN_COUNT) * 1.5);
			var manaMul:Number  = Math.max(1, Math.max(0, pGroup.length - GROUP_BONUS_MIN_COUNT) * 2.0);
			
			var combo:Boolean;
			
			if (checkCombo()) {
				trace("Match3Score.track(pGroup) Give me bonus!");
				
				var bonus:BonusAchieved = new BonusAchieved();
					bonus.send();
					
				combo = true;
			}
			
			for each (var monster:Monster in pGroup) {
				if (combo) {
					monster.doubleMana();
				}
				
				groupScore += monster.scoreCoef;
				groupMana  += monster.manaCoef;
				
				if (_pickedMonster == monster) {
					_groupColor = _pickedMonster.reflection;
				}
			}
			
			_score += groupScore * scoreMul;
			_mana  += groupMana  * manaMul;
			
			var currentLevel:uint  = searchLevel();
			
			if (currentLevel != _level) {
				_level = currentLevel;
				
				dispatchEventWith(LEVEL_UP, false, _level);
			}
			
			dispatchEventWith(SCORE_CHANGE, false, { score:      _score, 
													 current:    groupScore * scoreMul, 
													 count:      _turnRemoved, 
													 positionX:  monster.x,
													 positionY:  monster.y } );
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
		
		public function updateEnemies(pEnemies:Vector.<Player>):void {
			_enemies = pEnemies;
		};
		
		public function checkEnemies():void {
			for each (var enemy:Player in _enemies) {
				if (score > enemy.score) {
					_enemy = enemy;
					
					dispatchEventWith(WIN, false, enemy);
					return;
				}
			}
		};
		
		public function complete():void {
			_turnRemoved = 0;
		};
		
		public function clean():void {
			_score = 0;
			_level = 0;
		};
		
		private function checkCombo():Boolean {
			if (!_groupColor || !_prevGroupColor) {
				return false;
			}
			
			if (_groupColor == _prevGroupColor) {
				_groupColor     = null;
				_prevGroupColor = null;
				
				return true;
			}
	
			return false;
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