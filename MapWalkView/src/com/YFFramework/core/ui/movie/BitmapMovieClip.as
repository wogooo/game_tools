package com.YFFramework.core.ui.movie
{
	/**
	 *  @author yefeng
	 *   @time:2012-4-6下午07:39:05
	 */
	import com.YFFramework.core.center.manager.update.UpdateManager;
	import com.YFFramework.core.debug.print;
	import com.YFFramework.core.event.YFEvent;
	import com.YFFramework.core.ui.movie.data.ActionData;
	import com.YFFramework.core.ui.movie.data.BitmapDataEx;
	import com.YFFramework.core.ui.movie.data.TypeDirection;
	import com.YFFramework.core.ui.movie.util.TweenMoviePlay;
	import com.YFFramework.core.utils.image.Cast;
	
	import flash.display.MovieClip;
	import flash.geom.Point;
	
	/**播放器基类 数据对象为ActionData
	 * 
	 */	
	public class BitmapMovieClip extends BitmapEx
	{
		
		public var actionData:ActionData;
		protected var _playTween:TweenMoviePlay;
		protected var _completeFunc:Function;
		protected var _completeParam:Object;
		public function BitmapMovieClip()
		{
			super();
			initUI();
			addEvents();
		}
		protected function initUI():void
		{
			_playTween=new TweenMoviePlay();
		}
		public function initData(actionData:ActionData):void
		{
			this.actionData=actionData;
			if(actionData)
			{
				blendMode=actionData.getBlendMode();
			}
		}
		
		/**
		 * @param mc   影片剪辑
		 * @param frameRate   两张图片切花的时间间隔
		 * @param pivot	轴点  坐标是相对于mc第一张的图片的左上角的位置的偏移量  为 null表示 不进行偏移
		 */
		public function initMC(mc:MovieClip,pivot:Point=null,frameRate:int=30):void
		{
			actionData=Cast.MCToActionData(mc,frameRate,pivot);
		}
		
//		private function updateRole(data:BitmapDataEx):void
//		{
//			bitmapData=data.bitmapData;
//			x=data.x;
//			y=data.y;
//		}
		
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
		protected function playInit(playArr:Vector.<BitmapDataEx>,frameRate:int,loop:Boolean=true):void
		{
			_playTween.initData(setBitmapDataEx,playArr,frameRate,loop);
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
			if(actionData.dataDict[action])
			{
				var arr:Vector.<BitmapDataEx>=	actionData.dataDict[action][direction];
				playInit(arr,int(actionData.headerData[action]["frameRate"]),loop);
			}
		}
		override public function dispose():void
		{
			super.dispose();
			removeEvents();
			UpdateManager.Instance.framePer.delFunc(_playTween.update);
			_playTween.dispose();
			_playTween=null;
			actionData=null;
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
		/**单纯的停止播放
		 */		
		public function pureStop():void
		{
			_playTween.stop();
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
			
		
				
	}
}