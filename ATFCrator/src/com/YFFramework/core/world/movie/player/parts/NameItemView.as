package com.YFFramework.core.world.movie.player.parts
{
	/**角色名称
	 *  2012-7-4
	 *	@author yefeng
	 */
	import com.YFFramework.core.ui.abs.AbsView;
	
	import flash.filters.GlowFilter;
	import flash.text.TextField;
	
	public class NameItemView extends AbsView
	{
		private var _textFiled:TextField; 
		private var _preTextColor:uint;
		
		private static const SelectColor:uint=0xFF0000;
		public function NameItemView(name:String="天下无贼",autoRemove:Boolean=false)
		{
			super(autoRemove);
			mouseChildren=false;
			_preTextColor=0x00FF00;
			setTextColor(_preTextColor);
			text=name;
		}
		
		override protected function initUI():void
		{
			super.initUI();
			_textFiled=new TextField();
			_textFiled.textColor=0xFFFFFF;
			_textFiled.filters=[new GlowFilter(0x000000,1,2,2,2)]
			addChild(_textFiled);		
		}
		
		public function setTextColor(color:uint):void
		{
			_textFiled.textColor=color;
		}
		
		public function set text(txt:String):void
		{
			_textFiled.text=txt;
			_textFiled.height=_textFiled.textHeight+5;
			_textFiled.width=_textFiled.textWidth+5;
		}
		public function get text():String
		{
			return _textFiled.text;
		}
		/**设置选中状态
		 */		
		public function setSelect(value:Boolean):void
		{
			if(value)
			{
				setTextColor(SelectColor);
			}
			else 
			{
				setTextColor(_preTextColor);
			}
		}
			
		/** 最小宽度
		 */		
		public function extractWidth():void
		{
			_textFiled.width=_textFiled.textWidth+10;
		}
		
	}
}