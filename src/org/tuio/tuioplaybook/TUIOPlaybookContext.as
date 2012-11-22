package org.tuio.tuioplaybook
{
	import org.osflash.signals.Signal;
	import org.robotlegs.mvcs.SignalContext;
	import org.tuio.tuioplaybook.controller.AddRootViewCommand;
	import org.tuio.tuioplaybook.controller.InitAppCommand;
	import org.tuio.tuioplaybook.signals.RootViewAdded;
	import org.tuio.tuioplaybook.view.RootMediator;
	import org.tuio.tuioplaybook.view.RootView;

	import flash.display.DisplayObjectContainer;


	/**
	 * @author Mat Janson Blanchet
	 */
	public class TUIOPlaybookContext extends SignalContext
	{
		public function TUIOPlaybookContext	(	contextView:DisplayObjectContainer = null, 
												autoStartup:Boolean = true
											)
		{
			super(contextView, autoStartup);
			setupCommands();
			setupModels();
			setupViews();
			dispatchStartup();
		}


		// + ----------------------------------------
		//		[ PRIVATE METHODS ]
		// + ----------------------------------------
		
		private function setupCommands():void
		{
			signalCommandMap.mapSignalClass	(	RootViewAdded, 
												InitAppCommand,
												true
											);
		}


		private function setupModels():void
		{
		}


		private function setupViews():void
		{
			mediatorMap.mapView(RootView, RootMediator);
		}


		private function dispatchStartup():void
		{
			var startUpSignal:Signal = new Signal();
			signalCommandMap.mapSignal	(	startUpSignal, 
											AddRootViewCommand, 
											true
										);
			startUpSignal.dispatch();
		}
	}
}
