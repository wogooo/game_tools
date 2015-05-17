package com.YFFramework.game.core.module.mapScence.model.proto
{
	/**
	 * 客户端发送战斗 vo   给服务端口
	 * 2012-8-6 下午3:12:09
	 *@author yefeng
	 */
	public class ClientFightVo
	{
		
		/**攻击者id 
		 */		
		public var atkId:int;
		/**被攻击者id 
		 */		
		public var uAtkId:int;
		
		/**攻击者的播放技能 id   攻击者的技能等级在 服务端有
		 */		
		public var skillDyId:int;
		
		public function ClientFightVo()
		{
		}
		
		
	}
}