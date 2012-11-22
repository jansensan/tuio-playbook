package org.tuio.tuioplaybook.model
{
	import net.jansensan.utils.validateIP;
	import org.osflash.signals.Signal;
	import org.robotlegs.mvcs.Actor;
	import org.tuio.tuioplaybook.model.valueobjects.SettingsVO;

	import flash.net.InterfaceAddress;
	import flash.net.NetworkInfo;
	import flash.net.NetworkInterface;


	/**
	 * @author Mat Janson Blanchet
	 */
	public class SettingsModel extends Actor
	{
		private	var	_deviceIP				:String;
		
		private	var	_host					:String = "255.255.255.255";
		private	var	_port					:String = "3333";
		private	var	_protocolIndex			:uint;
		
		private	var	_orientationIndex		:uint;
		
		private	var	_sendPeriodicUpdates	:Boolean = true;
		private	var	_sendFullUpdates		:Boolean = true;
		
		private	var	_updated				:Signal;


		// + ----------------------------------------
		//		[ PUBLIC METHODS ]
		// + ----------------------------------------

		public function SettingsModel()
		{
			super();
			_updated = new Signal(SettingsVO);
		}


		public function setHost(host:String):void
		{
			_host = host;
		}


		public function setPort(port:String):void
		{
			_port = port;
		}


		public function setProtocolIndex(index:int):void
		{
			_protocolIndex = index;
		}


		public function setOrientationIndex(index:uint):void
		{
			_orientationIndex = index;
		}


		public function setSendPeriodicUpdates(doSend:Boolean):void
		{
			_sendPeriodicUpdates = doSend;
		}


		public function setSendFullUpdates(doSend:Boolean):void
		{
			_sendFullUpdates = doSend;
		}


		// + ----------------------------------------
		//		[ PRIVATE METHODS ]
		// + ----------------------------------------
		
		private function getDeviceIP():void
		{
			// see http://stackoverflow.com/questions/3170585/get-ip-address-with-adobe-air-2
			var netInterfaces:Vector.<NetworkInterface> = NetworkInfo.networkInfo.findInterfaces();
			if(netInterfaces && netInterfaces.length > 0)
			{
				for each(var i:NetworkInterface in netInterfaces)
				{
					if(i.active)
					{
						var addresses:Vector.<InterfaceAddress> = i.addresses;
						for each(var j:InterfaceAddress in addresses)
						{
							if(validateIP(j.address)) _deviceIP = j.address;
						}
					}
				}
			}
		}
		
		
		// + ----------------------------------------
		//		[ GETTERS / SETTERS ]
		// + ----------------------------------------

		public function get sendFullUpdates():Boolean
		{
			return _sendFullUpdates;
		}


		public function get sendPeriodicUpdates():Boolean
		{
			return _sendPeriodicUpdates;
		}


		public function get orientationIndex():uint
		{
			return _orientationIndex;
		}


		public function get protocolIndex():int
		{
			return _protocolIndex;
		}


		public function get host():String
		{
			return _host;
		}


		public function get port():String
		{
			return _port;
		}


		public function get updated():Signal
		{
			return _updated;
		}


		public function get deviceIP():String
		{
			if(!_deviceIP) getDeviceIP();
			return _deviceIP;
		}
	}
}
