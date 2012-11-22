package org.tuio.tuioplaybook.view.settings
{
	import org.robotlegs.mvcs.SignalMediator;
	import org.tuio.tuioplaybook.constants.State;
	import org.tuio.tuioplaybook.model.SettingsModel;
	import org.tuio.tuioplaybook.model.StateModel;
	import org.tuio.tuioplaybook.model.valueobjects.SettingsVO;
	import org.tuio.tuioplaybook.signals.SettingsViewHidden;
	import org.tuio.tuioplaybook.signals.SettingsViewUpdated;
	import org.tuio.tuioplaybook.signals.StateChanged;


	/**
	 * @author Mat Janson Blanchet
	 */
	public class SettingsMediator extends SignalMediator
	{
		[Inject]
		public	var	view	:SettingsView;
		
		[Inject]
		public	var	stateModel	:StateModel;
		
		[Inject]
		public	var	settingsModel	:SettingsModel;
		
		[Inject]
		public	var	stateChanged	:StateChanged;
		
		[Inject]
		public	var	settingsViewUpdated	:SettingsViewUpdated;
		
		[Inject]
		public	var	settingsViewHidden	:SettingsViewHidden;


		override public function onRegister():void
		{
			signalMap.addToSignal(stateModel.updated, onStateUpdated);
			signalMap.addToSignal(settingsModel.updated, onSettingsUpdated);
			
			view.init();
			view.setDeviceIPLabel(settingsModel.deviceIP);
			view.setHostInput(settingsModel.host);
			view.setPortInput(settingsModel.port);
			view.canvasViewRequested.add(onCanvasViewRequested);
			view.updated.add(onViewUpdated);
			view.hidden.add(onViewHidden);
		}


		private function onStateUpdated():void
		{
			if(stateModel.state == State.SETTINGS)
			{
				view.show();
			}
			else
			{
				view.hide();
			}
		}


		private function onSettingsUpdated(vo:SettingsVO):void
		{
			trace("\n", this, "---  onSettingsUpdated  ---");
		}


		private function onCanvasViewRequested():void
		{
			stateChanged.dispatch(State.CANVAS);
		}


		private function onViewUpdated():void
		{
			settingsViewUpdated.dispatch(view.getSettings());
		}


		private function onViewHidden():void
		{
			settingsViewHidden.dispatch();
		}
	}
}
