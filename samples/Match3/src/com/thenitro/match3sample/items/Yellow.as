package com.thenitro.match3sample.items {
	public final class Yellow extends Cell {
		
		public function Yellow(pWidth:uint, pHeight:uint) {
			super(0xFFFF00, pWidth, pHeight);
		};
		
		override public function get reflection():Class {
			return Yellow;
		};
	};
}