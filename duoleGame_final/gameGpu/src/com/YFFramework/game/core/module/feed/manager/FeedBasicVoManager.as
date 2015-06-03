package com.YFFramework.game.core.module.feed.manager
{
	import com.YFFramework.game.core.module.feed.model.FeedBasicVo;
	
	import flash.utils.Dictionary;

	/***
	 *
	 *@author ludingchang 时间：2013-12-4 下午2:49:31
	 */
	public class FeedBasicVoManager
	{
		private static var _inst:FeedBasicVoManager;
		public static function Instence():FeedBasicVoManager
		{
			return _inst||=new FeedBasicVoManager;
		}
		private var _dic:Dictionary;
		public function FeedBasicVoManager()
		{
			_dic=new Dictionary;
		}
		public function cacheData(jsonData:Object):void
		{
			var feedBasicVo:FeedBasicVo;
			for (var id:String in jsonData)
			{
				feedBasicVo=new FeedBasicVo;
				feedBasicVo.id=jsonData[id].id;
				feedBasicVo.content=jsonData[id].content;
				feedBasicVo.story=jsonData[id].story;
				feedBasicVo.title=jsonData[id].title;
				feedBasicVo.type=jsonData[id].type;
				feedBasicVo.img=jsonData[id].img;
				_dic[feedBasicVo.id]=feedBasicVo;
			}
		}
		public function getFeedBasicVo(id:int):FeedBasicVo
		{
			return _dic[id];
		}
	}
}