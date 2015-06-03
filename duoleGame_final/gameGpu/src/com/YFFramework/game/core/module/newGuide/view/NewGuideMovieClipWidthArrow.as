package com.YFFramework.game.core.module.newGuide.view
{
	import com.YFFramework.core.debug.print;
	import com.YFFramework.core.proxy.StageProxy;
	import com.YFFramework.core.ui.abs.AbsView;
	import com.YFFramework.core.ui.yfComponent.PopUpManager;
	import com.YFFramework.game.core.global.util.UIPositionUtil;
	import com.YFFramework.game.ui.layer.LayerManager;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point;

	/**带有箭头的  movie 
	 * @author yefeng
	 * 2013 2013-10-22 下午4:23:08 
	 */
	public class NewGuideMovieClipWidthArrow extends AbsView
	{
		
		/**箭头向右 
		 */
		public static const ArrowDirection_Right:int=1;
		
		/**箭头向左
		 */
		public static const ArrowDirection_Left:int=2;
		/**箭头向上
		 */
//		public static const ArrowDirection_Up:int=3;
		/**箭头向下
		 */
		public static const ArrowDirection_Down:int=4;
		
		private var _newGuideMovie:NewGuideMovieClip;
		private var _newGuideArrowMovie:NewGuideArrowMovie;
		
		
		private static var _instance:NewGuideMovieClipWidthArrow;
		
		/**前一个容器
		 */
		private var _preContainer:Sprite;
		
		/** 引导相关联的对象
		 */
		private var _relativeSp:DisplayObject;
		/** rezie的时候需要重新定位 
		 */		
		private var _preW:Number=0;
		private var _preH:Number=0;
		private var _preDirection:int;
		
		public var resizeCall:Function;
		public function NewGuideMovieClipWidthArrow()
		{
			mouseChildren=mouseEnabled=false;
			StageProxy.Instance.stage.addEventListener(Event.RESIZE,onResize);
		}
		private function onResize(e:Event):void
		{
			if(_relativeSp)  //用于新手引导层，也就是窗口顶层 一般是 挖洞引导时候的resize 
			{
				//重新initRect
				var pt:Point=UIPositionUtil.getUIRootPosition(_relativeSp);
//				initRect(pt.x,pt.y,_preW,_preH,_preDirection,_relativeSp);
				if(resizeCall!=null)
				{
					resizeCall(pt.x,pt.y,_preW,_preH,_preDirection,_relativeSp);
				}
			}
		}
		
		
		
		
		/**获取其中的一个实例
		 */
		public static function get Instance():NewGuideMovieClipWidthArrow
		{
			if(_instance==null)
			{
				_instance=new NewGuideMovieClipWidthArrow();
			}
			return 	_instance;		
		}
		public function hide():void
		{
			if(PopUpManager.contains(this))PopUpManager.removePopUp(this); // 假如 其在pop层  将其从pop层移除去  因为 pop层含有模态 组建
			if(parent)parent.removeChild(this);
		}
		
		/**添加到容器
		 */
		public function addToContainer(container:Sprite):void
		{
			_preContainer=parent as Sprite;
			resizeCall=null;
			if(PopUpManager.contains(this))PopUpManager.removePopUp(this); // 假如 其在pop层  将其从pop层移除去  因为 pop层含有模态 组建
			container.addChild(this);
			
		}
		public function removeParent(container:Sprite):void
		{
			if(container.contains(this))container.removeChild(this);
		}
		
		override protected function initUI():void
		{
			super.initUI();
			_newGuideMovie=new NewGuideMovieClip();
			addChild(_newGuideMovie);
			_newGuideArrowMovie=new NewGuideArrowMovie();
			addChild(_newGuideArrowMovie);
		}
		
		/** 引导，用于 任务面板引导
		 * @param x
		 * @param y
		 */
		public function initGuideRight(x:Number,y:Number):void
		{
			if(parent!=_preContainer&&parent!=null)  //避免多次触发
			{
				_newGuideArrowMovie.playRight(x-74,y+116);
				if(contains(_newGuideMovie))removeChild(_newGuideMovie);
			}
		}
		
		/**引导 用于功能开启引导
		 */
		public function initGuideLeft(x:Number,y:Number):void
		{
			if(parent!=_preContainer)  //避免多次触发
			{
				_newGuideArrowMovie.playLeft(x+74,y+116);
				if(contains(_newGuideMovie))removeChild(_newGuideMovie);
			}
		}
		
		/**
		 * @param x
		 * @param y
		 * @param w
		 * @param h
		 * @param direction
		 * @param relativeSp  相关联的对象当 窗口 进行resize时  需要根据 relativeSp进行重新定位
		 */
		public function initRect(x:Number,y:Number,w:Number,h:Number,direction:int,relativeSp:DisplayObject=null):void
		{
			_relativeSp=relativeSp;
			_preW=w;
			_preH=h;
			_preDirection=direction;
			_newGuideMovie.initTweenRect(x,y,w,h,1200,1200);
			_newGuideMovie.start();
			if(!contains(_newGuideMovie))addChild(_newGuideMovie);
			switch(direction)
			{
				case ArrowDirection_Right:
					//					_newGuideArrowMovie.setMovieRotationY(0);
					//					_newGuideArrowMovie.x=x+-50;
					//					_newGuideArrowMovie.y=y+h*0.5;
					_newGuideArrowMovie.playRight(x-110,y+h*0.5+88);
					break;
				case ArrowDirection_Left:
					//					_newGuideArrowMovie.setMovieRotationY(180);
					//					_newGuideArrowMovie.x=x+95;
					//					_newGuideArrowMovie.y=y+h*0.5;
					_newGuideArrowMovie.playLeft(x+w+70,y+h*0.5+88);
					break;
				//				case ArrowDirection_Up:
				//					_newGuideArrowMovie.setMovieRotationY(270);
				//					_newGuideArrowMovie.x=x+w*0.5;
				//					_newGuideArrowMovie.y=y+75+h;
				//					break;
				case ArrowDirection_Down:
					//					_newGuideArrowMovie.setMovieRotationY(90);
					//					_newGuideArrowMovie.x=x+w*0.5;
					//					_newGuideArrowMovie.y=y+-75;
					_newGuideArrowMovie.playDown(x-35,y+h-75);
					break;
			}
		}
		override public function dispose(e:Event=null):void
		{
//			super.dispose();
//			_newGuideMovie=null;
//			_newGuideArrowMovie=null;
		}
		
	}
}