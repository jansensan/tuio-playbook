package org.tuio.tuioplaybook.view.settings
{
	import flash.display.StageOrientation;
	import net.jansensan.mvc.view.IView;
	import net.jansensan.utils.validateIP;

	import qnx.dialog.AlertDialog;
	import qnx.dialog.DialogSize;
	import qnx.display.IowWindow;
	import qnx.fuse.ui.buttons.LabelButton;
	import qnx.fuse.ui.buttons.SegmentedControl;
	import qnx.fuse.ui.buttons.ToggleSwitch;
	import qnx.fuse.ui.text.TextInput;
	import qnx.ui.data.DataProvider;

	import com.greensock.TweenMax;
	import com.greensock.easing.Cubic;

	import org.osflash.signals.Signal;
	import org.osflash.signals.natives.NativeSignal;
	import org.tuio.tuioplaybook.constants.Filter;
	import org.tuio.tuioplaybook.fonts.Style;
	import org.tuio.tuioplaybook.model.valueobjects.SettingsVO;

	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.MouseEvent;
	import flash.events.StageOrientationEvent;
	import flash.text.AntiAliasType;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;


	/**
	 * @author Mat Janson Blanchet
	 */
	public class SettingsView extends Sprite implements IView
	{
		private	const	WIDTH			:uint = 1024;
		private	const	HEIGHT			:uint = 600;
		private	const	PADDING			:uint = 32;
		private	const	HEADER_HEIGHT	:uint = 160;
		private	const	COLUMN_WIDTH	:uint = (WIDTH * 0.5) - PADDING;
		
		
		[Embed(source="assets/images/settings-bg.png")]
		private	const	BackgroundClass	:Class;


		private	var	_bg	:Bitmap;
		
		// socket inputs
		private	var	_hostLabel						:TextField;
		private	var	_hostInput						:TextInput;
		private	var	_hostInputBlurred				:NativeSignal;
		private	var	_isHostValid					:Boolean = false;
		
		private	var	_detectButton					:LabelButton;
		private	var	_detectButtonClicked			:NativeSignal;
		
		private	var	_portLabel						:TextField;
		private	var	_portInput						:TextInput;
		private	var	_portInputBlurred				:NativeSignal;
		private	var	_isPortValid					:Boolean = false;
		
		private	var	_protocolSelector				:SegmentedControl;
		private	var	_protocolSelectorSelected		:NativeSignal;
		
		private	var	_defaultButton					:LabelButton;
		private	var	_defaultButtonClicked			:NativeSignal;
		
		private	var	_currentIPLabel					:TextField;
		private	var	_currentIPValue					:TextField;
		
		private	var	_socketInputsHolder				:Sprite;

		// orientations
		private	var	_orientationSelector			:SegmentedControl;
		private	var	_orientationSelectorChanged		:NativeSignal;
		
		private	var	_orientationsInputsHolder		:Sprite;

		// updates
		private	var	_periodicUpdatesLabel			:TextField;
		private	var	_periodicUpdatesToggle			:ToggleSwitch;
		private	var	_periodicUpdatesToggleSelected	:NativeSignal;
		
		private	var	_fullUpdatesLabel				:TextField;
		private	var	_fullUpdatesToggle				:ToggleSwitch;
		private	var	_fullUpdatesToggleSelected		:NativeSignal;
		
		private	var	_updatesInputsHolder			:Sprite;

		// start
		private	var	_startButton					:LabelButton;
		private	var	_startButtonClicked				:NativeSignal;
		
		private	var	_startButtonHolder				:Sprite;

		// version
		private	var	_versionLabel					:TextField;
		private	var	_versionLabelHolder				:Sprite;

		private	var	_updated						:Signal;
		private	var	_canvasViewRequested			:Signal;

		// alert
		private	var	_alert							:AlertDialog;
		private	var	_alertButtonClicked				:NativeSignal;

		private	var	_hidden							:Signal;

		private	var	_orientationChanging			:NativeSignal;


		// + ----------------------------------------
		//		[ PUBLIC METHODS ]
		// + ----------------------------------------

		public function init():void
		{
			_updated = new Signal();
			_hidden = new Signal();
			_canvasViewRequested = new Signal();
			_orientationChanging = new NativeSignal	(	stage,
														StageOrientationEvent.ORIENTATION_CHANGING,
														StageOrientationEvent
													);
			
			addBackground();
			addSocketInputs();
			addOrientationsInputs();
			addUpdatesInputs();
			addStartButton();
			addVersionLabel();
			initAlert();
		}


		public function setDeviceIPLabel(ip:String):void
		{
			_currentIPValue.text = ip;
		}


		public function setHostInput(host:String):void
		{
			_hostInput.text = host;
		}


		public function setPortInput(port:String):void
		{
			_portInput.text = port;
		}


		public function show():void
		{
//			if(stage.orientation != StageOrientation.DEFAULT)
//			{
//				stage.setOrientation(StageOrientation.DEFAULT);
//			}
			
			
			visible = true;
			TweenMax.to	(	this, 
							0.55, 
							{
								y:0,
								ease:Cubic.easeInOut,
								onComplete:onShown
							}
						);
		}


		public function hide():void
		{
			_orientationChanging.remove(onOrientationChanging);
			TweenMax.to	(	this, 
							0.45, 
							{
								y:-HEIGHT,
								ease:Cubic.easeInOut,
								onComplete:onHidden
							}
						);
		}


		public function getSettings():SettingsVO
		{
			var vo:SettingsVO = new SettingsVO();
			
			vo.port = _portInput.text;
			vo.host = _hostInput.text;
			vo.protocolIndex = _protocolSelector.selectedIndex;
			
			vo.orientationIndex = _orientationSelector.selectedIndex;
			
			vo.sendPeriodicUpdates = _periodicUpdatesToggle.enabled;
			vo.sendFullUpdates = _fullUpdatesToggle.enabled;
			
			return vo;
		}


		public function kill():void
		{
		}


		// + ----------------------------------------
		//		[ PRIVATE METHODS ]
		// + ----------------------------------------

		private function initLabel(label:TextField):void
		{
			label.selectable = false;
			label.multiline = false;
			label.wordWrap = false;
			label.defaultTextFormat = Style.COMMON_LABEL;
			label.antiAliasType = AntiAliasType.ADVANCED;
			label.autoSize = TextFieldAutoSize.LEFT;
			label.embedFonts = true;
			label.filters = [Filter.COMMON_LABEL_DROP_SHADOW];
		}


		private function addBackground():void
		{
			_bg = new BackgroundClass();
			addChild(_bg);
		}


		private function addSocketInputs():void
		{
			var labelCenterY:uint;
			
			_hostLabel = new TextField();
			initLabel(_hostLabel);
			_hostLabel.text = "Host:";
			
			labelCenterY = _hostLabel.y + _hostLabel.height * 0.5;
			
			_hostInput = new TextInput();
			_hostInput.width = 172;
			_hostInput.x = int(_hostLabel.x + _hostLabel.width + PADDING);
			_hostInput.y = int(labelCenterY - _hostInput.height * 0.5);
			_hostInput.restrict = "0-9.";
			
			_hostInputBlurred = new NativeSignal	(	_hostInput,
														FocusEvent.FOCUS_OUT,
														FocusEvent
													);
			_hostInputBlurred.add(onHostInputBlurred);
			
			_portLabel = new TextField();
			initLabel(_portLabel);
			_portLabel.text = "Port:";
			_portLabel.x = _hostInput.x + _hostInput.width + PADDING;
			_portLabel.y = _hostLabel.y;
			
			_portInput = new TextInput();
			_portInput.x = int(_portLabel.x + _portLabel.width + PADDING);
			_portInput.y = int(labelCenterY - _portInput.height * 0.5);
			_portInput.width = int(COLUMN_WIDTH - _portInput.x - PADDING);
			_portInput.restrict = "0-9";
			
			_portInputBlurred = new NativeSignal	(	_portInput,
														FocusEvent.FOCUS_OUT,
														FocusEvent
													);
			_portInputBlurred.add(onPortInputBlurred);
			
			_detectButton = new LabelButton();
			_detectButton.label = "Detect";
			_detectButton.x = COLUMN_WIDTH;
			_detectButton.y = int(labelCenterY - _detectButton.height * 0.5);
			
			_detectButtonClicked = new NativeSignal	(	_detectButton, 
														MouseEvent.CLICK, 
														MouseEvent
													);
			_detectButtonClicked.add(onDetectClicked);
			
			_currentIPLabel = new TextField();
			initLabel(_currentIPLabel);
			_currentIPLabel.text = "Current network address:";
			_currentIPLabel.x = int(_detectButton.x + _detectButton.width + PADDING * 2);
			_currentIPLabel.y = _hostLabel.y;
			
			
			var protocols:Array = [{label:"UDP"}, {label:"TCP"}, {label:"TCP"}];
			_protocolSelector = new SegmentedControl();
			_protocolSelector.dataProvider = new DataProvider(protocols);
			_protocolSelector.selectedIndex = 0;
			_protocolSelector.width = COLUMN_WIDTH - PADDING;
			_protocolSelector.y = int(_hostLabel.y + _hostLabel.height + PADDING);
			
			_protocolSelectorSelected = new NativeSignal	(	_protocolSelector, 
																Event.CHANGE,
																Event
															);
			_protocolSelectorSelected.add(onProtocolChanged);
			
			labelCenterY = _protocolSelector.y + _protocolSelector.height * 0.5;
			
			_defaultButton = new LabelButton();
			_defaultButton.label = "Default";
			_defaultButton.x = COLUMN_WIDTH;
			_defaultButton.y = int(labelCenterY - _defaultButton.height * 0.5);
			
			_defaultButtonClicked = new NativeSignal	(	_defaultButton,
															MouseEvent.CLICK,
															MouseEvent
														);
			_defaultButtonClicked.add(onDefaultClicked);
			
			_currentIPValue = new TextField();
			initLabel(_currentIPValue);
			_currentIPValue.text = "255.255.255.255";
			_currentIPValue.x = _currentIPLabel.x;
			_currentIPValue.y = int(labelCenterY - _currentIPValue.height * 0.5);
			
			_socketInputsHolder = new Sprite();
			_socketInputsHolder.addChild(_hostLabel);
			_socketInputsHolder.addChild(_hostInput);
			_socketInputsHolder.addChild(_portLabel);
			_socketInputsHolder.addChild(_portInput);
			_socketInputsHolder.addChild(_detectButton);
			_socketInputsHolder.addChild(_currentIPLabel);
			_socketInputsHolder.addChild(_protocolSelector);
			_socketInputsHolder.addChild(_defaultButton);
			_socketInputsHolder.addChild(_currentIPValue);
			_socketInputsHolder.x = PADDING;
			_socketInputsHolder.y = HEADER_HEIGHT + PADDING;
			addChild(_socketInputsHolder);
		}


		private function addOrientationsInputs():void
		{
			var orientations:Array = [];
			orientations.push({label:"Automatic"});
			orientations.push({label:"Landscape"});
			orientations.push({label:"Portrait"});
			
			_orientationSelector = new SegmentedControl();
			_orientationSelector.dataProvider = new DataProvider(orientations);
			_orientationSelector.selectedIndex = 0;
			_orientationSelector.width = COLUMN_WIDTH - PADDING;
			
			_orientationSelectorChanged = new NativeSignal	(	_orientationSelector,
																Event.CHANGE,
																Event
															);
			_orientationSelectorChanged.add(onOrientationSelectorChanged);
			
			_orientationsInputsHolder = new Sprite();
			_orientationsInputsHolder.addChild(_orientationSelector);
			_orientationsInputsHolder.x = PADDING;
			_orientationsInputsHolder.y = HEADER_HEIGHT + 176;
			addChild(_orientationsInputsHolder);
		}


		private function addUpdatesInputs():void
		{
			var labelCenterY:uint;
			
			_periodicUpdatesLabel = new TextField();
			initLabel(_periodicUpdatesLabel);
			_periodicUpdatesLabel.text = "Send periodic updates";
			
			labelCenterY = _periodicUpdatesLabel.y + _periodicUpdatesLabel.height * 0.5;
			_periodicUpdatesToggle = new ToggleSwitch();
			_periodicUpdatesToggle.defaultLabel = "OFF";
			_periodicUpdatesToggle.selectedLabel = "ON";
			_periodicUpdatesToggle.selected = true;
			_periodicUpdatesToggle.x = COLUMN_WIDTH * 0.5;
			_periodicUpdatesToggle.y = int(labelCenterY - _periodicUpdatesToggle.height * 0.5);;
			
			_periodicUpdatesToggleSelected = new NativeSignal	(	_periodicUpdatesToggle,
																	Event.SELECT,
																	Event
																);
			_periodicUpdatesToggleSelected.add(onPeriodicUpdatesSelected);
			
			_fullUpdatesLabel = new TextField();
			initLabel(_fullUpdatesLabel);
			_fullUpdatesLabel.text = "Send full updates";
			_fullUpdatesLabel.x = COLUMN_WIDTH;
			_fullUpdatesLabel.y = _periodicUpdatesLabel.y;
			
			_fullUpdatesToggle = new ToggleSwitch();
			_fullUpdatesToggle.defaultLabel = "OFF";
			_fullUpdatesToggle.selectedLabel = "ON";
			_fullUpdatesToggle.selected = true;  
			_fullUpdatesToggle.x = _fullUpdatesLabel.x + (COLUMN_WIDTH * 0.5);
			_fullUpdatesToggle.y = int(labelCenterY - _fullUpdatesToggle.height * 0.5);;
			
			_fullUpdatesToggleSelected = new NativeSignal	(	_fullUpdatesToggle,
																Event.SELECT,
																Event
															);
			_fullUpdatesToggleSelected.add(onFullUpdatesSelected);
			
			_updatesInputsHolder = new Sprite();
			_updatesInputsHolder.addChild(_periodicUpdatesLabel);
			_updatesInputsHolder.addChild(_periodicUpdatesToggle);
			_updatesInputsHolder.addChild(_fullUpdatesLabel);
			_updatesInputsHolder.addChild(_fullUpdatesToggle);
			_updatesInputsHolder.x = PADDING;
			_updatesInputsHolder.y = HEADER_HEIGHT + 272;
			addChild(_updatesInputsHolder);
		}


		private function addStartButton():void
		{
			_startButton = new LabelButton();
			_startButton.label = "Start";
			_startButton.width = 0.5 * (COLUMN_WIDTH + PADDING);
			
			_startButtonClicked = new NativeSignal	(	_startButton,
														MouseEvent.CLICK,
														MouseEvent
													);
			_startButtonClicked.add(onStartClicked);
			
			_startButtonHolder = new Sprite();
			_startButtonHolder.addChild(_startButton);
			_startButtonHolder.x = PADDING;
			_startButtonHolder.y = HEADER_HEIGHT + 336;
			addChild(_startButtonHolder);
		}


		private function addVersionLabel():void
		{
			_versionLabel = new TextField();
			initLabel(_versionLabel);
			_versionLabel.defaultTextFormat = Style.VERSION_LABEL;
			_versionLabel.text = "v0.1";
			
			_versionLabelHolder = new Sprite();
			_versionLabelHolder.addChild(_versionLabel);
			_versionLabelHolder.x = int(WIDTH - PADDING - _versionLabelHolder.width);
			_versionLabelHolder.y = _startButtonHolder.y + _startButtonHolder.height - _versionLabelHolder.height;
			addChild(_versionLabelHolder);
		}


		private function initAlert():void
		{
			// http://supportforums.blackberry.com/t5/Adobe-AIR-Development/How-to-display-QNX-alert-dialog-using-AS3-and-CS4/td-p/1280075
			
			_alert = new AlertDialog();
			_alert.addButton("OK");
			_alert.dialogSize = DialogSize.SIZE_SMALL;
			_alert.hideOnButtonClick = true;
			_alert.hideOnOutsideClick = true;
			
			_alertButtonClicked = new NativeSignal	(	_alert,
														Event.SELECT,
														Event
													);
			_alertButtonClicked.add(onAlertButtonClicked);
		}


		private function dispatchUpdate():void
		{
			if(_isHostValid && _isPortValid)
			{
				_updated.dispatch();
			}
		}


		// + ----------------------------------------
		//		[ EVENT HANDLERS ]
		// + ----------------------------------------

		private function onHidden():void
		{
			visible = false;
			_hidden.dispatch();
		}


		private function onShown():void
		{
			_orientationChanging.add(onOrientationChanging);
		}


		private function onOrientationChanging(_:StageOrientationEvent):void
		{
			if(visible)
			{
				_.preventDefault();
				_.stopImmediatePropagation();
				_.stopPropagation();
			}
		}


		private function onHostInputBlurred(_:FocusEvent):void
		{
			if(!validateIP(_hostInput.text))
			{
				_isHostValid = false;
				
				_alert.title = "Invalid input";
				_alert.message = "The host value you entered is not a valid IP address format (255.255.255.255).";
				_alert.show(IowWindow.getAirWindow().group);
			}
			else
			{
				_isHostValid = true;
			}
			dispatchUpdate();
		}


		private function onPortInputBlurred(_:FocusEvent):void
		{
			if(isNaN(Number(_portInput.text)))
			{
				_isPortValid = false;
				
				_alert.title = "Invalid input";
				_alert.message = "The port value you entered is not a number.";
				_alert.show(IowWindow.getAirWindow().group);
			}
			else
			{
				var numDigits:uint = _portInput.text.split("").length;
				if(numDigits > 4)
				{
					_isPortValid = false;
					
					_alert.title = "Invalid input";
					_alert.message = "The post value you entered is too high. Please enter a maximum of 4 digits.";
					_alert.show(IowWindow.getAirWindow().group);
				}
				else
				{
					_isPortValid = true;
				}
			}
		}


		private function onDetectClicked(_:MouseEvent):void
		{
			trace("\n", this, "---  detectButtonClickedHandler  ---");
			
		}


		private function onProtocolChanged(_:Event):void
		{
			dispatchUpdate();
		}


		private function onDefaultClicked(_:MouseEvent):void
		{
			trace("\n", this, "---  defaultButtonClickedHandler  ---");
			
		}


		private function onOrientationSelectorChanged(_:Event):void
		{
			dispatchUpdate();
		}


		private function onPeriodicUpdatesSelected(_:Event):void
		{
			dispatchUpdate();
		}


		private function onFullUpdatesSelected(_:Event):void
		{
			dispatchUpdate();
		}


		private function onStartClicked(_:MouseEvent):void
		{
			_canvasViewRequested.dispatch();
		}


		private function onAlertButtonClicked(_:Event):void
		{
			trace("\n", this, "---  onAlertButtonClicked  ---");
		}


		// + ----------------------------------------
		//		[ GETTERS / SETTERS ]
		// + ----------------------------------------

		public function get updated():Signal
		{
			return _updated;
		}


		public function get canvasViewRequested():Signal
		{
			return _canvasViewRequested;
		}


		public function get hidden():Signal
		{
			return _hidden;
		}
	}
}
