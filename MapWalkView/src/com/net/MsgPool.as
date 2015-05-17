package com.net
{
	import com.netease.protobuf.Message;
	

	/**
	 * @author zhoujun
	 * @E-mail: 214501728@qq.com
	 * @version 1.0.0
	 * creation time：2012-8-24 下午05:49:13
	 * 
	 */
	public class MsgPool
	{
		//======================================================================
		//        property
		//======================================================================
		private static var _instance:MsgPool;
		private var poolArr:Array = [];
		private var can_send:Boolean = true;
		private var gameEngine:NetEngine = NetManager.gameSocket;
		//======================================================================
		//        constructor
		//======================================================================
		
		public function MsgPool()
		{
		}
		
		public static function addCallBack(cmd:int, msgClass:Class, func:Function):void
		{
			MsgPool.instance.gameEngine.addCallback(cmd, msgClass, func);
		}
		//======================================================================
		//        public function
		//======================================================================
		public static function sendGameMsg(cmd:int,msg:Message):void{
			if(MsgPool.instance.can_send){
				MsgPool.instance.gameEngine.sendMessage(cmd,msg);
//				Debug.trace(null,"cmd"+cmd);
			}else{
				MsgPool.instance.poolArr.push([cmd,msg]);
			}
		}
		
		public static function stop():void{
			MsgPool.instance.can_send = false;
		}
		
		public static function start(clearPool:Boolean = false):void{
			MsgPool.instance.can_send = true;
			if(clearPool == false){
				for(var i:int = 0; i<MsgPool.instance.poolArr.length; i++){
					var tmpAry:Array = MsgPool.instance.poolArr[i];
					var cmd:int = tmpAry[0];
					var msg:Message = tmpAry[1];
					MsgPool.instance.gameEngine.sendMessage(cmd,msg);
				}
			}
			
			MsgPool.instance.poolArr.length = 0;
		}
		
		
		
		//======================================================================
		//        private function
		//======================================================================
		
		//======================================================================
		//        event handler
		//======================================================================
		private static function get instance():MsgPool{
			if(_instance == null){
				_instance = new MsgPool();
			}
			
			return _instance;
		}
		
		
		//======================================================================
		//        getter&setter
		//======================================================================
		
		
	}
} 