package com.YFFramework.core.ui.movie
{
	/**@author yefeng
	 * 2013 2013-11-1 下午2:49:58 
	 */
	import com.YFFramework.core.center.update.MovieUpdateManager;
	import com.YFFramework.core.event.YFEvent;
	import com.YFFramework.core.ui.abs.AbsView;
	import com.YFFramework.core.ui.movie.data.ActionData;
	import com.YFFramework.core.ui.movie.data.BitmapDataEx;
	import com.YFFramework.core.ui.movie.data.TypeDirection;
	import com.YFFramework.core.ui.movie.util.TweenMoviePlay;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	
	public class BitmapMovieClip extends AbsView
	{
		public var actionData:ActionData;
		protected var _playTween:TweenMoviePlay;
		protected var _completeFunc:Function;
		protected var _completeParam:Object;
		
		private var _isStart:Boolean;

		private var _bitmap:Bitmap;
		public function BitmapMovieClip()
		{
			super(false);
		}
		override protected function initUI():void 
		{
			_bitmap=new Bitmap();
			_playTween=new TweenMoviePlay();
			_playTween.setPlayFunc(setBitmapDataEx);
			addChild(_bitmap);
		}
		public function initData(actionData:ActionData):void
		{
			this.actionData=actionData;
			if(actionData)
			{
				blendMode=actionData.getBlendMode();
			}
		}
		
		public function set bitmapData(data:BitmapData):void
		{
			_bitmap.bitmapData=data;
		}
		public function get bitmapData():BitmapData
		{
			return _bitmap.bitmapData;
		}
		
		public function setBitmapDataEx(data:BitmapDataEx):void
		{
			_bitmap.x=data.x;
			_bitmap.y=data.y;
			_bitmap.bitmapData=data.bitmapData;;
		}

		
		override protected function addEvents():void
		{
			_playTween.addEventListener(YFEvent .Complete,onPlayComplete);
		}
		override protected function removeEvents():void
		{
			_playTween.removeEventListener(YFEvent.Complete,onPlayComplete);
		}
		///一个动作做完之后触发
		protected function onPlayComplete(e:YFEvent):void
		{
			if(_completeFunc!=null)_completeFunc(_completeParam);
		}
		protected function playInit(playArr:Vector.<BitmapDataEx>,frameRate:int,loop:Boolean=true):void
		{
			_playTween.initData(playArr,frameRate,loop);
			_playTween.start();
		}
		
		/**  播放方向
		 * resetPlay 重新冲第一帧开始播放
		 */
		public function play(action:int,direction:int=-1,loop:Boolean=true,completeFunc:Function=null,completeParam:Object=null,resetPlay:Boolean=false):void
		{
			_completeFunc=completeFunc;
			_completeParam=completeParam;
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
			if(actionData)
			{
				if(actionData.dataDict[action])
				{
					var arr:Vector.<BitmapDataEx>=	actionData.dataDict[action][direction];
					playInit(arr,int(actionData.headerData[action]["frameRate"]),loop);
				}
			}
		}
		/**调用 stop方法后 需要调用 start方法 重新启动后才能使用play方法
		 */		
		public function start():void
		{
			//			UpdateManager.Instance.framePer.regFunc(_playTween.update);
			if(!_isStart)
			{
				MovieUpdateManager.Instance.addFunc(_playTween.update);
				_isStart=true;
			}
		}
		/**再次启用需要调用start方法
		 */		
		public function stop():void
		{
			//			_playTween.stop();
			//			UpdateManager.Instance.framePer.delFunc(_playTween.update);
			if(_isStart)
			{
				_playTween.stop();
				MovieUpdateManager.Instance.removeFunc(_playTween.update);
				_isStart=false;
			}
			
		}
		/**单纯的停止播放
		 */		
		public function pureStop():void
		{
			_playTween.stop();
		}
		
		public function playDefault(loop:Boolean=true,completeFunc:Function=null,completeParam:Object=null,resetPlay:Boolean=true):void
		{
			if(actionData)
			{
				var action:int=actionData.getActionArr()[0];
				var direction:int=actionData.getDirectionArr(action)[0];
				play(action,direction,loop,completeFunc,completeParam,resetPlay);
			}
		}
		
		/** 播放默认动作
		 */		
		public function playDefaultAction(direction:int,loop:Boolean=true,completeFunc:Function=null,completeParam:Object=null,resetPlay:Boolean=true):void
		{
			var action:int=actionData.getActionArr()[0];
			play(action,direction,loop,completeFunc,completeParam,resetPlay);
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
		
		override public function dispose(e:Event=null):void
		{
			super.dispose();
			if(!_isDispose)
			{
				_playTween.dispose();
				_playTween=null;
				actionData=null;
				_completeFunc=null;
				_completeParam=null;
				_bitmap=null;
			}
		}
	}
}