package component.manager
{
	import com.YFFramework.core.ui.yf2d.data.YF2dActionData;
	
	import component.ActionContainer;
	import component.ImageEx;
	import component.manager.data.FrameData;
	
	import flash.display.BitmapData;
	import flash.geom.Rectangle;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	
	import manager.ActionData;
	

	/**生成  sp文件  
	 * 
	 * @author yefeng
	 *20122012-4-13下午11:31:39
	 */
	public class GpuFileGenerator
	{
	
		public function GpuFileGenerator()
		{
		}
		
//		public static  function createData(headerData:Object,importType:int,rootContainer:Group):GPUActionData
//		{
//			var actionData:GPUActionData=new GPUActionData();
//			actionData.dataType=importType;
//			actionData.headerData=headerData;
//			var len:int;
//			var i:int;
//			var image:ImageEx;
//			var rectData:RectData;
//			var action:int;
//			var direction:int;
//			var frameData:FrameData;
//			var container:ActionContainer
//			
//			 var containerLen:int=rootContainer.numElements;
//			 var bitmpData:BitmapData;
//			 for(var j:int=0;j!=containerLen;++j) 
//			 {
//				 
//				 container=rootContainer.getElementAt(j) as ActionContainer;
//				 len=container.contentNumElements;
//				 bitmpData=container.getPic();
//				 actionData.bitmapDataArr.push(bitmpData);
//				 for(i=0;i!=len;++i)
//				 {
//					 image=container.getContentAt(i) as ImageEx;
//					 rectData=image.rectData;
//					 action=rectData.action;
//					 direction=rectData.direction;
//					 
//					 frameData=new FrameData();
//					 frameData.x=rectData.x;
//					 frameData.y=rectData.y;
//					 frameData.rect=new Rectangle(image.x,image.y,rectData.rect.width,rectData.rect.height);
//					 
//					 if(!actionData.dataDict[action]) actionData.dataDict[action]=new Object();
//					 if(!actionData.dataDict[action][direction]) 
//					 {
//						 actionData.dataDict[action][direction]=new Vector.<FrameData>();
//						 actionData.dataDict[action][direction].length=actionData.headerData[action][direction]["len"];
//					 }
//					 actionData.dataDict[action][direction][rectData.frameIndex]=frameData;
//				 }
//			 }
//			 /// 增加 headerData 
//			 if(!actionData.headerData["atlas"])
//			 {
//				 actionData.headerData["atlas"]={};
//				 actionData.headerData["atlas"]["0"]={w:actionData.bitmapDataArr[0].width,h:actionData.bitmapDataArr[0].height}
//				 if(actionData.dataType!=TypeActionData.All)
//				 {
//					 actionData.headerData["atlas"]["1"]={w:actionData.bitmapDataArr[1].width,h:actionData.bitmapDataArr[1].height}
//				 }
//			 }
//			 
//			 return actionData;
//		}
		
		
		
		
		/**    每一个方向 一张贴图      action  ---direction -----打贴图  贴图
		 * @param headerData
		 * @param containerDict
		 * bitmapDataArr=[{data:BitmapData,name:String},...]
		 */		
		public static  function createYF2dData(headerData:Object,containerDict:Dictionary,bitmapDataArr:Array):YF2dActionData
		{
			var actionData:YF2dActionData=new YF2dActionData();
			actionData.headerData=headerData;
			var len:int;
			var image:ImageEx;
			var rectData:RectData;
			var action:int;
			var direction:int;
			var frameData:FrameData;
			var container:ActionContainer;
			var actionDict:Dictionary;
			var i:int;
			var bitmpData:BitmapData;
			var picName:String;//图片名称  导出图片 给flash压缩
			var picData:Object
			for (var actionStr:String in containerDict)
			{
				action=int(actionStr);
				actionDict=containerDict[action];
				for (var directionStr:String in actionDict)
				{	
					direction=int(directionStr);
					container=actionDict[direction];
					len=container.contentNumElements;
					bitmpData=container.getPic();
					picData={};
					picData.data=bitmpData;
					picData.name=action+"_"+direction;
					bitmapDataArr.push(picData);
					for(i=0;i!=len;++i)
					{
						image=container.getContentAt(i) as ImageEx;
						rectData=image.rectData;
						action=rectData.action;
						direction=rectData.direction;
						
						frameData=new FrameData();
//						frameData.x=rectData.x;
//						frameData.y=rectData.y;
						/// yf2d的 注册点在几何中心					
						frameData.x=rectData.x+rectData.rect.width*0.5;   ////在ActionData的基础上加上了一个 半宽
						frameData.y=rectData.y+rectData.rect.height*0.5;
						
						frameData.frameIndex=rectData.frameIndex;
						frameData.delay=rectData.delay;
						///// uv  坐标  
				//		frameData.rect=new Rectangle(image.x/bitmpData.width,image.y/bitmpData.height,rectData.rect.right/bitmpData.width,rectData.rect.bottom/bitmpData.height);
						
						frameData.rect=new Rectangle(image.x,image.y,rectData.rect.width,rectData.rect.height);
						if(!actionData.headerData[action]) actionData.headerData[action]=new Object();
						if(!actionData.headerData[action][direction]) 
						{
							actionData.headerData[action][direction]={};
						}
						if(!actionData.headerData[action][direction]["data"])
						{
							actionData.headerData[action][direction]["data"]=[];
						}
						actionData.headerData[action][direction]["data"][rectData.frameIndex]=frameData;
					}
				}
			}
			return actionData;
		}
		
		
		public static function  createyf2DHead(actionData:YF2dActionData):ByteArray
		{
			var bytes:ByteArray=new ByteArray();
			bytes.writeObject(actionData.headerData);
			return bytes;
		}
		
		

//		public static function  createGPUPBytes(actionData:GPUActionData):ByteArray
//		{
//			
//			var bytes:ByteArray=createHead(actionData);
//		
//			//// 分解  
//			var len:int=actionData.bitmapDataArr.length;
//			
//			for(var i:int=0;i!=len;++i)
//			{
//				var raCoder:JPGEncoder=new JPGEncoder();
//				var rbgCoder:JPGEncoder=new JPGEncoder();
//				var arr:Vector.<BitmapData>=ImageAlphaUtil.spliteAlphaData(actionData.bitmapDataArr[i]);
//				var rbg:ByteArray=rbgCoder.encode(arr[0]);
//				var ra:ByteArray=raCoder.encode(arr[1]);
//				
//				writeBytes(bytes,rbg);
//				writeBytes(bytes,ra);
//			}
//			bytes.compress();
//			return bytes;
//		}
		
		
		
	private static function writeBytes(mainBytes:ByteArray,writed:ByteArray):void
	{
		var len:int=writed.length;
		mainBytes.writeInt(len);
		mainBytes.writeBytes(writed);
	}
		
	
//	public static function  createSSWFeader(actionData:GPUActionData):ByteArray
//	{
//		var bytes:ByteArray=createHead(actionData);
//		bytes.compress();
//		return bytes;
//	}
//	
//	
//	private static function createHead(actionData:GPUActionData):ByteArray
//	{
//		var totalbytes:ByteArray=new ByteArray();
//		totalbytes.writeByte(actionData.dataType);
//		var headStr:String=utils.json.JSON.encode(actionData.headerData);
//		totalbytes.writeUTF(headStr);
//		for each (var action :int in actionData.headerData["action"])
//		{
//			for each (var direction:int in actionData.headerData[action]["direction"])
//			{
//				for each (var frameData:FrameData in actionData.dataDict[action][direction])
//				{
//					writeFrameDa(totalbytes,frameData);
//				}
//			}
//		}
//		return totalbytes;
//	}
	
//	private static function writeFrameDa(total:ByteArray,frameData:FrameData):void
//	{
//		var bytes:ByteArray=new ByteArray();
//		bytes.writeInt(frameData.x);
//		bytes.writeInt(frameData.y);
//		bytes.writeInt(frameData.delay);
//		//bytes.writeInt(frameData.frameIndex);
//		bytes.writeInt(frameData.rect.x);
//		bytes.writeInt(frameData.rect.y);
//		bytes.writeInt(frameData.rect.width)
//		bytes.writeInt(frameData.rect.height);
//		
//		total.writeInt(bytes.length);
//		total.writeBytes(bytes);
//	}
	
	
		
	}
}