package manager.UV
{
	import com.YFFramework.air.FileUtil;
	import com.YFFramework.core.debug.print;
	import com.YFFramework.core.event.YFEventCenter;
	import com.YFFramework.core.net.loader.image_swf.BytesLoader;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.filesystem.File;
	import flash.geom.Matrix;
	import flash.system.ApplicationDomain;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	import flash.utils.Endian;
	
	import manager.ActionData;
	import manager.BitmapDataEx;

	/**生成  .yf文件
	 */
	public class YFDataManager
	{
		
		/**数据解析完触发
		 */
		public static const YFDataComplete:String="manager.UV.YFDataComplete";
		private static  var _dict:Dictionary=new Dictionary();

		public function YFDataManager()
		{
		}
		
		public static function createFile(imageTotalBytes:ByteArray,headBytes:ByteArray,fileDir:File,fileName:String):void
		{
			var myBytes:ByteArray=new ByteArray();
			myBytes.endian=Endian.LITTLE_ENDIAN; ///for C++
			var headLen:int=headBytes.length;
			myBytes.writeInt(headLen);
			myBytes.writeBytes(headBytes);
			myBytes.writeBytes(imageTotalBytes);
			myBytes.compress();
			FileUtil.createFileByByteArray(fileDir,fileName,myBytes);
		}
		
		
		
		
		
		
		/**@param actionBytes 解析actionBytes 
		 * flag 为标志
		 */		
		public static function analysseActionData(actionBytes:ByteArray,flag:Object):void
		{
			actionBytes.uncompress();
			actionBytes.endian=Endian.LITTLE_ENDIAN;
			var headerBytes:ByteArray=new ByteArray();
			headerBytes.endian=Endian.LITTLE_ENDIAN;
			var imageBytes:ByteArray=new ByteArray();
			imageBytes.endian=Endian.LITTLE_ENDIAN;
			var len:int=actionBytes.readInt();
			actionBytes.readBytes(headerBytes,0,len);
			actionBytes.readBytes(imageBytes,0,actionBytes.bytesAvailable);
			//	var headerData:Object=headerBytes.readObject();
			var headerStr:String=headerBytes.readUTF();
			
			var headerData:Object=JSON.parse(headerStr);
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
						bitmapDataEx.x=bitmapDataExData.x-bitmapDataExData.rect.width*0.5;
						bitmapDataEx.y=bitmapDataExData.y-bitmapDataExData.rect.height*0.5;
						bitmapDataEx.delay=bitmapDataExData.delay;
						bitmapDataEx.frameIndex=index;
						bitmapDataEx.w=bitmapDataExData.rect.width;
						bitmapDataEx.h=bitmapDataExData.rect.height;
						bitmapDataEx.matTx=-bitmapDataExData.rect.x;
						bitmapDataEx.matTy=-bitmapDataExData.rect.y;
						
						actionData.dataDict[action][direction].push(bitmapDataEx);
						index++;
					}
					
					//创建大贴图集合
					bitmapBytes=new ByteArray();
					var bytesLen:int=imageBytes.readInt();
					imageBytes.readBytes(bitmapBytes,0,bytesLen);
					
					var loader:BytesLoader=new BytesLoader();
					loader.loadCompleteCalback=complete;
					loader.setData({action:action,direction:direction,actionData:actionData});
					loader.load(bitmapBytes,domain);

					//删除 不必要的数据
					actionData.headerData[action][direction]["data"]=null;
					delete actionData.headerData[action][direction]["data"];
				}
			}
			
		}
		
		private static  function complete(loader:BytesLoader,domain:ApplicationDomain):void
		{
			var atlas:BitmapData=Bitmap(loader.content).bitmapData;
			
			var data:Object=loader.getData();
			var action:int=data.action;
			var direction:int=data.direction;
			var actionData:ActionData=data.actionData;
			var bitmapData:BitmapData;
			for each(var bitmapDataEx:BitmapDataEx in actionData.dataDict[action][direction])
			{
				bitmapData=new BitmapData(bitmapDataEx.w,bitmapDataEx.h,true,0xFF0000);
				var mat:Matrix=new Matrix();
				mat.tx=bitmapDataEx.matTx;
				mat.ty=bitmapDataEx.matTy;
				bitmapData.draw(atlas,mat);
				bitmapDataEx.bitmapData=bitmapData;
			}
			_dict[actionData].index++;
			atlas.dispose();
//			print("打印:",_dict[actionData].index,_dict[actionData].len);
			if(_dict[actionData].index==_dict[actionData].len)
			{
				YFEventCenter.Instance.dispatchEventWith(YFDataComplete,{actionData:actionData,flag:_dict[actionData].flag});
				delete _dict[actionData];
			}
		}
		
		
		private static function getActionLen(actionData:ActionData):int
		{
			var len:int=0;
			for each (var action:int in actionData.getActionArr())
			{
				for each (var direction:int in actionData.getDirectionArr(action))
				{
					len++;
				}
			}
			return len;
		}
		
	}
}