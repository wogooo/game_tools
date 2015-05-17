package manager
{
	import com.YFFramework.air.FileUtil;
	import com.YFFramework.core.utils.image.advanced.encoder.PNGEncoder;
	
	import flash.display.BitmapData;
	import flash.filesystem.File;
	import flash.system.ApplicationDomain;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	
	import type.TypeFile;
	

	/**
	 * 导出无损图片给flash
	 * @author yefeng
	 *20122012-4-10下午10:14:54
	 */
	public class ExportPngManager
	{
		//图片的前缀名   中间以下划线分开   XW_1_2_003.png这样的
	//	private static const Pre:String="XW_";
		public function ExportPngManager()
		{
		}
		/**  头部加了东西
		 * header[action][direction]) header[action][direction]
		 */		
		public static  function  doExport(dir:File,actionData:ActionData,fileName:String):void
		{
			var header:Object=actionData.headerData;
			//防止修改原数据 
		//	var str:String=utils.json.JSON.encode(header);
		//	header=utils.json.JSON.decode(str) as Object
			
			// readObject writeObject 只能 读 和写 Object类型的数据 
			var tempBytes:ByteArray=new ByteArray();
			tempBytes.writeObject(header);
			tempBytes.position=0;
			header=tempBytes.readObject();

			var encoder:PNGEncoder=new PNGEncoder();
			
			var index:int;
			var imageData:ByteArray;
			
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
				//		dataEx.frameIndex=bitmapDataEx.frameIndex;
						if(!header[action][direction])
						{
							header[action][direction]={};
						}
						if(!header[action][direction]["data"]) header[action][direction]["data"]=[];

						header[action][direction]["data"].push(dataEx);

						
						///开始导出图片
						var name:String=action+"_"+direction+"_"+getIndexStr(index);
						imageData=encoder.encode(bitmapDataEx.bitmapData);
					
						FileUtil.createFileByByteArray(dir,fileName+"/"+name+".png",imageData);
						index++;
					}
				}
			}
			
		//	 var headerStr:String=utils.json.JSON.encode(header);
			 var headerBytes:ByteArray=new ByteArray();
		//	 headerBytes.writeUTF(headerStr);
			 headerBytes.writeObject(header);
			 FileUtil.createFileByByteArray(dir,fileName+TypeFile.HeadExtention,headerBytes);
		}
	
		private static  function getIndexStr(index:int):String
		{
			var str:String=String(index);
			var len:int=4;
			var dif:int=len-str.length;
			if(dif>0)
			{
				for(var i:int=0;i!=dif;++i)
				{
					str="0"+str;
				}
			}
			return str;			
			
		}
	}
}