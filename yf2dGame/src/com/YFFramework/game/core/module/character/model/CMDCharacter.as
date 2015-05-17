package com.YFFramework.game.core.module.character.model
{
	
///	人物面板模块 300--399

	/**2012-8-23 下午3:59:49
	 *@author yefeng
	 */
	public class CMDCharacter
	{
		/**客户端请求 脱下装备
		 */		
		public static const C_PutOffEquip:int= 300;
		/** 服务端返回脱下装备
		 */
		public static const S_PutOffEquip:int=300;
		/**请求装备列表
		 */		
		public static const C_RequestCharacterList:int=301;
		/**请求装备列表
		 */	
		public static const S_RequestCharacterList:int=301;
		
		public function CMDCharacter()
		{
		}
	}
}