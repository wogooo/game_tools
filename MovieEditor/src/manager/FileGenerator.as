package manager
{
	import flash.utils.ByteArray;
	
	import utils.RawCompress;

	/** 文件创建
	 *  @author yefeng
	 *   @time:2012-4-5下午05:02:42
	 */
	public class FileGenerator
	{
		private static var _instance:FileGenerator;
		public function FileGenerator()
		{
		}
		public static function get Instance():FileGenerator
		{
			if(!_instance)_instance=new FileGenerator();
			return _instance;
		}
		
		public function  createData(actionData:ActionData,rgbQuality:int=60,raQuality:int=60,bgColor:uint=0xFFFFFF):ByteArray		
		{
			var data:ByteArray=new ByteArray();
		//	var  headerUTF:String=utils.json.JSON.encode(actionData.headerData);
		//	data.writeUTF(headerUTF);
			data.writeObject(actionData.headerData);//写入投文件
			var imageBytes:ByteArray;
		//	var imageArrLen:int;
			////动作
			for each (var action :int in actionData.headerData["action"] )
			{
				///方向 
				for each(var direction :int in actionData.headerData[action]["direction"])
				{
					for each (var bitmapDataEx:BitmapDataEx in actionData.dataDict[action][direction])
					{
						imageBytes=RawCompress.Instance.compressEx(bitmapDataEx,rgbQuality,raQuality,bgColor);
						data.writeInt(imageBytes.length);
						data.writeBytes(imageBytes);
					}
				}
			} 
			
			data.compress();
			return data;			
		}
		
		public function analyze(data:ByteArray):Object
		{
			data.uncompress();
		//	var headerUTF:String=data.readUTF();
		//	var headerData:Object=Object(utils.json.JSON.decode(headerUTF));
			var headerData:Object=data.readObject();
			var imageArrLen:int;
			var i:int=0;
			var imageLen:int;//图片的字节长度 
			var imageBytes:ByteArray;
			var imageData:Object;
			var imageObject:Object={}; 
			imageObject.headerData=headerData;
			imageObject.dataArr=new Vector.<Object>();
			////动作
			for each (var action :int in headerData["action"] )
			{
				///方向 
				for each(var direction :int in headerData[action]["direction"])
				{
					imageArrLen=headerData[action][direction]["len"];
					for(i=0;i!=imageArrLen;++i)
					{
						imageBytes=new ByteArray();
						imageLen=data.readInt();
						data.readBytes(imageBytes,0,imageLen);
						imageData=RawCompress.Instance.unCompressEx(imageBytes);
						imageData.action=action;
						imageData.direction=direction;
/// imageData {x:x,y:y,delay:delay,frameIndex:frameIndex,action:action,direction:direction,data:Vector.<ByteArray>([rbgData,raData])};
						imageObject.dataArr.push(imageData); 
					}
				}
			}
			return imageObject;
		}
		
		
		
		
		
		
	
		
	}
}