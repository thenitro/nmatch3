package com.thenitro.match3sample.items {
	
	public final class Blue extends Cell {
		
		public function Blue(pWidth:uint, pHeight:uint) {
			super(0x0000FF, pWidth, pHeight);
		};
		
		override public function get reflection():Class {
			return Blue;
		};
	}
}