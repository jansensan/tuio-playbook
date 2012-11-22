package org.tuio.tuioplaybook.view.canvas
{
	import flash.geom.Point;
	import net.jansensan.display.DisplayObjectPool;
	import net.jansensan.mvc.view.IView;

	import qnx.events.QNXApplicationEvent;
	import qnx.system.QNXApplication;

	import org.osflash.signals.Signal;
	import org.osflash.signals.natives.NativeSignal;
	import org.tuio.tuioplaybook.constants.Orientation;

	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.display.StageOrientation;
	import flash.events.Event;
	import flash.events.StageOrientationEvent;
	import flash.events.TouchEvent;
	import flash.geom.Rectangle;
	import flash.ui.Multitouch;
	import flash.ui.MultitouchInputMode;


	/**
	 * @author Mat Janson Blanchet
	 */
	public class CanvasView extends Sprite implements IView
	{
		[Embed(source="assets/images/vignette.png")]
		private	const	VignetteClass	:Class;
		
		[Embed(source="assets/images/arrow.png")]
		private	const	ArrowAsset	:Class;

		private	var	_viewport				:Rectangle;
		
		private	var	_vignette				:Bitmap;
		private	var	_arrow					:Sprite;
		
		private	var	_orientationChanging	:NativeSignal;
		private	var	_orientationChanged		:NativeSignal;
		private	var	_resized				:NativeSignal;
		private	var	_bezelSwiped			:NativeSignal;
		private	var	_touchBegan				:NativeSignal;
		private	var	_touchEnded				:NativeSignal;
		private	var	_touchMoved				:NativeSignal;
		private	var	_updated				:Signal;
		private	var	_settingsViewRequested	:Signal;
		
		private	var	_maxTouchPoints			:uint;
		private	var	_cursorPool				:DisplayObjectPool;
		private	var	_activeCursors			:Vector.<TouchCursor>;
		private	var	_touchPoints			:Vector.<Point>;
		private	var	_numActiveCursors		:int = 0;
		
		private	var	_isVisible				:Boolean = false;


		public	var	orientation	:uint = Orientation.AUTOMATIC;


		// + ----------------------------------------
		//		[ PUBLIC METHODS ]
		// + ----------------------------------------

		public function init():void
		{
			// http://www.adobe.com/devnet/flash/articles/multitouch_gestures.html
			Multitouch.inputMode = MultitouchInputMode.TOUCH_POINT;
			
			
			//  add ui
			addVignette();
			addArrow();
			
			
			// updates
			updateViewport();
			updateLayout();
			
			
			// add signals
			_orientationChanging = new NativeSignal	(	stage,
														StageOrientationEvent.ORIENTATION_CHANGING,
														StageOrientationEvent
													);
			
			_orientationChanged = new NativeSignal	(	stage,
														StageOrientationEvent.ORIENTATION_CHANGE,
														StageOrientationEvent
													);
			
			_resized = new NativeSignal	(	stage,
											Event.RESIZE,
											Event
										);
			
			var app:QNXApplication = QNXApplication.qnxApplication;
			_bezelSwiped = new NativeSignal	(	app,
												QNXApplicationEvent.SWIPE_DOWN,
												QNXApplicationEvent
											);
			
			_touchBegan = new NativeSignal	(	stage,
												TouchEvent.TOUCH_BEGIN,
												TouchEvent
											);
			
			_touchEnded = new NativeSignal	(	stage,
												TouchEvent.TOUCH_END,
												TouchEvent
											);
			
			_touchMoved = new NativeSignal	(	stage,
												TouchEvent.TOUCH_MOVE,
												TouchEvent
											);
			
			_updated = new Signal();
			_settingsViewRequested = new Signal();
			
			
			// create pool
			createCursorPool();
		}


		public function show():void
		{
//			if(orientation == Orientation.AUTOMATIC || orientation == Orientation.LANDSCAPE)
//			{
//				if(stage.orientation != StageOrientation.DEFAULT)
//				{
//					stage.setOrientation(StageOrientation.DEFAULT);
//				}
//			}
//			else
//			{
//				stage.setOrientation(StageOrientation.ROTATED_RIGHT);
//			}
			
			_bezelSwiped.add(onBezelSwiped);
			_touchBegan.add(onTouchBegan);
			_touchMoved.add(onTouchMoved);
			_touchEnded.add(onTouchEnded);
			
			_orientationChanging.add(onOrientationChanging);
			_orientationChanged.add(onOrientationChanged);
			_resized.add(onStageResized);
			
			_isVisible = true;
		}


		public function hide():void
		{
			_isVisible = false;
			
			_bezelSwiped.remove(onBezelSwiped);
			_touchBegan.remove(onTouchBegan);
			_touchMoved.remove(onTouchMoved);
			_touchEnded.remove(onTouchEnded);
			
			_orientationChanging.remove(onOrientationChanging);
			_orientationChanged.remove(onOrientationChanged);
			_resized.remove(onStageResized);
		}


		public function kill():void
		{
			
		}


		// + ----------------------------------------
		//		[ PRIVATE METHODS ]
		// + ----------------------------------------

		private function addVignette():void
		{
			_vignette = new VignetteClass();
			_vignette.smoothing = true;
			addChild(_vignette);
		}


		private function addArrow():void
		{
			var image:Bitmap = new ArrowAsset();
			image.x = -int(image.width * 0.5);
			image.y = -int(image.height * 0.5);
			image.alpha = 0.125;

			_arrow = new Sprite();
			_arrow.addChild(image);

			addChild(_arrow);
		}


		private function updateViewport():void
		{
			if(!_viewport)
			{
				_viewport = new Rectangle();
			}
			_viewport.width = stage.stageWidth;
			_viewport.height = stage.stageHeight;
		}


		private function updateLayout():void
		{
			_vignette.width = _viewport.width;
			_vignette.height = _viewport.height;
			
			_arrow.x = int(_viewport.width * 0.5);
			_arrow.y = int(_viewport.height * 0.5);
		}


		private function createCursorPool():void
		{
			_maxTouchPoints = Multitouch.maxTouchPoints;
			_cursorPool = new DisplayObjectPool(TouchCursor, _maxTouchPoints);
			_activeCursors = new Vector.<TouchCursor>();
		}


		private function getActiveCursorById(id:int):TouchCursor
		{
			var cursor:TouchCursor;
			var i:uint;
			for(i = 0; i < _numActiveCursors; i++)
			{
				if(_activeCursors[i].id == id)
				{
					cursor = _activeCursors[i];
					break;
				}
			}
			return cursor;
		}


		private function removeCursor(cursor:TouchCursor):void
		{
			// remove from display list
			removeChild(cursor);
			
			// remove from active list
			var i:uint;
			for(i = 0; i < _numActiveCursors; i++)
			{
				if(cursor == _activeCursors[i])
				{
					_activeCursors.splice(i, 1);
					_numActiveCursors = _activeCursors.length;
				}
			}
			
			// return to pool
			_cursorPool.returnItem(cursor);
		}


		private function setTouchPoints():void
		{
			if(!_touchPoints)
			{
				_touchPoints = new Vector.<Point>();
			}
			else
			{
				_touchPoints.length = 0;
			}
			
			var p:Point;
			var i:uint;
			for(i = 0; i < _numActiveCursors; i++)
			{
				p = new Point();
				p.x = _activeCursors[i].x;
				p.y = _activeCursors[i].y;
				_touchPoints.push(p);
			}
		}


		// + ----------------------------------------
		//		[ EVENT HANDLERS ]
		// + ----------------------------------------

		private function onStageResized(_:Event):void
		{
			updateViewport();
			updateLayout();
		}


		private function onOrientationChanging(_:StageOrientationEvent):void
		{
			if(!_isVisible || (_isVisible && orientation != Orientation.AUTOMATIC))
			{
				_.preventDefault();
				_.stopImmediatePropagation();
				_.stopPropagation();
			}
		}


		private function onOrientationChanged(_:StageOrientationEvent):void
		{
			
		}


		private function onBezelSwiped(_:QNXApplicationEvent):void
		{
			_settingsViewRequested.dispatch();
		}


		private function onTouchBegan(_:TouchEvent):void
		{
			var cursor:TouchCursor = _cursorPool.getItem() as TouchCursor;
			if(cursor)
			{
				cursor.id = _.touchPointID;
				cursor.x = _.stageX;
				cursor.y = _.stageY;
				addChild(cursor);
				_activeCursors.push(cursor);
				_numActiveCursors = _activeCursors.length;
			}
			_updated.dispatch();
		}


		private function onTouchMoved(_:TouchEvent):void
		{
			var cursor:TouchCursor = getActiveCursorById(_.touchPointID);
			if(cursor)
			{
				cursor.x = _.stageX;
				cursor.y = _.stageY;
			}
			_updated.dispatch();
		}


		private function onTouchEnded(_:TouchEvent):void
		{
			removeCursor(getActiveCursorById(_.touchPointID));
			_updated.dispatch();
		}


		// + ----------------------------------------
		//		[ GETTERS / SETTERS ]
		// + ----------------------------------------

		public function get settingsViewRequested():Signal
		{
			return _settingsViewRequested;
		}


		public function get updated():Signal
		{
			return _updated;
		}


		public function get touchPoints():Vector.<Point>
		{
			setTouchPoints();
			return _touchPoints;
		}


		public function get viewport():Rectangle
		{
			return _viewport;
		}
	}
}
