package com.YFFramework.game.core.module.mapScence.world.yf2dCore
{
	import com.YFFramework.core.center.manager.update.UpdateManager;
	import com.YFFramework.core.center.update.UpdateTT;
	import com.YFFramework.core.proxy.StageProxy;
	import com.YFFramework.core.world.movie.player.optimize.SceneZoneManager;
	import com.YFFramework.core.yf2d.display.DisplayObject2D;
	import com.YFFramework.core.yf2d.display.DisplayObjectContainer2D;
	import com.YFFramework.core.yf2d.events.YF2dMouseEvent;
	import com.YFFramework.game.core.global.MouseManager;
	import com.YFFramework.game.core.global.MouseStyle;
	import com.YFFramework.game.ui.layer.LayerManager;
	
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.utils.Timer;
	import flash.utils.getTimer;

	/** 鼠标交互  与yf2d 引擎结合使用 处理yf2d鼠标事件
	 * author :夜枫
	 * 时间 ：2011-12-5 下午02:01:48
	 */
	public class Interaction
	{
		private var _dictArr:Array;
		private var currentTarget:DisplayObject2D;
		private var mouseDownObj:DisplayObject2D;
		private var mouseUpObj:DisplayObject2D;
		
		private var stagePt:Point;
		private var _checkCirecle:int=150;
		
		private var _optimiseTime:Number=0;
		
		private var mouseMove:MouseEvent;
		public function Interaction()
		{
			stagePt=new Point();
			addEvent();
		}
		
		private function addEvent():void
		{
			StageProxy.Instance.stage.addEventListener(MouseEvent.CLICK,handleMouseEvent);
			StageProxy.Instance.stage.addEventListener(MouseEvent.MOUSE_DOWN,handleMouseEvent);
			StageProxy.Instance.stage.addEventListener(MouseEvent.MOUSE_UP,handleMouseEvent);
//			StageProxy.Instance.stage.addEventListener(MouseEvent.MOUSE_MOVE,handleMouseEvent);
			
			mouseMove=new MouseEvent(MouseEvent.MOUSE_MOVE);
			var timer:Timer=new Timer(100);
			timer.addEventListener(TimerEvent.TIMER,onTimer);
			timer.start();
		}
		private function onTimer(e:TimerEvent):void
		{
			if(UpdateTT.AnalysseIt<=0)
			{
				handleMouseEvent(mouseMove);
			}
		}
		

		
		/**  处理 鼠标事件 
		 * @param stagePoint
		 * @param container   进行鼠标响应的容器
		 * @param e
		 * 检测数组
		 */		
		public function handleMouse(stagePoint:Point,display:DisplayObjectContainer2D,e:MouseEvent,dictArr:Array):void
		{
			var obj:DisplayObject2D=display.hitTestPoint2(stagePoint,dictArr,true);
			
			if(obj==null&&currentTarget)
			{
				if(currentTarget.hasEventListener(YF2dMouseEvent.MOUSE_OUT))
				{
					event=new YF2dMouseEvent(YF2dMouseEvent.MOUSE_OUT,currentTarget,true);
					event.stageX=stagePoint.x;
					event.stageY=stagePoint.y;
					currentTarget.dispatchEvent(event);
					currentTarget=null;
				}
				MouseManager.resetToDefaultMouse();
				return ;
			}
			if(LayerManager.UIViewRoot.getObjectsUnderPoint(stagePoint).length==0)
			{
//				if(obj==null&&currentTarget)
//				{
//					if(currentTarget.hasEventListener(YF2dMouseEvent.MOUSE_OUT))
//					{
//						event=new YF2dMouseEvent(YF2dMouseEvent.MOUSE_OUT,currentTarget,true);
//						event.stageX=stagePoint.x;
//						event.stageY=stagePoint.y;
//						currentTarget.dispatchEvent(event);
//						currentTarget=null;
//					}
//					MouseManager.resetToDefaultMouse();
//					return ;
//				}
				
				if(!(obj&&obj.mouseEnabled)) 
				{
					MouseManager.resetToDefaultMouse();
					return ;     
				}
				var localPoint:Point=obj.globalToLocal(stagePoint);
				var event:YF2dMouseEvent;
				switch(e.type)
				{
					case MouseEvent.CLICK:
						if(mouseDownObj==mouseUpObj&&mouseDownObj&&mouseDownObj.hasEventListener(YF2dMouseEvent.CLICK))
						{
							event=new YF2dMouseEvent(YF2dMouseEvent.CLICK,obj,true,localPoint.x,localPoint.y);
							event.stageX=stagePoint.x;
							event.stageY=stagePoint.y;
							mouseDownObj.dispatchEvent(event);
						}
						break;
					case MouseEvent.MOUSE_DOWN:
						if(obj.hasEventListener(YF2dMouseEvent.MOUSE_DOWN))
						{
							event=new YF2dMouseEvent(YF2dMouseEvent.MOUSE_DOWN,obj,true,localPoint.x,localPoint.y);
							event.stageX=stagePoint.x;
							event.stageY=stagePoint.y;
							obj.dispatchEvent(event);
							mouseDownObj=obj;
						}
						break;
					case MouseEvent.MOUSE_UP:
						if(obj.hasEventListener(YF2dMouseEvent.MOUSE_UP))
						{
							event=new YF2dMouseEvent(YF2dMouseEvent.MOUSE_UP,obj,true,localPoint.x,localPoint.y);
							event.stageX=stagePoint.x;
							event.stageY=stagePoint.y;
							obj.dispatchEvent(event);
							mouseUpObj=obj;
						}
						break;
					case MouseEvent.MOUSE_MOVE:
						
						if(obj.hasEventListener(YF2dMouseEvent.MOUSE_MOVE))
						{
							event=new YF2dMouseEvent(YF2dMouseEvent.MOUSE_MOVE,obj,true,localPoint.x,localPoint.y);
							event.stageX=stagePoint.x;
							event.stageY=stagePoint.y;
							obj.dispatchEvent(event);
						}
						////创建 mouseOver   mouseOut事件
						if(!currentTarget)
						{
							if(obj.hasEventListener(YF2dMouseEvent.MOUSE_OVER))
							{
								currentTarget=obj;
								event=new YF2dMouseEvent(YF2dMouseEvent.MOUSE_OVER,currentTarget,true,localPoint.x,localPoint.y);
								event.stageX=stagePoint.x;
								event.stageY=stagePoint.y;
								currentTarget.dispatchEvent(event);
							}
							return ;
						}
						else if (currentTarget!=obj&&currentTarget)
						{
							if(currentTarget.hasEventListener(YF2dMouseEvent.MOUSE_OUT))
							{
								event=new YF2dMouseEvent(YF2dMouseEvent.MOUSE_OUT,currentTarget,true,localPoint.x,localPoint.y);
								event.stageX=stagePoint.x;
								event.stageY=stagePoint.y;
								currentTarget.dispatchEvent(event);
							}
							if(obj.hasEventListener(YF2dMouseEvent.MOUSE_OVER))
							{
								event=new YF2dMouseEvent(YF2dMouseEvent.MOUSE_OVER,currentTarget,true,localPoint.x,localPoint.y);
								event.stageX=stagePoint.x;
								event.stageY=stagePoint.y;
								obj.dispatchEvent(event);
								currentTarget=obj;
							}
							return ;
						}
						break;
					default:
						return ;
						break;
				}
			}
			else 
			{
//				if(obj==null)MouseManager.resetToDefaultMouse();
//				MouseManager.resetToDefaultMouse();
//				if(currentTarget)
//				{
//					if(currentTarget.hasEventListener(YF2dMouseEvent.MOUSE_OUT))
//					{
//						event=new YF2dMouseEvent(YF2dMouseEvent.MOUSE_OUT,currentTarget,true);
//						event.stageX=stagePoint.x;
//						event.stageY=stagePoint.y;
//						currentTarget.dispatchEvent(event);
//						currentTarget=null;
//					}
//					return ;
//				}
			}
		}

		
		private function handleMouseEvent(e:MouseEvent=null):void
		{
			if(getTimer()-_optimiseTime>=200)
			{
				stagePt.x=StageProxy.Instance.stage.mouseX;
				stagePt.y=StageProxy.Instance.stage.mouseY;
				///原型区域所在范围内检测
				var dictArr:Array=SceneZoneManager.Instance.getZoneDict2(stagePt.x-_checkCirecle,stagePt.y-_checkCirecle,stagePt.x+_checkCirecle,stagePt.y+_checkCirecle);
				if(LayerManager.PlayerLayer)
				{
					handleMouse(stagePt,LayerManager.PlayerLayer,e,dictArr);
				}
				_optimiseTime=getTimer();
			}
		}
		
	}
}