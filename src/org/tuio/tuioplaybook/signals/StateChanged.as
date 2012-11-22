package org.tuio.tuioplaybook.signals
{
	import org.osflash.signals.Signal;


	/**
	 * @author Mat Janson Blanchet
	 */
	public class StateChanged extends Signal
	{
		public function StateChanged()
		{
			super(String);
		}
	}
}
