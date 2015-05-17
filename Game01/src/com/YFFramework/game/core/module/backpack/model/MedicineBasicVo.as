package com.YFFramework.game.core.module.backpack.model
{
	import com.YFFramework.game.core.global.model.GoodsBasicVo;
	
	/** 药品 等消耗性的可使用道具的 静态vo 
	 * 2012-8-21 下午1:47:52
	 *@author yefeng
	 */
	public class MedicineBasicVo extends GoodsBasicVo
	{
		/**冷却时间   单位为毫秒
		 */
		public var coolTime:int;
		public function MedicineBasicVo()
		{
			super();
		}
	}
}