package org.tuio.tuioplaybook.controller
{
	import org.robotlegs.mvcs.Command;
	import org.tuio.tuioplaybook.model.SettingsModel;
	import org.tuio.tuioplaybook.model.valueobjects.SettingsVO;


	/**
	 * @author Mat Janson Blanchet
	 */
	public class UpdateSettingsCommand extends Command
	{
		[Inject]
		public	var	settings	:SettingsModel;
		
		[Inject]
		public	var	vo	:SettingsVO;


		override public function execute():void
		{
			settings.setHost(vo.host);
			settings.setPort(vo.port);
			
			settings.setProtocolIndex(vo.protocolIndex);
			
			settings.setOrientationIndex(vo.orientationIndex);
			
			settings.setSendPeriodicUpdates(vo.sendPeriodicUpdates);
			settings.setSendFullUpdates(vo.sendFullUpdates);
			
			settings.updated.dispatch(vo);
		}
	}
}
