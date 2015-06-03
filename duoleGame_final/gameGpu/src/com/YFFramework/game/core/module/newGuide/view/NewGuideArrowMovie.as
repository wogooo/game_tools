package com.YFFramework.game.core.module.newGuide.view
{
	/**@author yefeng
	 * 2013 2013-7-2 下午2:39:39 
	 */
	import com.YFFramework.core.event.ParamEvent;
	import com.YFFramework.core.ui.abs.AbsView;
	import com.YFFramework.core.ui.movie.BitmapMovieClip;
	import com.YFFramework.core.ui.movie.data.ActionData;
	import com.YFFramework.core.ui.movie.data.TypeAction;
	import com.YFFramework.core.ui.movie.data.TypeDirection;
	import com.YFFramework.core.utils.net.SourceCache;
	import com.YFFramework.game.core.global.manager.CommonEffectURLManager;
	
	import flash.events.Event;
	
	/**新手引导的  箭头  打开 NPC对话窗口显示的箭头
	 */	
	public class NewGuideArrowMovie extends AbsView
	{
		
		private var _movie:BitmapMovieClip;
		private var _container:AbsView;
		
		private var _rotation:Number=0;
		private static const Func_Left:int=1;
		private static const Func_Right:int=2;
		private static const Func_Down:int=3;
		private var _flag:int=Func_Left;
		private var _myScaleX:Number=1;
		public function NewGuideArrowMovie()
		{
			super(false);
			mouseChildren=mouseEnabled=false;
		}
		override protected function initUI():void
		{
			_container=new AbsView();
			addChild(_container);
			_movie=new BitmapMovieClip();
			_container.addChild(_movie);
//			setMovieRotationY(180);
			var url:String=CommonEffectURLManager.NewGuideArrowURL;
			var actionData:ActionData=SourceCache.Instance.getRes2(url) as ActionData;
			if(!actionData)
			{
				addEventListener(url,onEffectLoaded);
				SourceCache.Instance.loadRes(url,null,SourceCache.ExistAllScene,null,{dispatcher:this},true);
			}
			else 
			{
				initActionData(actionData);
			}
			
		}
		
		private function onEffectLoaded(e:ParamEvent):void
		{
			var url:String=e.type;
			removeEventListener(url,onEffectLoaded);
			if(!isDispose)
			{
				var actionData:ActionData=SourceCache.Instance.getRes2(url) as ActionData;
				initActionData(actionData);
			}
		}
		
		private function initActionData(actionData:ActionData):void
		{
			_movie.initData(actionData);
			_movie.start();
//			_container.rotationZ=_rotation;
			
			if(_flag==Func_Left)
			{
				_movie.playDefault();
				_movie.scaleX=-1;
			}
			else if(_flag==Func_Right)
			{
				_movie.playDefault();
				_movie.scaleX=1;
			}
			else if(_flag==Func_Down)
			{
				playDown(x,y);
			}
			else 
			{
				_movie.playDefault();
			}
			
		}
		
		/**设置movie的旋转角度
		 */
//		public function setMovieRotationY(rotation:int):void
//		{
//			_rotation=rotation
//			_container.rotationZ=_rotation;
//		}
		
		override public function dispose(e:Event=null):void
		{
			super.dispose();
			removeEventListener(CommonEffectURLManager.NewGuideArrowURL,onEffectLoaded);
			_movie=null;
			_container=null;
		}
		
		/**播放向右的动画
		 */
		public function playRight(endX:Number,endY:Number):void
		{
			_movie.play(TypeAction.Walk,TypeDirection.Up,false,completeIt)
			x=endX;
			y=endY;
			_myScaleX=_movie.scaleX=1;
			_flag=Func_Right;
		}
		private function completeIt(obj:Object):void
		{
			_movie.playDefault();
			_movie.scaleX=_myScaleX;
		}
		/** 播放向左的动画
		 */		
		public function playLeft(endX:Number,endY:Number):void
		{
			_movie.play(TypeAction.Walk,TypeDirection.Up,false,completeIt)
			x=endX;
			y=endY;
			
			_myScaleX=_movie.scaleX=-1;
			_flag=Func_Left;
		}
		
		/**播放指向下的动画
		 * @param endX
		 * @param endY
		 * 
		 */
		public function playDown(endX:Number,endY:Number):void
		{
			_movie.play(TypeAction.Attack,TypeDirection.Up);
			x=endX;
			y=endY;
			_flag=Func_Down;
			_myScaleX=1;
		}

		
		
		
	}
}