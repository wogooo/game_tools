package com.YFFramework.core.ui.yfComponent.controls
{
	import com.YFFramework.core.ui.abs.AbsUIView;
	import com.YFFramework.core.ui.utils.Draw;
	
	import flash.display.Shape;
	import flash.events.Event;
	
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
		 * @param totalTime  总时间 
		 * @param loop   是否循环播放
		 * @param completeFunc  播放完成触发的方法
		 * @param completeParam   完成方法的参数
		 */		
		public function play(totalTime:Number,startTime:int=0,loop:Boolean=false,completeFunc:Function=null,completeParam:Object=null):void
		{
			var frate:Number=totalTime/totalFrames;
//			var startTime:int=0;
			var index:int=(startTime*totalFrames/totalTime)-1;
			if(index<0)index=0;
			if(index>=totalFrames)index=totalFrames-1;
			_cdView.play(frate,index,loop,completeFunc,completeParam);
		} 
		
		public function start():void
		{
			_cdView.start();
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
		override public function dispose(e:Event=null):void
		{
			super.dispose();
			_cdView=null;
			_maskShape=null;
		}
		
		
		
	}
}