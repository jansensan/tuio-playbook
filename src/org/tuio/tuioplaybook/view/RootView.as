package org.tuio.tuioplaybook.view
{
	import net.jansensan.mvc.view.IView;

	import flash.display.Sprite;


	/**
	 * @author jansensan
	 */
	public class RootView extends Sprite implements IView
	{
		public function init():void
		{
		}


		public function show():void
		{
			visible = true;
		}


		public function hide():void
		{
			visible = false;
		}


		public function kill():void
		{
		}
	}
}
