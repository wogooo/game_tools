package com.YFFramework.game.core.module.story.view
{
	import com.YFFramework.core.proxy.StageProxy;
	import com.YFFramework.game.ui.layer.LayerManager;
	
	import flash.events.TimerEvent;
	import flash.filters.GlowFilter;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.utils.Timer;

	/***
	 *彩色旁白
	 *@author ludingchang 时间：2013-8-1 下午4:06:15
	 */
	public class ColorText
	{
		private var _timer:Timer;
		private var _txt:TextField;
		
		public function ColorText()
		{
			_timer=new Timer(5000,1);
			_timer.addEventListener(TimerEvent.TIMER_COMPLETE,disappear);
			_txt=new TextField;
			_txt.autoSize=TextFieldAutoSize.LEFT;
			_txt.mouseEnabled=false;
			_txt.selectable=false;
			var txtf:TextFormat=new TextFormat;
			txtf.size=20;
			_txt.textColor=0xffffff;
			_txt.defaultTextFormat=txtf;
			var filter:GlowFilter=new GlowFilter(0xff0000,.5,10,10);
			_txt.filters=[filter];
		}
		
		private function disappear(event:TimerEvent):void
		{
			if(_txt&&_txt.parent)
				_txt.parent.removeChild(_txt);
			_timer.stop();
		}
		
		/**
		 *显示旁白 
		 * @param txt 文字内容
		 * @param time 多少毫秒后消失
		 */		
		public function show(txt:String,time:int=5000):void
		{
			_txt.text=txt;
			LayerManager.StoryLayer.addChild(_txt);
			_txt.x=StageProxy.Instance.getWidth()/2-_txt.width/2;
			_txt.y=StageProxy.Instance.getHeight()-200;
			_timer.delay=time;
			_timer.reset();
			_timer.start();
		}
		/**强制消失*/
		public function forceDisappear():void
		{
			disappear(null);
		}
	}
}