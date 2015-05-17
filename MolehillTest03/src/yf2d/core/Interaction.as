package yf2d.core
{
	import flash.display.Stage;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	import yf2d.display.DisplayObject2d;
	import yf2d.display.Scence2D;
	import yf2d.events.YFMouseEvent;

	/** 鼠标交互
	 * author :夜枫
	 * 时间 ：2011-12-5 下午02:01:48
	 */
	internal class Interaction
	{
		private var stage:Stage;
		private var scence:Scence2D;
		private var currentTarget:DisplayObject2d;
		private var mouseDownObj:DisplayObject2d;
		private var mouseUpObj:DisplayObject2d;

		public function Interaction(stage:Stage,scence:Scence2D)
		{
			this.stage=stage;
			this.scence=scence;
			addEvent();
		}
		
		
		private function addEvent():void
		{
			stage.addEventListener(MouseEvent.CLICK,handleMouseEvent);
			stage.addEventListener(MouseEvent.MOUSE_DOWN,handleMouseEvent);
			stage.addEventListener(MouseEvent.MOUSE_UP,handleMouseEvent);
			stage.addEventListener(MouseEvent.MOUSE_MOVE,handleMouseEvent);
		}
		
		private function handleMouseEvent(e:MouseEvent):void
		{
			var stagePoint:Point=new Point(stage.mouseX-scence.x,stage.mouseY-scence.y);
			var obj:DisplayObject2d=scence.hitTestPoint(stagePoint);
			if(obj==null&&currentTarget)
			{
				event=new YFMouseEvent(YFMouseEvent.MOUSE_OUT,currentTarget);
				event.stageX=stagePoint.x;
				event.stageY=stagePoint.y;
				currentTarget.dispatchEvent(event);
				currentTarget=null;
				return ;
			}
			if(!(obj&&obj.mouseEnable)) return ;      
			var localPoint:Point=obj.globalToLocal(stagePoint);
			var event:YFMouseEvent;
			switch(e.type)
			{
				case MouseEvent.CLICK:
					if(mouseDownObj==mouseUpObj&&mouseDownObj)
					{
						event=new YFMouseEvent(YFMouseEvent.CLICK,obj);
						event.stageX=stagePoint.x;
						event.stageY=stagePoint.y;
						event.localX=localPoint.x;
						event.localY=localPoint.y;
						mouseDownObj.dispatchEvent(event);
					}
					break;
				case MouseEvent.MOUSE_DOWN:
					event=new YFMouseEvent(YFMouseEvent.MOUSE_DOWN,obj);
					event.stageX=stagePoint.x;
					event.stageY=stagePoint.y;
					event.localX=localPoint.x;
					event.localY=localPoint.y;
					obj.dispatchEvent(event);
					mouseDownObj=obj;
					break;
				case MouseEvent.MOUSE_UP:
					event=new YFMouseEvent(YFMouseEvent.MOUSE_UP,obj);
					event.stageX=stagePoint.x;
					event.stageY=stagePoint.y;
					event.localX=localPoint.x;
					event.localY=localPoint.y;
					obj.dispatchEvent(event);
					mouseUpObj=obj;
					break;
				case MouseEvent.MOUSE_MOVE:
					event=new YFMouseEvent(YFMouseEvent.MOUSE_MOVE,obj);
					event.stageX=stagePoint.x;
					event.stageY=stagePoint.y;
					event.localX=localPoint.x;
					event.localY=localPoint.y;
					obj.dispatchEvent(event);
					
					////创建 mouseOver   mouseOut事件
					if(!currentTarget)
					{
						currentTarget=obj;
						event=new YFMouseEvent(YFMouseEvent.MOUSE_OVER,currentTarget);
						event.stageX=stagePoint.x;
						event.stageY=stagePoint.y;
						event.localX=localPoint.x;
						event.localY=localPoint.y;
						currentTarget.dispatchEvent(event);
						return ;
					}
					else if (currentTarget!=obj)
					{
						event=new YFMouseEvent(YFMouseEvent.MOUSE_OUT,currentTarget);
						event.stageX=stagePoint.x;
						event.stageY=stagePoint.y;
						event.localX=localPoint.x;
						event.localY=localPoint.y;
						currentTarget.dispatchEvent(event);
						event=new YFMouseEvent(YFMouseEvent.MOUSE_OVER,currentTarget);
						event.stageX=stagePoint.x;
						event.stageY=stagePoint.y;
						event.localX=localPoint.x;
						event.localY=localPoint.y;
						obj.dispatchEvent(event);
						currentTarget=obj;
						return ;
					}
					break;
				default:
					return ;
					break;
			}
			
		}
	}
}