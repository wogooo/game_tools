package net
{
    import flash.events.Event;
    import flash.utils.ByteArray;

    public class NetEvent extends Event
    {
        public var cmd:int;
		public var data:ByteArray;
        public static const ON_CONNECT:String = "onConnect";
        public static const ON_DISCONNECT:String = "onDisconnect";
		public static const ON_ERROR_CODE:String = "onErrorCode";

        public function NetEvent(param1:String, cmd:int=-1,param2:ByteArray = null, param3:Boolean = false, param4:Boolean = false) : void
        {
            super(param1, param3, param4);
			this.cmd = cmd;
			this.data = param2;
            return;
        }// end function
		
		public override function clone():Event 
		{
			return new NetEvent(type, cmd, data, bubbles, cancelable);
		}
    }
}
