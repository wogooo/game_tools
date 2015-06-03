package com.YFFramework.core.ui.yfComponent.controls
{
	import com.YFFramework.core.ui.abs.Scale9Bitmap;
	import com.YFFramework.core.ui.yfComponent.YFSkin;
	
	import flash.events.Event;
	import flash.events.MouseEvent;

	/** 窗口类   加上了一按钮
	 * 2012-8-9 上午10:01:57
	 *@author yefeng
	 */
	public class YFWindow extends YFPane
	{
		
		/**面板关闭后响应的回调函数
		 */		
	//	public var closeCallback:Function;
		/** 关闭按钮
		 */		
		protected var _closeBtn:YFSimpleButton;
		
		/** 顶部皮肤
		 */
		protected var _bgTop:Scale9Bitmap;
	
		public function YFWindow(width:Number=300, height:Number=200, autoRemove:Boolean=false)
		{
			super(width, height, autoRemove);
		}
		override protected function initUI():void
		{
			_style=YFSkin.Instance.getStyle(YFSkin.WindowSkin);
			_bgBody=_style.link.body as Scale9Bitmap;
			_bgTop=_style.link.top as Scale9Bitmap;
			///设置窗体透明度
			_bgBody.alpha=0.9;
			addChild(_bgTop);
			addChild(_bgBody);
			_bgBody.y=_bgTop.y+_bgTop.height;
			_closeBtn=new YFSimpleButton(10);
			addChild(_closeBtn);
			updateCloseBtn();
		}
		
		private function updateCloseBtn():void
		{
			_closeBtn.x=_bgBody.width-_closeBtn.width-2;
			_closeBtn.y=4;

		}
		
		override protected function addEvents():void
		{
			super.addEvents();
			_closeBtn.addEventListener(MouseEvent.CLICK,onCloseBtn);
		}
		
		override protected function removeEvents():void
		{
			super.removeEvents();
			_closeBtn.removeEventListener(MouseEvent.CLICK,onCloseBtn);
		}
		
		override protected function onDragEvent():void
		{
			_bgTop.addEventListener(MouseEvent.MOUSE_DOWN,onMouseEvent);
			_bgTop.addEventListener(MouseEvent.MOUSE_UP,onMouseEvent);	
		}
		override protected function removeDragEvent():void
		{
			_bgTop.removeEventListener(MouseEvent.MOUSE_DOWN,onMouseEvent);
			_bgTop.removeEventListener(MouseEvent.MOUSE_UP,onMouseEvent);
		}
		/**
		 *关闭窗口面板  
		 */		
		protected function onCloseBtn(e:MouseEvent):void
		{
			parent.removeChild(this);
//			if(closeCallback!=null)closeCallback();
		}
		
		override public function set width(value:Number):void
		{
			super.width=value;
			_bgTop.width=value;
			updateCloseBtn();
		}
		override public function set height(value:Number):void
		{
			_bgBody.height=value-_bgTop.height;
		}

		override public function dispose(e:Event=null):void
		{
			super.dispose();
			_closeBtn=null;
			_bgTop=null
		}
		
	}
}