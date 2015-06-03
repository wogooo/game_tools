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
//			if(underLine)
//			{
//				myStr="<u>"+txt+"</u>";
//			}
//			myStr ='<font color="'+fontColor+'">'+myStr+'</font>';
//			if(event)   
//			{
//				myStr ='<a href="event:'+txt+'">'+myStr+'</a>';
//			}
			if(event)   
			{
				myStr ='<a href="event:'+txt+'">'+myStr+'</a>';
			}

			myStr='<font color="'+fontColor+'">'+myStr+'</font>';
			if(underLine)
			{
				myStr="<u>"+myStr+"</u>";
			}
			return myStr;
		}
		
		/**
		 * font 标签指定一种字体或一个字体列表来显示文本。
		 * @param txt
		 * @param size
		 * @param color
		 * @param font：默认SimSun
		 * @return 
		 * 
		 */			
		public static function createHtmlText(txt:String, size:int = 12, color:String = '000000',font:String = "SimSun") : String
		{
			var html:String = "";
			html = "<font size=\'" + size + "\' color=\'#" + color + "\' font=\'" + font + "\'>"+txt+"</font>";
			
			return html;
		}
		
		public static function alignText(txt:String, align:String = "center") : String
		{
			var str:String = "<p align=\'" + align + "\'>" + txt + "</p>";
			return str;
		}
		
		public static function addLink(eventText:String,txt:String,underLine:Boolean = true):String{
			if(underLine){
				return "<u><a href='event:"+eventText+"'>"+txt+"</a></u>";
			}else{
				return "<a href='event:"+eventText+"'>"+txt+"</a>";
			}
			
		}
		
		public static function addUnderLine(txt:String):String{
			return "<u>"+txt+"</u>";
		}
		
		public static function createLeadingFormat(str:String,leading:int):String
		{
			var html:String="<textformat leading=\'" + leading + "\'>"+str+"</textformat>";
			return html;
		}
		
		public static function createIndentFormat(str:String,indent:int):String
		{
			var html:String="<textformat indent=\'" + indent + "\'>"+str+"</textformat>";
			return html;
		}
		
	}
}