package com.YFFramework.core.ui.yfComponent.controls
{
	import com.YFFramework.core.debug.print;
	import com.YFFramework.core.ui.abs.AbsUIView;
	import com.YFFramework.core.ui.utils.Draw;
	
	import flash.display.Shape;
	import flash.events.Event;
	import flash.utils.getTimer;
	
	/**2012-11-1 下午1:08:55
	 *@author yefeng
	 */
	public class YFCD extends AbsUIView
	{
		protected var _cdView:YFCDData;
		
		protected var _maskShape:Shape;
		/** 高度
		 */		
		private var _mWidth:Number;
		/**宽度
		 */		
		private var _mHeight:Number; 
		private var _loop:Boolean;
		private var _completeFunc:Function;
		private var _completeFuncParam:Object;
		private var _isComplete:Boolean=false;
		
		/**播放总时间
		 */
		private var _totalTime:Number=0;
		/** 开始播放的时间
		 */
		private var _startTime:Number=0;
		public function YFCD(width:Number,height:Number)
		{
			_mWidth=width;
			_mHeight=height;
			super(false);
			mouseChildren=false;
		}
		override protected function initUI():void
		{
			super.initUI();
			_cdView=new YFCDData();
			addChild(_cdView);
			_cdView.setPivotXY(_mWidth*0.5,_mHeight*0.5);
			_cdView.alpha=0.7;
			initMask();
		}
		
		protected function initMask():void
		{
			_maskShape=new Shape();
			_maskShape.y=0;
			_maskShape.x=0;
			Draw.DrawRect(_maskShape.graphics,_mWidth,_mHeight,0xFF0000);
			addChild(_maskShape)
			this.mask=_maskShape;
		}

		/**
		 * @param totalTime  总时间   单位为毫秒
		 * @param loop   是否循环播放
		 * @param completeFunc  播放完成触发的方法
		 * @param completeParam   完成方法的参数
		 */		
		public function play(totalTime:Number,startTime:int=0,loop:Boolean=false,completeFunc:Function=null,completeParam:Object=null):void
		{
			_totalTime=totalTime;
			var _frameRate:int=totalTime/totalFrames;
			_loop=loop;
//			var startTime:int=0;
			var index:int=(startTime*totalFrames/totalTime)-1;
			if(index<0)index=0;
			if(index>=totalFrames)index=totalFrames-1;
			_isComplete = false;
			_cdView.play(_frameRate,index,loop,completeFunc,completeParam);
		} 
		/** 复制	CD使用的方法
		 * @param frameRate
		 * @param index
		 * @param loop
		 * @param completeFunc
		 * @param completeParam
		 * 
		 */		
		protected function playForClone(frameRate:Number,index:int=0,loop:Boolean=true,completeFunc:Function=null,completeParam:Object=null):void
		{
			_cdView.play(frameRate,index,loop,completeFunc,completeParam);
		}
		
		public function start():void
		{
			_cdView.start();
			_startTime=getTimer();
		}
		
		/**获取剩余播放的时间
		 */
		public function getRemainTime():Number
		{
			var dif:Number=_totalTime-(getTimer()-_startTime);
			if(dif<0)dif=0;
			return dif;
		}
		
		public function stop():void
		{
			_cdView.stop();			
		}
		public function get  totalFrames():int
		{
			return _cdView.totalFrames;
		}
		/**  停留在第几张图片序列帧 第一帧为0
		 * @param index
		 */		
		public function gotoAndStop(index:int):void
		{
			_cdView.gotoAndStop(index);
		}		
		public function clone(completeFunc:Function=null,completeFuncParam:Object=null):YFCD
		{
			var cd:YFCD=new YFCD(_mWidth,_mHeight);
			cd.playForClone(_cdView.frameRate,_cdView.getPlayIndex(),_loop,completeFunc,completeFuncParam);
			cd.start();
			cd._totalTime=_totalTime;
			cd._startTime=_startTime;
			return cd;
		}
		public function get framerate():int
		{
			return _cdView.frameRate;
		}
		override public function dispose(e:Event=null):void
		{
			super.dispose();
			_cdView=null;
			_maskShape=null;
			_completeFunc=null;
			_completeFuncParam=null;
		}
		
		
	}
}