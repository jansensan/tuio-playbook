package org.tuio.tuioplaybook.model.valueobjects
{


	/**
	 * @author Mat Janson Blanchet
	 */
	public class SettingsVO
	{
		public	var	host				:String;
		public	var	port				:String;
		public	var	protocolIndex		:uint;
		
		public	var	orientationIndex	:uint;
		
		public	var	sendPeriodicUpdates	:Boolean;
		public	var	sendFullUpdates		:Boolean;
	}
}
