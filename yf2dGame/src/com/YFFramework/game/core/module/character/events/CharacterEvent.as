package com.YFFramework.game.core.module.character.events
{
	/**人物模块 事件
	 * 2012-8-23 下午3:52:45
	 *@author yefeng
	 */
	public class CharacterEvent
	{
		private static const Path:String="com.YFFramework.game.core.module.character.events.";
		/**客户端请求脱下装备
		 */		
		public static const C_PutOffEquip:String=Path+"C_PutOffEquip";
		/**服务端返回  脱下装备
		 */		
		public static const S_PutOffEquip:String=Path+"S_PutOffEquip";
		public function CharacterEvent()
		{
		}
	}
}