package cursor
{
	import flash.display.BitmapData;
	import flash.geom.Point;

	/**
	 *  @author yefeng
	 *   @time:2012-5-19下午03:03:00
	 */
	public class CursorModule
	{
		private var data:BitmapData;
		public function CursorModule():void
		{
			init();
		}
		
		private function init():void
		{
			var ui:ColorSelect=new ColorSelect();
			data=new BitmapData(ui.width,ui.height,true,0x000000);
			data.draw(ui);
			MouseCursorManager.regCursor("select",Vector.<BitmapData>([data]),new Point(1,12));
		}
	}
}