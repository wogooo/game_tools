package manager
{
	import com.YFFramework.core.ui.yf2d.data.YF2dActionData;
	
	import flash.display.BitmapData;
	import flash.geom.Matrix;
	import flash.system.ApplicationDomain;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;

	/**2012-11-19 下午8:22:06
	 *@author yefeng
	 */
	public class yf2dForBitmapUtil
	{
		public function yf2dForBitmapUtil()
		{
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
			var pre:String="yf2d_";
			var className:String;
			var atlasData:BitmapData;
			var index:int;
			var bitmapData:BitmapData
			for each (var action:int in actionData.headerData["action"])
			{
				actionData.dataDict[action]=new Dictionary();
				for each (var direction :int in actionData.headerData[action]["direction"])
				{
					actionData.dataDict[action][direction]=new Vector.<BitmapDataEx>();
					index=0;
					className=pre+action+"_"+direction;
					bmpClass=domain.getDefinition(className) as Class;
					atlasData=new bmpClass() as BitmapData;
					
					for each (var frameData:Object in actionData.headerData[action][direction]["data"])
					{
						bitmapData=new BitmapData(frameData.rect.width,frameData.rect.height,true,0xFFFFFF);
							
						var mat:Matrix=new Matrix();
						mat.tx=-frameData.rect.x
						mat.ty=-frameData.rect.y
						bitmapData.draw(atlasData,mat);
						bitmapDataEx=new BitmapDataEx();
						bitmapDataEx.x=frameData.x-frameData.rect.width*0.5;
						bitmapDataEx.y=frameData.y-frameData.rect.height*0.5;
						bitmapDataEx.delay=frameData.delay;
						bitmapDataEx.frameIndex=index;
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
			var headData:Object=headBytes.readObject()
			return {headData:headData,swfBytes:swfBytes}
		}

		
	}
}