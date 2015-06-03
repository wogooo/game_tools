package com.YFFramework.game.core.module.bag.backPack
{
	import com.YFFramework.core.ui.yfComponent.controls.YFCD;
	import com.YFFramework.game.core.global.TimeManager;
	import com.YFFramework.game.core.module.AnswerActivity.dataCenter.ActivityData;
	import com.YFFramework.game.core.module.ModuleManager;
	import com.YFFramework.game.core.module.bag.data.OpenCellBasicManager;
	import com.YFFramework.game.core.module.bag.data.OpenCellBasicVo;
	import com.msg.open_cell.CRefreshTimeReq;
	import com.net.MsgPool;
	
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import flash.utils.getTimer;
	import flash.utils.setTimeout;

	/**
	 * 用于开启背包格子
	 * @author jina;
	 * @version 1.0.0
	 * creation time：2014-1-13 上午9:55:22
	 */
	public class OpenBagGridManager
	{
		//======================================================================
		//       public property
		//======================================================================
		/** 即将开启格子的id信息 */
		public static var openGridId:int=0;
		
		/** 从第一个开启格子到当前格子总经历时间(这个值是启动游戏时服务器发来的，所以以这个为基准且不可改变)
		 * 单位：毫秒 */
		public static var serverTime:Number=0;
		
		/** 服务器校准时间，两个地方会改变：1每次开启格子后返回，2每五分钟校准  */
		public static var serverTotalTime:Number=0;	
		
		/** 客户端自己计时，自运行起经过多长时间 */
//		public static var clientTime:Number=0;
		
		private var _timer:Timer;
		private static var _instance:OpenBagGridManager;
		
		private var _cd:YFCD;
		/** 当前播放cd的数据 */
		private var _cdVo:OpenCellBasicVo;
		private var _time:Object;
//		private var _startStamp:Number;
		//======================================================================
		//       private property
		//======================================================================
		
		//======================================================================
		//        constructor
		//======================================================================
		
		public function OpenBagGridManager()
		{
		}
		
		//======================================================================
		//        public function
		//======================================================================
		public function updateTime(updateTimeReq:Function):void
		{
			_timer=new Timer(5*60*ActivityData.MILLISECOND);
			_timer.addEventListener(TimerEvent.TIMER,updateTimeReq);
		}

		public static function get instance():OpenBagGridManager
		{
			if(_instance==null) _instance=new OpenBagGridManager();
			return _instance;
		}

		public function get cd():YFCD
		{
			return _cd;
		}

		/**
		 * 设置时间开启格子cd
		 * @param id
		 * @param serverTime 如果不为0，说明cd是从头播放的()
		 * 
		 */		
		public function initCd():void
		{
			if(_cd != null)
			{
				_cd.dispose();
				_cd = null;
			}
			_cdVo=OpenCellBasicManager.Instance.getOpenCellBasicVo(openGridId);
			_cd=new YFCD(40,40);
			_cd.play(_cdVo.delta_time*ActivityData.MILLISECOND,serverTime*ActivityData.MILLISECOND,false,completeCloseCd);
			_time={total:_cdVo.delta_time,start:serverTime,stamp:getTimer()};
			_cd.start();
//			_startStamp=getTimer();
//			trace("********",openGridId,"开始播放!!!!!!!!!!!!!","服务器时间",serverTime,"本地运行时间：",getTimer())

		}

		//======================================================================
		//        private function
		//======================================================================
		/** cd播完向服务器发请求开格子 */
		private function completeCloseCd(obj:Object):void
		{
//			trace("*******",openGridId,"播放完成!!!!!!!!!!!!!","本地运行时间：",getTimer())
			ModuleManager.bagModule.openOnlineGridReq(_cdVo.id);
			_cd.dispose();
			_cd=null;
			_time=null;
		}

		/** 包括两个时间:总时间，开始时间*/
		public function get time():Object
		{
			return _time;
		}

//		/** 开始cd时，当前时间（） */
//		public function get startStamp():Number
//		{
//			return _startStamp;
//		}


		//======================================================================
		//        event handler
		//======================================================================
		
		//======================================================================
		//        getter&setter
		//======================================================================
		
		
	}
} 