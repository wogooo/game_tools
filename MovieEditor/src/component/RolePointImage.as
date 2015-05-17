package component
{
	/**  动画引点图像 
	 *  @author yefeng
	 *   @time:2012-4-6下午07:26:38
	 */
	import com.YFFramework.air.flex.FlexUI;
	import com.YFFramework.core.ui.utils.Draw;
	
	import mx.events.FlexEvent;
	
	import spark.components.Image;
	
	public class RolePointImage extends FlexUI
	{
		private var image:Image;
		public function RolePointImage()
		{
			super(false);
			image=new Image();
			addElement(image);
			mouseChildren=false;
		}
		public function set source(obj:Object):void
		{
			image.addEventListener(FlexEvent.READY,onReady);
			image.source=obj;
		}
		
		private function onReady(e:FlexEvent):void
		{
			width=image.bitmapData.width;
			height=image.bitmapData.height;
			image.x=-width*0.5;
			image.y=-height*0.5;
			
			image.removeEventListener(FlexEvent.READY,onReady);
			
			var UI:FlexUI=new FlexUI()
			Draw.DrawCircle(UI.graphics,1,0,0,0xFF0000);
			addElement(UI);


		}
		
	}
}