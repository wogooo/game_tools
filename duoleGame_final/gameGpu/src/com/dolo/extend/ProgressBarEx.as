package com.dolo.extend
{
	/**@author yefeng
	 * 2013 2013-7-9 下午5:22:46 
	 */
	import com.YFFramework.core.center.manager.update.UpdateManager;
	import com.YFFramework.core.ui.abs.AbsView;
	import com.YFFramework.core.utils.common.ClassInstance;
	import com.dolo.ui.controls.Label;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.text.TextField;
	import flash.utils.getTimer;
	
	public class ProgressBarEx extends AbsView
	{
		private var _mc:Sprite;
		private var _scaleContent:Sprite;
		private var _percent:Number;
		private var _skinId:int=-1;
		private var _currentTime:Number;
		private var _totalTime:Number;
		private var _completeFunc:Function;
		private var _completeParam:Object;
		private var _isStart:Boolean;
		
		/**文本描述
		 */
		private var _text:Label;
		public function ProgressBarEx(skinId:int=-1)
		{
			_skinId=skinId;
			super(false);
		}
		override protected function initUI():void
		{
			initSkin();
			initText();
			_isStart=false;
		}
		
		private function initText():void
		{
			_text=new Label();
			addChild(_text);
		}
		
		public function setText(txt:String):void
		{
			_text.setText(txt,0xFFFFFF,true,16);
			_text.exactWidth();
			_text.x=(_mc.width-_text.width)*0.5;
			_text.y=_mc.y-_text.height
		}
		
		/**设置皮肤
		 */		
		protected function initSkin():void
		{
			var mc:MovieClip;
			switch(_skinId)
			{
				case 1:
					mc=ClassInstance.getInstance("progressbarEx_1");
					break;
			}
			if(mc)	setSkin(mc,mc.scaleContent);
		}
		/**
		 * @param mc  设置的皮肤内容 
		 * @param scaleContent    可以进行进度显示的  缩放皮肤 进度条
		 */		
		public function setSkin(mc:Sprite,scaleContent:Sprite):void
		{
			_mc=mc;
			_scaleContent=scaleContent;
			if(_mc)
			{
				if(_mc.parent)_mc.parent.removeChild(_mc);
			}
			addChild(_mc);
		}
		
		public function set percent(value:Number):void
		{
			_percent=value;
			if(_percent>1)
			{
				_percent=1;
			}
			else if(_percent<0)_percent=0;
			_scaleContent.scaleX=_percent;
		}
		/**  获取百分比
		 */		
		public function get percent():Number
		{
			return _percent;
		}
		
		public function play(time:Number,completeFunc:Function,completeParam:Object):void
		{
			_currentTime=getTimer();
			_totalTime=time;
			_completeFunc=completeFunc;
			_completeParam=completeParam;
			percent=0;
			_isStart=true;
			UpdateManager.Instance.framePer.regFunc(update);
		}
		private function update():void
		{
			var passTime:Number=getTimer()-_currentTime;
			if(passTime>_totalTime)
			{
				stop();
				if(_completeFunc!=null)
				{
					_completeFunc(_completeParam);
				}
			}
			else 
			{
				percent=passTime/_totalTime;	
			}
		}
		override public function dispose(e:Event=null):void
		{
			super.dispose(e);
			stop();
			_completeFunc=null;
			_completeParam=null;
		}
		public function stop():void
		{
			if(_isStart)
			{
				_isStart=false;
				UpdateManager.Instance.framePer.delFunc(update);
			}
		}
		
	}
}