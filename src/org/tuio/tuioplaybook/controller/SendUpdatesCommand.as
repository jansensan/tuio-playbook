package org.tuio.tuioplaybook.controller
{
	import org.robotlegs.mvcs.SignalCommand;
	import org.tuio.tuioplaybook.service.TUIOService;

	import flash.geom.Point;
	import flash.geom.Rectangle;


	/**
	 * @author Mat Janson Blanchet
	 */
	public class SendUpdatesCommand extends SignalCommand
	{
		[Inject]
		public	var	viewport	:Rectangle;
		
		[Inject]
		public	var	touchPoints	:Vector.<Point>;
		
		[Inject]
		public	var	tuio	:TUIOService;


		override public function execute():void
		{
			tuio.sendUpdates(viewport, touchPoints);
		}
	}
}
