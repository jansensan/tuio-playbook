package org.tuio.tuioplaybook.service
{
	import org.robotlegs.mvcs.Actor;
	import org.tuio.tuioplaybook.model.SettingsModel;

	import flash.geom.Point;
	import flash.geom.Rectangle;


	/**
	 * @author Mat Janson Blanchet
	 */
	public class TUIOService extends Actor
	{
		[Inject]
		public	var	settings	:SettingsModel;


		// + ----------------------------------------
		//		[ PUBLIC METHODS ]
		// + ----------------------------------------

		public function sendUpdates(viewport:Rectangle, points:Vector.<Point>):void
		{
			trace("\n", this, "---  sendUpdates  ---");
			
			trace("\t", "viewport: " + (viewport));
			trace("\t", "points: " + (points));
			
			// TODO: find out what and how to send
		}
	}
}
