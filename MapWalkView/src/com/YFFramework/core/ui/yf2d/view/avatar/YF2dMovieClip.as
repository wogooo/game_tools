package com.YFFramework.core.ui.yf2d.view.avatar
{
	/**@author yefeng
	 *2012-11-17下午11:41:48
	 */
	import com.YFFramework.core.center.manager.update.UpdateManager;
	import com.YFFramework.core.debug.print;
	import com.YFFramework.core.event.YFEvent;
	import com.YFFramework.core.ui.movie.data.TypeDirection;
	import com.YFFramework.core.ui.yf2d.data.BitmapFrameData;
	import com.YFFramework.core.ui.yf2d.data.MovieData;
	import com.YFFramework.core.ui.yf2d.data.YF2dActionData;
	import com.YFFramework.core.ui.yf2d.tween.TweenYF2dPlay;
	
	import flash.geom.Point;
	
	import yf2d.display.DisplayObjectContainer2D;
	import yf2d.display.sprite2D.Sprite2D;
	import yf2d.display.sprite2D.YF2dClip;
	
	public class YF2dMovieClip extends YF2dClip
	{
		public var actionData:YF2dActionData;
		protected var _playTween:TweenYF2dPlay;
		protected var _completeFunc:Function;
		protected var _completeParam:Object;
		
		public function YF2dMovieClip()
		{
			super();
			mouseChildren=false;
			addEvents()
		}
		public function initData(data:YF2dActionData):void
		{
			actionData=data;
			if(actionData)
			{
				blendMode=actionData.getBlendMode();
			}
		}
		
		override protected function initUI():void
		{
			super.initUI();
			_playTween=new TweenYF2dPlay();
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
			if(_completeFunc!=null)_completeFunc(_completeParam);
		}
		protected function playInit(movieData:MovieData,scaleX:Number,frameRate:int,loop:Boolean=true):void
		{
			_playTween.initData(updateTextureData,movieData,scaleX,frameRate,loop);
			_playTween.start();
		}
		/**停止播放
		 */		
		public function playTweenStop():void
		{
			_playTween.stop();
		}
		/**  播放方向
		 * resetPlay 重新冲第一帧开始播放
		 */
		public function play(action:int,direction:int=-1,loop:Boolean=true,completeFunc:Function=null,completeParam:Object=null,resetPlay:Boolean=false):void
		{
			_completeFunc=completeFunc;
			_completeParam=completeParam;
			var scaleX:Number=1;
			if(direction>5)
			{
				scaleX=-1;
				switch(direction)
				{
					case TypeDirection.LeftDown:
						direction=TypeDirection.RightDown
						break;
					case TypeDirection.Left:
						direction=TypeDirection.Right;
						break;
					case TypeDirection.LeftUp:
						direction=TypeDirection.RightUp;
						break;
				}
			}
			else if(direction>0)
			{
				scaleX=1;
			}
			if(actionData.dataDict[action])
			{
				var movieData:MovieData=actionData.dataDict[action][direction];
				if(movieData)
				{
					///设置贴图
					_movie.setFlashTexture(movieData.getTexture());
					///设置像素源
					_movie.setAtlas(movieData.bitmapData);
					playInit(movieData,scaleX,int(actionData.headerData[action]["frameRate"]),loop);

				}
			}
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
		public function pureStop():void
		{
			_playTween.stop();
		}

		/**
		 * @param index  在 action  direction 的数组中停留在 index 帧上
		 * @param action
		 * @param direction
		 * 
		 */
		public function gotoAndStop(index:int,action:int,direction:int):void
		{
			play(action,direction,false);
			_playTween.gotoAndStop(index);
			//	UpdateManager.Instance.framePer.delFunc(_playTween.update);
		}
		override public function dispose(childrenDispose:Boolean=true):void
		{
			super.dispose(childrenDispose);
			removeEvents();
			UpdateManager.Instance.framePer.delFunc(_playTween.update);
			_playTween.dispose();
			_playTween=null;
			actionData=null;
			_completeFunc=null;
			_completeParam=null;
			_movie=null;
		}
		
		/** parentPt是  parentContainer坐标系下的坐标，parentContainer为空时表示根容器舞台 
		 *   判断该点是否在 Sprite2D对象身上   假如该点透明也就不在身上
		 */
		public function getIntersect(parentPt:Point,parentContainer:DisplayObjectContainer2D=null):Boolean
		{
			return _movie.getIntersect(parentPt,parentContainer);
		}

	}
}