package com.YFFramework.game.core.module.skill.model
{
	/**自动拖放技能的数据
	 * @author yefeng
	 * 2013 2013-7-27 下午3:58:02 
	 */
	public class AutoPutSkillVo
	{
		/**要拖到的格子位置
		 */		
		public var key_id:int;
		/**该格子在UILayer下的坐标
		 */		
		public var x:Number;
		/**该格子在UILayer下的坐标
		 */	
		public var y:Number;
		public function AutoPutSkillVo()
		{
		}
	}
}