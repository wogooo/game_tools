package com.YFFramework.game.core.module.AnswerActivity.AnswerView
{
	/**
	 * @author jina;
	 * @version 1.0.0
	 * creation time：2013-8-7 上午10:34:51
	 */
	import com.YFFramework.core.event.YFEvent;
	import com.YFFramework.core.event.YFEventCenter;
	import com.YFFramework.game.core.global.manager.ConstMapBasicManager;
	import com.YFFramework.game.core.global.view.window.WindowTittleName;
	import com.YFFramework.game.core.module.AnswerActivity.AnswerView.panel.AnswerPanel;
	import com.YFFramework.game.core.module.AnswerActivity.AnswerView.panel.PreAnswerPanel;
	import com.YFFramework.game.core.module.AnswerActivity.AnswerView.panel.RewardPanel;
	import com.YFFramework.game.core.module.AnswerActivity.dataCenter.ActivityBasicManager;
	import com.YFFramework.game.core.module.AnswerActivity.dataCenter.ActivityBasicVo;
	import com.YFFramework.game.core.module.AnswerActivity.dataCenter.ActivityData;
	import com.YFFramework.game.core.module.AnswerActivity.dataCenter.ActivityDyManager;
	import com.YFFramework.game.core.module.AnswerActivity.event.AnswerActivityEvent;
	import com.YFFramework.game.core.module.ModuleManager;
	import com.dolo.ui.controls.Window;
	import com.dolo.ui.managers.UI;
	
	import flash.display.Sprite;
	import flash.events.Event;
	
	public class AnswerActivityWindow extends Window
	{
		//======================================================================
		//       public property
		//======================================================================
		
		//======================================================================
		//       private property
		//======================================================================
		private const PRE_PANEL:int=0;
		private const ANSWER_PANEL:int=1;
		private const REWARD_PANEL:int=2;
		
		private var _ui:Sprite;
		
		private var _preView:PreAnswerPanel;
		private var _answerView:AnswerPanel;
		private var _rewardView:RewardPanel;
		private var _panels:Array;

		private var _join:Boolean=false;
		private var _answerEnd:Boolean=false;
		
		private var _activityType:int;
		private var _activityVo:ActivityBasicVo;
		
		//======================================================================
		//        constructor
		//======================================================================	
		public function AnswerActivityWindow(backgroundBgId:int=0)
		{
			_ui = initByArgument(572,414,"answerActivity",WindowTittleName.answerActivityTitle);
			setContentXY(27,25);
			
			_preView = new PreAnswerPanel(Object(_ui).view1);
			_answerView = new AnswerPanel(Object(_ui).view2);
			_rewardView = new RewardPanel(Object(_ui).view3);
			
			_panels=[_preView,_answerView,_rewardView];
			
			_activityType=ActivityData.ACTIVITY_ANSWER;
			_activityVo=ActivityBasicManager.Instance.getActivityBasicVoByType(_activityType);
			
			addEvent();
		}
		
		//======================================================================
		//        public function
		//======================================================================
		override public function open():void
		{	
			if(ActivityDyManager.instance.canJoinActivity(ActivityData.ACTIVITY_ANSWER) == true && _join == false)
			{
				ModuleManager.answerActivityModule.joinActivityReq(_activityType);
			}
			
			if(_join)
			{
				checkPanel();
				super.open();
			}
		}
		
		public function updateQuestion(qId:int,qNum:int):void
		{
			_answerView.updateQuestion(qId,qNum);
		}
		
		public function updateRightAnswer(right:Boolean):void
		{
			_answerView.updateQuestionsNum(right);
		}
		
		public function changeRewardPanel():void
		{
			showPanel(REWARD_PANEL);
			_rewardView.updatePanel();
			_answerEnd=true;
		}
		
		/** 活动结束后问题序号重置
		 */		
		public function resetQuestionIndex():void
		{
			_answerView.questionIndex=0;
		}
			
		public function set join(value:Boolean):void
		{
			_join = value;
		}
		
		public function set answerEnd(value:Boolean):void
		{
			_answerEnd = value;
		}
		//======================================================================
		//        private function
		//======================================================================
		private function addEvent():void
		{
			YFEventCenter.Instance.addEventListener(AnswerActivityEvent.ANSWER_COUNT_DOWN_END,beginAnswer);
			YFEventCenter.Instance.addEventListener(AnswerActivityEvent.CLOSE_ANSWER_WINDOW,closeWindow);//关闭window
		}
		
		private function checkPanel():void
		{
			var curTime:Number=ActivityDyManager.instance.getMyDate().time;
			var start:Number = ActivityData.answerStartTime+ActivityData.ONE_MINUTE;
			var end:Number= start + _activityVo.continue_time * ActivityData.MILLISECOND;
			if((start - curTime)<=ActivityData.ONE_MINUTE)
			{
				showPanel(PRE_PANEL);
				countDownPreTime(start-curTime);
			}
			else if(curTime >= start && _answerEnd == false)
			{
				showPanel(ANSWER_PANEL);
			}
			else if(_answerEnd)
			{
				changeRewardPanel();
			}	
		}
		
		private function showPanel(index:int):void
		{
			for(var i:int=0;i<=REWARD_PANEL;i++)
			{
				_panels[i].setVisible();
			}
			_panels[index].setVisible(true);
		}
		
		private function countDownPreTime(time:int):void
		{
			_preView.countDownPreTime(time);
		}
		
		
		//======================================================================
		//        event handler
		//======================================================================
		private function beginAnswer(e:YFEvent):void
		{
			showPanel(ANSWER_PANEL);
		}
		
		private function closeWindow(e:YFEvent):void
		{
			close();
		}	

		//======================================================================
		//        getter&setter
		//======================================================================
		public function get activityType():int
		{
			return _activityType;
		}
		
	}
} 