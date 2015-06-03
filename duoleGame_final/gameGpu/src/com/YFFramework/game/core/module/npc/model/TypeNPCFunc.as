package com.YFFramework.game.core.module.npc.model
{
	/**NPC 功能类型
	 * @author yefeng
	 * 2013 2013-5-2 下午2:02:44 
	 */
	public class TypeNPCFunc
	{
		
		/**  商店NPC
		 */		
		public static const Shop:int=1;
		/**传送NPC 
		 */			
		public static const Transfer:int=2;
		
		/**副本类型
		 */		
		public static const Raid:int=3;
		/**工会类型  打开 公会 界面
		 */		
		public static const Guid:int=4;
		
		/**兑换 ，打开兑换界面
		 */
		public static const Exchange:int=5;
		
		
		//公共显示类型
		/**加入工会标签
		 */		
		public static const Guid_Add:int=1;
		
		/**创建工会标签
		 */		
		public static const Guid_Create:int=2;

		/**进入工会领地类型
		 */		
		public static const Guid_Enter:int=3;

		public function TypeNPCFunc()
		{
		}
	}
}