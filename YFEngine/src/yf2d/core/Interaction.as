package yf2d.core
{
	import com.YFFramework.core.proxy.StageProxy;
	import com.YFFramework.core.ui.layer.LayerManager;
	import com.YFFramework.core.world.movie.player.optimize.SceneZoneManager;
	
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	import yf2d.display.DisplayObject2D;
	import yf2d.display.DisplayObjectContainer2D;
	import yf2d.events.YF2dMouseEvent;

	/** 鼠标交互
	 * author :夜枫
	 * 时间 ：2011-12-5 下午02:01:48
	 */
	internal class Interaction
	{
		private var _dictArr:Array;
		private var currentTarget:DisplayObject2D;
		private var mouseDownObj:DisplayObject2D;
		private var mouseUpObj:DisplayObject2D;
		
		private var stagePt:Point;
		private var _checkCirecle:int=150;
		
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
			StageProxy.Instance.stage.addEventListener(MouseEvent.MOUSE_MOVE,handleMouseEvent);
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
				return ;
			}
			if(!(obj&&obj.mouseEnabled)) return ;     
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
					else if (currentTarget!=obj)
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

		
		private function handleMouseEvent(e:MouseEvent):void
		{
			stagePt.x=StageProxy.Instance.stage.mouseX;
			stagePt.y=StageProxy.Instance.stage.mouseY;
			///原型区域所在范围内检测
			var dictArr:Array=SceneZoneManager.Instance.getZoneDict2(stagePt.x-_checkCirecle,stagePt.y-_checkCirecle,stagePt.x+_checkCirecle,stagePt.y+_checkCirecle);
			if(LayerManager.PlayerLayer)
			{
				handleMouse(stagePt,LayerManager.PlayerLayer,e,dictArr);
			}
		}
		
	}
}