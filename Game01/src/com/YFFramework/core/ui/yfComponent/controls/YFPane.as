package com.YFFramework.core.ui.yfComponent.controls
{
	import com.YFFramework.core.net.loader.image_swf.UILoader;
	import com.YFFramework.core.proxy.StageProxy;
	import com.YFFramework.core.ui.abs.Scale9Bitmap;
	import com.YFFramework.core.ui.yfComponent.YFComponent;
	import com.YFFramework.core.ui.yfComponent.YFSkin;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.events.MouseEvent;

	/**面板  背景是采用的 游戏图片  
	 * 2012-6-25
	 *	@author yefeng
	 */
	public class YFPane extends YFComponent
	{
		
		protected var _bgBody:Scale9Bitmap;
		public function YFPane(width:Number=300,height:Number=200,autoRemove:Boolean=false)
		{
			super(autoRemove);
			initSize(width,height);
		}
		protected function initSize(width:Number,height:Number):void
		{
			this.width=width;
			this.height=height;
		}

		override protected function initUI():void
		{
			
			_style=YFSkin.Instance.getStyle(YFSkin.panelBgSkin);
			_bgBody=_style.link as Scale9Bitmap;
			addChild(_bgBody);
			///设置窗体透明度
			_bgBody.alpha=0.9;
		}
		
		override protected function addEvents():void
		{
			super.addEvents();
			onDragEvent();
		
		}
		protected function onDragEvent():void
		{
			_bgBody.addEventListener(MouseEvent.MOUSE_DOWN,onMouseEvent);
			_bgBody.addEventListener(MouseEvent.MOUSE_UP,onMouseEvent);	
		}
		protected function removeDragEvent():void
		{
			_bgBody.removeEventListener(MouseEvent.MOUSE_DOWN,onMouseEvent);
			_bgBody.removeEventListener(MouseEvent.MOUSE_UP,onMouseEvent);
		}
		override protected function removeEvents():void
		{
			super.removeEvents();
			removeDragEvent();
		}
		
		
		/**
		 * 
		 */		
		protected function onMouseEvent(e:MouseEvent):void
		{
			switch(e.type)
			{
				case MouseEvent.MOUSE_DOWN:
					this.startDrag();
					break;
				case MouseEvent.MOUSE_UP:
					this.stopDrag();
					inScenceAdjust();
					break;
			}
		}	
	
		/**让窗口在屏幕内  防止被拖出去
		 */		
		protected function inScenceAdjust():void
		{
			if(y<50) y=50;
			else if(y>StageProxy.Instance.stage.stageHeight-50) y=StageProxy.Instance.stage.stageHeight-50
			if(x>StageProxy.Instance.stage.stageWidth-50)x=StageProxy.Instance.stage.stageWidth-50
			else if(x<-width*0.5) x=-width*0.5;
		}
		override public  function set width(value:Number):void
		{
			_bgBody.width=value;
		}
		
		override public function set height(value:Number):void
		{
			_bgBody.height=value;
		}
			
			
		
	}
}