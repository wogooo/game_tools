package com.YFFramework.game.core.module.exchange.manager
{
	/***
	 *兑换数据管理类
	 *@author ludingchang 时间：2013-8-17 下午3:27:43
	 */
	public class ExchangeManager
	{
		private static var _inst:ExchangeManager;
		public static function get Instence():ExchangeManager
		{
			return _inst||=new ExchangeManager;
		}
		public function ExchangeManager()
		{
		}
	}
}