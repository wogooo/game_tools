package com.YFFramework.core.net.loader.map
{
	import com.YFFramework.core.net.loader.file.FileLoader;
	
	import flash.events.Event;
	import flash.net.URLLoaderDataFormat;
	import flash.utils.ByteArray;

	/**加载 .map文件  .map文件  是 压缩过的 atf文件 
	 *  我们只需要获取   里面的字节数据即可
	 * @author yefeng
	 *2012-11-20下午10:11:38
	 */
	public class MapLoader extends FileLoader
	{
		public function MapLoader()
		{
			super(URLLoaderDataFormat.BINARY);
		}
		///加载  
		override protected function onComplete(e:Event):void
		{
			_data=loader.data;
			////压缩 atf 数据 
			var bytes:ByteArray=_data as ByteArray;
			bytes.uncompress();
			if(loadCompleteCallBack!=null)loadCompleteCallBack(bytes,_tmpData);
			remove();
		}

		
	}
}