package com.YFFramework.core.ui.movie
{
	import com.YFFramework.core.center.manager.update.UpdateManager;
	import com.YFFramework.core.event.YFEvent;
	import com.YFFramework.core.ui.movie.data.BitmapDataEx;
	import com.YFFramework.core.ui.movie.util.TweenMoviePlay;
	import com.YFFramework.core.utils.image.Cast;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.geom.Point;

	/**播放器   BitmapMovieClip 是数据对象是 ActionData 
	 * 该类的数据对象是 数组  Vector.<BitmapDataEx>
	 *  该类的作用主要是为了实现变速  也就是说 某个动画的 播放速度是不同 比如CD 动画   不同的物品 他们的CD动画是 不同的
	 * 2012-8-21 上午10:40:40
	 *@author yefeng
	 */
	public class RawMovieClip extends BitmapEx
	{
		protected var _playArr:Vector.<BitmapDataEx>;
//		protected var _playTween:TimeTweenSimple;
		protected var _playTween:TweenMoviePlay;

		protected var _completeFunc:Function;
		protected var _completeParam:Object;
		protected var _frameRate:int;
		protected var _loop:Boolean;
		public function RawMovieClip()
		{
			super();
			initUI();
			addEvents();
		}
		protected function initUI():void
		{
			_playTween=new TweenMoviePlay();
			_playTween.setPlayFunc(setBitmapDataEx);
		}
		/** 
		 * @param playArr  播放数组
		 */		
		public function initData(playArr:Vector.<BitmapDataEx>):void
		{
			_playArr=playArr;
		}
		/**
		 * @param mc   影片剪辑
		 * @param frameRate   两张图片切花的时间间隔
		 * @param pivot	轴点  坐标是相对于mc第一张的图片的左上角的位置的偏移量  为 null表示 不进行偏移
		 */
		public function initMC(mc:MovieClip,pivot:Point=null):void
		{
			_playArr=Cast.MCToSequence(mc,pivot);
		}
		
		protected function addEvents():void
		{
			_playTween.addEventListener(YFEvent.Complete,onPlayComplete);
		}
		protected function removeEvents():void
		{
			_playTween.removeEventListener(YFEvent.Complete,onPlayComplete);
		}
		///一个动作做完之后触发
		protected function onPlayComplete(e:YFEvent):void
		{
			gotoAndStop(0);
			this.dispatchEvent(new Event(Event.COMPLETE));
			if(_completeFunc!=null)_completeFunc(_completeParam);
		}
		protected function playInit(playArr:Vector.<BitmapDataEx>,index:int,frameRate:int,loop:Boolean=true):void
		{
			_playTween.initData(playArr,frameRate,loop);
			_playTween.start(index);
		}
		public function getPlayIndex():int
		{
			return _playTween.getPlayIndex();
		}
		
		override public function dispose():void
		{
			super.dispose();
			removeEvents();
			UpdateManager.Instance.framePer.delFunc(_playTween.update);
			_playTween.dispose();
			_playTween=null;
			_playArr=null;
			_completeFunc=null;
			_completeParam=null;
		}
		/**调用 stop方法后 需要调用 start方法 重新启动后才能使用play方法
		 */		
		public function start():void
		{
			UpdateManager.Instance.framePer.regFunc(_playTween.update);
		}
		/**再次启用需要调用start方法
		 */		
		public function stop():void
		{
			_playTween.stop();
			UpdateManager.Instance.framePer.delFunc(_playTween.update);
		}
		/**
		 * @param frameRate  图片间切换的速度间隔  单位为毫秒 
		 * @param loop   是否循环播放
		 * @param completeFunc  播放完成触发的方法
		 * @param completeParam   完成方法的参数
		 */		
		public function play(frameRate:Number,index:int=0,loop:Boolean=true,completeFunc:Function=null,completeParam:Object=null):void
		{
			_loop=loop;
			_frameRate=frameRate;
			_completeFunc=completeFunc;
			_completeParam=completeParam;
			playInit(_playArr,index,_frameRate,_loop);
		}
		public function get  totalFrames():int
		{
			return _playArr.length;
		}
		/**  停留在第几张图片序列帧 第一帧为0
		 * @param index
		 */		
		public function gotoAndStop(index:int):void
		{
			var arr:Vector.<BitmapDataEx>=new Vector.<BitmapDataEx>();
			arr.push(_playArr[index]);
			playInit(arr,0,10000,true);
		}
		
		public function get frameRate():int
		{
			return _frameRate;
		}
	}
}