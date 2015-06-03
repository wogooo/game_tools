package com.YFFramework.game.core.module.AnswerActivity.AnswerView.panel
{
	/**
	 * @author jina;
	 * @version 1.0.0
	 * creation time：2013-8-7 下午1:18:13
	 */
	import com.YFFramework.core.center.manager.update.UpdateManager;
	import com.YFFramework.core.event.YFEventCenter;
	import com.YFFramework.core.ui.abs.AbsView;
	import com.YFFramework.game.core.module.AnswerActivity.event.AnswerActivityEvent;
	import com.YFFramework.game.ui.imageText.ImageTextManager;
	import com.YFFramework.game.ui.imageText.TypeImageText;
	import com.dolo.ui.managers.UI;
	import com.dolo.ui.tools.Xdis;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.EventDispatcher;
	import flash.utils.getTimer;
	
	public class PreAnswerPanel extends EventDispatcher
	{
		//======================================================================
		//       public property
		//======================================================================
		
		//======================================================================
		//       private property
		//======================================================================
		private var _mc:MovieClip;
		
		private var _preTime:int;
		private var _startTime:int;
		
		private var _numSp:Sprite;
		//======================================================================
		//        constructor
		//======================================================================
		
		public function PreAnswerPanel(mc:MovieClip)
		{
			_mc=mc;
			_numSp=Xdis.getChild(_mc,"numSp");
		}
		
		//======================================================================
		//        public function
		//======================================================================
		public function setVisible(show:Boolean=false):void
		{
			_mc.visible=show;
		}
		
		public function countDownPreTime(preTime:int):void
		{
			_preTime=preTime;
			UpdateManager.Instance.framePer.regFunc(countDown);
			_startTime=getTimer();
		}
		//======================================================================
		//        private function
		//======================================================================
		private function countDown():void
		{
			var curTime:int = _preTime - (getTimer() - _startTime);
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
				YFEventCenter.Instance.dispatchEventWith(AnswerActivityEvent.ANSWER_COUNT_DOWN_END);
			}
		}

		//======================================================================
		//        event handler
		//======================================================================
		
		//======================================================================
		//        getter&setter
		//======================================================================
		
		
	}
} 