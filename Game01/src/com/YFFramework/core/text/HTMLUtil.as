package com.YFFramework.core.text
{
	/**2012-10-25 上午9:30:58
	 *@author yefeng
	 */
	public class HTMLUtil
	{
		public function HTMLUtil()
		{
		}
		/**
		 * @param txt  具体文本
		 * @param fontColor  字体颜色
		 * @param eventFunc 单击文本调用的函数
		 * @param underLine	文本是否具有下划线    只有具有下划线时才会触发事件
		 * @param event 是否响应事件 响应的事件所带的参数 应的事件是 TextEvent.LINK   获取数据 是 e.text
		 */		
		public static function setFont(txt:String,fontColor:String="#FF0000",underLine:Boolean=false,event:Boolean=false):String
		{
			var myStr:String=txt;
			if(underLine)
			{
				myStr="<u>"+txt+"</u>";
			}
			myStr ='<font color="'+fontColor+'">'+myStr+'</font>';
			if(event)   
			{
				myStr ='<a href="event:'+txt+'">'+myStr+'</a>';
			}
			return myStr;
		}
		
		
	}
}