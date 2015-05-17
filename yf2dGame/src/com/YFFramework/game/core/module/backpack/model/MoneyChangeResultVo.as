package com.YFFramework.game.core.module.backpack.model
{
	/**钱币数发生改变
	 * 2012-11-16 下午1:52:49
	 *@author yefeng
	 */
	public class MoneyChangeResultVo
	{
		/**  改变的数量
		 */
		public  var change:Number;
		/**当前玩家的钱数
		 */
		public var money:Number;
		/**钱币的类型  值在GoodsUtil.Money_Gold  Money_YuanBao
		 */
		public var type:int;
		public function MoneyChangeResultVo()
		{
		}
	}
}