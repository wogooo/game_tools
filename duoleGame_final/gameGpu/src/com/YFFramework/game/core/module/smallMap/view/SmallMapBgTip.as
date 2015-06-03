package com.YFFramework.game.core.module.smallMap.view
{
	/**@author yefeng
	 * 2013 2013-9-4 下午4:00:16 
	 */
	import com.YFFramework.core.proxy.StageProxy;
	import com.YFFramework.core.ui.abs.AbsView;
	import com.YFFramework.core.utils.StringUtil;
	import com.YFFramework.core.utils.common.ClassInstance;
	import com.YFFramework.game.ui.layer.LayerManager;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	/** tips管理类
	 */
	public class SmallMapBgTip extends AbsView
	{
		//提示文本的顶部边距（全局设置，影响所有ToolTip实例）
		public static var paddingTop:Number = 4;
		//提示文本的左边距（全局样设置，影响所有ToolTip实例）
		public static var paddingLeft:Number = 8;
		
		public static const glow:GlowFilter=new GlowFilter(0x000000,1,2,2,2);

		public static var MinWidth:int=50;

		/**背景底
		 */
		public static var tipBackgroundLinkName:String = "skin_minWindow";
		
		private static const MaxWidth:int=120;
		protected var _bgSkin:Sprite;
		protected var _textFiled:TextField;
		public function SmallMapBgTip()
		{
			super(false); 
		}
		
		override protected function initUI():void
		{
			super.initUI(); 
			_bgSkin=ClassInstance.getInstance(tipBackgroundLinkName);
			_bgSkin.cacheAsBitmap=true;
			addChildAt(_bgSkin,0);
			initLabel();
			updateSize();
		}
		private function initLabel():void
		{
			_textFiled=new TextField();
			_textFiled.autoSize="left";
			//	_textFiled.mouseEnabled=false;
			_textFiled.text="";
			_textFiled.multiline=true;
			_textFiled.wordWrap=true;
//			var tf:TextFormat=new TextFormat(YFStyle.font,_size,_color,_bold);
//			tf.align=_textAlign;
//			_textFiled.setTextFormat(tf);
			var textFormat:TextFormat = new TextFormat();
			textFormat.font = "_sans";
			textFormat.size = 12;
			_textFiled.setTextFormat(textFormat);
			addChild(_textFiled);
			_textFiled.textColor=0xFFFFFF;
			_textFiled.filters=[glow];
		}
		
		/**设置文本
		 *
		 */
		public function setText(msg:String):void
		{
			var str:String=StringUtil.trim(msg);
			_textFiled.text=str;
			_textFiled.width=MaxWidth;
			updateSize();
		}
		
		protected function updateSize():void
		{
			_textFiled.x=paddingLeft;
			_textFiled.y=paddingTop;
//			_textFiled.width=MaxWidth;
//			var w:Number=_textFiled.textWidth+5;
//			_textFiled.width=w>=MinWidth?w:MinWidth;
			_textFiled.width=MinWidth;
			_textFiled.x=paddingLeft+(MinWidth-_textFiled.textWidth-5)*0.5;
			_bgSkin.width=_textFiled.width+paddingLeft*2;
			_bgSkin.height=_textFiled.height+paddingTop*2;
		}

		
		
		
		/**
		 * @param target   给  target对象设置tips 
		 */		
		public function setTips(target:Sprite):void
		{
			target.addEventListener(MouseEvent.MOUSE_OVER,onMouseEvent);
			target.addEventListener(MouseEvent.MOUSE_OUT,onMouseEvent);
			target.addEventListener(MouseEvent.MOUSE_MOVE,onMouseEvent);
		}
		
		/** 移除 tips 
		 */		
		public function removeTips(target:Sprite):void
		{
			target.removeEventListener(MouseEvent.MOUSE_OVER,onMouseEvent);
			target.removeEventListener(MouseEvent.MOUSE_OUT,onMouseEvent);
			target.removeEventListener(MouseEvent.MOUSE_MOVE,onMouseEvent);
			
		}
		
		private function onMouseEvent(e:MouseEvent):void
		{
			var target:Sprite=e.target as Sprite;
			if(target)
			{
				switch(e.type)
				{
					////滑上 和移动 
					case MouseEvent.MOUSE_OVER:
					case MouseEvent.MOUSE_MOVE:
						show();
						locate();
						break;
					///移出去 
					case MouseEvent.MOUSE_OUT:
						hide();
						break;
				}
			}
		}
		
		/** 进行tips定位
		 */		
		private function locate():void
		{
			var  rightX:int=12;
			var downY:int=15;
			x=LayerManager.TipsLayer.mouseX+rightX;
			y=LayerManager.TipsLayer.mouseY+downY;
			var w:int=StageProxy.Instance.stage.stageWidth;
			var h:int=StageProxy.Instance.stage.stageHeight;
			if(x+width>w)  x=x-width-rightX*2;
			if(y+height>h) y=y-height-downY*2;
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
		public function hide():void
		{
			if(LayerManager.TipsLayer.contains(this))LayerManager.TipsLayer.removeChild(this);
		}
		
		
	}
}