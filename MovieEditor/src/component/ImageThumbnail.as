package component
{
	/**
	 *  @author yefeng
	 *   @time:2012-4-6下午04:43:25
	 */
	import com.YFFramework.air.flex.FlexUI;
	import com.YFFramework.core.ui.utils.Draw;
	
	import flash.filters.GlowFilter;
	
	import manager.BitmapDataEx;
	
	import spark.components.BorderContainer;
	
	public class ImageThumbnail extends FlexUI
	{
		import spark.components.Image;
		///缩放因子
		private static const Scale:Number=0.25;
		public var  source:BitmapDataEx;
		private var image:Image;
		public function ImageThumbnail()
		{
			super(true);
			init();
		}
		
		public function initImage(source:BitmapDataEx):void
		{
			this.source=source;
			image.source=source.bitmapData;
			image.x=0;
			image.y=0;
			if(width<=source.bitmapData.width)
			{
				image.scaleX=(width)/source.bitmapData.width;
			}
			if(height<=source.bitmapData.height)
			{
				image.scaleY=(height)/source.bitmapData.height;
			}

		}
		protected function init():void
		{
			mouseChildren=false;
			width=50;
			height=50;
			image=new Image();
			addElement(image);
			Draw.DrawRect(graphics,width,50,0xcccccc);
		}
		
		private var _state:int;
		
		// 0 1 2
		public function  set state(value:int):void
		{
			_state=value;
			var filter:GlowFilter;
			
			switch(value)
			{
				case 0:
					filters=[];
					break;
				case 1:
					filter=new GlowFilter(0xFF0000,1,10,10,2);
					filters=[filter]
					break;
				case 2:
					filter=new GlowFilter(0x33FF00,1,10,10,2);
					filters=[filter]
					break;
			}
		}
		
		
		public function get state():int
		{
			return _state;
		}
	}
}