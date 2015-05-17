package 
{
	import com.YFFramework.core.net.loader.file.FileLoader;
	
	import flash.events.ProgressEvent;
	
	/**
	 * author :夜枫 * 时间 ：2011-9-25 下午02:59:34
	 */
	public final class MoreFileLoader
	{
		/**该函数带有一个FilesLoader类型的参数
		 */		
		public  var loadCompleteCallBack:Function=null;
		/**该函数带有ProgressEvent类型的参数 和一个int型的指示当前正在加载的个数的参数<索引从0开始>
		 */		
		public var progressCallBack:Function=null;
		/**  数据保存数组
		 */
		public var dataArr:Array;
		private var totalLen:int;//数组总长度
		public function MoreFileLoader()
		{
			dataArr=[];
		}
		/** 文件地址   arr里保存的是 Object类型的对象  含有  {url , tips  id}   
		 */
		public function load(arr:Vector.<Object>):void
		{
			totalLen=arr.length;
			var loader:FileLoader;
			for each(var obj:Object in arr)
			{
				loader=new FileLoader();
				loader.loadCompleteCallBack=onLoadFinish;
//				loader.progressCallBack=onProgress;
				loader.load(obj.url,obj);
			}
		}
//		private function onProgress(e:ProgressEvent,data:Object):void
//		{
//			if(progressCallBack!=null)
//			{
//				progressCallBack(e,data);
//			}
//		}
	
		private function onLoadFinish(loader:FileLoader):void
		{
			var data:Object=loader.data;
			var tempData:Object=loader.getTemData();
			dataArr.push({id:tempData.id,data:data});
			if(dataArr.length==totalLen)
			{
				if(loadCompleteCallBack!=null)loadCompleteCallBack(this);
			}
		}

		public function dispose():void
		{
			dataArr=null;
		}
		
	}
}