package com.YFFramework.game.core.module.AnswerActivity.AnswerView.panel
{
	/**
	 * @author jina;
	 * @version 1.0.0
	 * creation time：2013-8-7 下午1:20:11
	 */
	import com.YFFramework.core.event.YFEventCenter;
	import com.YFFramework.core.ui.abs.AbsView;
	import com.YFFramework.game.core.global.manager.PropsBasicManager;
	import com.YFFramework.game.core.module.AnswerActivity.dataCenter.ActivityData;
	import com.YFFramework.game.core.module.AnswerActivity.dataCenter.answer.QuestionRewardBasicManager;
	import com.YFFramework.game.core.module.AnswerActivity.dataCenter.answer.QuestionRewardBasicVo;
	import com.YFFramework.game.core.module.AnswerActivity.event.AnswerActivityEvent;
	import com.YFFramework.game.ui.imageText.ImageTextManager;
	import com.YFFramework.game.ui.imageText.TypeImageText;
	import com.dolo.ui.controls.Button;
	import com.dolo.ui.tools.Xdis;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	public class RewardPanel extends EventDispatcher
	{
		//======================================================================
		//       public property
		//======================================================================
		
		//======================================================================
		//       private property
		//======================================================================
		private var _mc:MovieClip;
		
		private var _remainQuestionTf:TextField;
		private var _rightQuestionTf:TextField;
		
		private var _numSp:Sprite;
		
		private var _itemName:TextField;
		private var _itemNum:TextField;
		
		private var _confirmBtn:Button;
		//======================================================================
		//        constructor
		//======================================================================
		
		public function RewardPanel(mc:MovieClip)
		{
			_mc=mc;
			
			_remainQuestionTf=Xdis.getChild(_mc,"remainQuestion");
			_remainQuestionTf.text = '0';
			
			_rightQuestionTf=Xdis.getChild(_mc,"rightAnswer");
			
			_numSp=Xdis.getChild(_mc,"numSp");
			var num:AbsView=ImageTextManager.Instance.createNum('0',TypeImageText.ACTIVITY_NUM_BIG);
			_numSp.addChild(num);
			
			_itemName=Xdis.getChild(_mc,"itemName");
			
			_confirmBtn=Xdis.getChild(_mc,"confirm_button");
			
			_confirmBtn.addEventListener(MouseEvent.CLICK,onConfirm);
		}
		
		//======================================================================
		//        public function
		//======================================================================
		public function setVisible(show:Boolean=false):void
		{
			_mc.visible=show;
		}
		
		public function updatePanel():void
		{
			var right:int=ActivityData.rightAnswer;
			_rightQuestionTf.text = right.toString();
			
			if(right > 0)
			{
				var vo:QuestionRewardBasicVo=QuestionRewardBasicManager.Instance.getQuestionRewardBasicVo(right);
				var itemId:int=vo.item_id;
				var name:String = PropsBasicManager.Instance.getPropsBasicVo(itemId).name;
				_itemName.text = name + ' X '+vo.item_number;
			}
		}
		//======================================================================
		//        private function
		//======================================================================
		
		//======================================================================
		//        event handler
		//======================================================================
		private function onConfirm(e:MouseEvent):void
		{
			YFEventCenter.Instance.dispatchEventWith(AnswerActivityEvent.CLOSE_ANSWER_WINDOW);
		}
		//======================================================================
		//        getter&setter
		//======================================================================
		
		
	}
} 