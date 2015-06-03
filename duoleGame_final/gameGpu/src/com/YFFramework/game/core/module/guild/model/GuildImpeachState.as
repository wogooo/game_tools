package com.YFFramework.game.core.module.guild.model
{
	/***
	 *投票状态枚举类
	 *@author ludingchang 时间：2013-9-9 上午11:14:40
	 */
	public class GuildImpeachState
	{
		/**当前没有弹劾*/
		public static const NoImpeach:int=0;
		/**弹劾发起者*/
		public static const Impeacher:int=1;
		/**有投票权的人*/
		public static const Voter:int=2;
		/**观察者（没有权利或已经对弹劾操作过了，只能查看投票结果）*/
		public static const Reader:int=3;
		
		public function GuildImpeachState()
		{
		}
	}
}