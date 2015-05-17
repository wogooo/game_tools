package com.YFFramework.core.movie3d.skill2d
{
	import away3d.animators.IAnimator;
	
	import com.YFFramework.core.center.manager.update.UpdateManager;
	import com.YFFramework.core.event.YFEvent;
	import com.YFFramework.core.movie3d.avartar.AbsView3D;
	import com.YFFramework.core.movie3d.core.YFEngine;
	import com.YFFramework.core.ui.movie.data.TypeDirection;
	import com.YFFramework.core.ui.yf2d.data.BitmapFrameData;
	import com.YFFramework.core.ui.yf2d.data.MovieData;
	import com.YFFramework.core.ui.yf2d.data.YF2dActionData;
	import com.YFFramework.core.ui.yf2d.tween.TweenYF2dPlay;
	
	import flash.geom.Matrix;
	import flash.geom.Matrix3D;
	import flash.geom.Point;
	import flash.geom.Vector3D;

	/**@author yefeng
	 *2013-3-20下午9:27:51
	 */
	
	
	public class Movie3D extends AbsView3D
	{
		private var _movie:YFSprite3D;
		public var actionData:YF2dActionData;
		protected var _playTween:TweenYF2dPlay;
		protected var _completeFunc:Function;
		protected var _completeParam:Object;
		
		public function Movie3D()
		{
			mouseChildren=false;
			initUI();
			addEvents();
		}
		
		override protected function initUI():void
		{
			super.initUI();
			_playTween=new TweenYF2dPlay();
			_movie=new YFSprite3D();
			addChild(_movie);
		}
		
		override protected function addEvents():void
		{
			super.addEvents();
			_playTween.addEventListener(YFEvent.Complete,onPlayComplete);
		}
		override protected function removeEvents():void
		{
			super.removeEvents();
			_playTween.removeEventListener(YFEvent.Complete,onPlayComplete);
		}
		
		///一个动作做完之后触发
		protected function onPlayComplete(e:YFEvent):void
		{
			if(_completeFunc!=null)_completeFunc(_completeParam);
		}
		protected function playInit(movieData:MovieData,frameRate:int,loop:Boolean=true):void
		{
			_playTween.initData(updateTextureData,movieData,1,frameRate,loop);
			_playTween.start();
		}
		
		 
		/**更新宽高 和UV
		 * @param bitmapFrameData
		 * @param scaleX
		 */		
		private function updateTextureData(bitmapFrameData:BitmapFrameData,scaleX:Number=1):void
		{
			_movie.updateUVData(bitmapFrameData.getMovie3DUV());
			_movie.width=bitmapFrameData.rect.width;
			_movie.height=bitmapFrameData.rect.height;
//			var wordPos:Vector3D=_movie.scenePosition;
//			//
//			var pt2d:Vector3D=new Vector3D();
////			pt2d.x +=bitmapFrameData.x;
////			pt2d.y +=bitmapFrameData.y;
//			//
//			pt2d=YFEngine.Instance.flashToModel3d(bitmapFrameData.x,bitmapFrameData.y);
//			
//			var movieMat:Matrix3D=_movie.sceneTransform;
//			movieMat.invert();
//			pt2d=movieMat.transformVector(pt2d);
//			_movie.position=pt2d;
			
//			_movie.x=bitmapFrameData.x;
//			_movie.y=bitmapFrameData.y;//+_movie.height*0.5;
//			_movie.z=bitmapFrameData.y;//+_movie.height*0.5;

//			_movie.y=100;
//			_movie.z=100;

//			_movie.setFlashPosition(bitmapFrameData.x+YFEngine.Instance.getRenderWidth()*0.5,bitmapFrameData.y+YFEngine.Instance.getRenderHeight()*0.5);
//			
//			_movie.setFlashPosition(bitmapFrameData.x,bitmapFrameData.y);
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
//				scaleX=-1;
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
//				scaleX=1;
			}
			if(actionData.dataDict[action])
			{
				var movieData:MovieData=actionData.dataDict[action][direction];
//				///设置贴图
//				_movie.setFlashTexture(movieData.getTexture());
//				///设置像素源
//				_movie.setAtlas(movieData.bitmapData);
				_movie.updateBitmapData(movieData.bitmapData);
				playInit(movieData,int(actionData.headerData[action]["frameRate"]),loop);
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
		
		public function initData(actionData:YF2dActionData):void
		{
			this.actionData=actionData;
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
		override public function dispose():void
		{
			super.dispose();
			removeEvents();
			UpdateManager.Instance.framePer.delFunc(_playTween.update);
			_movie.dispose();
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
//		public function getIntersect(parentPt:Point,parentContainer:DisplayObjectContainer2D=null):Boolean
//		{
//			return _movie.getIntersect(parentPt,parentContainer);
//		}
			
	}
}