package org.tuio.tuioplaybook
{
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;


	[SWF(backgroundColor="#cccccc", frameRate="60", width="1024", height="600")]
	public class TUIOPlaybook extends Sprite
	{
		private	var	_context	:TUIOPlaybookContext;


		public function TUIOPlaybook()
		{
			init();
		}


		private function init():void
		{
			initStage();
			initContext();
		}


		private function initStage():void
		{
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
		}


		private function initContext():void
		{
			_context = new TUIOPlaybookContext(this, true);
		}
	}
}
