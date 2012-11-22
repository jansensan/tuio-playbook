package org.tuio.tuioplaybook.signals
{
	import org.osflash.signals.Signal;
	import org.tuio.tuioplaybook.model.valueobjects.SettingsVO;


	/**
	 * @author Mat Janson Blanchet
	 */
	public class SettingsViewUpdated extends Signal
	{
		public function SettingsViewUpdated()
		{
			super(SettingsVO);
		}
	}
}
