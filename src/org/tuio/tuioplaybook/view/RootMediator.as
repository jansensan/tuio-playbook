package org.tuio.tuioplaybook.view
{
	import org.robotlegs.mvcs.Mediator;
	import org.tuio.tuioplaybook.signals.RootViewAdded;


	/**
	 * @author jansensan
	 */
	public class RootMediator extends Mediator
	{
		[Inject]
		public	var	view	:RootView;
		
		[Inject]
		public	var	rootViewAdded	:RootViewAdded;


		override public function onRegister():void
		{
			view.init();
			rootViewAdded.dispatch(view.stage);
		}
	}
}
