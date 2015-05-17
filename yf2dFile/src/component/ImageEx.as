package component
{
	/**@author yefeng
	 *20122012-4-12下午10:31:35
	 */
	import com.YFFramework.air.flex.DragUI;
	import com.YFFramework.air.flex.FlexUI;
	import com.YFFramework.core.event.EventCenter;
	import com.YFFramework.core.ui.utils.Draw;
	
	import component.manager.RectData;
	
	import events.ParamEvent;
	
	import spark.components.Image;
	
	public class ImageEx extends DragUI
	{
		private var image:Image;
		public var rectData:RectData;
		private var frameUI:FlexUI;
		public function ImageEx()
		{
			image=new Image();
			addElement(image);
			super(true);
			mouseChildren=false;
			buttonMode=true;
			frameUI=new FlexUI();
			frameUI.mouseChildren=frameUI.mouseEnabled=false;
			addElement(frameUI);
		}
		override protected function addEvent():void
		{
			EventCenter.Instance.addEventListener(ParamEvent.ShowFrame,onParamEvent);
			EventCenter.Instance.addEventListener(ParamEvent.HideFrame,onParamEvent);
		}
		private function onParamEvent(e:ParamEvent):void
		{
			switch(e.type)
			{
				case ParamEvent.ShowFrame:
					frameUI.visible=true;
					break;
				case ParamEvent.HideFrame:
					frameUI.visible=false;
					break;
			}
		}
		public function set source(obj:RectData):void
		{
			rectData=obj;
			image.source=rectData.bitmapData;
			Draw.DrawRectLine(frameUI.graphics,0,0,rectData.rect.width,rectData.rect.height,0xFf0000);
			
		}
		override public function get width():Number
		{
			return rectData.rect.width;
		}
		override public function get height():Number
		{
			return rectData.rect.height;
		}
		
	}
}