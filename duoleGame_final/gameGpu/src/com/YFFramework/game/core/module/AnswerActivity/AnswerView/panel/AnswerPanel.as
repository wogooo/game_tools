package com.YFFramework.game.core.module.AnswerActivity.AnswerView.panel
{
	import com.YFFramework.core.center.manager.update.UpdateManager;
	import com.YFFramework.core.ui.abs.AbsView;
	import com.YFFramework.core.utils.common.ClassInstance;
	import com.YFFramework.game.core.module.AnswerActivity.dataCenter.ActivityData;
	import com.YFFramework.game.core.module.AnswerActivity.dataCenter.ActivityDyManager;
	import com.YFFramework.game.core.module.AnswerActivity.dataCenter.answer.QuestionBasicManager;
	import com.YFFramework.game.core.module.AnswerActivity.dataCenter.answer.QuestionBasicVo;
	import com.YFFramework.game.core.module.ModuleManager;
	import com.YFFramework.game.ui.imageText.ImageTextManager;
	import com.YFFramework.game.ui.imageText.TypeImageText;
	import com.dolo.ui.controls.RadioButton;
	import com.dolo.ui.managers.UI;
	import com.dolo.ui.tools.Xdis;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.EventDispatcher;
	import flash.text.TextField;
	import flash.utils.clearInterval;
	import flash.utils.getTimer;
	import flash.utils.setTimeout;

	/**
	 * @author jina;
	 * @version 1.0.0
	 * creation time：2013-8-7 下午1:19:42
	 */
	public class AnswerPanel extends EventDispatcher
	{
		//======================================================================
		//       public property
		//======================================================================
		
		//======================================================================
		//       private property
		//======================================================================
		private const ONE_QUESTION_TIME:int=20000;//20秒
		private const SHOW_ANSWER:int=5000;//1秒
		private const TOTAL_QUESTIONS:int=20;
		
		private var _mc:MovieClip;
		
		private var _question:TextField;
		private var _answerBtns:Array;
		private var _answer1Btn:RadioButton;
		private var _answer2Btn:RadioButton;
		private var _answer3Btn:RadioButton;
		private var _answer4Btn:RadioButton;

		private var _holders:Array;
		
		private var _remainQuestionTf:TextField;
		private var _rightQuestionTf:TextField;
		
		private var _numSp:Sprite;
		
		private var _startTime:int;
		
		private var _questionId:int;
		/** 问题序号  */
		private var _questionIndex:int=0;
		
		/** 一秒钟查看回答结果的定时器返回的随机数 */		
		private var _checkIndex:uint;
		
		/** 倒计时时间 */		
		private var _countTime:Number;
		//======================================================================
		//        constructor
		//======================================================================
		
		public function AnswerPanel(mc:MovieClip)
		{
			_mc=mc;
			
			_question=Xdis.getChild(_mc,"question");
			
			_answer1Btn=Xdis.getChild(_mc,"answer1_ga_radioButton");
			_answer2Btn=Xdis.getChild(_mc,"answer2_ga_radioButton");
			_answer3Btn=Xdis.getChild(_mc,"answer3_ga_radioButton");
			_answer4Btn=Xdis.getChild(_mc,"answer4_ga_radioButton");
			_answerBtns=[_answer1Btn,_answer2Btn,_answer3Btn,_answer4Btn];
			
			_holders=[];
			for(var i:int=0;i<4;i++)
			{
				_holders.push(Xdis.getChild(_mc,"sp"+(i+1)));
			}
			
			_remainQuestionTf=Xdis.getChild(_mc,"remainQuestion");
			_rightQuestionTf=Xdis.getChild(_mc,"rightAnswer");
			
			_numSp=Xdis.getChild(_mc,"numSp");
		}
		
		//======================================================================
		//        public function
		//======================================================================
		public function setVisible(show:Boolean=false):void
		{
			_mc.visible=show;
		}
		
		public function updateQuestion(questionId:int,Index:int):void
		{
			_questionId=questionId;
			//更新剩余题目、正确答案数
			_remainQuestionTf.text = (TOTAL_QUESTIONS - Index).toString();
			_rightQuestionTf.text = ActivityData.rightAnswer.toString();
			resetAllBtns();
			
			questionIndex++;
			if(questionIndex != Index)//半路杀进去答题的情况
			{
//				trace("两题序号不一样",Index,questionIndex)
				var start:Number=ActivityData.answerStartTime+ActivityData.MILLISECOND;
				var curTime:Number=ActivityDyManager.instance.getMyDate().time;
				var time:Number=(curTime-start)%(ONE_QUESTION_TIME+SHOW_ANSWER);
//				trace('剩余时间：',time)
				questionIndex=Index;
				if(time >= SHOW_ANSWER)//如果时间大于显示答案的时间，那就可以倒计时
					_countTime = time - SHOW_ANSWER;
				else//否则
				{
					var num:AbsView=ImageTextManager.Instance.createNum('0',TypeImageText.ACTIVITY_NUM_BIG);
					UI.removeAllChilds(_numSp);
					_numSp.addChild(num);
					
					setBtnsEnabled(false);
					refreshQuestion(questionId,questionIndex);
					return;
				}
			}
			else
				_countTime=ONE_QUESTION_TIME;
					
//			trace("题号：",questionIndex,"倒计时时间",_countTime)
			
			clearCross();
			setBtnsEnabled(true);
			UpdateManager.Instance.framePer.regFunc(countDown);
			_startTime=getTimer();
			refreshQuestion(questionId,questionIndex);	
		}
		

		
		//更新正确答案数，显示对错
		public function updateQuestionsNum(right:Boolean):void
		{
			_checkIndex = setTimeout(checkAnswer,SHOW_ANSWER);
			for(var i:int=0;i<4;i++)
			{
				if(RadioButton(_answerBtns[i]).selected == true)
				{
					if(right)
						_holders[i].addChild(ClassInstance.getInstance("answerRight"));
					else
						_holders[i].addChild(ClassInstance.getInstance("answerWrong"));
					break;
				}
			}
		}
		
		//======================================================================
		//        private function
		//======================================================================
		private function refreshQuestion(questionId:int,questionIndex:int):void
		{
			_questionId=questionId;
			var vo:QuestionBasicVo = QuestionBasicManager.Instance.getQuestionBasicVo(questionId);
			_question.text = questionIndex.toString()+'.'+vo.context;
			_answer1Btn.label = vo.answer1;
			_answer2Btn.label = vo.answer2;
			_answer3Btn.label = vo.answer3;
			_answer4Btn.label = vo.answer4;
			
		}
		
		private function clearCross():void
		{
			for(var i:int=0;i<4;i++)
			{
				UI.removeAllChilds(_holders[i]);
			}
		}
		
		private function checkAnswer():void
		{
			clearInterval(_checkIndex);
		}
		
		private function countDown():void
		{
			var curTime:int = _countTime - (getTimer() - _startTime);
			if(curTime >= 0)
			{
				var curNum:Number = int(curTime/1000);
				if(curNum >= 0)
				{
					var num:AbsView=ImageTextManager.Instance.createNum(curNum.toString(),TypeImageText.ACTIVITY_NUM_BIG);
					UI.removeAllChilds(_numSp);
					_numSp.addChild(num);
					if(curNum > 9)
						num.x=-num.width/4;
					else
						num.x=0;
				}
			}
			else
			{
				UpdateManager.Instance.framePer.delFunc(countDown);
				
				var answerId:int=0;
				if(_answer1Btn.selected)
					answerId=1;
				else if(_answer2Btn.selected)
					answerId=2;
				else if(_answer3Btn.selected)
					answerId=3;
				else if(_answer4Btn.selected)
					answerId=4;
				if(answerId != 0)
					ModuleManager.answerActivityModule.sendAnswer(_questionId,answerId);
				
				setBtnsEnabled(false);
			}
		}
		
		private function resetAllBtns():void
		{
			for(var i:int=0;i<4;i++)
			{
				RadioButton(_answerBtns[i]).selected=false;
			}
		}
		
		private function setBtnsEnabled(enabled:Boolean):void
		{
			for(var i:int=0;i<4;i++)
			{
				RadioButton(_answerBtns[i]).enabled=enabled;
			}
		}

		/** 问题序号 */
		public function get questionIndex():int
		{
			return _questionIndex;
		}
		
		public function set questionIndex(value:int):void
		{
			_questionIndex = value;
		}
		
		//======================================================================
		//        event handler
		//======================================================================
		
		//======================================================================
		//        getter&setter
		//======================================================================
		
		
	}
} 