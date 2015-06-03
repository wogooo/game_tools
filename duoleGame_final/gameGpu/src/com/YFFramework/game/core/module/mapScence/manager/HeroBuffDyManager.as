package com.YFFramework.game.core.module.mapScence.manager
{
	/**管理  主角的buff
	 * @author yefeng
	 * 2013 2013-12-31 下午2:27:06 
	 */
	public class HeroBuffDyManager extends BuffDyManager
	{
		private static var _heroBuffDyManager:HeroBuffDyManager;
		public function HeroBuffDyManager()
		{
			super();
		}
		public static function get Instance():HeroBuffDyManager
		{
			if(_heroBuffDyManager==null)_heroBuffDyManager=new HeroBuffDyManager();
			return _heroBuffDyManager;
		}
	}
}