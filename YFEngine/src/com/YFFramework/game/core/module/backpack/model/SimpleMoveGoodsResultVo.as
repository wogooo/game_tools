package com.YFFramework.game.core.module.backpack.model
{
	/**服务端返回单一窗口物品拖动的信息vo 
	 * 
	 * @author yefeng
	 *2012-8-18下午11:21:41
	 */
	public class SimpleMoveGoodsResultVo
	{
		
		/**移动物品的动态id 
		 */		
		public var movingDyId:String;
		
		/**移动物品的新格子数
		 */
		public var movingGridNum:int;
		/** 被动移动的 物品动态id   假如 移到的是空格子位置 则下面两个值是不存在的  也就是不进行赋值 
		 */		
		public var toGridDyId:String;
		/** 被动移动物品的新位置
		 */		
		public var toGridGridNum:int;
		public function SimpleMoveGoodsResultVo()
		{
		}
	}
}