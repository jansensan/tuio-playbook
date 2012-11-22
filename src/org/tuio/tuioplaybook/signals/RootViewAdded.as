package org.tuio.tuioplaybook.signals
{
	import org.osflash.signals.Signal;

	import flash.display.Stage;


	/**
	 * @author Mat Janson Blanchet
	 */
	public class RootViewAdded extends Signal
	{
		public function RootViewAdded()
		{
			super(Stage);
		}
	}
}
