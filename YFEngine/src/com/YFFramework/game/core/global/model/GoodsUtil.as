package com.YFFramework.game.core.global.model
{
	/**物品所在位置
	 * @author yefeng
	 *2012-7-28上午9:26:54
	 */
	public class GoodsUtil
	{
		
		////position  物品位置  
		/**在背包
		 */
		public static const Positon_Backpack:int=1;
		/**在仓库
		 */
		public static const  Position_Storage:int=2;
		/**在人物身上
		 */
		public static const  Position_Body:int=3; 
		
		
		////物品分类 
		
			
		/**普通物品   也就是其他物品
		 */		
		public static const   Big_Category_Goods:int=1;
		/**装备物品   小类在EquipCategory类里面
		 */		
		public static const  Big_Category_Equip:int=2;
		/**
		 * 药水  等 可直接使用的物品      将可直接使用的消耗性物品 归结为 药品 
		 */
		public static const Big_Category_Medicine:int=3;
		
		/** 宝石   不可直接使用
		 */
		public static const Big_Category_Stone:int=4;
		
		
		
		/////////////////小类
		
		///////////// 药品小类  
		
		/**  加血药剂
		 */		
		public static const Small_Category_Medicine_Blood:int=1;
		/**加魔法药剂
		 */
		public static const SmallCategory_Mdedicine_Magic:int=2;
		/**  经验 
		 */		
		public static const SmallCategory_Medicine_Exp:int=3;
		
		//// 装备小类 在 EquipCategory里面 
		
		/////宝石小类      战斗    防御   伤害     经验    四种 宝石种类
		
		//// 有  初级   中级    以及高级        可以将其归结为 等级  或者品质 都可以   宝石 等级 归结为品质       
		/**战斗力宝石
		 */		
		public static const SmallCategory_Stone_Fight:int=1;
		
		/**防御力宝石
		 */		
		public static const SmallCategory_Stone_Defence:int=2;
		/** 伤害宝石
		 */
		public static const SmallCategory_Stone_Damage:int=3;
		/**加经验宝石
		 */		
		public static const SmallCategory_Stone_Exp:int=4;
		
		
		//////  装备品质等级   分为     白品   1     良品  2    上品  3   精品 4      - 5 极品暂无 
		
		
		
		
		
		
		
		
		
		///////////////钱币类型
		/**金币
		 */
		public static const  Money_Gold:int=1;
		/**元宝
		 */
		public static const  Money_YuanBao:int=2;
		
		

		
		
		
		
		
		public function GoodsUtil()
		{
		}
	}
}