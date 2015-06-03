package com.YFFramework.game.core.module.trade.model
{
	/**
	 * @version 1.0.0
	 * creation time：2013-5-3 上午10:28:14
	 * 锁定物品DyVo
	 */
	public class LockItemDyVo{
		
		public var templateId:int;
		public var dyId:int;
		public var quantity:int;
		public var pos:int;
		public var url:String;
		public var type:int;	//道具类别：1.装备；2.道具
		
		public function LockItemDyVo(){
		}
	}
} 