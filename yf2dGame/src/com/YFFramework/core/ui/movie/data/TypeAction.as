package com.YFFramework.core.ui.movie.data
{
	/**@author yefeng
	 *2012-4-22下午2:49:29
	 */
	public class TypeAction
	{
		/**待机
		 */
		public static const Stand:int=1;
		
		/**行走
		 */
		public static const Walk:int=2;
		/**攻击
		 */
		public static const Attack:int=3;
		/** 受伤
		 */
		public static const Injure:int=4;
		/**死亡
		 */
		public static const Dead:int=5;
		/**战斗待机 战斗播放完后的待机
		 */		
		public static const AtkStand:int=6;
		
		public static const SpecialAtk_1:int=7;

		public static const SpecialAtk_2:int=8;
		/** 特殊攻击3
		 */
		public static const SpecialAtk_3:int=9;

		/** 特殊攻击4 
		 */
		public static const SpecialAtk_4:int=10;
		/**打坐
		 */		
		public static const Sit:int=11;

	
		
		/** 坐骑上 待机 
		 */
		public static const MountStand:int=12;
		
		/**坐骑上行走
		 */
		public static const MountWalk:int=13;
		
		/**
		 *坐骑上攻击 
		 */		
		public static const MountAttack:int=14;
		/**坐骑上受伤
		 */
		public static const MountInjure:int=15;
		
		/**坐骑上死亡
		 */
		public static const MountDead:int=16;
		

		public function TypeAction()
		{
		}
	}
}