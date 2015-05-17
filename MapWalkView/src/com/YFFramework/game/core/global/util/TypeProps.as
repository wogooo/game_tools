package com.YFFramework.game.core.global.util
{
	/**
	 * @version 1.0.0
	 * creation time：2013-3-25 上午10:13:32
	 * 
	 */
	public class TypeProps
	{
		/**
		 *道具类型 (服务端定义的)
		 */		
		public static const PROPS_TYPE_DRUG:int = 1;// 药品
		public static const PROPS_TYPE_ENHANCE:int = 2;// 装备强化材料    
		public static const PROPS_TYPE_GEM:int = 3; // 装备镶嵌宝石 
		public static const PROPS_TYPE_PET_EGG:int = 4;//宠物蛋
		public static const PROPS_TYPE_PET_COMFORT:int = 5;// 宠物驯养道具
		public static const PROPS_TYPE_PET_FEED:int = 6; // 宠物喂养道具
		public static const PROPS_TYPE_PET_ENHANCE:int = 7;//宠物强化
		public static const PROPS_TYPE_PET_COMPRE:int = 8; //宠物领悟
		public static const PROPS_TYPE_PET_SKILLBOOK:int = 9;
		public static const PROPS_TYPE_PET_SOPHI:int = 10; // 宠物洗练材料  
		public static const PROPS_TYPE_TASK:int = 11;
		public static const PROPS_TYPE_GIFTPACKS:int = 12;//礼包
		public static const PROPS_TYPE_SPECIAL:int = 13;// 特殊道具：人物洗点道具、宠物洗点道具、赎罪卡
		
		/**
		 * 查找templateId的枚举值 
		 */
		// 物品综合
		public static const CONST_ID_NEWHAND_GIFTPACKS:int	= 1;	// 新手礼包	

		// 强化石 100-199 
		public static const CONST_ID_LOW_STR_STONE:int		= 101;	// 初级强化石
		public static const CONST_ID_MID_STR_STONE:int 		= 102;	// 中级强化石
		public static const CONST_ID_HIGH_STR_STONE:int		= 103;	// 高级强化石
		
		// 宠物道具300-399
		// 310-319		
		public static const CONST_ID_PET_SOPHI:int			= 311;	// 宠物洗练
		// 320-329
		public static const CONST_ID_PET_RESET:int			= 321;	// 宠物洗点
		// 330-339	
		public static const CONST_ID_PET_LOW_CRYSTAL:int	= 331;	// 宠物低级晶核
		public static const CONST_ID_PET_MID_CRYSTAL:int	= 332;	// 宠物中级晶核
		public static const CONST_ID_PET_HIGH_CRYSTAL:int	= 333;	// 宠物高级晶核
		// 340-349		
		public static const CONST_ID_PET_COMPREHEND1:int	= 341;	// 宠物领悟1级
		public static const CONST_ID_PET_COMPREHEND2:int	= 342;	// 宠物领悟2级
		public static const CONST_ID_PET_COMPREHEND3:int	= 343;	// 宠物领悟3级
		public static const CONST_ID_PET_COMPREHEND4:int	= 344;	// 宠物领悟4级

		//道具类别
		public static const BIG_PROPS_TYPE_COMFORT:int = 5;		//宠物驯养道具类别
		public static const BIG_PROPS_TYPE_FEED:int = 6;		//宠物喂养道具类别
		public static const BIG_PROPS_TYPE_SKILLBOOK:int = 9;	//技能书类别
		
		/**
		 * 与宠物相关的 
		 */		
		public static const TOTAL_SLOTS:int=30;
		
		//宠物属性
		public static const BASIC_STR:int=1;
		public static const BASIC_AGI:int=2;
		public static const BASIC_INT:int=3;
		public static const BASIC_PHY:int=4;
		public static const BASIC_SPI:int=5;
		public static const BASIC_STR_QLT:int=6;
		public static const BASIC_AGI_QLT:int=7;
		public static const BASIC_INT_QLT:int=8;
		public static const BASIC_PHY_QLT:int=9;
		public static const BASIC_SPI_QLT:int=10;
		public static const GROWTH:int=11;
		public static const BASIC_STR_QLT_LIM:int=12;
		public static const BASIC_AGI_QLT_LIM:int=13;
		public static const BASIC_INT_QLT_LIM:int=14;
		public static const BASIC_PHY_QLT_LIM:int=15;
		public static const BASIC_SPI_QLT_LIM:int=16;
		public static const HP:int=21;
		public static const MANA:int=22;
		public static const HP_LIMIT:int=23;
		public static const MANA_LIMIT:int=24;
		public static const PHYSIC_ATK:int=25;
		public static const MAGIC_ATK:int=26;
		public static const PHYSIC_DEF:int=27;
		public static const MAGIC_DEF:int=28;
		public static const SPEED:int=40;
		
		public static const GROWTH_RATE1:Number=0.25;
		public static const GROWTH_RATE2:Number=0.1;
		public static const GROWTH_RATE3:Number=0.05;
		public static const GROWTH_RATE4:Number=0.04;
		public static const GROWTH_RATE5:Number=0.03;

		//Item shop id
		public static const ITEM_SHOP_ID:int=1;
		public static const ITEM_TYPE:int=2;
		
		//Color
		public static const WHITE:uint   = 0xffffff;
		public static const SILVER:uint  = 0xc0c0c0;
		public static const GRAY:uint    = 0x808080;
		public static const BLACK:uint   = 0x000000;
		public static const RED:uint     = 0xff0000;
		public static const MAROON:uint  = 0x800000;
		public static const YELLOW:uint  = 0xffff00;
		public static const OLIVE:uint   = 0x808000;
		public static const LIME:uint    = 0x00ff00;
		public static const GREEN:uint   = 0x008000;
		public static const AQUA:uint    = 0x00ffff;
		public static const TEAL:uint    = 0x008080;
		public static const BLUE:uint    = 0x0000ff;
		public static const NAVY:uint    = 0x000080;
		public static const FUCHSIA:uint = 0xff00ff;
		public static const PURPLE:uint  = 0x800080;
		public static const ORANGE:uint  = 0xff9900;
		
		public static const C5ec700:uint = 0x5ec700;
		public static const Cf0f275:uint = 0xf0f275;
		public static const Cffef95:uint = 0xffef95;
		public static const Cfff3a5:uint = 0xfff3a5;
		
		//绑定性
		public static const BIND_TYPE_YES:int=1;
		public static const BIND_TYPE_NO:int=2;
		public static const BIND_TYPE_EQUIP:int=3;
		
		//快捷键类型
		public static const BT_NONE:int=0;
		public static const BT_SKILL:int=1;
		public static const BT_ITEM:int=2;
		
		//职业类型
		/**新手 
		 */		
		public static const CAREER_NEWHAND:int = 0;
		/**战士
		 */		
		public static const CAREER_WARRIOR:int = 1;
		/**刺客
		 */		
		public static const CAREER_MASTER:int = 2;
		/**牧师
		 */	
		public static const CAREER_PRIEST:int = 3;
		/**法师
		 */	
		public static const CAREER_HUNTER:int = 4;
		/**猎人
		 */	
		public static const CAREER_BRAVO:int = 5;
		
		//装备类型
		/**
		 *头盔 
		 */		
		public static const EQUIP_TYPE_HELMET:int=1;
		public static const EQUIP_TYPE_CLOTHES:int=2;
		public static const EQUIP_TYPE_WRIST:int=3;
		public static const EQUIP_TYPE_NECKLACE:int=4;
		public static const EQUIP_TYPE_RING:int=5;
		public static const EQUIP_TYPE_SHOES:int=6;
		public static const EQUIP_TYPE_WEAPON:int=7;
		public static const EQUIP_TYPE_SHIELD:int=8;
		public static const EQUIP_TYPE_WINGS:int=9;
		public static const EQUIP_TYPE_FASHION_HEAD:int=10;
		public static const EQUIP_TYPE_FASHION_BODY:int=11;
		
		//属性类型
		public static const EA_NONE:int = 0;
		public static const BA_STRENGTH:int = 1;
		public static const BA_AGILE:int = 2;
		public static const BA_INTELLIGENCE:int = 3;
		public static const BA_PHYSIQUE:int = 4;
		public static const BA_SPIRIT:int = 5;
		public static const BA_STRENGTH_APT:int = 6;
		public static const BA_AGILE_APT:int = 7;
		public static const BA_INTELLIGENCE_APT:int = 8;
		public static const BA_PHYSIQUE_APT:int = 9;
		public static const BA_SPIRIT_APT:int = 10;
		public static const BA_GROW:int = 11;
		public static const EA_HEALTH:int = 21;
		public static const EA_MANA:int = 22;
		public static const EA_HEALTH_LIMIT:int = 23;
		public static const EA_MANA_LIMIT:int = 24;
		public static const EA_PHYSIC_ATK:int = 25;
		public static const EA_MAGIC_ATK:int = 26;
		public static const EA_PHYSIC_DEFENSE:int = 27;
		public static const EA_MAGIC_DEFENSE:int = 28;
		public static const EA_HITRATE:int = 29;
		public static const EA_MISSRATE:int = 30;
		public static const EA_CRITRATE:int = 31;
		public static const EA_TOUGHRATE:int = 32;
		public static const EA_PREDUCE:int = 33;
		public static const EA_MREDUCE:int = 34;
		public static const EA_BLOODRESIST:int = 35;
		public static const EA_POISONRESIST:int = 36;
		public static const EA_SWIMRESIST:int = 37;
		public static const EA_FROZENRESIST:int = 38;
		public static const EA_TYPES:int = 39;
		public static const EA_MOVESPEED:int = 40;
		
		//性别
		public static const GENDER_FEMALE:int = 0;
		public static const GENDER_MALE:int = 1;
		public static const GENDER_NONE:int = 2;
		
		//物品类型
		public static const ITEM_TYPE_EMPTY:int = 0;
		public static const ITEM_TYPE_EQUIP:int = 1;
		public static const ITEM_TYPE_PROPS:int = 2;
		
		//移动方向（背包，仓库，身体）
		public static const MOV_DIRECT_PACK_TO_PACK:int = 1;
		public static const MOV_DIRECT_PACK_TO_DEPOT:int = 2;
		public static const MOV_DIRECT_PACK_TO_BODY:int = 3;
		public static const MOV_DIRECT_DEPOT_TO_DEPOT:int = 4;
		public static const MOV_DIRECT_DEPOT_TO_PACK:int = 5;
		public static const MOV_DIRECT_BODY_TO_PACK:int = 6;
		
		//道具、装备品质
		public static const QUALITY_WHITE:int = 1;
		public static const QUALITY_GREEN:int = 2;
		public static const QUALITY_BLUE:int = 3;
		public static const QUALITY_PURPLE:int = 4;
		public static const QUALITY_ORANGE:int = 5;
		public static const QUALITY_RED:int = 6;
		
		//回复消息类型
		public static const RSPMSG_SUCCESS:int = 0;// 成功
		public static const RSPMSG_FAIL:int = 1;// 失败
		
		public static const RSPMSG_USEITEM_FAILED:int = 10;// 使用道具失败
		public static const RSPMSG_NOT_EXIST:int = 11; // 使用目标不存在
		public static const RSPMSG_PACK_FULL:int = 12; // 背包已满
		public static const RSPMSG_DEPOT_FULL:int = 13;// 仓库已满
		public static const RSPMSG_BALANCE_LESS:int = 14; // 余额不足
		
		public static const RSPMSG_UN_EQUIP:int = 15; // 不可装备
		public static const RSPMSG_POS_ERROR:int = 16;// 源位置或目标位置错误  
		public static const RSPMSG_EQUIP_POS_UNFIT:int = 17;// 装备位置不匹配
		public static const RSPMSG_EQUIP_RANK_UNFIT:int = 18;// 装备等级不匹配
		public static const RSPMSG_EQUIP_GENDER_UNFIT:int = 19;// 装备性别不匹配
		public static const RSPMSG_EQUIP_CAREER_UNFIT:int = 20;// 装备职业不匹配
		
		public static const RSPMSG_TEAM_NOT_EXIST:int = 100;// 队伍不存在，可能队长已经加入其它队伍
		public static const RSPMSG_TEAM_MEMBER_FULL:int = 101; // 队伍成员满
		public static const RSPMSG_TEAM_LEADER_LEAVE:int = 102;// 邀请的队长不在
		public static const RSPMSG_TEAM_JOIN_OTHER:int = 103; // 接受申请的队员已经加入其它队伍
		public static const RSPMSG_TEAM_OFFLINE:int = 104; // 接受申请的队员已经离线
		
		//离队原因
		public static const REASON_SELF_LEAVE:int = 1;
		public static const REASON_KICK:int = 2;
		public static const REASON_TEAM_DISAPPEAR:int = 3;	//暂时不用，当成self_leave处理
		public static const REASON_OFFLINE:int = 4;
		
		//存储类型
		public static const STORAGE_TYPE_BODY:int = 0;
		public static const STORAGE_TYPE_PACK:int = 1;
		public static const STORAGE_TYPE_DEPOT:int = 2;
		
		public function TypeProps(){
		}
	}
} 