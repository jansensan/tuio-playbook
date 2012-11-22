package org.tuio.tuioplaybook.controller
{
	import org.robotlegs.mvcs.SignalCommand;
	import org.tuio.tuioplaybook.view.RootView;


	/**
	 * @author Mat Janson Blanchet
	 */
	public class AddRootViewCommand extends SignalCommand
	{
		override public function execute():void
		{
			contextView.addChild(new RootView());
		}
	}
}
