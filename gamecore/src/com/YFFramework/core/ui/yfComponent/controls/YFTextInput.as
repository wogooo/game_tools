package com.YFFramework.core.ui.yfComponent.controls
{
	/**@author yefeng
	 *2012-5-14下午10:47:02
	 */
	import flash.events.Event;
	import flash.text.TextFieldType;
	
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
			_textFiled.wordWrap=true;
			_textFiled.multiline=false;
			_textFiled.type=TextFieldType.INPUT;
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
		
		
	}
}