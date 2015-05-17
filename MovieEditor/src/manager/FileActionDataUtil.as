package manager
{
	import com.YFFramework.air.FileUtil;
	import com.YFFramework.core.debug.print;
	import com.YFFramework.core.event.YFEventCenter;
	import com.YFFramework.core.net.loader.image_swf.BytesLoader;
	import com.YFFramework.core.utils.image.advanced.encoder.PNGEncoder;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.filesystem.File;
	import flash.system.ApplicationDomain;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	
	import type.TypeFile;

	/**2012-11-19 下午7:13:01
	 *@author yefeng
	 */
	public class FileActionDataUtil
	{
		public static const ActionDataComplete:String="ActionDataComplete";
		private static  var _dict:Dictionary=new Dictionary();
		public function FileActionDataUtil()
		{
		}
		
		private static function getActionLen(actionData:ActionData):int
		{
			var len:int=0;
			for each (var action:int in actionData.getActionArr())
			{
				for each (var direction:int in actionData.getDirectionArr(action))
				{
					len +=actionData.getDirectionLen(action,direction);
				}
			}
			return len;
		}
		
		/** 创建 ActionData文件
		 */		
		public static function createActionData(actionData:ActionData,dir:File,fileName:String):void
		{
			var header:Object=actionData.headerData;
			//防止修改原数据 
			var tempBytes:ByteArray=new ByteArray();
			tempBytes.writeObject(header);
			tempBytes.position=0;
			header=tempBytes.readObject();
			var encoder:PNGEncoder=new PNGEncoder();
			
			var imageData:ByteArray;
			var bitmapDataExByte:ByteArray;
			var totalBytes:ByteArray=new ByteArray();
			var index:int; 
			
			
			
			for each (var action:int in actionData.headerData["action"])
			{
				for each (var direction :int in actionData.headerData[action]["direction"])
				{
					index=0;
					for each (var bitmapDataEx:BitmapDataEx in actionData.dataDict[action][direction])
					{
						
						var dataEx:BitmapDataExData=new BitmapDataExData();
						dataEx.x=bitmapDataEx.x;
						dataEx.y=bitmapDataEx.y;
						dataEx.delay=bitmapDataEx.delay;
						bitmapDataEx.frameIndex=index;
						//		dataEx.frameIndex=bitmapDataEx.frameIndex;
						if(!header[action][direction])
						{
							header[action][direction]={};
						}
						if(!header[action][direction]["data"]) header[action][direction]["data"]=[];
						
						header[action][direction]["data"].push(dataEx);
						///开始导出图片
						imageData=encoder.encode(bitmapDataEx.bitmapData);
						totalBytes.writeInt(imageData.length);
						totalBytes.writeBytes(imageData);
						
						index++;
					}
				}
			}
			
			var headerBytes:ByteArray=new ByteArray();
			headerBytes.writeObject(header);
			
			var actionBytes:ByteArray=new ByteArray();
			actionBytes.writeInt(headerBytes.length);
			actionBytes.writeBytes(headerBytes);
			actionBytes.writeBytes(totalBytes);
			actionBytes.compress();
			FileUtil.createFileByByteArray(dir,fileName,actionBytes);	
		}
		
		/**@param actionBytes 解析actionBytes 
		 * flag 为标志
		 */		
		public static function analysseActionData(actionBytes:ByteArray,flag:Object):void
		{
			actionBytes.uncompress();
			var headerBytes:ByteArray=new ByteArray();
			var imageBytes:ByteArray=new ByteArray();
			var len:int=actionBytes.readInt();
			actionBytes.readBytes(headerBytes,0,len);
			actionBytes.readBytes(imageBytes,0,actionBytes.bytesAvailable);
			var headerData:Object=headerBytes.readObject();
			var actionData:ActionData=new ActionData();
			actionData.headerData=headerData;
			var imageLen:int=getActionLen(actionData);
			
			_dict[actionData]={len:imageLen,index:0,flag:flag}
			var bitmapBytes:ByteArray;	
			var bitmapDataEx:BitmapDataEx;
			var index:int;
			var domain:ApplicationDomain=new ApplicationDomain();
			for each (var action:int in headerData["action"])
			{
				actionData.dataDict[action]=new Dictionary();

				for each (var direction :int in headerData[action]["direction"])
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
						
						bitmapBytes=new ByteArray();
						var bytesLen:int=imageBytes.readInt();
						imageBytes.readBytes(bitmapBytes,0,bytesLen);
						
						
						var loader:BytesLoader=new BytesLoader();
						loader.loadCompleteCalback=complete;
						loader.setData({bitmapDataEx:bitmapDataEx,actionData:actionData});
						loader.load(bitmapBytes,domain);
						actionData.dataDict[action][direction].push(bitmapDataEx);
						index++;
					}
					
					actionData.headerData[action][direction]["data"]=null;
					delete actionData.headerData[action][direction]["data"];
				}
			}
			
		}
		
		private static  function complete(loader:BytesLoader,domain:ApplicationDomain):void
		{
			var bitmapData:BitmapData=Bitmap(loader.content).bitmapData;
			var bitmapDataEx:BitmapDataEx=BitmapDataEx(loader.getData().bitmapDataEx);
			bitmapDataEx.bitmapData=bitmapData;
			
			var actionData:ActionData=ActionData(loader.getData().actionData);
			_dict[actionData].index++;
//			print("测试长度:",_dict[actionData].index,_dict[actionData].len);
			if(_dict[actionData].index==_dict[actionData].len)
			{
				YFEventCenter.Instance.dispatchEventWith(ActionDataComplete,{actionData:actionData,flag:_dict[actionData].flag});
				delete _dict[actionData];

			}
		}
	}
}