package {
	import com.thenitro.match3sample.Game;
	
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	
	import starling.core.Starling;
	
	public class NMatch3Sample extends Sprite {
		
		public function NMatch3Sample() {
			stage.align     = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
			var s:Starling = new Starling(Game, stage);
				s.start();
		};
	};
}