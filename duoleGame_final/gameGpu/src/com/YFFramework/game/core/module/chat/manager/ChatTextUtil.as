package com.YFFramework.game.core.module.chat.manager
{
	import com.YFFramework.game.core.global.manager.PropsBasicManager;
	import com.YFFramework.game.core.global.util.TypeProps;
	
	import flash.utils.Dictionary;

	/**@author yefeng
	 * 2013 2013-6-28 下午3:25:05 
	 */
	public class ChatTextUtil{
		
		/**道具数据 的正则表达式 匹配  	<> 数据   比如    我给你一个<倚天剑=json>真的吗<屠龙刀=json>
		 */		
		private static const  GoodsDataRegExp:RegExp=/\<(?:[^\<]*?|.*?\<.*?\>[^<]*)\>/g;   //////匹配<>
		/**匹配  [] 发送者的信息  比如      我给你一个[倚天剑,1,1]真的吗[屠龙刀,2,2]  [name,type,id]   匹配  []
		 */		
		private static const SendDatakeyRegExp:RegExp=/\[(?:[^\[]*?|.*?\[.*?\][^[]*)\]/g;   //////匹配  []
		
		private static const SpaceStr:String=String.fromCharCode(12288); //宽字符


		public function ChatTextUtil()
		{
		}
		/**拆分数据  服务端发过来的数据     例如     我给你一个<倚天剑=json>真的吗<屠龙刀=json>, data参数必须带myId, myQuality, myType
		 * 返回 可读 数据
		 */		
		public static function getReadableData(content:String):Object
		{
			var arr:Array=content.match(GoodsDataRegExp);  /// 每个数据 是  
			var myContent:String=content.replace(GoodsDataRegExp,SpaceStr);
			var len:int=myContent.length;
			var index:int=0;
			var obj:Object;
			var myStrArr:Array=myContent.split("");
			var quality:int;
			var color:String;
			var id:int;
			var itemStr:String;
			var type:int;
			var totalObj:Object={};
			for(var i:int=0;i!=len;++i)
			{
				if (myContent.charAt(i) == SpaceStr)
				{
					obj=getGoodsData(arr[index]);
					quality=obj.data.myQuality;
					id=obj.data.myId;
					type=obj.data.myType;
					color="#"+TypeProps.getQualityColor(quality);
					itemStr="{"+color+"|"+obj.key+"|"+type+"|"+id+"}";// 拼接 {#color|name|type|id}结构
					myStrArr[i]=itemStr;
					totalObj[type+"_"+id]=obj.data;
					++index;
				}
			}
			myContent=myStrArr.join("");
			return {content:myContent,data:totalObj};  //content 可以直接填充的 数据    data 参数  id+"_"+"type"  映射 对应的数据
		}
		/**将要发送的数据转化为字符串    比如      我给你一个[倚天剑,1,1]真的吗[屠龙刀,2,2]  [name,type,id]
		 * @param sendContent  输入文本框里的数据 
		 * @param sendDict 存储 的 数据 map   内部 key 是   sendDict[type+"_"+id]=jsonData  比如 sendDict["1_1"]=json
		 */		 
		public static function convertSendDataToString(sendContent:String,sendDict:Dictionary):String
		{
			var content:String=sendContent;
			var arr:Array=content.match(SendDatakeyRegExp);  /// 每个数据 是   [倚天剑,1,1]  转化 为   <倚天剑=jsonData>
			var myContent:String=content.replace(SendDatakeyRegExp,SpaceStr);
			var len:int=myContent.length;
			var index:int=0;
			var myStrArr:Array=myContent.split("");
			var itemStr:String;
			for(var i:int=0;i!=len;++i)
			{
				if (myContent.charAt(i) == SpaceStr)
				{
					itemStr=getSendDataItemString(arr[index],sendDict); //将  每个数据 是   [倚天剑,1,1]  转化 为   <倚天剑=jsonData>
					if(itemStr)	myStrArr[i]=" "+itemStr+" ";  //存在该数据  //前面加上一个空格
					else  //不存在该数据 
					{
						myStrArr[i]=arr[index];  //不进行数据解析
					}
					++index;
				}
			}
			myContent=myStrArr.join("");
			return myContent; 
		}

		/**获取发送的数据 
		 * 将  每个数据 是   [倚天剑,1,1]  转化 为   <倚天剑=jsonData>
		 * inputItemStr  类似   [倚天剑,1,1] 这样的数据
		 * dict 存储数据的 map
		 */		
		private static function getSendDataItemString(inputItemStr:String,dict:Dictionary):String
		{
			var myInput:String=inputItemStr.substring(1,inputItemStr.length-1);
			var inputArr:Array=myInput.split(",");
//			var inputArr:Array=JSON.parse(inputItemStr) as Array;
			if(inputArr.length==3){
				var txtStr:String=inputArr[0];
				txtStr="【"+txtStr+"】";
				var key:String=txtStr+"_"+inputArr[1]+"_"+inputArr[2];
				var data:Object=dict[key];
				if(data)
				{ 
					var jsonStr:String=JSON.stringify(data);
					var mySendStr:String=txtStr+"="+jsonStr;
					mySendStr="<"+mySendStr+">";
					return mySendStr;
				}
			}
			return null;
		}
		
		//将  <倚天剑=json>  解析成 Object  类型   内部 需要含有  myQuality属性  myId   以及  type
		private static function getGoodsData(goodsStr:String):Object
		{
			var content:String=goodsStr.substring(1,goodsStr.length-1);  //倚天剑=json
			var arr:Array=content.split("="); //
			var key:String=arr[0];
			var dataStr:String=arr[1];
			var data:Object=JSON.parse(dataStr);
			return {key:key,data:data};
		}
	}
}