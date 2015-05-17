package com.YFFramework.core.ui.yfComponent.controls
{
	/**@author yefeng
	 *2012-5-14下午10:47:02
	 */
	import com.YFFramework.core.ui.yfComponent.YFStyle;
	
	import flash.events.Event;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	public class YFTextInput extends YFLabel
	{
		public function YFTextInput(text:String="",skinId:int=2,size:int=12,color:int=0x000000,bgColor:uint=0xFFFFFF,textAlign:String="left",bold:Boolean=false,autoRemove:Boolean=false)
		{
			super(text,skinId,size,color,bgColor,bold,textAlign,autoRemove);
			mouseChildren=true;
		}
		override protected function initUI():void
		{
			initTextField();
			createTextBg();
			_textFiled.autoSize=TextFieldAutoSize.NONE
			_textFiled.wordWrap=false;
			_textFiled.multiline=false;
			_textFiled.type=TextFieldType.INPUT;
			var tf:TextFormat=new TextFormat(YFStyle.font);
			tf.align=TextFormatAlign.LEFT;
			_textFiled.setTextFormat(tf);
			_textFiled.height=18;
			
		}
		
		override public function set width(value:Number):void
		{
			super.width=value;
			if(_bg)	_bg.width=value;
		}
		
		override public function dispose(e:Event=null):void
		{
			super.dispose(e);
			_bg=null;
		}
		
		/**设置字符限制
		 * 只能输入数字是是： 0-9
		 */		
		public function setRestrict(restrict:String):void
		{
			_textFiled.restrict=restrict;
		}
		/**只能输入数字Num
		 */		
		public function setRestrictNum():void
		{
			_textFiled.restrict=" 0-9";
		}
		
		public function setMaxChar(maxChar:int):void
		{
			_textFiled.maxChars=maxChar;
		}
		
	}
}