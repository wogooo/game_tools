package com.YFFramework.game.core.module.mapScence.model.fight
{
	import com.YFFramework.game.core.module.mapScence.world.view.player.PlayerView;

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
		public var changeHp:int;
		
		/**改变的魔法
		 */		
		public var changeMP:int;
		/**  dyId当前血量
		 */
		public var hp:int;
		/**当前魔法
		 */		
		public var mp:int;
		/** 伤害类型
		 */		 
		public var  damageType:int; // 伤害类型，1:扣血，2:加血，3:闪避，4:暴击			DamageType
		
		/** buffId 
		 */		
	//	public var buffId:int;
		
		
		/**终点位置  只对击退有用
		 */		
		public var endX:int;
		/**终点位置  只对击退有用
		 */	
		public var endY:int;
		
		/**是否 有击退 
		 */
		public var hasBeatBack:Boolean=false;
		
		
		public function UAtkInfo()
		{
		}
	}
}