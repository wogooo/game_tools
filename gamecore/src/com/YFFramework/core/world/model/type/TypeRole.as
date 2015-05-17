package com.YFFramework.core.world.model.type
{
	/**
	 *   角色类型  所有的类型都在这个类里面
	 * @author yefeng
	 *2012-4-28下午11:45:31
	 */
	public class TypeRole
	{
		
		///  角色 大类
		/**  玩家类型
		 */
		public static const BigCategory_Player:int=1;
		/**   怪物类型
		 */
		public static const BigCategory_Monster:int=2;
		
		/**当前玩家
		 */
		public static const BigCategory_Hero:int=3;
		
		
		///性别
		/**  男性
		 */		
		public static const Sex_Man:int=1;
		
		/**  女性
		 */
		public static const Sex_Woman:int=2;
		
		
		
		
		/**角色 1 
		 */
		public static const Career_1:int=1; 
		/**角色 2 
		 */
		public static const Career_2:int=2; 
		/**角色 3
		 */
		public static const Career_3:int=3; 
		/**角色 4
		 */
		public static const Career_4:int=4; 

		
		
		public function TypeRole()
		{
		}
	}
}