package org.tuio.tuioplaybook.view.canvas
{
	import flash.display.Shape;
	import flash.display.Sprite;


	/**
	 * @author Mat Janson Blanchet
	 */
	public class TouchCursor extends Sprite
	{
		private	const	RADIUS	:uint = 48;


		private	var	_circle		:Shape;
		private	var	_crossHair	:Shape;


		public	var	id		:int;


		public function TouchCursor()
		{
			const LINE_THICKNESS:uint = 2;
			const LINE_COLOR:uint = 0x333333;
			
			_circle = new Shape();
			_circle.graphics.beginFill(LINE_COLOR);
			_circle.graphics.drawCircle(0, 0, RADIUS);
			_circle.graphics.beginFill(0xcccccc);
			_circle.graphics.drawCircle(0, 0, RADIUS - LINE_THICKNESS);
			_circle.graphics.endFill();
			_circle.alpha = 0.5;
			
			const LINE_HEIGHT:uint = 600;
			const LINE_WIDTH:uint = 1024;
			
			_crossHair = new Shape();
			_crossHair.graphics.lineStyle(LINE_THICKNESS, LINE_COLOR);
			_crossHair.graphics.moveTo(0, -RADIUS);
			_crossHair.graphics.lineTo(0, -LINE_HEIGHT);
			_crossHair.graphics.moveTo(RADIUS, 0);
			_crossHair.graphics.lineTo(LINE_WIDTH, 0);
			_crossHair.graphics.moveTo(0, RADIUS);
			_crossHair.graphics.lineTo(0, LINE_HEIGHT);
			_crossHair.graphics.moveTo(-RADIUS, 0);
			_crossHair.graphics.lineTo(-LINE_WIDTH, 0);
			_crossHair.alpha = 0.25;
			
			addChild(_crossHair);
			addChild(_circle);
		}
	}
}
