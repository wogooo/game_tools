package cursor
{
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.ui.Mouse;
	import flash.ui.MouseCursor;
	import flash.ui.MouseCursorData;

	/**
	 *  @author yefeng
	 *   @time:2012-5-19下午02:58:56
	 */
	public class MouseCursorManager
	{
		public function MouseCursorManager()
		{
		}
		
		
		public static function  regCursor(name:String,data:Vector.<BitmapData>,hotSpot:Point=null):void
		{
			var cursorData:MouseCursorData=new MouseCursorData();
			cursorData.data=data;
			if(hotSpot)	cursorData.hotSpot=hotSpot;
			Mouse.registerCursor(name,cursorData);
			
		}
	}
}