package com.YFFramework.core.utils.image
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.events.TimerEvent;
	import flash.utils.Timer;

	/**
	 * author :夜枫 * 时间 ：2011-10-1 下午02:20:25
	 * 
	 * 轮询播放图片
	 */
	public final class BitmapUtil
	{
		private  var timer:Timer;
		private var playArr:Vector.<BitmapData>;//要播放的数组
		private var playIndex:int=0;
		private var player:Bitmap;
		private var len:int;  ///播放的bmpData数组长度
		public function BitmapUtil()
		{
			init();
		}
		protected function init():void
		{
			timer=new Timer(1000*1000,0);
			timer.addEventListener(TimerEvent.TIMER,onTimer);
		//	timer.addEventListener(TimerEvent.TIMER_COMPLETE,onTimer);
			
		}
		/**
		 * bmp 显示对象   bmpdataArr要显示的数据源    intervalTime每张图片之间显示的间隔  毫秒为单位     loop 是否循环显示    
		 * stopFirst  当不循环显示时  表示是否停在第一张也就是数组索引为0的位置  true表示最后是停在第一个位置， false表示停在最后一张
		 */		
		public   function  playBitmapDataArr(bmp:Bitmap,bmpdataArr:Vector.<BitmapData>,intervalTime:int,loop:Boolean=true,stopFirst:Boolean=true):void
		{
			timer.reset();
			///停在最后一张
		 	len=bmpdataArr.length;
			player=bmp;
			playArr=bmpdataArr;
			playIndex=0;
			timer.delay=intervalTime;
			if(loop)timer.repeatCount=0;
			else 
			{
				if(stopFirst) timer.repeatCount=len;
				else  timer.repeatCount=len-1;
			}
			bmp.bitmapData=bmpdataArr[0];
			timer.start();
		}
		
		protected function onTimer(e:TimerEvent):void
		{
			switch(e.type)
			{
				case TimerEvent.TIMER:
					
					++playIndex;
					player.bitmapData=playArr[playIndex%len];
					
					break;
				case TimerEvent.TIMER_COMPLETE:
					timer.stop();
					break;
			}
						
		}
		
		public function remove():void
		{
			timer.stop();
			timer.removeEventListener(TimerEvent.TIMER,onTimer);
			timer=null;
			playArr=null;
			player=null;
		}
		
	}
}