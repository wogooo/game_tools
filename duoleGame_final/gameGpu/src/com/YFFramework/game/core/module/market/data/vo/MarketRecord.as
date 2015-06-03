package com.YFFramework.game.core.module.market.data.vo
{
	import com.YFFramework.game.core.global.model.EquipDyVo;
	import com.YFFramework.game.core.global.model.PropsDyVo;
	import com.msg.item.CharacterEquip;
	import com.msg.item.CharacterProps;

	/**
	 * 寄售、求购信息的信息
	 * @version 1.0.0
	 * creation time：2013-6-5 上午11:28:07
	 * 
	 */
	public class MarketRecord
	{
		//======================================================================
		//       public property
		//======================================================================
		
		//======================================================================
		//       private property
		//======================================================================		
		public var recordId:int;
		
		public var equip:EquipDyVo;
		
		public var props:PropsDyVo;
		/** 求购专用字段
		 */		
		public var itemType:int;
		/** 求购专用字段
		 */
		public var itemId:int;
		/** 货币类型：MONEY_DIAMOND=1；MONEY_SILVER=3；(寄售、求购用)
		 */		
		public var moneyType:int;
		/** 单价：寄售、求购用
		 */		
		public var price:int;
		
		/**寄售、求购信息，买家名字 
		 */		
		public var playerName:String;
		
		/** 物品数量：寄售、求购用 
		 */		
		public var number:int
		
		/** 交易记录专用，交易时间
		 */		
		public var saleTime:int;
		
		/** 交易记录专用，交易状态 
		 */		
		public var status:int
		/** 寄售货币的类型（寄售货币专用字段） :如果这里是魔钻，那moneyType就是银币
		 */		
		public var saleMoneyType:int
		//======================================================================
		//        constructor
		//======================================================================
		
		public function MarketRecord()
		{
		}
		
		//======================================================================
		//        public function
		//======================================================================

		//======================================================================
		//        private function
		//======================================================================
		
		//======================================================================
		//        event handler
		//======================================================================
		
		//======================================================================
		//        getter&setter
		//======================================================================
		
		
	}
} 