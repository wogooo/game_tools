package com.YFFramework.game.core.module.skill.model
{
	/**设置快捷方式的vo 
	 * @author yefeng
	 * 2013 2013-7-25 上午10:39:11 
	 */
	public class SetQuikBoxVo
	{
		/**快捷键,不在快捷栏为-1
		 */		
		public var fromKeyId:int;

		/**格子内放的是 技能或者道具  值在  SkillModuleType.QuickType_
		 */
		public var boxType:int;
		/**技能或者道具id  //技能是静态id  道具是动态id   propDyVo
		 */		
		public var boxId:int;   

		/**拖入的目标格子
		 */		
		public var target_key_id:int;
		public function SetQuikBoxVo()
		{
		}
	}
}