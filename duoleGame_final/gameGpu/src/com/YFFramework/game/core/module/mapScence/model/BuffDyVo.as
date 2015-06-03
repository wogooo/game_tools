package com.YFFramework.game.core.module.mapScence.model
{
	/**@author yefeng
	 * 2013 2013-12-31 下午2:07:35 
	 * 
	 * 人物 buff的产生 是由  SFight 协议 以及 SHeroUseItemNotify 产生 
	 *  
	 * 宠物 buff的产生 是由  SFight 协议 以及 SPetUseItemNotify 产生
	 */
	public class BuffDyVo
	{
		
		/**产生buff 的技能id 
		 */
		public var skill_id:int;
		/** 技能等级   加血技能等级默认为 1 级
		 */
		public var skill_level:int;
		
		/** buff_ id 
		 */
		public var buff_id:int;
		
		/**产生buff时的时间==getTimer()   产生 buff的时间戳
		 */
		public var time:Number;
		public function BuffDyVo()
		{
		}
	}
}