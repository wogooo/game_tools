package com.YFFramework.core.world.model.type
{
	import com.YFFramework.core.world.model.MonsterDyVo;

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
	//	public static const BigCategory_Hero:int=3;
		/**宠物类型
		 */ 
		public static const BigCategory_Pet:int=4;
		
		/** npc 类型
		 */		
		public static const BigCategory_NPC:int=5;
		
		/**物品掉落
		 */ 
		public static const BigCategory_GropGoods:int=6;
		
		/**传送点
		 */		
		public static const BigCategory_SkipWay:int=7;
		
		/**怪物区域点 
		 */ 
		public static const BigCategory_MonsterZone:int=8;
		
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

		/** 人物站立 行走  战斗等状态
		 */
		public static const  State_Normal:int=1;
		/**人物打坐
		 */
		public static const  State_Sit:int=2;
		
		/**在坐骑上
		 */
		public static const  State_Mount:int=3;
		
		
		
		
		
		
		
		
		/**全体对象进行攻击 
		 * roleDyVo 对象是否在全体攻击的范围内
		 */ 
		public static  function CanFightAll(roleDyVo:MonsterDyVo):Boolean
		{
			//当对象为 怪物   玩家 或者宠物时  可以进行攻击
			if(roleDyVo.bigCatergory==TypeRole.BigCategory_Player||roleDyVo.bigCatergory==TypeRole.BigCategory_Monster||roleDyVo.bigCatergory==TypeRole.BigCategory_Pet)
			{
				return true;
			}
			return false;
		}
		
		
		
		
		
		
		
		
		public function TypeRole()
		{
		}
	}
}