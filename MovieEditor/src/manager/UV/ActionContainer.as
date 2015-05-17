package manager.UV
{
	/**@author yefeng
	 *20122012-4-12下午10:17:33
	 */
	import com.YFFramework.air.flex.FlexUI;
	import com.YFFramework.core.event.EventCenter;
	import com.YFFramework.core.proxy.StageProxy;
	import com.YFFramework.core.ui.utils.Draw;
	
	import events.ParamEvent;
	
	import flash.display.BitmapData;
	
	import mx.core.IVisualElement;
	import mx.events.FlexEvent;
	
	import spark.components.Image;
	
	public class ActionContainer extends FlexUI
	{
		
		/**相关联的对象
		 */ 
		public var action:int;
		public var direction:int;
		
		private var bg:FlexUI;
		public var container:FlexUI;
		
		private var _boundX:int;
		private var _boundY:int;
		private var _mColor:uint;
		public function ActionContainer()
		{
			super(true);
		}
		
	

		override public function dispose(e:FlexEvent=null):void
		{
			// TODO Auto Generated method stub
			super.dispose(e);
			bg=null;
			container=null;
		}
		
		override protected function initUI():void
		{
			// TODO Auto Generated method stub
			super.initUI();
			bg=new FlexUI(true);
			super.addElement(bg);
			bg.alpha=1;
			drawBg();
			bg.mouseChildren=bg.mouseEnabled=false;
			container=new FlexUI(true);
			super.addElement(container);
		}
	
		public function addContent(element:IVisualElement):void
		{
			container.addElement(element);
		}
		
		public function removeContent(element:IVisualElement):void
		{
			container.removeElement(element);
		}
		public function removeAllContent():void
		{
			container.removeAllElements();
		}
		
		public function getContentAt(index:int):IVisualElement
		{
			// TODO Auto Generated method stub
			return container.getElementAt(index);
		}
//		override public function getElementAt(index:int):IVisualElement
//		{
//			// TODO Auto Generated method stub
//			return container.getElementAt(index);
//		}
		
		
		public  function get contentNumElements():int
		{
			return container.numElements;
		}
		
		public function drawBg(color:uint=0x0006FF,_w:int=2048,_h:int=2048):void
		{
			width=_w;
			height=_h;
			drawBg2(color);
		}
		
		public function drawBg2(color:uint):void
		{
//			_mColor=color;
//			Draw.DrawRect(bg.graphics,width,height,_mColor);
		}
		public function get mColor():uint{ return _mColor;	}
		
		public function set boundX(value:int):void
		{
			_boundX = value;
		}
		public function get boundX():int
		{
			return get2Value(_boundX);
		}

		public function get boundY():int
		{
			return get2Value(_boundY);
		}
		
		public function set boundY(value:int):void
		{
			_boundY = value;
		}
		
		
		public function getPic():BitmapData
		{
			var data:BitmapData=new BitmapData(width,height,true,0x0000FF);
			 bg.visible=false;
			 EventCenter.Instance.dispatchEvent(new ParamEvent(ParamEvent.HideFrame));
			 data.draw(container);
			 EventCenter.Instance.dispatchEvent(new ParamEvent(ParamEvent.ShowFrame));
			 bg.visible=true;
			 return data;
		} 
		
		private function get2Value(value:int):int
		{
			if(value<2) return 2;
			else if(value<4) return 4;
			else if(value<8) return 8;
			else if(value<16) return 16;
			else if(value<32) return 32
			else if(value<64)	return 64;
			else if(value<=128) return 128;
			else if(value<=256) return 256;
			else if(value<=512) return 512;
			else if(value<=1024) return 1024;
			else if(value<=2048) return 2048;
			return -1;
		}
	}
}