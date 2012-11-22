package org.tuio.tuioplaybook.model
{
	import org.osflash.signals.Signal;
	import org.robotlegs.mvcs.Actor;
	import org.tuio.tuioplaybook.constants.State;


	/**
	 * @author Mat Janson Blanchet
	 */
	public class StateModel extends Actor
	{
		private	var	_state		:String = State.SETTINGS;
		private	var	_updated	:Signal;


		public function StateModel()
		{
			super();
			_updated = new Signal();
		}


		public function setState(state:String):void
		{
			_state = state;
			_updated.dispatch();
		}


		public function get state():String
		{
			return _state;
		}


		public function get updated():Signal
		{
			return _updated;
		}
	}
}
