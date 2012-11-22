package org.tuio.tuioplaybook.signals
{
	import org.osflash.signals.Signal;

	import flash.geom.Point;
	import flash.geom.Rectangle;


	/**
	 * @author Mat Janson Blanchet
	 */
	public class CanvasUpdated extends Signal
	{
		public function CanvasUpdated()
		{
			super(Rectangle, Vector.<Point>);
		}
	}
}
