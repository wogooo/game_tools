package com.YFFramework.game.core.module.arena.view
{
	import com.YFFramework.core.center.manager.ResizeManager;
	import com.YFFramework.core.center.manager.update.UpdateManager;
	import com.YFFramework.core.proxy.StageProxy;
	import com.YFFramework.core.ui.abs.AbsView;
	import com.YFFramework.game.core.module.AnswerActivity.dataCenter.ActivityData;
	import com.YFFramework.game.ui.imageText.ImageTextManager;
	import com.YFFramework.game.ui.imageText.TypeImageText;
	import com.YFFramework.game.ui.layer.LayerManager;
	import com.dolo.ui.managers.UI;
	
	import flash.display.Sprite;
	import flash.utils.getTimer;

	/**
	 * @author jina;
	 * @version 1.0.0
	 * creation time：2013-10-23 上午10:10:43
	 */
	public class ArenaCountDownView
	{
		//======================================================================
		//       public property
		//======================================================================
		
		//======================================================================
		//       private property
		//======================================================================
		private static var _instance:ArenaCountDownView;
		
		private var _startTime:int;
		private var _numSkin:int;
		private var _remainTime:Number;
		private var _numSp:Sprite;
		//======================================================================
		//        constructor
		//======================================================================
		
		public function ArenaCountDownView()
		{
			_numSp=new Sprite();
			ResizeManager.Instance.regFunc(resizeNumSp);
		}
		
		//======================================================================
		//        public function
		//======================================================================
		public function startCount(remainTime:int,numSkin:int=TypeImageText.ACTIVITY_NUM_BIG):void
		{
			_remainTime=remainTime*ActivityData.MILLISECOND;
			_numSkin=numSkin;
			
			UpdateManager.Instance.framePer.regFunc(countDown);
			LayerManager.NoticeLayer.addChild(_numSp);
			resizeNumSp();
			_startTime=getTimer();
		}
		
		public function hideCount():void
		{
			clear();	
		}
		//======================================================================
		//        private function
		//======================================================================
		private function countDown():void
		{
			var curTime:int = _remainTime - (getTimer() - _startTime);
			if(curTime >= 0)
			{
				var curNum:Number = int(curTime/1000);
				if(curNum >= 0)
				{
					UI.removeAllChilds(_numSp);
					var num:AbsView=ImageTextManager.Instance.createNum(curNum.toString(),_numSkin);					
					_numSp.addChild(num);
					if(curNum > 9)
						num.x=-num.width/4;
					else
						num.x=0;
				}
			}
			else
			{
				clear();
			}
		}
		
		protected function resizeNumSp():void
		{
			if(_numSp.parent)
			{
				_numSp.x = (StageProxy.Instance.stage.stageWidth)/2;
				_numSp.y = (StageProxy.Instance.stage.stageHeight)*0.4;
			}			
		}
		
		private function clear():void
		{
			UpdateManager.Instance.framePer.delFunc(countDown);
			if(LayerManager.NoticeLayer.contains(_numSp))
			{
				LayerManager.NoticeLayer.removeChild(_numSp);
				UI.removeAllChilds(_numSp);
			}
		}
		//======================================================================
		//        event handler
		//======================================================================
		
		//======================================================================
		//        getter&setter
		//======================================================================
		public static function get instance():ArenaCountDownView
		{
			if(_instance == null) _instance=new ArenaCountDownView();
			return _instance;
		}

	}
} 