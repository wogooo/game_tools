package com.YFFramework.core.utils.net
{
	import flash.utils.Dictionary;

	/**@author yefeng
	 * 2013 2013-11-14 下午1:58:56 
	 */
	public class SourceCacheArray
	{
		
		private var _loadQueen:Vector.<SourceCacheQueenData>;
		private var _queenSize:int;
		
		
		public var _dict:Dictionary;
		public function SourceCacheArray()
		{
			_loadQueen=new Vector.<SourceCacheQueenData>();
			_queenSize=0;
			
			_dict=new Dictionary();
		}
		
		public function add(sourceCacheQueenData:SourceCacheQueenData):void
		{
			if(!_dict[sourceCacheQueenData.url])
			
			
			_loadQueen.unshift(sourceCacheQueenData);
			_queenSize++;
		}
		public function pop():SourceCacheQueenData
		{
			_queenSize--;
			return _loadQueen.pop()
		}
		public function getSize():int
		{
			return _queenSize;
		}
	}
}