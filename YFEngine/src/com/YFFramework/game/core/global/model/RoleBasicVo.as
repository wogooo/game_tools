package com.YFFramework.game.core.global.model
{
	/**数据表 roleBasic.csv 的数据模型
	 * 2012-8-15 下午1:58:21
	 *@author yefeng
	 */
	public class RoleBasicVo
	{
		
		/**职业
		 */		
		public var carrer:int;
		
		/**  性别
		 */
		public var  sex:int;
		/**血量
		 */
		public var hp:int;
		/**物理攻击
		 */		
		public var pAtk:int;
		/** 物理防御
		 */
		public var pDefence:int;
		/**魔法攻击
		 */		
		public var mAtk:int;
		/**魔法防御
		 */		
		public var mDefence:int;
		/**命中率
		 */
		public var hitTarge:int;
		/**闪避 
		 */
		public var dodge:int;

		
		public function RoleBasicVo()
		{
		}
	}
}