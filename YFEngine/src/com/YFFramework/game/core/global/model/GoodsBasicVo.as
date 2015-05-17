package com.YFFramework.game.core.global.model
{
	/**物品
	 * @author yefeng
	 *2012-4-22上午11:22:19
	 */
	public class GoodsBasicVo 
	{
		/** 资源静态 id
		 */		
		public var basicId:int;
		/**资源id  
		 */
		public var resId:int;
		
		/**物品名称
		 */
		public var name:String;
		
		/**物品使用等级
		 */
		public var level:int;
		/** 价格
		 */
		public var price:int;
		/**物品大类
		 */
		public var bigCategory:int;
		/**物品小类  比如  药水  有 加血 药水  还要加魔法 药水   以及 加 不同 buff的药水
		 * 
		 * 
		 *  装备    武器  为一个小类 上衣为一个小类     类型 在EquipCategory
		 */		
		public var smallCategory:int;
		
		public function GoodsBasicVo()
		{
		}
	}
}