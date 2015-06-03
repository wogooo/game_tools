package com.YFFramework.game.core.module.activity.controller
{
	import com.CMD.GameCmd;
	import com.YFFramework.core.center.abs.module.AbsModule;
	import com.YFFramework.core.event.YFEvent;
	import com.YFFramework.core.event.YFEventCenter;
	import com.YFFramework.game.core.global.event.GlobalEvent;
	import com.YFFramework.game.core.global.manager.PropsDyManager;
	import com.YFFramework.game.core.global.util.TypeProps;
	import com.YFFramework.game.core.module.AnswerActivity.dataCenter.ActivityBasicManager;
	import com.YFFramework.game.core.module.AnswerActivity.dataCenter.ActivityBasicVo;
	import com.YFFramework.game.core.module.AnswerActivity.dataCenter.ActivityDyManager;
	import com.YFFramework.game.core.module.AnswerActivity.dataCenter.ActivityIconsManager;
	import com.YFFramework.game.core.module.activity.view.ActivityWindow;
	import com.YFFramework.game.core.module.notice.manager.NoticeManager;
	import com.YFFramework.game.core.module.notice.model.NoticeType;
	import com.msg.actv.ActivityStatus;
	import com.msg.actv.CActivityInfos;
	import com.msg.actv.CSignActivity;
	import com.msg.actv.SActivityInfos;
	import com.msg.actv.SSignActivity;
	import com.net.MsgPool;

	/***
	 *
	 *@author ludingchang 时间：2013-7-12 下午1:23:46
	 */
	public class ModuleActivity extends AbsModule{
		
		private var _activityWindow:ActivityWindow;
		
		public function ModuleActivity(){
			_activityWindow=new ActivityWindow;
		}
		
		override public function init():void{
			addEvents();
			addSocketCallback();
		}
		
		/** 报名参加活动,切记回复时，如果报名不成功，不会发送GlobalEvent.JoinedActivity，而是直接提示“XX活动报名不成功”
		 * @param activityType
		 */		
		public function joinActivityReq(activityType:int):void
		{
			var vo:ActivityBasicVo=ActivityBasicManager.Instance.getActivityBasicVoByType(activityType);
			if(ActivityDyManager.instance.canJoinActivity(vo.active_id))
			{
				var items:Array;
				if(vo.item_id > 0 && vo.item_number > 0)
					items=PropsDyManager.instance.getPropsPosArray(vo.item_id,vo.item_number);
				var msg:CSignActivity=new CSignActivity();
				msg.activityId=vo.active_id;
				if(items != null)
					msg.items=items;
				MsgPool.sendGameMsg(GameCmd.CSignActivity,msg);
			}
		}
		
		private function addEvents():void
		{
			//打开关闭总活动界面
			YFEventCenter.Instance.addEventListener(GlobalEvent.ActivityUIClick,onActivityUIClick);
			//进入游戏就向服务器请求已经参与活动的次数
			YFEventCenter.Instance.addEventListener(GlobalEvent.GameIn,onGameIn);			
		}
		
		private function addSocketCallback():void
		{
			//返回已经参加所有活动的次数
			MsgPool.addCallBack(GameCmd.SActivityInfos,SActivityInfos,activityInfoResp);
			//报名参加活动返回
			MsgPool.addCallBack(GameCmd.SSignActivity,SSignActivity,joinActivityResp);
			
		}	

		private function onActivityUIClick(e:YFEvent):void{
			_activityWindow.switchOpenClose();
			if(_activityWindow.isOpen)	_activityWindow.onOpen();
		}
		
		private function onGameIn(e:YFEvent):void
		{
			ActivityIconsManager.instance.init();
			ActivityDyManager.instance.startActivityTimer();						
			ActivityBasicManager.Instance.initActivitiesTimes();
			
			var msg:CActivityInfos=new CActivityInfos();
			MsgPool.sendGameMsg(GameCmd.CActivityInfos,msg);			
					
		}
		
		private function activityInfoResp(msg:SActivityInfos):void
		{
			if(msg != null)
			{
				var activities:Array=msg.actvStatusArr;
				for each(var activity:ActivityStatus in activities)
				{
					ActivityDyManager.instance.setActivityTimes(activity.activityType,activity.playTimes);
				}
				YFEventCenter.Instance.dispatchEventWith(GlobalEvent.ActivityTimesUpdate);
			}
		}
		
		private function joinActivityResp(msg:SSignActivity):void
		{
			var vo:ActivityBasicVo=ActivityBasicManager.Instance.getActivityBasicVo(msg.activityId);
			if(msg.errorInfo == TypeProps.RSPMSG_SUCCESS)
				YFEventCenter.Instance.dispatchEventWith(GlobalEvent.JoinedActivity,vo.active_type);
			else
			{
				var name:String=vo.active_name;
				NoticeManager.setNotice(NoticeType.Notice_id_80,-1,vo.active_name);
			}
			
		}
	}
}