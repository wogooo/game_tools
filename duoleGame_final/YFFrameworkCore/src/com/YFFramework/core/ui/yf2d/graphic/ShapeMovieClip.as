/**
 *
 * 
 * 
 * 				var clip:ShapeMovieClip=new ShapeMovieClip();
				clip.initData(data);
				clip.start();
				addChild(clip);
				clip.x=300;
				clip.y=300;
				clip.playDefault();

 * 
 * 
 * 
 * 
 *  
 */
package com.YFFramework.core.ui.yf2d.graphic
{
	/**@author yefeng
	 * 2013 2013-5-11 下午3:02:42 
	 */
	import com.YFFramework.core.event.YFEvent;
	import com.YFFramework.core.ui.movie.BitmapMovieClip;
	import com.YFFramework.core.ui.movie.data.ActionData;
	import com.YFFramework.core.ui.yf2d.data.ATFActionData;
	
	import flash.display.BitmapData;
	import flash.display.BlendMode;
	import flash.display.Sprite;
	import flash.events.TimerEvent;
	
	public class ShapeMovieClip extends Sprite implements IGraphicPlayer
	{
		protected var _activeAction:int=-1;
		protected var _activeDirection:int=-1;
		
		public var actionData:ActionData;
//		protected var _playTween:TweenYF2dPlay;
//		protected var _completeFunc:Function;
//		protected var _completeParam:Object;
//		private var _timer:Timer;
//		private var _shape:Shape;
		/**数据源
		 */		
//		protected var _sourceBitmapData:BitmapData;
		
		private var _bitmapMovieClip:BitmapMovieClip;
		
		public function ShapeMovieClip()
		{
			super();
			initUI();
//			addEvents();
			mouseChildren=false;
		}
		public function initData(actionData:ActionData):void
		{
			this.actionData=actionData;
//			if(actionData)
//			{ 
//				blendMode=actionData.getBlendMode()
//			} 
//			else blendMode=BlendMode.NORMAL;
			_bitmapMovieClip.initData(actionData);
		}
		public function clear():void
		{
//			_shape.graphics.clear();
			_bitmapMovieClip.bitmapData=null;
		}
		private function initUI():void
		{
//			_shape=new Shape();
//			addChild(_shape);
//			_playTween=new TweenYF2dPlay();
//			_playTween.setPlayFunc(updateBitmap);
//			initTimer();
			
			_bitmapMovieClip=new BitmapMovieClip();
			addChild(_bitmapMovieClip);
			
		}
//		public function updateBitmap(bitmapFrameData:BitmapFrameData,scaleX:Number=1):void
//		{
//			_shape.graphics.clear();
//			bitmapFrameData.initShapeData();
//			_shape.graphics.beginBitmapFill(_sourceBitmapData,bitmapFrameData.matrix,false);
//			_shape.graphics.drawRect(0,0,bitmapFrameData.rect.width,bitmapFrameData.rect.height);
//			_shape.graphics.endFill();
//			_shape.x=bitmapFrameData.shapeX;
//			_shape.y=bitmapFrameData.shapeY;
//			this.scaleX=scaleX;
//		}
		
//		protected function addEvents():void
//		{
//			_playTween.addEventListener(YFEvent.Complete,onPlayComplete);
//		}
//		protected function removeEvents():void
//		{
//			_playTween.removeEventListener(YFEvent.Complete,onPlayComplete);
//		}
		
		
		///一个动作做完之后触发
//		protected function onPlayComplete(e:YFEvent):void
//		{
//			if(_completeFunc!=null)_completeFunc(_completeParam);
//		}
//		protected function playInit(movieData:MovieData,scaleX:Number,loop:Boolean=true):void
//		{
//			_playTween.initData(movieData,scaleX,loop);
//			_playTween.start();
//		}
		/**停止播放
		 */		
		public function playTweenStop():void
		{
//			_playTween.stop();
			_bitmapMovieClip.stop();
		}
		/**  播放方向
		 * resetPlay 重新冲第一帧开始播放
		 */
		public function play(action:int,direction:int=-1,loop:Boolean=true,completeFunc:Function=null,completeParam:Object=null,resetPlay:Boolean=false):void
		{
			_activeDirection=direction;
			_activeAction=action;
			_bitmapMovieClip.play(action,direction,loop,completeFunc,completeParam,false);
//			_completeFunc=completeFunc;
//			_completeParam=completeParam;
//			var scaleX:Number=1;
//			if(direction>5)
//			{
//				scaleX=-1;
//				switch(direction)
//				{
//					case TypeDirection.LeftDown:
//						direction=TypeDirection.RightDown
//						break;
//					case TypeDirection.Left:
//						direction=TypeDirection.Right;
//						break;
//					case TypeDirection.LeftUp:
//						direction=TypeDirection.RightUp;
//						break;
//				}
//			}
//			else if(direction>0)
//			{
//				scaleX=1;
//			}
//			if(actionData.dataDict[action])
//			{
//				var movieData:MovieData=actionData.dataDict[action][direction];
//				if(movieData)
//				{
//					///设置像素源
//					_sourceBitmapData=movieData.bitmapData;
//					playInit(movieData,scaleX,loop);
//				}
//			}
		}
//		private function initTimer():void
//		{
//			_timer=new Timer(30);
//			_timer.addEventListener(TimerEvent.TIMER,onTimer);
			
//		}
//		private function removeTimer():void
//		{
//			_timer.removeEventListener(TimerEvent.TIMER,onTimer);
//			_timer.stop()
//			_timer=null;
//		}
//		private function onTimer(e:TimerEvent):void
//		{
//			_playTween.update();
//		}
		/**调用 stop方法后 需要调用 start方法 重新启动后才能使用play方法
		 */		
		public function start():void
		{
//			_timer.start();
			_bitmapMovieClip.start();
		}
		/**再次启用需要调用start方法
		 */		
		public function stop():void
		{
//			_playTween.stop();
//			_timer.stop();
			_bitmapMovieClip.stop();
		}
		
		public function playDefault(loop:Boolean=true,completeFunc:Function=null,completeParam:Object=null,resetPlay:Boolean=true):void
		{
			var action:int=actionData.getActionArr()[0];
			var direction:int=actionData.getDirectionArr(action)[0];
			play(action,direction,loop,completeFunc,completeParam,resetPlay);
		}
		
		/** 播放默认动作
		 */		
		public function playDefaultAction(direction:int,loop:Boolean=true,completeFunc:Function=null,completeParam:Object=null,resetPlay:Boolean=true):void
		{
			var action:int=actionData.getActionArr()[0];
			play(action,direction,loop,completeFunc,completeParam,resetPlay);
		}
		
		/**单纯的停止播放
		 */		
//		public function pureStop():void
//		{
//			_playTween.stop();
//		}
		
		/**
		 * @param index  在 action  direction 的数组中停留在 index 帧上
		 * @param action
		 * @param direction
		 * 
		 */
		public function gotoAndStop(index:int,action:int,direction:int):void
		{
//			play(action,direction,false);
//			_playTween.gotoAndStop(index);
			//	UpdateManager.Instance.framePer.delFunc(_playTween.update);
		}
		public function dispose():void
		{
//			removeChild(_shape);
//			_shape.graphics.clear();
//			removeEvents();
//			stop();
//			_playTween.dispose();
//			removeTimer();
//			_playTween=null;
//			actionData=null;
//			_completeFunc=null;
//			_completeParam=null;
//			_sourceBitmapData=null;
//			_shape=null;
			removeChild(_bitmapMovieClip);
			_bitmapMovieClip.dispose();
			_bitmapMovieClip=null;
		}
		
		
		
		
		
		
		
		
	}
}