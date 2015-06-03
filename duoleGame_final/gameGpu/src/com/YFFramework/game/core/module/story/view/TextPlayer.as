package com.YFFramework.game.core.module.story.view
{
	/**@author yefeng
	 * 2013 2013-7-16 上午10:45:24 
	 */
	import com.YFFramework.core.center.manager.ResizeManager;
	import com.YFFramework.core.proxy.StageProxy;
	import com.YFFramework.core.ui.abs.AbsView;
	
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.utils.Timer;
	
	/**  文本播放器 用于剧情文本的播放
	 */	
	public class TextPlayer extends AbsView
	{
		private var _completeCallBack:Function;
		private var _completeParam:Array;
		private var _textField:TextField;
		private var _timer:Timer;
		private var _isStart:Boolean;
		/** 播放的总时间
		 */		
		private var _totalTime:int;
		/** 每个字停留的时间
		 */		
		private var _charIntervalTime:int;
		/**文本总长度
		 */		
		private var _textLen:int;
		private var _totaltext:String;
		/**当前播放到的位置
		 */		
		private var _currentTextIndex:int;
		/**当前文本
		 */		
		private var _currentText:String;
		/**距离右边的距离
		 */		
		private var _rightSpace:int;
		public function TextPlayer()
		{
			super(false);
		}
		override protected function initUI():void
		{
			_isStart=false;
			_textField=new TextField();
			_textField.selectable=false;
			_textField.autoSize="left";
			_textField.multiline=true;
			_textField.wordWrap=true;
			_textField.mouseWheelEnabled=false;
			addChild(_textField);
			var format:TextFormat=new TextFormat();
			format.size=20;
//			format.bold=true;
			format.color=0xFFFFFF;
			_textField.defaultTextFormat=format;
			initTimer();
		}
		
		override protected function addEvents():void
		{
			super.addEvents();
			ResizeManager.Instance.regFunc(resizeIt);
		}
		
		private function resizeIt():void
		{
			var w:int=StageProxy.Instance.getWidth()-_rightSpace;
			_textField.width=w>0?w:10;
		}
		override protected function removeEvents():void
		{
			super.removeEvents();
			ResizeManager.Instance.delFunc(resizeIt);
		}
		
		private function initTimer():void
		{
			_timer=new Timer(1000);
			_timer.addEventListener(TimerEvent.TIMER,onTimer);
		}
		private function removeTimer():void
		{
			_timer.stop();
			_timer.removeEventListener(TimerEvent.TIMER,onTimer);
			_timer=null;
		}
		/**开始 
		 */		
		public function start():void
		{
			if(!_isStart)
			{
				_isStart=true;
				_timer.start();
			}
			
		}
		/**停止
		 */		
		public function stop():void
		{
			if(_isStart)
			{
				_isStart=false;
				_timer.stop();
			}
		}
		/**处理timer
		 */		
		private function onTimer(e:TimerEvent):void
		{
			playFunc();
		}
		
		/**播放
		 * time   是时间 单位是毫秒
		 * completeCall   播放完成的回调
		 *  completeParam  播放完成的参数
		 */		
		public function play(value:String,time:int,rightSpace:int=0,completeCall:Function=null,completeParam:Array=null):void
		{
			_rightSpace=rightSpace;
			_totaltext=value;
			_textLen=_totaltext.length;
			_textField.text="";
			_totalTime=time;
			_charIntervalTime=_totalTime/_textLen;
			_timer.delay=_charIntervalTime;
			_currentTextIndex=0;
			_completeCallBack=completeCall;
			_completeParam=completeParam;
			resizeIt();
		}
		
		/**播放数据
		 */		
		private function playFunc():void
		{
			if(_currentTextIndex<=_textLen)
			{
				_currentText=_totaltext.substr(0,_currentTextIndex);
				_textField.text=_currentText;
				_currentTextIndex++;
			}
			else 
			{
				stop();
				if(_completeCallBack!=null)
					_completeCallBack.apply(null,_completeParam);
			}
		}
		
		public function get text():String
		{
			return _textField.text;
		}
		public function clear():void
		{
			_textField.text="";
		}
		public function exactWidth():void
		{
			_textField.width=_textField.textWidth+15;
		}
		override public function dispose(e:Event=null):void
		{
			super.dispose();
			removeTimer();
			
		}
		override public function set width(value:Number):void
		{
			_textField.width=value;
		}
		override public function set height(value:Number):void
		{
			_textField.height=value;
		}
	}
}