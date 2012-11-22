package org.tuio.tuioplaybook.view.canvas
{
	import org.robotlegs.mvcs.SignalMediator;
	import org.tuio.tuioplaybook.constants.State;
	import org.tuio.tuioplaybook.model.SettingsModel;
	import org.tuio.tuioplaybook.model.StateModel;
	import org.tuio.tuioplaybook.signals.CanvasUpdated;
	import org.tuio.tuioplaybook.signals.SettingsViewHidden;
	import org.tuio.tuioplaybook.signals.StateChanged;


	/**
	 * @author Mat Janson Blanchet
	 */
	public class CanvasMediator extends SignalMediator
	{
		[Inject]
		public	var	view	:CanvasView;
		
		[Inject]
		public	var	stateModel	:StateModel;
		
		[Inject]
		public	var	settingsModel	:SettingsModel;
		
		[Inject]
		public	var	stateChanged	:StateChanged;
		
		[Inject]
		public	var	settingsViewHidden	:SettingsViewHidden;
		
		[Inject]
		public	var	canvasUpdated	:CanvasUpdated;


		// + ----------------------------------------
		//		[ EVENT HANDLERS ]
		// + ----------------------------------------

		override public function onRegister():void
		{
			signalMap.addToSignal(stateModel.updated, onStateModelUpdated);
			signalMap.addToSignal(settingsViewHidden, onSettingsViewHidden);
			
			view.init();
			
			signalMap.addToSignal(view.updated, onCanvasUpdated);
			signalMap.addToSignal(view.settingsViewRequested, onSettingsViewRequested);
		}


		private function onStateModelUpdated():void
		{
			if(stateModel.state == State.CANVAS)
			{
				view.show();
			}
			else
			{
				view.hide();
			}
		}


		private function onCanvasUpdated():void
		{
			canvasUpdated.dispatch(view.viewport, view.touchPoints);
		}


		private function onSettingsViewRequested():void
		{
			stateChanged.dispatch(State.SETTINGS);
		}


		private function onSettingsViewHidden():void
		{
			view.orientation = settingsModel.orientationIndex;
		}
	}
}
