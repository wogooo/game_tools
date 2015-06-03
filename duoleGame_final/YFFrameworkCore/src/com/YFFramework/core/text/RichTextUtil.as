package com.YFFramework.core.text
{
	/** 策划文本 解析器，解析成  RichText 能够识别的格式   "人物系统文本解析到{#0099ff|地图名}找{#ffff00|aa0}";
	 * @author yefeng
	 * 2013 2013-4-26 下午3:27:34 
	 */
	public class RichTextUtil
	{

		public function RichTextUtil()
		{
		}
		/**
		 * @param txt  人物系统文本解析  	人物系统文本解析到{#0099ff|地图名}找{#ffff00|铁匠} 
		 * exeFunc  带有一个参数
		 * 返回 RichText能够识别的数组
		 */		
		public static function  analysisText(txt:String,exeFunc:Function,data:Object,overColor:String,downColor:String):Array
		{
			var str:String=txt;
			var resultArr:Array=[];
			while(str.length>0)
			{
				str=handleIt(str,resultArr,exeFunc,data,overColor,downColor);
			}
			return resultArr;
		}
		
		private static function handleIt(str:String,resultArr:Array,exeFunc:Function,data:Object,overColor:String,downColor:String):String
		{
			var regExp:RegExp=/\{(?:[^\{]*?|.*?\{.*?\}[^{]*)\}/g; 
			var checkObj:Object=regExp.exec(str);
			var cellArr:Array;
			var tempStr:String;
			var realStr:String;
			var objLen:int;
			var cellArr2:Array;
			if(checkObj)
			{
				cellArr=[];
				cellArr[0]=str.substring(0,checkObj.index)  ///解析 {}前面的数据
				if(cellArr[0]!="")	resultArr.push(cellArr);
				///
				objLen=checkObj.length;
				for(var i:int=0;i!=objLen;++i)  ///解析  {}
				{
					tempStr=checkObj[i];
					realStr=tempStr.substring(1,tempStr.length-1);
					//					cellArr2=realStr.split("|");
					cellArr2=convertToRichArr(realStr,exeFunc,data,overColor,downColor);
					if(cellArr2[0]!="")	resultArr.push(cellArr2);
				}
				str=str.substr(checkObj.index+tempStr.length,str.length);
			}
			else   ///单纯的文本
			{
				cellArr=[];
				cellArr[0]=str;
				if(cellArr[0]!="")resultArr.push(cellArr);
				str="";
			}
			return str
		}
		/**
		 * #0099ff|地图名|type|onlyId    将这种类型的 字符串转化为  富文本支持的数组    [text,TextObject,eventFunc,eventParam]
		 */		
		private static function convertToRichArr(str:String,exeFunc:Function,data:Object,overColor:String,downColor:String):Array
		{
			var textObj:TextObject;
			var arr:Array=str.split("|");
			var len:int=arr.length;
			textObj=new TextObject(arr[0]);//new TextObject(arr[0],arr[0],arr[0]);
			var txt:String=arr[1];
			var eventparam:Object;
			if(len>=3)
			{
				eventparam={};
				eventparam.data=data;
				eventparam.type=arr[2];
				if(len>=4)eventparam.id=arr[3]
			}
			var returnArr:Array=[txt,textObj];
			if(eventparam)returnArr.push(exeFunc,eventparam);
			return returnArr;
		}
		
	}
}