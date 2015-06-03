package com.YFFramework.game.core.global.model
{
	/** 物品的动态vo (服务器发来的)
	 * @author yefeng
	 *2012-7-28上午9:22:35
	 */
	public class PropsDyVo
	{

		/** 道具 动态id
		 */
		public var propsId:int;
		
		/**道具 静态id 
		 */	
		public var templateId:int;	
		
		/**道具数量
		 */
		public var quantity:int;
		
		/** 绑定性： 绑定1；不绑定2
		 */		
		public var binding_type:int;
		
		/**
		 * 道具获得时间 
		 */
		public var obtain_time:int;
		public function PropsDyVo()
		{
		}
	}
}