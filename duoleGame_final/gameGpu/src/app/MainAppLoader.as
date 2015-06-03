package app
{
	/**@author yefeng
	 * 2013 2013-8-31 下午1:52:54 
	 */
	import com.YFFramework.core.net.loader.file.FileLoader;
	import com.YFFramework.core.net.loader.image_swf.UILoader;
	
	import flash.utils.ByteArray;
	
	public class MainAppLoader extends UILoader
	{
		public function MainAppLoader()
		{
			super();
		}
		override protected function fileLoadCallBack(fileLoader:FileLoader):void
		{
			var data:ByteArray=fileLoader.data as ByteArray;
			var tmpObj:Object=fileLoader.getTemData();
			_data=tmpObj;
			//			var loader:BytesLoader=new BytesLoader();
			//			loader.loadCompleteCalback=bytesLoadComplete;
			//			loader.load(data,domain);
			
			
			var swfbytes:ByteArray=new ByteArray();
			data.readInt();
			data.readBytes(swfbytes,0,data.bytesAvailable);
			loadBytes(swfbytes,tmpObj);
		}

	}
}