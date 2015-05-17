package com.YFFramework.game.core.global.model
{
	/**  主角的当前状态 
	 * 2012-9-5 上午10:57:19
	 *@author yefeng
	 */
	public class HeroState
	{
		/** 是否处于战斗状态   处于战斗状态人物不能进行移动  只有处于非战斗状态人物才能进行移动  处于锁定状态下
		 */
		public var isLock:Boolean;
		
		/**人物将要做的事情，可能是走到某点，由于该点是在播放技能的过程中产生的  技能播完后 走到该点    也可能是将要对某个对象发起攻击
		 * 类型为  playerView 或者point 
		 */
		public var willDo:Object;

		/**是否中断  当再次单击时 中断 下一次技能
		 */ 
	//	public var isBreak:Boolean;
		public function HeroState()
		{
			isLock=false;
		//	isBreak=false;
		}
		
		
		
		
	}
}