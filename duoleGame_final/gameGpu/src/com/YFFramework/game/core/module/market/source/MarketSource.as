package com.YFFramework.game.core.module.market.source
{
	/**
	 * @version 1.0.0
	 * creation time：2013-5-28 上午10:05:29
	 * 
	 */
	public class MarketSource
	{
		//======================================================================
		//       public property
		//======================================================================
		public static const LEVEL_ALL:int=1;//全部等级
		public static const LEVEL_ONE:int=2;//1-29
		public static const LEVEL_TWO:int=3;//30-49
		public static const LEVEL_THREE:int=4;//50-69
		
		public static const QUALITY_ALL:int=0;//全部品质
		
		public static const MONEY_ALL:int=0;//全部货币
		
		public static const HOT_SALE1:int=1;
		public static const HOT_SALE2:int=2;
		public static const HOT_SALE3:int=3;
		public static const HOT_SALE4:int=4;
		public static const HOT_SALE5:int=5;
		public static const HOT_SALE6:int=6;
		public static const HOT_SALE7:int=7;
		public static const HOT_SALE8:int=8;
		
		/*********************************************************************/
		
		/** 魔钻子类枚举
		 */		
//		public static const SUB_CLASS_DIAMOND:int=901;
		
		/** 银币子类枚举
		 */		
//		public static const SUB_CLASS_SILVER:int=902;
		
		/*********************************************************************/
		/** 寄售
		 */		
		public static const MARKET_SALE:int=1;
		/** 求购
		 */		
		public static const MARKET_WANT:int=2;
		/** 寄售下架
		 */		
		public static const MARKET_SALE_DOWN:int=3;
		/** 求购下架
		 */		
		public static const MARKET_WANT_DOWN:int=4;
		/** 买入
		 */		
		public static const MARKET_BUY_IN:int=5;
		/** 卖出
		 */		
		public static const MARKET_SALE_OUT:int=6;
		
		/*********************************************************************/
		
		public static const SEND_TO_CHAT_MONEY:int = 100;
		
		/*********************************************************************/
		
		/** 表示寄售类型
		 */		
		public static const CONSIGH:int=1;
		/** 表示求购类型
		 */	
		public static const PURCHASE:int=2;
		/**我的交易记录 
		 */		
		public static const MYLOG:int=3;
		/**筛选物品米那边的icon类型 
		 */		
		public static const SIFT:int=4;		
		
		/*********************************************************************/
		
		/**一行几个图标 
		 */		
		public static const ROW_NUM:int=5;
		/**一页35个 
		 */		
		public static const PAGE_NUM:int=20;
		/**筛选面板图标排列：图标宽40+间距12 
		 */		
		public static const ICON_WIDTH:int=52;
		/**寄售、求购信息item高度 
		 */		
		public static const RECORD_HEIGHT:int=50;
		/**我的交易记录item高度 
		 */		
		public static const MY_RECORD_HEIGHT:int=51;
		
		/*****************************************************************/
		
		/**判断背包是否进入寄售模式 
		 */		
		public static var ConsignmentStatus:Boolean;
		
		/*****************************************************************/
		
		/**当前锁定的位置 ;注意：如果寄售成功，则把当前值设为0
		 */		
		public static var curLockPos:int;
		/**上个被锁定物品的位置; 如果和这次的不同，就把上次的解锁 
		 */		
		public static var lastLockPos:int;
		
		/******************************************************************/
		
		public static var MY_TOTAL_ITEMS:int=10;
		
		//======================================================================
		//       private property
		//======================================================================
		
		//======================================================================
		//        constructor
		//======================================================================
		
		public function MarketSource()
		{
		}
		
		//======================================================================
		//        public function
		//======================================================================
		/**
		 * 返回到的是枚举和标签组成的object 
		 * @return 
		 * 
		 */		
		public static function getLevelNameAry():Array
		{
			var obj:Object;
			var nameAry:Array=["全部等级","1-29","30-49","50-59"];
			var tmp:Array=[];
			for(var i:int=0;i < 4;i++)
			{
				obj=new Object();
				obj.type=i+1;
				obj.name=nameAry[i];
				tmp.push(obj);
			}
			return tmp;
		}
		/**
		 * 返回到的是枚举和标签组成的object
		 * @return 
		 * 
		 */		
		public static function getQualityNameAry():Array
		{
			var obj:Object;
			var nameAry:Array=["全部品质","普通","优秀","精良","史诗","传说","神器"];
			return nameAry;
		}
		
		/**
		 * 返回到的是枚举和标签组成的object
		 * @return 
		 * 
		 */		
		public static function getMoneyNameAry():Array
		{
			var obj:Object;
			var nameAry:Array=["全部货币","银币","魔钻"];
			return nameAry;
		}
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