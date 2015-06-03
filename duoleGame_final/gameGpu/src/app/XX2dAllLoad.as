package app
{
	import com.YFFramework.core.event.YFEvent;
	import com.YFFramework.core.utils.net.SourceCache;
	import com.YFFramework.game.gameConfig.ConfigManager;

	/**预载所有的地图资源文件
	 * @author yefeng
	 * 2013 2013-9-11 下午6:10:01 
	 */
	public class XX2dAllLoad
	{
		
		/**完成响应
		 */
		public  var completeFunc:Function;
		
		/**当前已经完成的加载个数
		 */
		private var _loadIndex:int;
		/**数组长度 
		 */
		private var _arrLen:int;
		public function XX2dAllLoad()
		{
			
		}
		
		
		/**加载所有的资源
		 */
		public function loadAll():void
		{
			_loadIndex=0;
			var arr:Array=ConfigManager.Instance.getXX2dFiles();
			_arrLen=arr.length;
			var url:String;
			for(var i:int=0;i!=_arrLen;++i)
			{
				url=arr[i];
				SourceCache.Instance.addEventListener(url,onxx2dComplete);
				SourceCache.Instance.forceLoadRes(url);
			}
			if(_arrLen==0)completeFunc();
		}
		private function onxx2dComplete(e:YFEvent):void
		{
			var url:String=e.type;
			SourceCache.Instance.removeEventListener(url,onxx2dComplete);
			_loadIndex++;
			if(_loadIndex==_arrLen)
			{
				completeFunc();
			}
		}
		
	}
}