package com.YFFramework.game.core.module.AnswerActivity.dataCenter
{
	import com.YFFramework.core.event.YFEventCenter;
	import com.YFFramework.game.core.global.DataCenter;
	import com.YFFramework.game.core.global.event.GlobalEvent;
	import com.YFFramework.game.core.global.manager.ConstMapBasicManager;
	import com.YFFramework.game.core.module.notice.manager.NoticeManager;
	
	import flash.events.TimerEvent;
	import flash.utils.Dictionary;
	import flash.utils.Timer;
	import flash.utils.clearInterval;
	import flash.utils.clearTimeout;
	import flash.utils.setInterval;
	import flash.utils.setTimeout;
	
	import org.osmf.events.TimeEvent;

	/**
	 * @author jina;
	 * @version 1.0.0
	 * creation time：2013-8-19 上午9:50:01
	 */
	public class ActivityNoticeManager
	{
		//======================================================================
		//       public property
		//======================================================================
		
		//======================================================================
		//       private property
		//======================================================================
		private static var _instance:ActivityNoticeManager;
		private var _notRegularDict:Dictionary;
		private var _regularDict:Dictionary;
		/** 连播公告时用的计时器 */		
		private var _timerDict:Dictionary;
		//======================================================================
		//        constructor
		//======================================================================
		
		public function ActivityNoticeManager()
		{
			
		}
		
		public function init():void
		{
			_notRegularDict=new Dictionary();
			_regularDict=new Dictionary();
			_timerDict=new Dictionary();
		}
		//======================================================================
		//        public function
		//======================================================================
		/** 因为公告和icon没有等级限制，所以只用登陆的时候检查一遍，然后每次十二点的时候重新刷新就行了
		 */		
		public function checkNoticeProcess():void
		{
			init();
			
			var activities:Array=ActivityBasicManager.Instance.getAllActivities();
			for each(var vo:ActivityBasicVo in activities)
			{
				if(vo.notice_id > 0)
				{
					//今天的日期是否大于开启日期
					if(ActivityDyManager.instance.checkToday(vo) == true)
					{
						//是否周期活动
						if(vo.is_cycle == ActivityData.YES)
						{
							//是否（当前日期-开启日期）%周期日期=0
							if(ActivityDyManager.instance.checkCycleDate(vo) == true)
							{
								if(vo.is_regular == ActivityData.NO)
									checkNotRegularNotice(vo);
								else
									checkRegularNotice(vo);
							}
						}
						else
						{
							//是否在活动开启日期+活动持续时间
							var start:Number;
							start=ActivityDyManager.instance.getOpenDate(vo)+ActivityDyManager.instance.getMilliSeconds(vo.start_time1)
									-vo.notice_interval*ActivityData.MILLISECOND;
							setActivityTimeOut(vo,start,11111);
						}
					}
				}
			}
		}
		//======================================================================
		//        private function
		//======================================================================
		private function checkNotRegularNotice(vo:ActivityBasicVo):void
		{
			var show:Boolean=false;
			var start:Number=0;
			var end:Number=0;
			var MILLISECOND:Number=ActivityData.MILLISECOND;
			if(vo.start_notice_time > 0)
			{
				if(vo.start_time1 != '')
				{
					start = ActivityDyManager.instance.getTodayDate()+ActivityDyManager.instance.getMilliSeconds(vo.start_time1)
							- vo.start_notice_time * MILLISECOND - vo.notice_interval*MILLISECOND;
					setActivityTimeOut(vo,start);
				}
				if(vo.start_time2 != '')
				{
					start = ActivityDyManager.instance.getTodayDate()+ActivityDyManager.instance.getMilliSeconds(vo.start_time2)
						- vo.start_notice_time * MILLISECOND - vo.notice_interval*MILLISECOND;
					setActivityTimeOut(vo,start);
				}
				if(vo.start_time3 != '')
				{
					start = ActivityDyManager.instance.getTodayDate()+ActivityDyManager.instance.getMilliSeconds(vo.start_time3)
						- vo.start_notice_time * MILLISECOND - vo.notice_interval*MILLISECOND;
					setActivityTimeOut(vo,start);
				}
				if(vo.start_time4 != '')
				{
					start = ActivityDyManager.instance.getTodayDate()+ActivityDyManager.instance.getMilliSeconds(vo.start_time4)
						- vo.start_notice_time * MILLISECOND - vo.notice_interval*MILLISECOND;
					setActivityTimeOut(vo,start);
				}
				if(vo.start_time5 != '')
				{
					start = ActivityDyManager.instance.getTodayDate()+ActivityDyManager.instance.getMilliSeconds(vo.start_time5)
						- vo.start_notice_time * MILLISECOND - vo.notice_interval*MILLISECOND;
					setActivityTimeOut(vo,start);
				}
			}
		}
		
		private function checkRegularNotice(vo:ActivityBasicVo):void
		{	
			var start:Number=0;
			var MILLISECOND:Number=ActivityData.MILLISECOND;
			var interal:Number=vo.open_interval*MILLISECOND;//活动开启间隔

			for(var i:int=0;i<vo.open_times;i++)
			{
				start = ActivityDyManager.instance.getTodayDate()+ActivityDyManager.instance.getMilliSeconds(vo.start_time1)
					+interal*i - vo.start_notice_time*MILLISECOND;
//				var date:Date=new Date(start);
//				trace('播放公告开始时间：',date.hours,':',date.minutes)
				setActivityTimeOut(vo,start,i);
			}
		}
		
		/**
		 * 规律活动或非规律活动都用这个方法
		 * @param vo
		 * @param start 通知开始时间，已减去一个通告间隔，因为后面定时器的缺陷，不能立即生效
		 * @param label 为区别一天规律活动的字段；非规律活动默认10000
		 * 
		 */		
		private function setActivityTimeOut(vo:ActivityBasicVo,start:Number,i:int=10000):void
		{
			var curTime:Number=ActivityDyManager.instance.getMyDate().time;
			var index:uint;

			if(curTime < (start-vo.notice_interval*ActivityData.MILLISECOND))
			{
				//因为timer设置间隔后不会立即启动，所以要先减去一个公告时间间隔
				index = setTimeout(startNotice,start-curTime-vo.notice_interval*ActivityData.MILLISECOND,
					vo,start,i,0);
				_regularDict[vo.active_type.toString()+start.toString()+i.toString()]=index;
			}
			else//在公告期间进入，要算已经公告了几遍
			{
//				var date:Date=new Date();
//				trace('当前时间：',date.hours,date.minutes)
				var finishTimes:int=Math.ceil((curTime-start)/(vo.notice_interval*ActivityData.MILLISECOND));
				if(finishTimes < vo.start_notice_time/vo.notice_interval)
				{
					getNoticeTimer(vo,finishTimes);
				}
			}
		}
		
		private function startNotice(vo:ActivityBasicVo,time:Number,i:int,finishTimes:int):void
		{
			var str:String=vo.active_id.toString()+time.toString()+i.toString();
			clearTimeout(_regularDict[str]);
			_regularDict[str]=null;
			delete _regularDict[str];
			
			getNoticeTimer(vo,finishTimes);
		}
		
		private function getNoticeTimer(vo:ActivityBasicVo,finish:int):void
		{
//			trace('已经播放的次数：',finish)
			var timer:Timer=new Timer(vo.notice_interval*ActivityData.MILLISECOND,vo.start_notice_time/vo.notice_interval-finish);
			timer.addEventListener(TimerEvent.TIMER,noticeEveryTime);
			timer.addEventListener(TimerEvent.TIMER_COMPLETE,timerComplete);
			_timerDict[timer]=vo;
			timer.start();
		}
		
		private function noticeEveryTime(e:TimerEvent):void
		{
//			trace('开始播放公告啦！！！！！！')
			var vo:ActivityBasicVo=_timerDict[e.currentTarget] as ActivityBasicVo;
			NoticeManager.setNotice(vo.notice_id,-1,vo.active_name);
		}
		
		private function timerComplete(e:TimerEvent):void
		{
			var timer:Timer=e.currentTarget as Timer;
			timer.stop();
			_timerDict[e.currentTarget]=null;
			delete _timerDict[e.currentTarget];
		}
		//======================================================================
		//        event handler
		//======================================================================
		
		//======================================================================
		//        getter&setter
		//======================================================================
		public static function get instance():ActivityNoticeManager
		{
			if(_instance == null)
				_instance = new ActivityNoticeManager();
			return _instance;
		}

	}
} 