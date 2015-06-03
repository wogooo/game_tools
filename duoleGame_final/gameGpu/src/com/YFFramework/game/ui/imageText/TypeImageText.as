package com.YFFramework.game.ui.imageText
{
	/**
	 *  文字类型
	 * 2012-10-9 上午11:33:25
	 *@author yefeng
	 */
	public class TypeImageText
	{
		
		/**怪物 类型
		 */
		public static const Monster:int=1111;
		/**角色类型
		 */
		public static const Role:int=1112;
		
		
		//////////////// 数字
		/**怪物受伤字体 123456789
		 */
		public static const Num_MonsterHurt:int=1;
		
		/**  怪物扣血的减号
		 */		
		public static const Num_MonsterMinus:int=2;

		/** 加魔数字
		 */
		public static const Num_Add_MP:int=3;
		/**加魔数字的加号
		 */		
		public static const Num_Add_MP_plus:int=4;		
		/**扣蓝减号
		 */		
		public static const Num_Add_MP_Minus:int=5;		

		/**加血数字 吃血瓶 加血数字
		 */		
		public static const Num_Add_Hp:int=6;
		/**加血数字的加号
		 */		
		public static const Num_Add_Hp_Plus:int=7;

		/**人物扣血数字
		 */		
		public static const Num_RoleHurt:int=8;
		/**人物扣血减号
		 */		
		public static const Num_RoleHurt_Minus:int=9;

		
		public static const ACTIVITY_NUM_BIG:int=10;
		
//		public static const Num_Yellow_4:int=6;
		
//		public static const Num_Blue:int=7;
		/**战斗力文字
		 */		
		public static const Num_power:int=11;
		
		
		/**怪物暴击 
		 */		
		public static const Monster_Crit:int=12;
		/** 怪物miss 
		 */		
		public static const Monster_Miss:int=13;
		/**角色暴击
		 */
		public static const Role_Crit:int=14;
		/**  角色miss
		 */		
		public static const Role_Miss:int=15;
		
		/** (显示在舞台中下)战斗力加号 */		
		public static const Power_Plus:int=16;
		/** (显示在舞台中下)战斗力减号 */		
		public static const Power_Minus:int=17;
		/** (显示在舞台中下)战斗力大数字 */		
		public static const Power_Big_Num:int=18;
		/** (显示在舞台中下)战斗力减少红色小数字 */		
		public static const Power_Red_Num:int=19;
		/** (显示在舞台中下)战斗力增加绿色小数字 */		
		public static const Power_Green_Num:int=20;
		
		/////////////////////////// 文字
		
		/**经验
		 */		
		public static const Text_Exp:int=91;
		/**
		 *攻击      绿色 表示攻击增加
		 */		
		public static const Text_Atk_Add:int=92;
		/**攻击      红色 表示攻击减少
		 */		
		public static const Text_Atk_Mul:int=93;

		/** 防御  绿色 表示防御增加
		 */		
		public static const Text_Defense_Add:int=94;
		
		/** 防御  红色 表示防御减少 minus
		 */		
		public static const Text_Defense_Mul:int=95;
		/** 生命值 绿色 表示生命值增加
		 */
		public static const Text_Hp_Add:int=96;
		/** 生命值 红色 表示生命值减少
		 */
		public static const Text_Hp_Mul:int=97;
		/** 战斗力文字（舞台中下方的）
		 */		
		public static const Text_Power:int=98;
	

	}
}