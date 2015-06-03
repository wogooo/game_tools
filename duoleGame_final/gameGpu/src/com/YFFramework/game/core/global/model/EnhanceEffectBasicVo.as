package com.YFFramework.game.core.global.model
{
	public class EnhanceEffectBasicVo
	{

		/**部位   1  是武器  2 是衣服    具体类型在EquipCategory里面
		 */
		public var part_type:int;

		public var priest:int;
		public var sex:int;
		public var master:int;
		
		public var warrior:int;
		public var hunter:int;
		public var bravo:int;
		/**强化等级
		 */
		public var enhance_level:int;

		public function EnhanceEffectBasicVo()
		{
		}
	}
}