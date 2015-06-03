package com.YFFramework.game.core.module.forge.data
{
	import com.YFFramework.game.core.global.manager.EquipBasicManager;
	import com.YFFramework.game.core.global.model.EquipBasicVo;
	import com.YFFramework.game.core.global.model.EquipDyVo;
	import com.YFFramework.game.core.global.util.TypeProps;
	
	import flash.utils.Dictionary;

	/**
	 * @version 1.0.0
	 * creation time：2013-7-5 上午9:36:15
	 * 
	 */
	public class ForgeSource
	{
		//======================================================================
		//       public property
		//======================================================================
		/***************************常用变量*************************/
		public static const MAX_ENHENCE_LEVEL:int = 12;
		
		/** 装备强化
		 */		
		public static const EQUIP_ENHANCE:int=1;
		/** 装备进阶
		 */		
		public static const EQUIP_LEVEL_UP:int=2;
		/** 宝石镶嵌
		 */		
		public static const INLAY_GEMS:int=3;
		/** 宝石摘除
		 */		
		public static const REMOVE_GEMS:int=4;
		/** 物品合成
		 */		
		public static const PROPS_COMPOSE:int=5;
		/** 装备洗练
		 */		
		public static const EQUIP_SOPHI:int=6;
		/** 装备分解
		 */		
//		public static const EQUIP_DISOLVE:int=7;

		
		/*********************************************/
		/** EquipItemRender只显示强化等级,装备洗练里的装备显示也用这个
		 */		
		public static const SHOW_ENHANCE_LEVEL:int=1;
		/** EquipItemRender只显示材料数量
		 */		
		public static const ITEM_NUM:int=2;
		/** EquipItemRender只显示“已镶嵌宝石/全部孔数”
		 */		
		public static const SHOW_GEMS:int=3;
		/** EquipItemRender:强化石比较特殊,单独处理
		 */		
		public static const ENHENCE_STONES:int=4;
		/** EquipItemRender：装备进阶
		 */		
		public static const EQUIP_SHOW_LEVEL_UP:int=5;
		/**********************显示render里tips里使用哪种tip***********************/
		
		public static const CHARACTER:int = 1;
		public static const BAG:int = 2;
		public static const PROPS:int = 3;
		/** 被转移的装备有可能在背包或身上
		 */		
		public static const MIX_EQUIP:int=4;
		
		/************************宝石类型************************/
		/** 攻击 */		
		public static const GEM_TYPE_ATTACK:int=1;
		/** 防御 */		
		public static const GEM_TYPE_DEFEND:int=2;
		/** 生命 */		
		public static const GEM_TYPE_LIFE:int=3;
		
		/****************************装备显示顺序**************************/
		private static const ORDER_EQUIPS:Array=[TypeProps.EQUIP_TYPE_WEAPON,TypeProps.EQUIP_TYPE_CLOTHES,TypeProps.EQUIP_TYPE_WRIST,
												TypeProps.EQUIP_TYPE_SHIELD,TypeProps.EQUIP_TYPE_HELMET,TypeProps.EQUIP_TYPE_NECKLACE,
												TypeProps.EQUIP_TYPE_SHOES,TypeProps.EQUIP_TYPE_RING];
		
		/** 把含有EquipDyVo的数组安装策划要求的显示顺序排列 */
		public static function orderContainEquips(tmpAry:Array):Array
		{
			//第一步：把所有装备按部位放在字典里
			var equipsDict:Dictionary=new Dictionary();
			var bsVo:EquipBasicVo;
			var ary:Array;
			for each(var vo:EquipDyVo in tmpAry)
			{
				bsVo=EquipBasicManager.Instance.getEquipBasicVo(vo.template_id);
				if(equipsDict[bsVo.type] == null)
					equipsDict[bsVo.type]=[];
				ary=equipsDict[bsVo.type];
				ary.push(vo);
			}
			//第二步：按照ORDER_EQUIPS里的顺序，取出每个EquipDyVo，排列好放在equips
			var equips:Array=[];
			for each(var type:int in ORDER_EQUIPS)
			{
				if(equipsDict[type] != null)
				{
					ary=equipsDict[type];
					for each(vo in ary)
					{
						equips.push(vo);
					}
				}
			}
			return equips;
		}
		//======================================================================
		//       private property
		//======================================================================
		
		//======================================================================
		//        constructor
		//======================================================================
		
		public function ForgeSource()
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