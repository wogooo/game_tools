package gpu2d.display
{
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.ui.Mouse;
	import flash.ui.MouseCursor;
	
	import gpu2d.events.GMouseEvent;

	/**
	 * author :夜枫
	 * 时间 ：2011-11-13 上午11:31:32
	 */
	public class GSprite extends GDisplayObjectContainer
	{
		private var _buttonMode:Boolean;
		//private var _starDrag:Boolean;
		public function GSprite()
		{
			super();
			_buttonMode=false;
			addEvent();
		}
		private function addEvent():void
		{
			addEventListener(GMouseEvent.MOUSE_OVER,onMouseEvent);
			addEventListener(GMouseEvent.MOUSE_OUT,onMouseEvent);
		//	addEventListener(GMouseEvent.MOUSE_DOWN,onMouseEvent);
		//	addEventListener(GMouseEvent.MOUSE_UP,onMouseEvent);
		//	addEventListener(GMouseEvent.MOUSE_MOVE,onMouseEvent);
		}
		
		
		public function get  buttonMode():Boolean
		{
			return _buttonMode;
		}
		public function set buttonMode(value:Boolean):void
		{
			_buttonMode=value;
		}
		
		private function onMouseEvent(e:GMouseEvent):void
		{
			switch(e.type)
			{
				case GMouseEvent.MOUSE_OVER:
					if(_buttonMode)	Mouse.cursor=MouseCursor.BUTTON;

					break;
				case GMouseEvent.MOUSE_OUT:
					Mouse.cursor=MouseCursor.AUTO;
					
					break;

/*				case GMouseEvent.MOUSE_DOWN:
					break;

				case GMouseEvent.MOUSE_UP:
					break;
*/
				/*case GMouseEvent.MOUSE_MOVE:
					if(_starDrag)
					{
						var rect:Rectangle=getBounds(this);
						var pt:Point=globalToLocal(new Point(e.stageX,e.stageY));
						trace(pt.x-rect.x,pt.y-rect.y,width*0.5,height*0.5,"---000")
						var reallyX:int=int(e.stageX-rect.x-(pt.x-rect.x));
						var reallyY:int=int(e.stageY-rect.y-(pt.y-rect.y));
						trace(x,y,e.stageX,e.stageY,e.localX,rect,pt,"----");
						x=reallyX;
						y=reallyY;

					}
					break;*/

					
				default:
					break;
			}
		}
		
		
/*		public function startDrag():void
		{
			_starDrag=true;
		}
		
		public function stopDrag():void
		{
			_starDrag=false;
		}
*/	}
}