package com.thenitro.match3sample.items {
	public final class Cyan extends Cell {
		
		public function Cyan(pWidth:uint, pHeight:uint) {
			super(0x00FFFF, pWidth, pHeight);
		};
		
		override public function get reflection():Class {
			return Cyan;
		};
	}
}