package com.YFFramework.core.utils.net
{
	import flash.geom.Point;

	/**sourceCache队列 数据
	 * @author yefeng
	 * 2013 2013-11-14 上午10:31:43 
	 */
	public class SourceCacheQueenData
	{
		
		private static const MaxPoolSize:int=20;
		
		private static var _pool:Vector.<SourceCacheQueenData>=new Vector.<SourceCacheQueenData>(); 
		private static var _size:int=0;
		
		public var url:String;
//		public var data:Object;
		public var exsitFlag:Object;
		public var pivot:Point;
//		public var dispather:Object;
		public var swfConvert:Boolean;
		/**swf 是否作为链接名存储
		 */
		public var swfLink:Boolean;

		public function SourceCacheQueenData()
		{
		}
		
		public static function getSourceCacheQueenData():SourceCacheQueenData
		{
			if(_size>0)
			{
				--_size;
				return _pool.pop();
			}
			else 
			{
				return new SourceCacheQueenData();
			}
					
		}
		
		public static function toPool(sourceCacheQueenData:SourceCacheQueenData):void
		{
			sourceCacheQueenData.dispose();
			if(_size<MaxPoolSize)
			{
				_pool.push(sourceCacheQueenData);
				_size++;
			}
		}
		
		private function dispose():void
		{
			url=null;
//			data=null;
			exsitFlag=null;
			pivot=null;
//			dispather=null;
		}
	}
}