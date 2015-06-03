package com.YFFramework.game.core.global.util
{
	import com.YFFramework.core.utils.common.ClassInstance;
	
	import flash.display.Sprite;
	

	/**
	 * @version 1.0.0
	 * creation time：2013-3-25 上午10:13:32
	 * 
	 */
	public class TypeProps{
		/****************************道具类型 (服务端定义的)***********************/	
		/** 加血道具 */
		public static const PROPS_TYPE_HP_DRUG:int = 1;		// 加血道具
		/** 装备强化材料 */
		public static const PROPS_TYPE_ENHANCE:int = 2;		// 装备强化材料
		/** 装备镶嵌宝石 */
		public static const PROPS_TYPE_GEM:int = 3; 		// 装备镶嵌宝石
		/** 宠物蛋 */
		public static const PROPS_TYPE_PET_EGG:int = 4;		//宠物蛋
		/** 宠物驯养道具 */
		public static const PROPS_TYPE_PET_COMFORT:int = 5;	// 宠物驯养道具
		/** 宠物喂养道具 */
		public static const PROPS_TYPE_PET_FEED:int = 6; 	// 宠物喂养道具
		/** 宠物强化 */
		public static const PROPS_TYPE_PET_ENHANCE:int = 7;	//宠物强化
		/** 宠物领悟 */
		public static const PROPS_TYPE_PET_COMPRE:int = 8; 	//宠物领悟
		/** 宠物技能书 */
		public static const PROPS_TYPE_PET_SKILLBOOK:int = 9;
		/** 宠物洗练材料 */
		public static const PROPS_TYPE_PET_SOPHI:int = 10;	// 宠物洗练材料
		/** 任务道具 */
		public static const PROPS_TYPE_TASK:int = 11;
		/** 礼包 */
		public static const PROPS_TYPE_GIFTPACKS:int = 12;	//礼包
		/** 特殊道具：人物洗点道具、宠物洗点道具、赎罪卡 */
		public static const PROPS_TYPE_SPECIAL:int = 13;	// 特殊道具：人物洗点道具、宠物洗点道具、赎罪卡
		/** 坐骑蛋 */
		public static const PROPS_TYPE_MOUNT_EGG:int = 14;	//坐骑蛋
		/** 坐骑喂养道具 */
		public static const PROPS_TYPE_MOUNT_FEED:int = 15;	//坐骑喂养道具
		/** 羽毛 */
		public static const PROPS_TYPE_FEATHER:int = 16;	// 羽毛
		/** 血池补充  */		
		public static const PROPS_TYPE_HPPOOL:int=17;	
		/** 魔池补充  */		
		public static const PROPS_TYPE_MPPOOL:int=18;
		/** 魔瓶道具类别 */
		public static const PROPS_TYPE_MP_DRUG:int=19;		//魔瓶道具类别
		/** 坐骑附灵道具 */
		public static const PROPS_TYPE_MOUNT_ADD:int=22;	//坐骑附灵道具
		/** 装备洗练道具  */		
		public static const PROPS_TYPE_DEFT:int=23;	
		/** 其他功能道具（临时属性）  */		
		public static const PROPS_TYPE_OTHER_USE:int=24;		
		/** 永久增加属性  */		
		public static const PROPS_TYPE_ATTR_UP:int=25;
		/** 直接增加经验值  */		
		public static const PROPS_TYPE_EXP_UP:int=26;		
		/**传送类 道具    小飞鞋 */		
		public static const PROPS_TYPE_FLY:int= 27; // 传送卷轴类
		/** 回程道具 */
		public static const	PROPS_TYPE_TP:int= 28; // 回城道具类型			
		/** 开启背包格道具  */		
		public static const PROPS_TYPE_OPEN_PACK:int=29;
		/** 开启仓库格道具  */		
		public static const PROPS_TYPE_OPEN_DEPOT:int=30;
		/** 魔元道具  */		
		public static const PROPS_TYPE_MAGIC_SOUL:int=31;
		/** 神脉升级道具  */		
		public static const PROPS_TYPE_PULSE_UP:int=32;
		/**公会贡献*/
		public static const PROPS_TYPE_GUILD_CONTRIBUTION:int = 34;
		
		/*************************************装备类型*************************************/		
		/** 头盔1 */		
		public static const EQUIP_TYPE_HELMET:int=1;
		/** 衣服2 */		
		public static const EQUIP_TYPE_CLOTHES:int=2;
		/** 手套3 */		
		public static const EQUIP_TYPE_WRIST:int=3;
		/** 项链4 */		
		public static const EQUIP_TYPE_NECKLACE:int=4;
		/** 戒指5 */		
		public static const EQUIP_TYPE_RING:int=5;
		/** 鞋子6 */		
		public static const EQUIP_TYPE_SHOES:int=6;
		/** 武器7 */		
		public static const EQUIP_TYPE_WEAPON:int=7;
		/** 副手8 */		
		public static const EQUIP_TYPE_SHIELD:int=8;
		/** 翅膀 9*/		
		public static const EQUIP_TYPE_WINGS:int=9;
//		public static const EQUIP_TYPE_FASHION_HEAD:int=10;
		/** 时装11 */		
		public static const EQUIP_TYPE_FASHION_BODY:int=11;
				
		/*****************************************物品大类：装备、道具、（空）、钱**************************************/
		
		public static const ITEM_TYPE_EMPTY:int = 0;
		/** 装备类型 */		
		public static const ITEM_TYPE_EQUIP:int = 1;
		/**道具类型 */		
		public static const ITEM_TYPE_PROPS:int = 2;
		/**钱的类型：魔钻  */	
		public static const ITEM_TYPE_MONEY:int= 3;
		
		/**************************** 查找templateId的枚举值     现在变为 映射表  通过查表 ********************************/
		
		/** 装备洗练道具 */		
		public static const CONST_EQUIP_SOPHI:int= 107;
		/** 小喇叭道具 */
		public static const CONST_ID_SPEAKER_ITEM:int = 298; //小喇叭道具
		
		/******************************与宠物相关的 ************************************/
		
		public static const TOTAL_SLOTS:int=30;
		
		public static const GROWTH_RATE1:Number=0.25;
		public static const GROWTH_RATE2:Number=0.1;
		public static const GROWTH_RATE3:Number=0.05;
		public static const GROWTH_RATE4:Number=0.04;
		public static const GROWTH_RATE5:Number=0.03;

		/******************************Color ************************************/
		
		public static const COLOR_WHITE:uint   = 0xffffff;
		public static const COLOR_SILVER:uint  = 0xc0c0c0;
		public static const COLOR_GRAY:uint    = 0x808080;
		public static const COLOR_BLACK:uint   = 0x000000;
		public static const COLOR_RED:uint     = 0xff0000;
		public static const COLOR_MAROON:uint  = 0x800000;
		public static const COLOR_YELLOW:uint  = 0xffff00;
		public static const COLOR_OLIVE:uint   = 0x808000;
		public static const COLOR_LIME:uint    = 0x00ff00;
		public static const COLOR_GREEN:uint   = 0x008000;
		public static const COLOR_AQUA:uint    = 0x00ffff;
		public static const COLOR_TEAL:uint    = 0x008080;
		public static const COLOR_BLUE:uint    = 0x0000ff;
		public static const COLOR_NAVY:uint    = 0x000080;
		public static const COLOR_FUCHSIA:uint = 0xff00ff;
		public static const COLOR_PURPLE:uint  = 0x800080;
		public static const COLOR_ORANGE:uint  = 0xff9900;
		
		public static const C5ec700:uint = 0x5ec700;
		public static const Cf0f275:uint = 0xf0f275;
		public static const Cffef95:uint = 0xffef95;
		public static const Cfff3a5:uint = 0xfff3a5;
		public static const C8CF213:uint = 0x8CF213;
		public static const C1ff1e0:uint = 0x1ff1e0;
		public static const Cfff0b6:uint = 0xfff0b6;//文字黄色
		
		/******************************绑定性 ************************************/
		
		/** 绑定：1 */		
		public static const BIND_TYPE_YES:int=1;
		/** 不绑定：2  */		
		public static const BIND_TYPE_NO:int=2;
		/** 穿戴后绑定：3 */		
		public static const BIND_TYPE_EQUIP:int=3;
		
		/******************************属性类型 ************************************/
		
		public static const EA_NONE:int = 0;
		/** 力量 */		
		public static const BA_STRENGTH:int = 1;
		/** 敏捷 */		
		public static const BA_AGILE:int = 2;
		/** 智力 */		
		public static const BA_INTELLIGENCE:int = 3;
		/** 体质 */		
		public static const BA_PHYSIQUE:int = 4;
		/** 精神 */		
		public static const BA_SPIRIT:int = 5;
		public static const BA_STRENGTH_APT:int = 6;
		public static const BA_AGILE_APT:int = 7;
		public static const BA_INTELLIGENCE_APT:int = 8;
		public static const BA_PHYSIQUE_APT:int = 9;
		public static const BA_SPIRIT_APT:int = 10;
		public static const BA_GROW:int = 11;
		public static const BA_STR_QLT_LIM:int=12;
		public static const BA_AGI_QLT_LIM:int=13;
		public static const BA_INT_QLT_LIM:int=14;
		public static const BA_PHY_QLT_LIM:int=15;
		public static const BA_SPI_QLT_LIM:int=16;
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
		public static const EA_PVEREDUCE:int = 39;
		public static const EA_PVPREDUCE:int = 40;
		public static const EA_PSTRIKE:int = 41;
		public static const EA_MSTRIKE:int = 42;
		public static const EA_EXPADD:int = 43;
		public static const EA_UNUSE2:int = 44;
		public static const EA_UNUSE3:int = 45;
		public static const EA_UNUSE4:int = 46;
		public static const EA_UNUSE5:int = 47;
		public static const EA_UNUSE6:int = 48;
		public static const EA_UNUSE7:int = 49;
		public static const EA_UNUSE8:int = 50;
		public static const EA_UNUSE9:int = 51;
		public static const EA_UNUSE10:int = 52;
		public static const EA_TYPES:int = 53;
		public static const EA_MOVESPEED:int = 54;		
		
		//性别
		public static const GENDER_FEMALE:int = 0;
		public static const GENDER_MALE:int = 1;
		public static const GENDER_NONE:int = 2;
		
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
		
		public static const RSPMSG_RIDE_FIGHTING:int= 201;  // 战斗状态无法骑马
		public static const RSPMSG_RIDE_NOMOUNT:int= 202;  // 没有出战坐骑
		
		public static const RSPMSG_IN_TRADING:int= 151;  // 正在交易中
		public static const RSPMSG_TRADE_OUT_RANGE:int= 152;  // 不在范围内
		public static const RSPMSG_TRADE_OFFLINE:int= 153;  // 对方已离线
		
		public static const RSPMSG_RAID_TIMELIMIT:int= 301;  // 不在副本的进入时间内
		public static const RSPMSG_RAID_LEVEL_NOT_FIT:int= 302;  // 等级不符合
		
		//离队原因
		public static const REASON_SELF_LEAVE:int = 1;
		public static const REASON_KICK:int = 2;
		public static const REASON_TEAM_DISAPPEAR:int = 3;	//暂时不用，当成self_leave处理
		public static const REASON_OFFLINE:int = 4;
		
		//存储类型
		public static const STORAGE_TYPE_BODY:int = 0;
		public static const STORAGE_TYPE_PACK:int = 1;
		public static const STORAGE_TYPE_DEPOT:int = 2;
		
		/**坐骑最大数量 
		 */		
		public static const MOUNT_MAX_NUM:int=1;
		
		/**坐骑模型组件数量：1或者2；
		 */		
		public static const MOUNT_PARTS_1:int=1;
		/**坐骑模型数量为2 
		 */ 
		public static const MOUNT_PARTS_2:int=2;
		
		/** 魔钻 */			
		public static const MONEY_DIAMOND:int = 1;//魔钻
		/** 礼券 */		
		public static const MONEY_COUPON:int = 2;//礼券
		/** 银币 */		
		public static const MONEY_SILVER:int = 3;//银币
		/** 银锭 */		
		public static const MONEY_NOTE:int = 4;//银锭
		/**公会贡献*/
		public static const MONEY_GUILD_CONTRIBUTION:int=5;
		
		///任务    富文本 描述的 第三个字段  所代表的类型    
		/**装备类型    富文本 定义的类型 RichText定义的类型
		 */		
		public static const TaskGoodsType_Equip:int=1;
		/** 道具类型  富文本 定义的类型 RichText定义的类型
		 */		
		public static const TaskGoodsType_Prop:int=2;
		/**NPC类型  富文本 定义的类型 RichText定义的类型
		 */		
		public static const TaskGoodsType_NPC:int=3;
		/**人物类型 富文本 定义的类型 RichText定义的类型
		 */
//		public static const TaskGoodsType_Person:int=4;
		
		
		///任务目标类型 TaskTagetBasicVo.tag_type    目标类型   1 装备     2  道具   3   怪物    4  对话
		/// 任务目标类型
		/** 任务目标 为 购买装备
		 */		
		public static const TaskTargetType_Equip:int=1;
		/** 任务目标为购买道具
		 */		
		public static const TaskTargetType_Prop:int=2;
		/**任务目标为 杀怪
		 */		
		public static const TaskTargetType_Monster:int=3;
		/** 任务目标为对话  包含中间过程的对话 也就是 接受任务 必须完成任务对话才能提交任务的类型   当 为任务目标时   数量程序写死为  1  
		 */		
		public static const TaskTargetType_NPCDialog:int=4;
		/** 任务目标为对话 不 包含中间过程的对话 也就是 接受任务 后自动变为完成状态   当 为任务目标时   数量程序写死为  1  
		 */		
		public static const TaskTargetType_NPCSimpleDialog:int=5;
		/**采集任务
		 */		
		public static const TaskTargetType_Gather:int=6;
		/**7完成副本 
		 */		
		public static const TaskTargetType_Raid:int=7;

		/**剧情  剧情进行对话
		 */
		public static const TaskTargetType_Stroy:int=8;
		
		/**装备强化
		 */
		public static const TaskTargetType_Equip_Enhance:int=9;  
		/**拥有某个坐骑
		 */
		public static const TaskTargetType_Ride:int=10;	//拥有某个坐骑
		/**装备镶嵌
		 */
		public static const TaskTargetType_Inlay:int=11;		//装备镶嵌
		/**天神命脉
		 */
		public static const TaskTargetType_Div:int=12;		//天神命脉升级
		/**翅膀
		 */
		public static const TaskTargetType_Wing:int=13;		//翅膀进阶

		/**怪物区域   玩家在世界地图上点击行走到 该区域
		 */
		public static const TaskTargetType_MonsterZone:int=24;
		/**行走到世界地图的目标点
		 */
		public static const TaskTargetType_WorldMapPt:int=25;
		
		
		/**打开 锻造界面 进行武器锻造    新手引导任务处理
		 */
		public static const TaskTargetType_WeaponLevelUp:int=30;
		
		/**31  打开新手礼包
		 */
		public static const TaskTargetType_OpenNewPack:int=31;
		
		/**32 打开装备强化面板
		 */
		public static const TaskTargetType_WeaponStrengthen:int=32;
		
		/**33 打开宝石镶嵌面板
		 */
		public static const TaskTargetType_GemInlay:int=33;
		/** 36 打开 翅膀进阶面板 
		 */
		public static const TaskTargetType_WingLevelUp:int=36;  
		
		/**打开 商城
		 */
		public static const TaskTargetType_OpenMall:int=50;  
 
		//副本
		public static const RaidTypeSingle:int=1;
		public static const RaidTypeTeam:int=2;
		public static const RaidTypeUnion:int=3;
		
		//组队
		public static const TeamCareerReqAll:int=6;

		public static const TeamPowerReqAll:int=1;
		public static const TeamPowerReq30:int=2;
		public static const TeamPowerReq50:int=3;
		
		
		public static function getQualityColor(quality:int):String
		{
			switch(quality)
			{
				case TypeProps.QUALITY_WHITE:
					return 'FFFFFF';
				case TypeProps.QUALITY_GREEN:
					return '8cf213';
				case TypeProps.QUALITY_BLUE:
					return '0078ff';
				case TypeProps.QUALITY_PURPLE:
					return 'd200ff';
				case TypeProps.QUALITY_ORANGE:
					return 'f9a410';
				case TypeProps.QUALITY_RED:
					return 'ff4a00';
				default:
					return 'FFFFFF';
			}
		}
		
		public static function getMoneyTypeIcon(moneyType:int):Sprite
		{
			var icon:Sprite;
			switch(moneyType)
			{
				case TypeProps.MONEY_COUPON:
					icon=ClassInstance.getInstance('coupon');
					break;
				case TypeProps.MONEY_DIAMOND:
					icon=ClassInstance.getInstance('diamond');
					break;
				case TypeProps.MONEY_NOTE:
					icon=ClassInstance.getInstance('note');
					break;
//				case TypeProps.MONEY_SILVER:
//					icon=ClassInstance.getInstance('silver');
//					break;
			}
			return icon;
		}
		
		/**
		 *取各属性的中文描述 
		 * @param attr 在TypeProps里定义的类型
		 * @return 中文描述（如：力量、敏捷、智力等）
		 * 
		 */		
		public static function getAttrName(attr:int):String
		{
			switch(attr)
			{
				case TypeProps.BA_STRENGTH:
					return "力量";
				case TypeProps.BA_AGILE:
					return "敏捷";
				case TypeProps.BA_INTELLIGENCE:
					return "智力";
				case TypeProps.BA_PHYSIQUE:
					return "体质";
				case TypeProps.BA_SPIRIT:
					return "精神";
				case TypeProps.BA_STRENGTH_APT:
					return "力量资质";
				case TypeProps.BA_AGILE_APT:
					return "敏捷资质";
				case TypeProps.BA_INTELLIGENCE_APT:
					return "智力资质";
				case TypeProps.BA_PHYSIQUE_APT:
					return "体质资质";
				case TypeProps.BA_SPIRIT_APT:
					return "精神资质";
				case TypeProps.BA_GROW:
					return "成长值";
				case TypeProps.EA_HEALTH:
					return "生命";
				case TypeProps.EA_MANA:
					return "魔法";
				case TypeProps.EA_HEALTH_LIMIT:
					return "生命上限";
				case TypeProps.EA_MANA_LIMIT:
					return "魔法上限";
				case TypeProps.EA_PHYSIC_ATK:
					return "物理攻击";
				case TypeProps.EA_MAGIC_ATK:
					return "魔法攻击";
				case TypeProps.EA_PHYSIC_DEFENSE:
					return "物理防御";
				case TypeProps.EA_MAGIC_DEFENSE:
					return "魔法防御";					
				case TypeProps.EA_HITRATE:
					return "命中";
				case TypeProps.EA_MISSRATE:
					return "闪避";
				case TypeProps.EA_CRITRATE:
					return "暴击";
				case TypeProps.EA_TOUGHRATE:
					return "坚韧";					
				case TypeProps.EA_PREDUCE:
					return "物理减伤";
				case TypeProps.EA_MREDUCE:
					return "魔法减伤";
				case TypeProps.EA_BLOODRESIST:
					return "减速抗性";
				case TypeProps.EA_TOUGHRATE:
					return "定身抗性";					
				case TypeProps.EA_SWIMRESIST:
					return "晕眩抗性";
				case TypeProps.EA_FROZENRESIST:
					return "沉默抗性";
				case TypeProps.EA_MOVESPEED:
					return "移动速度";
				case EA_PSTRIKE:
					return "物理穿透";
				case EA_MSTRIKE:
					return "魔法穿透";
				case EA_EXPADD:
					return "经验加成";
				default:
					return "";
			}
		}
		
		public function TypeProps(){
		}
	}
} 