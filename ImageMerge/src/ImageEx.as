package
{
	import com.YFFramework.air.flex.DragUI;
	import com.YFFramework.air.flex.FlexUI;
	import com.YFFramework.core.ui.utils.Draw;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	
	import spark.components.Image;
	
	/**2012-11-21 下午6:06:41
	 *@author yefeng
	 */
	public class ImageEx extends DragUI
	{
		private var frameUI:FlexUI;
		private var image:Image;

		private var _bitmapData:BitmapData;
		public function ImageEx()
		{
			image=new Image();
			addElement(image);
			
			frameUI=new FlexUI();
			addElement(frameUI);
			frameUI.mouseChildren=frameUI.mouseEnabled=false;
			super();
			mouseChildren=false;
			buttonMode=true;

		}
		public function get bitmapData():BitmapData
		{
			return _bitmapData;
		}
		
		public function set frameVisible(value:Boolean):void
		{
			frameUI.visible=value;
		}
			
		
		public function set source(obj:BitmapData):void
		{
			_bitmapData=obj;
//			image.width=_bitmapData.width;
//			image.height=_bitmapData.height;  
			
			image.source=_bitmapData;
			Draw.DrawRectLine(frameUI.graphics,0,0,_bitmapData.width,_bitmapData.height,0xFf0000);

		}
		override public function get width():Number
		{
			return _bitmapData.width;
		}
		override public function get height():Number
		{
			return _bitmapData.height;
		}
	}
}