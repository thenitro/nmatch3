package com.thenitro.match3sample.items {
	public final class Green extends Cell {
		
		public function Green(pWidth:uint, pHeight:uint) {
			super(0x00FF00, pWidth, pHeight);
		};
		
		override public function get reflection():Class {
			return Green;
		};
	};
}