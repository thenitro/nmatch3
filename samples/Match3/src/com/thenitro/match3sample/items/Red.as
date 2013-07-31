package com.thenitro.match3sample.items {
	
	public final class Red extends Cell {
		
		public function Red(pWidth:uint, pHeight:uint) {
			super(0xFF0000, pWidth, pHeight);
		};
		
		override public function get reflection():Class {
			return Red;
		};
	};
}