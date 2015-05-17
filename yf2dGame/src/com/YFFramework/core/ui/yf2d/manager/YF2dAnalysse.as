package com.YFFramework.core.ui.yf2d.manager
{
	import com.YFFramework.core.ui.yf2d.data.BitmapFrameData;
	import com.YFFramework.core.ui.yf2d.data.MovieData;
	import com.YFFramework.core.ui.yf2d.data.YF2dActionData;
	
	import flash.display.BitmapData;
	import flash.system.ApplicationDomain;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;

	/**@author yefeng
	 *2012-11-17下午11:05:12
	 */
	public class YF2dAnalysse
	{
		public function YF2dAnalysse()
		{
		}
		
		
		
		/**
		 * 
		 * @param actionData  目前只具有头部信息
		 * @param domain  域
		 */
		public static  function extractActionData(actionData:YF2dActionData,domain:ApplicationDomain):void
		{
			
			var bitmapDataEx:BitmapFrameData;
			var movieData:MovieData;
			var bmpClass:Class;
			var pre:String="yf2d_";
			var className:String;
			var bitmapData:BitmapData;
			var uvVect:Vector.<Number>;
			for each (var action:int in actionData.headerData["action"])
			{
				actionData.dataDict[action]=new Dictionary();
				for each (var direction :int in actionData.headerData[action]["direction"])
				{
					className=pre+action+"_"+direction;
					bmpClass=domain.getDefinition(className) as Class;
					bitmapData=new bmpClass() as BitmapData;

					movieData=new MovieData();
					movieData.dataArr=new Vector.<BitmapFrameData>();
					actionData.dataDict[action][direction]=movieData;
					movieData.bitmapData=bitmapData;
					
					for each (var frameData:Object in actionData.headerData[action][direction]["data"])
					{
						bitmapDataEx=new BitmapFrameData();
						bitmapDataEx.x=frameData.x;
						bitmapDataEx.y=frameData.y;
						bitmapDataEx.delay=frameData.delay;
						///设置宽高
						bitmapDataEx.setTextureRect(frameData.rect.x,frameData.rect.y,frameData.rect.width,frameData.rect.height);
						///设置 uv 
						uvVect=Vector.<Number>([frameData.rect.x/bitmapData.width,frameData.rect.y/bitmapData.height,frameData.rect.width/bitmapData.width,frameData.rect.height/bitmapData.height]);
						bitmapDataEx.setUVData(uvVect);
						movieData.dataArr.push(bitmapDataEx);
					}
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
			var headData:Object=headBytes.readObject()
			return {headData:headData,swfBytes:swfBytes}
		}

		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
	}
}