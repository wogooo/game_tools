package com.YFFramework.core.ui.movie.hswf
{
	import com.YFFramework.core.ui.movie.data.ActionData;
	import com.YFFramework.core.ui.movie.data.BitmapDataEx;
	
	import flash.display.BitmapData;
	import flash.system.ApplicationDomain;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	

	/**
	 *  @author yefeng
	 *   @time:2012-4-11上午11:50:26
	 */
	public class HswfAnalysse
	{
		public function HswfAnalysse()
		{
		}
		
		///
		private static  function getIndexStr(index:Number):String
		{
			var str:String=String(index);
			var len:Number=4;
			var dif:Number=len-str.length;
			if(dif>0)
			{
				for(var i:Number=0;i!=dif;++i)
				{
					str="0"+str;
				}
			}
			return str;			
			
		}
		
		
		
		/**
		 * 
		 * @param actionData  目前只具有头部信息
		 * @param domain  域
		 */
		public static  function extractActionData(actionData:ActionData,domain:ApplicationDomain):void
		{
			
			
			
			var bitmapDataEx:BitmapDataEx;
			var bmpClass:Class;
			var pre:String="chitu_";
			var className:String;
			var index:int;
			var bitmapData:BitmapData;
			for each (var action:int in actionData.headerData["action"])
			{
				actionData.dataDict[action]=new Dictionary();
				for each (var direction :int in actionData.headerData[action]["direction"])
				{
					actionData.dataDict[action][direction]=new Vector.<BitmapDataEx>();
					
					index=0;
					for each (var bitmapDataExData:Object in actionData.headerData[action][direction]["data"])
					{
						bitmapDataEx=new BitmapDataEx();
						bitmapDataEx.x=bitmapDataExData.x;
						bitmapDataEx.y=bitmapDataExData.y;
						bitmapDataEx.delay=bitmapDataExData.delay;
						bitmapDataEx.frameIndex=index;
						
						className=pre+action+"_"+direction+"_"+getIndexStr(index);
						bmpClass=domain.getDefinition(className) as Class;
						bitmapData=new bmpClass() as BitmapData;
						bitmapDataEx.bitmapData=bitmapData;
						
						actionData.dataDict[action][direction].push(bitmapDataEx);
						
						index++;
						
					}
					
					actionData.headerData[action][direction]["data"]=null;
					delete actionData.headerData[action][direction]["data"];
				}
			}
		}
		
		
		
		
		
		public static function analysse(hswfBytes:ByteArray):Object
		{
			hswfBytes.uncompress();
			var headLen:Number=hswfBytes.readInt();
			var swfLen:Number=hswfBytes.readInt();
			var swfBytes:ByteArray=new ByteArray();
			var headBytes:ByteArray=new ByteArray(); 
			hswfBytes.readBytes(headBytes,0,headLen);
			hswfBytes.readBytes(swfBytes,0,swfLen);
			
	//		var headDataStr:String=headBytes.readUTF();
			
		//	var  headData:Object=JSON.decode(headDataStr) as Object;
	//		var  headData:Object=JSON.parse(headDataStr) as Object;
			var headData:Object=headBytes.readObject()
				
			return {headData:headData,swfBytes:swfBytes}
		}
	}
}