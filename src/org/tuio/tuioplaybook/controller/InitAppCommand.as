package org.tuio.tuioplaybook.controller
{
	import org.robotlegs.mvcs.SignalCommand;
	import org.tuio.tuioplaybook.fonts.Fonts;
	import org.tuio.tuioplaybook.model.SettingsModel;
	import org.tuio.tuioplaybook.model.StateModel;
	import org.tuio.tuioplaybook.service.TUIOService;
	import org.tuio.tuioplaybook.signals.CanvasUpdated;
	import org.tuio.tuioplaybook.signals.RootViewAdded;
	import org.tuio.tuioplaybook.signals.SettingsViewHidden;
	import org.tuio.tuioplaybook.signals.SettingsViewUpdated;
	import org.tuio.tuioplaybook.signals.StateChanged;
	import org.tuio.tuioplaybook.view.canvas.CanvasMediator;
	import org.tuio.tuioplaybook.view.canvas.CanvasView;
	import org.tuio.tuioplaybook.view.settings.SettingsMediator;
	import org.tuio.tuioplaybook.view.settings.SettingsView;


	/**
	 * @author Mat Janson Blanchet
	 */
	public class InitAppCommand extends SignalCommand
	{
		[Inject]
		public	var	rootViewAdded	:RootViewAdded;


		override public function execute():void
		{
			signalCommandMap.mapSignalClass	(	StateChanged, 
												SetStateCommand,
												false
											);
			signalCommandMap.mapSignalClass	(	SettingsViewUpdated, 
												UpdateSettingsCommand,
												false
											);
			signalCommandMap.mapSignalClass	(	CanvasUpdated, 
												SendUpdatesCommand,
												false
											);
			
			injector.mapSingleton(SettingsViewHidden);
			injector.mapSingleton(StateModel);
			injector.mapSingleton(SettingsModel);
			injector.mapSingleton(TUIOService);
			
			mediatorMap.mapView(SettingsView, SettingsMediator);
			mediatorMap.mapView(CanvasView, CanvasMediator);
			
			var fonts:Fonts = new Fonts();
//			fonts.traceEmbeddedFonts();
			
			contextView.addChild(new CanvasView());
			contextView.addChild(new SettingsView());
		}
	}
}
