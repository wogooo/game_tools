package com.YFFramework.game.core.module.mapScence.manager
{
	/** 特殊技能控制器
	 * @author yefeng
	 * 2013 2013-9-7 下午2:59:41 
	 */
	public class SpecialSkillManager
	{
		
		/**定身  定身时可以发技能 只是不能移动
		 */
		public static var Dingshen:Boolean=false;
		
		/**晕眩     不能移动 不能发起攻击
		 */
		public static var YunXuan: Boolean=false;
		
		/**不能使用技能
		 */
		public static var ChenMo:Boolean=false;
		public function SpecialSkillManager()
		{
		}
	}
}