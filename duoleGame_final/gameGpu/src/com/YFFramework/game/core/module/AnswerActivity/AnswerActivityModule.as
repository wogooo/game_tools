package com.YFFramework.game.core.module.AnswerActivity
{
	/**
	 * @author jina;
	 * @version 1.0.0
	 * creation time：2013-8-7 上午10:31:23
	 */
	import com.CMD.GameCmd;
	import com.YFFramework.core.center.abs.module.AbsModule;
	import com.YFFramework.core.event.YFEvent;
	import com.YFFramework.core.event.YFEventCenter;
	import com.YFFramework.game.core.global.TimeManager;
	import com.YFFramework.game.core.global.event.GlobalEvent;
	import com.YFFramework.game.core.global.manager.ConstMapBasicManager;
	import com.YFFramework.game.core.global.manager.PropsDyManager;
	import com.YFFramework.game.core.global.util.NoticeUtil;
	import com.YFFramework.game.core.global.util.TypeProps;
	import com.YFFramework.game.core.module.AnswerActivity.AnswerView.AnswerActivityWindow;
	import com.YFFramework.game.core.module.AnswerActivity.dataCenter.ActivityBasicManager;
	import com.YFFramework.game.core.module.AnswerActivity.dataCenter.ActivityBasicVo;
	import com.YFFramework.game.core.module.AnswerActivity.dataCenter.ActivityData;
	import com.YFFramework.game.core.module.AnswerActivity.dataCenter.ActivityDyManager;
	import com.YFFramework.game.core.module.AnswerActivity.dataCenter.ActivityIconsManager;
	import com.YFFramework.game.core.module.notice.manager.NoticeManager;
	import com.YFFramework.game.core.module.notice.model.NoticeType;
	import com.YFFramework.game.core.scence.TypeScence;
	import com.dolo.ui.managers.UIManager;
	import com.msg.actv.ActivityStatus;
	import com.msg.actv.CActivityInfos;
	import com.msg.actv.CAnswer;
	import com.msg.actv.CSignActivity;
	import com.msg.actv.SActivityInfos;
	import com.msg.actv.SAnswer;
	import com.msg.actv.SQuestion;
	import com.msg.actv.SResult;
	import com.msg.actv.SSignActivity;
	import com.net.MsgPool;
	
	public class AnswerActivityModule extends AbsModule
	{
		//======================================================================
		//       public property
		//======================================================================
		
		//======================================================================
		//       private property
		//======================================================================
		private var _answerWindow:AnswerActivityWindow;
		//======================================================================
		//        constructor
		//======================================================================
		
		public function AnswerActivityModule()
		{
			super();
			_belongScence=TypeScence.ScenceGameOn;
			_answerWindow=new AnswerActivityWindow();
		}
		
		
		//======================================================================
		//        public function
		//======================================================================
		override public function init():void
		{
			
			addEvents();
			addSocketCallback();
		}
		//======================================================================
		//        private function
		//======================================================================
		private function addEvents():void
		{
			//打开答题界面
			YFEventCenter.Instance.addEventListener(GlobalEvent.AnswerActivityUIClick,openAnswer);
			//答题活动是否成功参加
			YFEventCenter.Instance.addEventListener(GlobalEvent.JoinedActivity,canJoinAnswer);
			//开始活动（有报名时间就从报名时间开始）
			YFEventCenter.Instance.addEventListener(GlobalEvent.showActivityIcon,startActivity);
			//答题结束
//			YFEventCenter.Instance.addEventListener(GlobalEvent.CloseActivity,closeActivity);
		}
		
		private function addSocketCallback():void
		{
			//针对智者千虑活动
			MsgPool.addCallBack(GameCmd.SQuestion,SQuestion,questions);
			//答题活动问题正确与否
			MsgPool.addCallBack(GameCmd.SAnswer,SAnswer,answer);
			//活动结果
			MsgPool.addCallBack(GameCmd.SResult,SResult,activityResult);
		}
		
		/** 报名参加活动
		 * @param activityType
		 */		
		public function joinActivityReq(activityType:int):void
		{
			var vo:ActivityBasicVo=ActivityBasicManager.Instance.getActivityBasicVoByType(activityType);
			var items:Array;
			if(vo.item_id > 0 && vo.item_number > 0)
				items=PropsDyManager.instance.getPropsPosArray(vo.item_id,vo.item_number);
			var msg:CSignActivity=new CSignActivity();
			msg.activityId=vo.active_id;
			if(items != null)
				msg.items=items;
			MsgPool.sendGameMsg(GameCmd.CSignActivity,msg);
		}
		
		/** 答题活动
		 * @param questionId
		 * @param answerId
		 */		
		public function sendAnswer(questionId:int,answerId:int):void
		{
			var msg:CAnswer=new CAnswer();
			msg.questionId=questionId;
			msg.answer=answerId;
			MsgPool.sendGameMsg(GameCmd.CAnswer,msg);
		}
		//======================================================================
		//        event handler
		//======================================================================
		private function openAnswer(e:YFEvent):void
		{
			UIManager.switchOpenClose(_answerWindow);
		}
		
		private function canJoinAnswer(e:YFEvent):void
		{
			var type:int=e.param as int;
			if(_answerWindow.activityType == type)
			{
				_answerWindow.join=true;
				_answerWindow.open();
			}
		}
		
		private function startActivity(e:YFEvent):void
		{
			var obj:Object=e.param as Object;
			if(obj.activityType == ActivityData.ACTIVITY_ANSWER)
			{
				ActivityData.answerStartTime=obj.startTime;
				_answerWindow.answerEnd=false;
			}
		}
		
		private function questions(msg:SQuestion):void
		{
//			trace('来问题啦啦啦啦！~~~~',msg.questionNumber)
			if(msg.hasRightNumber)
				ActivityData.rightAnswer=msg.rightNumber;
			_answerWindow.updateQuestion(msg.questionId,msg.questionNumber);
		}

		private function answer(msg:SAnswer):void
		{
			if(msg.isCorrect == true)
				ActivityData.rightAnswer++;
			_answerWindow.updateRightAnswer(msg.isCorrect);
		}
		
		private function activityResult(msg:SResult):void
		{
//			trace('发活动奖励啦啦啦！~~~')
			if(msg.activityId == ActivityData.ACTIVITY_ANSWER)
			{
				_answerWindow.changeRewardPanel();
				_answerWindow.resetQuestionIndex();
				_answerWindow.join=false;
			}
		}
		
//		private function closeActivity(e:YFEvent):void
//		{
//			var activityId:int=e.param as int;
//			if(activityId == ActivityData.ACTIVITY_ANSWER)
//			{
//				
//			}
//		}
		//======================================================================
		//        getter&setter
		//======================================================================
		
		
	}
} 