package org.tuio.tuioplaybook.controller
{
	import org.robotlegs.mvcs.Command;
	import org.tuio.tuioplaybook.model.StateModel;


	/**
	 * @author Mat Janson Blanchet
	 */
	public class SetStateCommand extends Command
	{
		[Inject]
		public	var	state	:String;
		
		[Inject]
		public	var	model	:StateModel;


		override public function execute():void
		{
			model.setState(state);
		}
	}
}
