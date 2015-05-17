package
{
	import com.YFFramework.air.FileUtil;
	import com.YFFramework.core.utils.UtilString;
	
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.utils.ByteArray;
	import flash.utils.getTimer;
	
	import mx.controls.Alert;

	public class DataManager
	{
		public function DataManager()
		{
		}
		
		
		public static function createATFMovie(headerData:Object,atfDir:File,alert:Boolean=false):void
		{
			var bytes:ByteArray=new ByteArray();
			
			var headBytes:ByteArray=new ByteArray();
			headBytes.writeObject(headerData);
			bytes.writeBytes(headBytes,0,headBytes.length);
			
			var direction :int;
			
			var action:int;
			var actionLen:int=headerData["action"].length;
			
			var dataLen:int;//数据长度
			var j:int;
			var fileName:String;
			
			var childFile:File;
			for(var i:int=0;i!=actionLen;++i)
			{
				action=headerData["action"][i];
				for each (direction in headerData[action]["direction"])
				{
//					className=pre+action+"_"+direction;
//					bmpClass=domain.getDefinition(className) as Class;
//					bitmapData=new bmpClass() as BitmapData;
					
					fileName=action+"_"+direction+".atf";
					childFile=File.desktopDirectory;
					childFile.url=atfDir.url+"/"+fileName;
					readATFFile(bytes,childFile);
				}
			}
			
			bytes.compress();
			FileUtil.createFileByByteArray(atfDir.parent,atfDir.name+FileNameExtension.ATFMovie,bytes);
			
			if(alert)
			{
				Alert.show("atfMovie生成OK");
			}
		}
		
		
		/**读取atf 文件
		 */ 
		private static function readATFFile(totalBytes:ByteArray,file:File):void
		{
			var fileName:String=file.name;
			var exactName:String=UtilString.getExactName(file.name);
			var bytes:ByteArray=new ByteArray();
			var stream:FileStream=new FileStream();
			stream.open(file,FileMode.READ);
			stream.readBytes(bytes,0,stream.bytesAvailable);
			stream.close();
			bytes.position=0;
			
			
			totalBytes.writeInt(bytes.length);
			totalBytes.writeBytes(bytes,0,bytes.length);
		}

		
		
		
	}
}