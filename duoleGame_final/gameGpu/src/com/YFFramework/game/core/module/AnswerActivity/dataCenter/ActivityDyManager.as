package com.YFFramework.game.core.module.AnswerActivity.dataCenter
{
	import com.YFFramework.core.event.YFEventCenter;
	import com.YFFramework.game.core.global.DataCenter;
	import com.YFFramework.game.core.global.TimeManager;
	import com.YFFramework.game.core.global.event.GlobalEvent;
	import com.YFFramework.game.core.global.manager.PropsDyManager;
	import com.YFFramework.game.core.global.util.NoticeUtil;
	
	import flash.utils.Dictionary;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;

	/**
	 * 用户参与所有
	 * @author jina;
	 * @version 1.0.0
	 * creation time：2013-8-8 上午9:38:38
	 */
	public class ActivityDyManager
	{
		//======================================================================
		//       public property
		//======================================================================
		
		//======================================================================
		//       private property
		//======================================================================
		private static var _instance:ActivityDyManager;
		
		/** 存储不规律开启定时器 */		
		private var _notRegularDict:Dictionary;
		/** 存储规律开启定时器 */		
		private var _regularDict:Dictionary;
		/** 存储已经加载过的活动，防止重复加载 */		
		private var _alreadyLoadDict:Dictionary;
		/** 按活动类型，存储每个活动已经参加几次 */		
		private var _activitiesTimesDict:Dictionary;
		
		/** 零点定时器 */		
		private var _zeroIndex:uint;
		//======================================================================
		//        constructor
		//======================================================================
		
		public function ActivityDyManager()
		{
			
		}
		
		private function init():void
		{
			_activitiesTimesDict=new Dictionary();
			_notRegularDict=new Dictionary();
			_regularDict=new Dictionary();
			_alreadyLoadDict=new Dictionary();
		}
		
		public static function get instance():ActivityDyManager
		{
			if(_instance == null)
				_instance = new ActivityDyManager();
			return _instance;
		}
		//======================================================================
		//        public function
		//======================================================================
		/** 已经完成的全部活动次数
		 * @param activityType
		 * @param times 次数
		 * 
		 */			
		public function setActivityTimes(activityType:int,times:int):void
		{
			_activitiesTimesDict[activityType]=times;
		}
		
		/** 查询某个活动已经完成的次数
		 * @param activityType
		 * @return 如果没有这个活动会返回null
		 */		
		public function getActivityTimes(activityType:int):int
		{
			return _activitiesTimesDict[activityType];
		}
		
		public function startActivityTimer():void
		{
			init();
			findCanJoinActivity();
			ActivityNoticeManager.instance.checkNoticeProcess();
			
			///还要加个今天到明天零点的timeout
			var myDate:Date=getMyDate();
			var nextDate:Date=new Date(myDate.fullYear,myDate.month,myDate.date+1);
			_zeroIndex=setTimeout(untilZero,nextDate.time-myDate.time);
		}
		
		private function untilZero():void
		{
			clearTimeout(_zeroIndex);
			startActivityTimer();
		}
		
		/**
		 * 每次人物升级都要判断是否有可参加的活动，因为原来不能参加的活动，升级后可以参加的情况
		 * @param init 初始加载是true
		 * 
		 */		
		public function findCanJoinActivity(init:Boolean=true):void
		{
			var activities:Array=ActivityBasicManager.Instance.getAllActivities();;
			var canJoinAry:Array=[];
			var vo:ActivityBasicVo;
			if(init)
			{
				for each(vo in activities)
				{
					if(vo.icon_id > 0)
					{
						var level:int=DataCenter.Instance.roleSelfVo.roleDyVo.level
						if(vo.icon_level == 0 || level >= vo.icon_level)//如果图标为0，说明没限制
						{
							canJoinAry.push(vo);
						}
					}				
				}
			}
			else
			{
				for each(vo in activities)
				{
					//icon_level为0的情况已经在一开始加载过了
					if(_alreadyLoadDict[vo.active_id] == null && vo.icon_id > 0 && 
						vo.icon_level > 0 && DataCenter.Instance.roleSelfVo.roleDyVo.level >= vo.icon_level)
						canJoinAry.push(vo);
				}
			}
			checkActivityProcess(canJoinAry);
		}

		/** 检查活动表里除了时间的一切判断能否参加活动的条件
		 * (这里不用检查报名持续时间是因为：1.所有报名持续时间都是报名开始时间+活动持续时间；2.活动图标一旦开始显示就说明可以报名了)
		 */		
		//**策划为了竞技场随意改了需求，又要检查报名持续时间，你大爷的！
		public function canJoinActivity(activityId:int):Boolean
		{
			var canJoin:Boolean;
			var vo:ActivityBasicVo=ActivityBasicManager.Instance.getActivityBasicVo(activityId);
			var count:int=_activitiesTimesDict[vo.active_type];			
			var level:int=DataCenter.Instance.roleSelfVo.roleDyVo.level;
			if(level >= vo.min_level && level <= vo.max_level)
			{
				//回头还要判断世界等级
				if(vo.identity == ActivityData.PART_NO_LIMITED)
				{
					if(vo.item_id > 0)//消耗道具
					{
						if(PropsDyManager.instance.getPropsQuantity(vo.item_id) >= vo.item_number)
						{
							if(vo.limit_times > 0)
							{
								if(count < vo.limit_times)
								{
									if(checkActivityJoinTime(vo))
										canJoin=true;
									else
									{
										NoticeUtil.setOperatorNotice("活动已经开始，请下次再来！");
										canJoin=false;
									}
								}
								else
									canJoin=false;
							}
							else
								canJoin=true;
						}
						else
							canJoin=false;
					}
					else//不用消耗道具
					{
						if(vo.limit_times > 0)
						{
							if(count < vo.limit_times)
							{
								if(checkActivityJoinTime(vo))
									canJoin=true;
								else
								{
									NoticeUtil.setOperatorNotice("活动已经开始，请下次再来！");
									canJoin=false;
								}
							}
							else
								canJoin=false;
						}
						else
							canJoin=true;
					}
				}
				else//回头公会判断条件补上,暂时除了身份不限都不让参加
				{
					canJoin=false;
				}
			}
			else
				canJoin=false;
			
			return canJoin;
		}

		
		
		/** 查询活动需要消耗多少道具
		 * @param activityId
		 * @return 
		 */		
		public function getComsumeItems(activityId:int):Array
		{
//			var activityId:int=ConstMapBasicManager.Instance.getTempId(constId);
			var vo:ActivityBasicVo=ActivityBasicManager.Instance.getActivityBasicVo(activityId);
			return PropsDyManager.instance.getPropsPosArray(vo.item_id,vo.item_number);
		}
		
		/** 当前日期是否大于开启日期
		 * @param vo
		 * @return true->大于
		 */		
		public function checkToday(vo:ActivityBasicVo):Boolean
		{
			var today:Number=getTodayDate();
			var openDay:Number=getOpenDate(vo);
			if(today > openDay)
				return true;
			else
				return false;
		}
		
		/** 得到与服务器同步时间后date
		 * @return 
		 */		
		public function getMyDate():Date
		{
			var dayMilliSecond:Number=TimeManager.getServerTime()*ActivityData.MILLISECOND;
			var date:Date=new Date(dayMilliSecond)
			return date;
		}
		
		public function getDate(year:int,month:int,day:int,hour:int=0,minutes:int=0,second:int=0):Date
		{
			return new Date(year,month-1,day,hour,minutes,minutes,second);
		}
		
		/** 根据时分秒转化为毫秒
		 * @param str 格式：111000
		 * @return 
		 */		
		public function getMilliSeconds(str:String):Number
		{
			var time:Number;
			var hour:int=int(str.substr(0,2));
			var minutes:int=int(str.substr(2,2));
			var seconds:int=int(str.substr(4,2));
			time = ((hour*60+minutes)*60+seconds)*ActivityData.MILLISECOND;
			return time;
		}
		
		/** 今天的0点0分0秒自1970.1.1以来的毫秒数
		 * @return 
		 */		
		public function getTodayDate():Number
		{
			var date:Date=new Date(getMyDate().fullYear,getMyDate().month,getMyDate().date);
			return date.time;
		}
		
		/** 活动开启日期(20130807)0点0分0秒自1970.1.1的毫秒数
		 * @return 
		 */		
		public function getOpenDate(vo:ActivityBasicVo):Number
		{
			var openStr:String=vo.open_date;
			var openTime:Number=getDate(int(openStr.substr(0,4)),int(openStr.substr(4,2)),int(openStr.substr(6,2))).time;
			return openTime;
		}
		
		/** 周期活动条件下，计算当前日期是不是在活动日期上
		 * @return 0->在这个日期上；大于0的都是不符合活动日期
		 */		
		public function checkCycleDate(vo:ActivityBasicVo):Boolean
		{
			var today:Number=getTodayDate();
			var openDay:Number=getOpenDate(vo);
			var days:Number=(today-openDay)%(ActivityData.ONE_DAY_MILLISECONDS*vo.cycle_days);
			if(days == 0)
				return true;
			else
				return false;
		}
		
		//======================================================================
		//        private function
		//======================================================================
		
		/** 一旦活动表加载完成之后，就要逐个遍历每个活动是否开始报名(或是否开始)，是否结束 */		
		private function checkActivityProcess(activities:Array):void
		{
			for each(var vo:ActivityBasicVo in activities)
			{
				//活动图标要>0,否则说明这个活动不用
				if(DataCenter.Instance.roleSelfVo.roleDyVo.level >= vo.icon_level)
				{
					//今天的日期是否大于开启日期
					if(checkToday(vo) == true)
					{
						//是否周期活动
						if(vo.is_cycle == ActivityData.YES)
						{
							//是否（当前日期-开启日期）%周期日期=0
							if(checkCycleDate(vo) == true)
							{
								//记录这个活动已遍历过，不管活动在今天有没有结束，避免重复加载
								_alreadyLoadDict[vo.active_id]=vo;
								if(vo.is_regular == ActivityData.NO)
									checkNotRegularActivity(vo);
								else
									checkRegularActivity(vo);
							}
						}
						else
						{
							_alreadyLoadDict[vo.active_id]=vo;
							//是否在活动开启日期+活动持续时间
							var start:Number=getOpenDate(vo)+getMilliSeconds(vo.start_time1);
							var end:Number=start+vo.continue_time*ActivityData.MILLISECOND;
							setActivityTimeOut(vo,start,end,10000);
						}
					}
				}
			}
		}
		
		
		/** 周期性活动，每日非规律情况下，控制图标在活动开始（如果有报名时间则在报名开始事）亮起，在活动结束时关闭
		 * @param vo
		 * @return 
		 */		
		private function checkNotRegularActivity(vo:ActivityBasicVo):void
		{
			var showAry:Array=[];
			var show:Boolean=false;
			var start:Number=0;
			var end:Number=0;
			var MILLISECOND:Number=ActivityData.MILLISECOND;
			if(vo.start_time1 != '')
			{
				start = getTodayDate()+getMilliSeconds(vo.start_time1);
				end = start + vo.continue_time*MILLISECOND;
				show=setActivityTimeOut(vo,start,end,0);
				showAry.push(show);
			}
			if(vo.start_time2 != '')
			{
				start = getTodayDate()+getMilliSeconds(vo.start_time2);
				end = start + vo.continue_time*MILLISECOND;
				show=setActivityTimeOut(vo,start,end,0);
				showAry.push(show);
			}
			if(vo.start_time3 != '')
			{
				start = getTodayDate()+getMilliSeconds(vo.start_time3);
				end = start + vo.continue_time*MILLISECOND;
				show=setActivityTimeOut(vo,start,end,0);
				showAry.push(show);
			}
			if(vo.start_time4 != '')
			{
				start = getTodayDate()+getMilliSeconds(vo.start_time4);
				end = start + vo.continue_time*MILLISECOND;
				show=setActivityTimeOut(vo,start,end,0);
				showAry.push(show);
			}
			if(vo.start_time5 != '')
			{
				start = getTodayDate()+getMilliSeconds(vo.start_time5);
				end = start + vo.continue_time*MILLISECOND;
				show=setActivityTimeOut(vo,start,end,0);
				showAry.push(show);
			}
			
			for each(show in showAry)
			{
				if(show)
					return;
			}
			YFEventCenter.Instance.dispatchEventWith(GlobalEvent.CloseActivity,vo.active_type);
		}
		
		
		private function checkRegularActivity(vo:ActivityBasicVo):void
		{
			var show:Boolean=false;
			var showAry:Array=[];
			
			var start:Number=0;
			var end:Number=0;
			var MILLISECOND:Number=ActivityData.MILLISECOND;
//			var interal:Number=vo.open_interval*MILLISECOND;//日开启间隔是多少毫秒
			for(var i:int=0;i<vo.open_times;i++)
			{
				//getTodayDate()+getMilliSeconds(vo.start_time1)算出的是一天开始活动的时间;
				start = getTodayDate()+getMilliSeconds(vo.start_time1)+vo.open_interval*MILLISECOND*i;			
//				var date:Date=new Date(start);
//				trace(vo.active_name,"start:",date.hours,":",date.minutes,":",date.seconds)
				end=start+vo.continue_time*MILLISECOND;				
//				date=new Date(end);
//				trace(vo.active_name,"end:",date.hours,":",date.minutes,":",date.seconds)					
				show=setActivityTimeOut(vo,start,end,i);
				showAry.push(show);
			}
			
			for each(show in showAry)
			{
				if(show)
					return;
			}
			
			YFEventCenter.Instance.dispatchEventWith(GlobalEvent.CloseActivity,vo.active_type);
		}
		
		/** 
		 * @param constId
		 * @param start
		 * @param end
		 * @param i 第几次开启
		 */		
		private function setActivityTimeOut(vo:ActivityBasicVo,start:Number,end:Number,i:int):Boolean
		{
			var show:Boolean=false;
			var curTime:Number=getMyDate().time;
			var index:uint;
			if(curTime < start)
			{
				show=false;
				index = setTimeout(startRegularActivity,start-curTime,vo.active_type,start,i,ActivityData.START);
				_regularDict[vo.active_type.toString()+start.toString()+i.toString()]=index;
				
				index = setTimeout(startRegularActivity,end-curTime,vo.active_type,ActivityData.CLOSE,i,ActivityData.CLOSE);
				_regularDict[vo.active_type.toString()+end.toString()+i.toString()]=index;
			}
			else if(curTime >= start && curTime < end)
			{
				index = setTimeout(startRegularActivity,end-curTime,vo.active_type,ActivityData.CLOSE,i,ActivityData.CLOSE);
				_regularDict[vo.active_type.toString()+end.toString()+i.toString()]=index;
				
				var obj:Object={};
				obj.activityType=vo.active_type;
				obj.startTime=start;
				YFEventCenter.Instance.dispatchEventWith(GlobalEvent.showActivityIcon,obj);//进入游戏时活动已经开始了
				show=true;
//				trace(vo.active_name,"开始显示图标！");
			}
			else if(curTime >= end)
			{
				show=false;
			}
			return show;
		}
		
		private function startRegularActivity(activityType:int,time:Number,i:int,lable:int):void
		{
			var str:String=activityType.toString()+time.toString()+i.toString();
			clearTimeout(_regularDict[str]);
			_regularDict[str]=null;
			delete _regularDict[str];
			
			if(lable == ActivityData.START)
			{
				var obj:Object={};
				obj.activityType=activityType;
				obj.startTime=time;
				YFEventCenter.Instance.dispatchEventWith(GlobalEvent.showActivityIcon,obj);//到时间活动开始了
			}
			else
			{
				YFEventCenter.Instance.dispatchEventWith(GlobalEvent.CloseActivity,activityType);
//				var date:Date=new Date();
//				trace(activityType,"图标消失",date.hours,":",date.minutes,":",date.seconds)
			}
		}
		
		/** 判断可以活动时间是否在报名时间内
		 * @param vo
		 * @return 
		 */		
		private function checkActivityJoinTime(vo:ActivityBasicVo):Boolean
		{		
			var curTime:Number=getMyDate().time;
			var start:Number=0;
			var end:Number=0;
			var MILLISECOND:Number=ActivityData.MILLISECOND;
			if(vo.is_cycle == ActivityData.YES)//是周期活动
			{
				if(vo.is_regular == ActivityData.NO)//不规律开启
				{		
					if(vo.start_time1 != '')
					{
						start = getTodayDate()+getMilliSeconds(vo.start_time1)-vo.sign_time*MILLISECOND;
						end = start + vo.sign_continue_time*MILLISECOND;
						if(curTime >= start && curTime<end)
							return true;
					}
					if(vo.start_time2 != '')
					{
						start = getTodayDate()+getMilliSeconds(vo.start_time2)-vo.sign_time*MILLISECOND;
						end = start + vo.sign_continue_time*MILLISECOND;
						if(curTime >= start && curTime<end)
							return true;
					}
					if(vo.start_time3 != '')
					{
						start = getTodayDate()+getMilliSeconds(vo.start_time3)-vo.sign_time*MILLISECOND;
						end = start + vo.sign_continue_time*MILLISECOND;
						if(curTime >= start && curTime<end)
							return true;
					}
					if(vo.start_time4 != '')
					{
						start = getTodayDate()+getMilliSeconds(vo.start_time4)-vo.sign_time*MILLISECOND;
						end = start + vo.sign_continue_time*MILLISECOND;
						if(curTime >= start && curTime<end)
							return true;
					}
					if(vo.start_time5 != '')
					{
						start = getTodayDate()+getMilliSeconds(vo.start_time5)-vo.sign_time*MILLISECOND;
						end = start + vo.sign_continue_time*MILLISECOND;
						if(curTime >= start && curTime<end)
							return true;
					}
				}
				else//规律开启
				{
					for(var i:int=0;i<vo.open_times;i++)
					{
						//getTodayDate()+getMilliSeconds(vo.start_time1)算出的是一天开始活动的时间
						start = getTodayDate()+getMilliSeconds(vo.start_time1)+vo.open_interval*MILLISECOND*i-vo.sign_time*MILLISECOND;				
						end=start+vo.sign_continue_time*MILLISECOND;
//						var date:Date=new Date(start);
//						trace("报名开始时间",date.hours,":",date.minutes)
//						var date1:Date=new Date(end);
//						trace("报名结束时间",date1.hours,":",date1.minutes)
						if(curTime >= start && curTime < end)
						{
//							trace("可以报名！")
							return true;
						}
					}
				}
			}
			else//不是周期活动
			{
				start=getTodayDate()+getMilliSeconds(vo.start_time1)-vo.sign_time*MILLISECOND;;
				end=start+vo.sign_continue_time*MILLISECOND;
				if(curTime >= start && curTime < end)
					return true;
			}
			return false;
		}
		//======================================================================
		//        event handler
		//======================================================================
		
		//======================================================================
		//        getter&setter
		//======================================================================
		
		
	}
} 