package com.YFFramework.core.text
{
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	

	/**
	 * author :夜枫 * 时间 ：2011-10-1 下午04:47:46
	 *  用来管理生成 textField 
	 */
	public final class TextManager
	{
		private static  const  font:String="宋体";
		public function TextManager()
		{
		}
		public static   function createTextField(_size:int=12,col:uint=0xffffff,isBold:Boolean=false):TextField
		{
			var text:TextField=new TextField();
			text.autoSize="left";
			var format:TextFormat=new TextFormat();
			format.font=font;
			format.align=TextFormatAlign.LEFT;
			format.size=_size;
			format.color=col;
			format.bold=isBold;
			text.defaultTextFormat=format;
			return text;
		}
		
		public static  function setStyle(tf:TextField,_size:int=12,col:uint=0xffffff,isBold:Boolean=false):void
		{
			var format:TextFormat=new TextFormat();
			format.font=font;
			format.align=TextFormatAlign.LEFT;
			format.size=_size;
			format.color=col;
			format.bold=isBold;
			tf.setTextFormat(format);
		}
		
		
	}
}