package com.YFFramework.game.core.module.mapScence.model.fight
{
	import com.YFFramework.core.world.movie.player.PlayerView;

	/**
	 * 被攻击者的具体信息
	 * 2012-9-5 上午9:34:14
	 *@author yefeng
	 */
	public class UAtkInfo
	{
		/**被攻击的对象
		 */ 
		public var player:PlayerView;
		
		/**伤害掉落的血量
		 */ 
		public var hp:int;
		
		/**血量百分比
		 */ 
		public  var hpPercent:Number;
		public function UAtkInfo()
		{
		}
	}
}