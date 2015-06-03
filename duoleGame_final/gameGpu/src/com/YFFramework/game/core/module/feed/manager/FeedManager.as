package com.YFFramework.game.core.module.feed.manager
{
	import com.YFFramework.core.event.YFEventCenter;
	import com.YFFramework.game.core.module.feed.event.FeedEvent;
	import com.YFFramework.game.core.module.feed.model.FeedBasicVo;
	import com.YFFramework.game.core.module.feed.model.TypeFeed;

	/***
	 *feed分享管理类
	 *@author ludingchang 时间：2013-12-4 下午2:18:41
	 */
	public class FeedManager
	{
		private static var _inst:FeedManager;
		public static function get Instence():FeedManager
		{
			return _inst||=new FeedManager;
		}
		public function FeedManager()
		{
			globle_data=0;
			_temp_data=0;
		}
		
		/**全局数据，只分享一次的用这个*/
		public var globle_data:int;
		/**临时数据，单次登录分享一次的用这个*/
		private var _temp_data:uint;
		
		public function shouldShow(id:int):Boolean
		{
			var vo:FeedBasicVo=FeedBasicVoManager.Instence().getFeedBasicVo(id);
			if(vo.type==TypeFeed.OneTime)//单次
			{
				return !(globle_data&(1<<id));
			}
			else if(vo.type==TypeFeed.MoreTime)//多次
			{
				return !(_temp_data&(1<<id));
			}
			return false;
		}
		public function show(id:int):void
		{
			var vo:FeedBasicVo=FeedBasicVoManager.Instence().getFeedBasicVo(id);
			if(vo.type==TypeFeed.OneTime)//单次
			{
				globle_data=setData(globle_data,vo.id,true);
				YFEventCenter.Instance.dispatchEventWith(FeedEvent.SaveFeedID,globle_data);//保存到服务器
			}
			else if(vo.type==TypeFeed.MoreTime)//多次
			{
				_temp_data=setData(_temp_data,vo.id,true);
			}
		}
		private function setData(source:uint,pos:int,value:Boolean):uint
		{
			if(value)
				source |= (1<<pos);
			else
				source &= (~(1<<pos));
			return source;
		}
	}
}