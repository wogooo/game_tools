package com.YFFramework.game.ui.controls
{
	import com.YFFramework.core.proxy.StageProxy;
	import com.YFFramework.core.ui.abs.Scale9Bitmap;
	import com.YFFramework.game.ui.layer.LayerManager;
	import com.YFFramework.core.ui.yfComponent.YFComponent;
	import com.YFFramework.core.ui.yfComponent.YFSkin;
	import com.YFFramework.core.utils.StringUtil;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	import com.YFFramework.core.ui.yfComponent.controls.YFLabel;
	
	/** 控件 toolTips  单例
	 * 2012-8-13 上午10:06:31
	 *@author yefeng
	 */
	public class YFTooltips extends YFComponent
	{
		private static const MaxWidth:int=120;
		protected var _bgSkin:Scale9Bitmap;
		protected var _label:YFLabel;
		private static var _instance:YFTooltips;
		public function YFTooltips()
		{
			super(false);
		}
		/**  toolTips组件
		 */
		public static function get Instance():YFTooltips
		{
			if(!_instance) _instance=new YFTooltips();
			return _instance;
		}
		
		override protected function initUI():void
		{
			super.initUI(); 
			_style=YFSkin.Instance.getStyle(YFSkin.YFComponentTips);
			_bgSkin=_style.link.bg as Scale9Bitmap;
			addChildAt(_bgSkin,0);
			_label=new YFLabel("",1);
			addChild(_label);
			_label.exactWidth();
			updateSize();
			
		}
		
		/**设置文本
		 *
		 */
		protected function setText(msg:String):void
		{
			_label.width=MaxWidth;
			_label.text=msg;
			updateSize();
		}
			
		protected function updateSize():void
		{
			_label.x=_style.scale9L-4;
			_label.y=_style.scale9T-4;
			_label.width=MaxWidth;
			_label.exactWidth();
			_bgSkin.width=_style.scale9L+_style.scale9R+_label.textWidth-4;
			_bgSkin.height=_style.scale9T+_style.scale9B+_label.textHeight-4;
		}
		
		/**
		 * @param target   给  target对象设置tips 
		 */		
		public function setTips(target:YFComponent):void
		{
			target.addEventListener(MouseEvent.MOUSE_OVER,onMouseEvent);
			target.addEventListener(MouseEvent.MOUSE_OUT,onMouseEvent);
			target.addEventListener(MouseEvent.MOUSE_MOVE,onMouseEvent);
		}
		
		/** 移除 tips 
		 */		
		public function removeTips(target:YFComponent):void
		{
			target.removeEventListener(MouseEvent.MOUSE_OVER,onMouseEvent);
			target.removeEventListener(MouseEvent.MOUSE_OUT,onMouseEvent);
			target.removeEventListener(MouseEvent.MOUSE_MOVE,onMouseEvent);

		}
		
		private function onMouseEvent(e:MouseEvent):void
		{
			var target:YFComponent=e.target as YFComponent;
			if(target)
			{
				switch(e.type)
				{
					////滑上 和移动 
					case MouseEvent.MOUSE_OVER:
					case MouseEvent.MOUSE_MOVE:
						var str:String=target.toolTip;
						str=StringUtil.trim(str);
						if(str!="")
						{
							setText(str);
							show();
							locate();
						}
						break;
					///移出去
					case MouseEvent.MOUSE_OUT:
						hide();
						break;
				}
			}
		}
		
		
		/**
		 * 显示 
		 */		
		private function show():void
		{
			if(!LayerManager.TipsLayer.contains(this))	LayerManager.TipsLayer.addChild(this);
		}
		/**隐藏
		 */		
		private function hide():void
		{
			if(LayerManager.TipsLayer.contains(this))LayerManager.TipsLayer.removeChild(this);
		}
		
		/** 进行tips定位
		 */		
		private function locate():void
		{
			var  rightX:int=0;
			var downY:int=20;
			x=LayerManager.TipsLayer.mouseX+rightX;
			y=LayerManager.TipsLayer.mouseY+downY;
			var w:int=StageProxy.Instance.stage.stageWidth;
			var h:int=StageProxy.Instance.stage.stageHeight;
			if(x+width>w)  x=x-width-rightX*2;
			if(y+height>h) y=y-height-downY*2;
		}
		
		
		
		override public function dispose(e:Event=null):void
		{
			super.dispose(e);
		}
		

		
	}
}