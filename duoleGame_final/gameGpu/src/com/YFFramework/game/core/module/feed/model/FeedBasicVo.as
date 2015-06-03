package com.YFFramework.game.core.module.feed.model
{
	/***
	 *feed数据类
	 *@author ludingchang 时间：2013-12-4 下午2:47:12
	 */
	public class FeedBasicVo
	{
		
		public var id:int;
		/**标题*/
		public var title:String;
		/**内容*/
		public var content:String;
		/**故事内容*/
		public var story:String;
		/**类型*/
		public var type:int;
		/**图片url*/
		public var img:String;
		public function FeedBasicVo()
		{
		}
	}
}