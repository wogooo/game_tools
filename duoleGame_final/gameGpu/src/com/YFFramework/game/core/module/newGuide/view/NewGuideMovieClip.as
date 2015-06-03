package com.YFFramework.game.core.module.newGuide.view
{
	import com.YFFramework.core.proxy.StageProxy;
	import com.YFFramework.core.ui.abs.AbsView;
	import com.YFFramework.core.ui.utils.Draw;
	import com.YFFramework.game.core.global.util.UIPositionUtil;
	import com.YFFramework.game.core.global.view.ui.ButtonEffectView;
	import com.greensock.TweenLite;
	import com.greensock.easing.Bounce;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.Timer;

	/**@author yefeng
	 * 2013 2013-7-1 下午7:34:02 
	 * 新手引导动画 
	 */
	public class NewGuideMovieClip extends AbsView
	{
		/**红色颜色
		 */		
//		protected var _redColor:AbsView;
//		/**黄色颜色
//		 */		
//		protected var _yellowColor:AbsView;
//		
//		private var _timer:Timer;
//		
//		private var _visible:Boolean;
//		/**矩形区域
//		 */		
		protected var _rect:Rectangle;

		/**引导的tips
		 */		
		private var _newGuideTips:NewGuideTaskPanelTip;
		
		
		
		public var _tempW:Number=0;
		public var _tempH:Number=0;
		
		
		private var _buttonEffect:ButtonEffectView;
		
		
		
		/** rezie的时候需要重新定位 
		 */		
		private var _preW:Number=0;
		private var _preH:Number=0;
		/** 引导相关联的对象
		 */
		private var _relativeSp:Sprite;

		/** resize的回调
		 */
		public var resizeCall:Function;
		public function NewGuideMovieClip()
		{
			StageProxy.Instance.stage.addEventListener(Event.RESIZE,onResize);

		}
		private function onResize(e:Event):void
		{
			if(_relativeSp)  //用于新手引导层，也就是窗口顶层 一般是 挖洞引导时候的resize 
			{
				//重新initRect
				var pt:Point=UIPositionUtil.getUIRootPosition(_relativeSp);
				initRect(pt.x,pt.y,_preW,_preH,_relativeSp);
				if(resizeCall!=null)resizeCall(this,pt.x,pt.y,_preW,_preH);
			}
		}

		
		override protected function initUI():void
		{
//			_redColor=new AbsView(false);
//			_yellowColor=new AbsView(false);
//			addChild(_redColor);
//			addChild(_yellowColor);
//			_visible=false;
			_newGuideTips=new NewGuideTaskPanelTip();
			_rect=new Rectangle();
//			toggleView();
//			initMovie();
			mouseChildren=mouseEnabled=false;
			_buttonEffect=new ButtonEffectView();
			addChild(_buttonEffect);
		}
		
		public function hideButtonEffectView():void
		{
			if(contains(_buttonEffect))removeChild(_buttonEffect);
		}
		
		
		
//		private function toggleView():void
//		{
//			_visible=!_visible;
//			_redColor.visible=!_visible
//			_yellowColor.visible=_visible;
//		}
		/** 创建引导区域
		 */		
		public function initRect(x:Number,y:Number,width:Number,height:Number,relativeSp:Sprite):void
		{
			
			_relativeSp=relativeSp;
			_preW=width;
			_preH=height;
			
			_rect.x=x;
			_rect.y=y;
			_rect.height=height;
			_rect.width=width;
//			_redColor.graphics.clear();
//			Draw.DrawRectLine(_redColor.graphics,0,0,width,height,0xFF0000,2);
//			_yellowColor.graphics.clear();
//			Draw.DrawRectLine(_yellowColor.graphics,0,0,width,height,0xFFFF00,2);
			this.x=x;
			this.y=y;
			
			//设置buttonEffect款高以及位置
			_buttonEffect.setShowSize(width+ButtonEffectView.OffsetX*2,height+ButtonEffectView.OffsetY*2);	
			_buttonEffect.x=width*0.5
			_buttonEffect.y=height*0.5-0;
			if(!contains(_buttonEffect))addChild(_buttonEffect);
		}
//		private function initMovie():void
//		{
//			_timer=new Timer(300);
//			_timer.addEventListener(TimerEvent.TIMER,onTimer);
//		}
//		private function removeMovie():void
//		{
//			_timer.removeEventListener(TimerEvent.TIMER,onTimer);
//			_timer.stop();
//		}
//		
		public function start():void
		{
//			_timer.start();
		}
//		public function stop():void
//		{
//			_timer.stop();
//		}
//		
//		private function onTimer(e:TimerEvent):void
//		{
//			toggleView();
//		}
		
		override public function dispose(e:Event=null):void
		{
//			super.dispose();
			if(contains(_buttonEffect))removeChild(_buttonEffect);
			removeTips();
//			super.dispose();
//			removeMovie();
//			_timer=null;
//			__redColor=null;
//			yellowColor=null;
			resizeCall=null;
		}
		
		/**释放内存
		 */		
		public function release():void
		{
			if(contains(_buttonEffect))removeChild(_buttonEffect);
			_buttonEffect.dispose();
			super.dispose();
			removeTips();
			StageProxy.Instance.stage.removeEventListener(Event.RESIZE,onResize);
			resizeCall=null;
//			removeMovie();
//			_redColor=null;
//			_yellowColor=null;
//			_timer=null;
		}
		public function removeFromParent():void
		{
			if(parent)parent.removeChild(this);
		}
		
		/**显示的tips名称
		 * container   tips的容器
		 */
		public function setTips(targetName:String,container:Sprite):void
		{
			_newGuideTips.setTips(targetName);
			container.addChild(_newGuideTips);
			
			var endX:Number=x-_newGuideTips.width+20;
			var endY:Number=y+_rect.height+30;
			_newGuideTips.x=endX;
			_newGuideTips.y=endY-30;
			TweenLite.killTweensOf(_newGuideTips);
			TweenLite.to(_newGuideTips,0.5,{y:endY,ease:Bounce.easeOut});
		}
		public function removeTips():void
		{
			if(_newGuideTips.parent)_newGuideTips.parent.removeChild(_newGuideTips);
		}
		
		
		/** 从  maxW maxH 宽高 缓动到   minW  minH  坐标为 endX  endY 
		 * @param endX
		 * @param endY
		 * @param minW
		 * @param minH
		 * @param maxW
		 * @param maxH
		 */
		public function initTweenRect(endX:Number,endY:Number,minW:Number,minH:Number,maxW:Number,maxH:Number,complete:Function=null,completeArr:Array=null,relativeSp:Sprite=null):void
		{
			
			_relativeSp=relativeSp;
			_preW=minW;
			_preH=minH;
			
			var beginX:Number=endX-(maxW-minW)*0.5
			var beginY:Number=endY-(maxH-minH)*0.5;         
			var t:Number=0.5;
			x=beginX;
			y=beginY;
			_tempW=maxW;
			_tempH=maxH;
			TweenLite.to(this,t,{x:endX,y:endY,onUpdate:updateFunc,_tempW:minW,_tempH:minH,onComplete:complete,onCompleteParams:completeArr});
		}
		/**更新函数
		 */
		private function updateFunc():void
		{
			if(!_isDispose)
			{
			//	initRect(x,y,_tempW,_tempH);
				_buttonEffect.setShowSize(_tempW+ButtonEffectView.OffsetX*2,_tempH+ButtonEffectView.OffsetY*2);	
				_buttonEffect.x=_tempW*0.5
				_buttonEffect.y=_tempH*0.5-2;
			}
		}
			
	}
}