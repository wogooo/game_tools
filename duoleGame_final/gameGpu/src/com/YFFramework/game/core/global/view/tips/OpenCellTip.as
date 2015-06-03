package com.YFFramework.game.core.global.view.tips
{
	/**
	 * @author jina;
	 * @version 1.0.0
	 * creation time：2014-1-13 下午5:11:32
	 */
	import com.YFFramework.core.text.HTMLUtil;
	import com.YFFramework.game.core.global.TimeManager;
	import com.YFFramework.game.core.global.util.FilterConfig;
	import com.YFFramework.game.core.global.util.TimerDispather;
	import com.YFFramework.game.core.global.util.TimerDispatherEvent;
	import com.YFFramework.game.core.module.AnswerActivity.dataCenter.ActivityData;
	import com.YFFramework.game.core.module.bag.backPack.OpenBagGridManager;
	import com.dolo.common.GlobalPools;
	import com.dolo.ui.managers.UI;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.utils.getTimer;
	
	public class OpenCellTip extends Sprite
	{
		//======================================================================
		//       public property
		//======================================================================
		/** 文本区块和区块间的距离 */
		private const GAP_X:int=8;
		//======================================================================
		//       private property
		//======================================================================
		private var _bgMc:Sprite;
		private var _txt:TextField;
		
		private var _totalTime:Number;
		private var _startTime:Number;
		private var _startStamp:Number;
		//======================================================================
		//        constructor
		//======================================================================
		
		public function OpenCellTip()
		{
			super();
		}
		
		//======================================================================
		//        public function
		//======================================================================
		public function setTip():void
		{
			var time:Object=OpenBagGridManager.instance.time;
			if(time == null) return;
			_totalTime=time.total;
			_startTime=time.start;
			_startStamp=time.stamp;
			
			dispose();
			UI.stage.addEventListener( Event.RENDER, onStageRender);
			
			initTip();
			_txt.x=GAP_X;
			_txt.y=GAP_X;
			
			updateTime();
			TimerDispather.instance.addFunc(TimerDispatherEvent.OpenCellGrid,updateTime);
			
			_bgMc.height=_txt.height+GAP_X*2;
		}
		
		public function dispose(event:Event = null):void
		{
			this.removeEventListener(Event.REMOVED_FROM_STAGE,dispose);
			
			if(_txt)
			{
				GlobalPools.textFieldPool.returnObject(_txt);
				_txt=null;
			}
			
			if(_bgMc && _bgMc.parent)
			{
				_bgMc.parent.removeChild(_bgMc);
				TipUtil.tipBackgrounPool.returnObject(_bgMc);
				_bgMc = null;
			}
			
			TimerDispather.instance.delFunc(TimerDispatherEvent.OpenCellGrid);
		}
		//======================================================================
		//        private function
		//======================================================================
		private function initTip():void
		{
			_bgMc= TipUtil.tipBackgrounPool.getObject();
			_bgMc.width=180;
			addChild(_bgMc);
			
			_txt=GlobalPools.textFieldPool.getObject();
			_txt.width=150;
			_txt.multiline=true;
			_txt.wordWrap=true;
			_txt.filters=FilterConfig.Black_name_filter;
			_txt.autoSize=TextFieldAutoSize.LEFT;
			_txt.selectable=false;
			_txt.mouseEnabled=false;
			addChild(_txt);			
		}
		
		private function updateTime():void
		{			
			var now:Number=getTimer();
			var time:Number=_totalTime-_startTime-(now-_startStamp)/ActivityData.MILLISECOND;
			var remainTime:String
			if(time > 0)
				remainTime=HTMLUtil.createHtmlText(TimeManager.getTimeStrFromSec(time),12,'00ff00');
			else
			{
				remainTime = HTMLUtil.createHtmlText('即将开启',12,'00ff00');
				TimerDispather.instance.addFunc(TimerDispatherEvent.OpenCellGrid,updateTime);
			}
			_txt.htmlText=HTMLUtil.createHtmlText('只要你累积一定的在线时间，可自行开启一个背包格',12,'ffffff')+'<br>'+remainTime;
		}
		//======================================================================
		//        event handler
		//======================================================================
		private function onStageRender(e:Event):void
		{
			UI.stage.removeEventListener( Event.RENDER, onStageRender );
		}
		//======================================================================
		//        getter&setter
		//======================================================================
		
		
	}
} 