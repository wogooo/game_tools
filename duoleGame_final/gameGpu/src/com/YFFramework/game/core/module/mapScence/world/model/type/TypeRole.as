package com.YFFramework.game.core.module.mapScence.world.model.type
{
	import com.YFFramework.core.utils.common.ClassInstance;
	import com.YFFramework.game.core.global.util.TypeProps;
	
	import flash.display.MovieClip;

	/**
	 *   角色类型  所有的类型都在这个类里面
	 * @author yefeng
	 *2012-4-28下午11:45:31
	 */
	public class TypeRole
	{
		///人物默认皮肤
		/**  新手人物男
		 */		
		private static const DefaultNew_ManCloth:int=200000;
		/**新手人物女
		 */ 
		private static const DefaultNew_WonManCloth:int=100000;
		
		/**战士人物男
		 */		
		private static const DefaultZhanShi_ManCloth:int=210001;
		/**
		 *战士人物女 
		 */		
		private static const DefaultZhanShi_WomanCloth:int=110001;
		/**法师人物男
		 */		
		private static const DefaultFashi_ManCloth:int=220001;
		/**法师人物女
		 */		
		private static const DefaultFashi_WomanCloth:int=120001;
		/**牧师人物男
		 */		
		private static const DefaultMushi_ManCloth:int=230001;
		/**牧师人物女
		 */		
		private static const DefaultMushi_WomanCloth:int=130001;
		/**猎人男
		 */		
		private static const DefaultLieRen_ManCloth:int=240001;
		/**猎人女
		 */		
		private static const DefaultLieRen_WomanCloth:int=140001;
		/**刺客男
		 */		
		private static const DefaultCike_ManCloth:int=250001;
		/**刺客女
		 */		
		private static const DefaultCike_WomanCloth:int=150001;
		
		///  角色 大类   对应  ObjectType 表
		/**  玩家类型
		 */
		public static const BigCategory_Player:int=0;
		/**宠物类型
		 */ 
		public static const BigCategory_Pet:int=1;
		/**   怪物类型
		 */
		public static const BigCategory_Monster:int=2;
		/** npc 类型
		 */		
		public static const BigCategory_NPC:int=3;
		/** 采集物类型 
		 */		
		public static const BigCategory_Gather:int=4;
		/**传送点
		 */		
		public static const BigCategory_Transfer:int=5;
		
		/**物品掉落
		 */ 
		public static const BigCategory_GropGoods:int=6;
		/**陷阱类型
		 */		
		public static const BigCategory_Trap:int=7;
		
		/**怪物区域点 
		 */ 
		public static const BigCategory_MonsterZone:int=8;
		
		///性别
		/**  男性
		 */		
		public static const Sex_Man:int=1;
		
		/**  女性
		 */
		public static const Sex_Woman:int=0;
		
		
		
		
		/**新手
		 */
		public static const CAREER_NEWHAND:int=0; 
		/**战士
		 */
		public static const CAREER_WARRIOR:int=1; 
		/**法师
		 */
		public static const CAREER_MASTER:int=2; 
		/**牧师
		 */
		public static const CAREER_PRIEST:int=3; 
		/** 猎人
		 */		
		public static const CAREER_HUNTER:int=4; 
		/**刺客
		 */
		public static const CAREER_BRAVO:int=5; 


		/** 人物站立 行走  战斗等状态
		 */
		public static const  State_Normal:int=1;
		/**人物打坐
		 */
		public static const  State_Sit:int=2;
		
		/**在坐骑上
		 */
		public static const  State_Mount:int=3;
		
		
		
		///// PK模式
		/**  和平模式
		 *  只能攻击怪物
		 */		
		public static const PKMode_Peace:int=1;
		/**全体攻击
		 */		
		public static const PKMode_All:int=2;
		/**善恶攻击  玩家只能攻击怪物和红名、灰名玩家及其宠物，不能攻击白名玩家及其
		 */
		public static const PKMode_JusticeEvil:int=3;
		/**组队攻击  玩家只能攻击怪物和自己队伍以外的玩家及其宠物，不能攻击队伍成员及其宠物。
		 */		
//		public static const PKMode_Team:int=4;
		/** 公会模式 玩家只能攻击怪物和自己公会以外的玩家及其宠物，不能攻击公会成员及其宠物。
		 */		
		public static const PKMode_Sociaty:int=5;
		
		/**白名
		 */		
		public static const NameColor_White:int=1;
		/**灰名
		 */		
		public static const NameColor_Gray:int=2;
		/**红名玩家
		 */		
		public static const NameColor_Red:int=3;
		
		/*****************************地图类型：******************************/		
		/** 1 安全地图 */		
		public static const MapScene_SafeArea:int=1;
		/** 2 野外地图 */		
		public static const MapScene_Field:int=2;
		/** 3 副本地图 */		
		public static const MapScene_Raid:int=3;
		/** 4 竞技场地图 */		
		public static const MapScene_Arena:int=4;
		
		/******************************怪物类型：*****************************/		
		/** 普通怪 */		
		public static const MonsterType_Normal:int=1;
		/**精英怪 */		
		public static const MonsterType_Elite:int=2;
		/**Boss怪 */		
		public static const MonsterType_Boss:int=3;
		
		////////////传送点类型 用于 小地图    设置小地图样式
		/**传送点类型 用于 小地图   普通类型
		 */		
//		public static const TransferType_Normal:int=1;
//		/**传送点类型 用于 小地图   特殊类型
//		 */		
//		public static const TransferType_Special:int=2;
		
		///小地图上 的 npc或者怪物点的显示类型
		/** 小地图上不显示 
		 */		
		public static const SmallMapShowType_None:int=0;
		/**  怪物区域
		 */		
		public static const SmallMapShowType_MonsterZone:int=1;
		/**功能npc
		 */		
		public static const SmallMapShowType_FuncNPC:int=2;
		/** 其他npc
		 */		
		public static const SmallMapShowType_OtherNPC:int=3;
		/**传送点
		 */		
		public static const SmallMapShowType_TransferPt:int=4;
		/**移动npc 
		 */		
		public static const SmallMapShowType_MoveNPC:int=5;

		
		/////阵营枚举
		
		/**无阵营
		 */
		public static const Camp_None:int=0;

		/**阵营 玩家 1 
		 */
		public static const Camp_Player_1:int=1;

		/** 阵营 玩家2 
		 */
		public static const Camp_Player_2:int=2;

		/**敌对阵营
		 */
		public static const Camp_Enemy:int=3;

		/**中立阵营
		 */
		public static const Camp_Middle:int=4;

		
		/**非vip */
		public static const VIP_TYPE_NONE:int=0;
		
		/**普通vip */
		public static const VIP_TYPE_NORMAL:int=1;

		/**年费vip */
		public static const VIP_TYPE_YEAR:int=2;
		
		
		/**  获取职业
		 */		
		public static function getCareerName(career:int):String
		{
			switch(career)
			{
				case CAREER_NEWHAND:
					return "新手";
				case CAREER_WARRIOR:
					return "战士";
				case CAREER_BRAVO:
					return "刺客";
				case CAREER_PRIEST:
					return "牧师";
				case CAREER_MASTER:
					return "法师";
				case CAREER_HUNTER:
					return "猎人";
				default:
					return '';
			}
			
		}
		
		public static function getSexName(gender:int):String
		{
			var str:String='';
			switch(gender)
			{
				case TypeProps.GENDER_FEMALE:
					str = "女";
					break;
				case TypeProps.GENDER_MALE:
					str = "男";
					break;
				case TypeProps.GENDER_NONE:
					str = "无";
					break;
			}
			return str;
		}
		
		/** 获取PK模式值
		 */		
		public static function getPKModeName(pkMode:int):String
		{
			var str:String="";
			switch(pkMode)
			{
				case PKMode_Peace:
					str="和平";
					break;
				case PKMode_All:
					str="杀戮";
					break;
				case PKMode_JusticeEvil:
					str="善恶";
					break;
//				case PKMode_Team:
//					str="组队模式";
//					break;
				case PKMode_Sociaty:
					str="工会";
					break;
			}
			return str;
		}
		/**获取 名字颜色
		 */		
		public static function getNameColor(nameColor:int):uint
		{
			switch(nameColor)
			{
				case NameColor_White:
					return 0xFFFFFF;
					break;
				case NameColor_Gray:
					return 0x666666;
					break;
				case NameColor_Red:
					return 0xFF0000;
					break;
			}
			return 0xFFFFFF;
		}

		/**  获取人物默认皮肤
		 */	
		public static function getDefaultSkin(sex:int,career:int):int
		{
			switch(career)
			{
				//新手
				case TypeRole.CAREER_NEWHAND:
					switch(sex)
					{
						case TypeRole.Sex_Man:
							return DefaultNew_ManCloth;
							break;
						case TypeRole.Sex_Woman:
							return DefaultNew_WonManCloth;
							break;
					}
					break;
				//战士
				case TypeRole.CAREER_WARRIOR:
					switch(sex)
					{
						case TypeRole.Sex_Man:
							return DefaultZhanShi_ManCloth;
							break;
						case TypeRole.Sex_Woman:
							return DefaultZhanShi_WomanCloth;
							break;
					}
					break;
				///法师
				case TypeRole.CAREER_MASTER:
					switch(sex)
					{
						case TypeRole.Sex_Man:
							return DefaultFashi_ManCloth;
							break;
						case TypeRole.Sex_Woman:
							return DefaultFashi_WomanCloth;
							break;
					}
					break;
				//牧师
				case TypeRole.CAREER_PRIEST:
					switch(sex)
					{
						case TypeRole.Sex_Man:
							return DefaultMushi_ManCloth;
							break;
						case TypeRole.Sex_Woman:
							return DefaultMushi_WomanCloth;
							break;
					}
					break;
				//猎人
				case TypeRole.CAREER_HUNTER:
					switch(sex)
					{
						case TypeRole.Sex_Man:
							return DefaultLieRen_ManCloth;
							break;
						case TypeRole.Sex_Woman:
							return DefaultLieRen_WomanCloth;
							break;
					}
					break;
				//刺客
				case TypeRole.CAREER_BRAVO:
					switch(sex)
					{
						case TypeRole.Sex_Man:
							return DefaultCike_ManCloth;
							break;
						case TypeRole.Sex_Woman:
							return DefaultCike_WomanCloth;
							break;
					}
					break;
			}
			return -1;
		}
	
		/** 根据vip类型，和vip等级返回这个vip对应资源名字，资源是MovieClip
		 警告：这个方法适用于自己的vip */
		public static function getVipResName(vipType:int,vipLevel:int):String
		{
			var vipRes:String='';
			if(vipType == 0)
				return '';
			if(vipType == VIP_TYPE_NORMAL)  //普通 vip     931803640 第一个vip等级
			{
			//	vipRes += vipLevel.toString();
				vipRes="a"+(931803640+vipLevel-1);
			}
			else if(vipType == VIP_TYPE_YEAR)
			{
				vipRes = 'vipYear'+vipLevel.toString();
			}
			return vipRes;
		}
		
		/**获取vip 的原件
		 */
		public static function getVIPMC(vipType:int,vipLevel:int):MovieClip
		{
			var name:String=getVipResName(vipType,vipLevel);
			if(name!="")
			{
				return ClassInstance.getInstance(name);
			}
			return null;
		}
		
		
		
//		/** 适用于如排行榜之类的其他玩家vip情况。
//		 不是vip:type-0，level-0；普通vip：type-0，level>0；年费vip：type-2，level>0 */
//		public static function getOtherVipResName(vipType:int,vipLevel:int):String
//		{
//			var vipRes:String='vip';
//			if(vipType == 0 && vipLevel == 0)
//				return '';
//			if(vipType == 0 && vipLevel > 0)
//			{
//				vipRes += vipLevel.toString();
//			}
//			else if(vipType == 2 && vipLevel > 0)
//			{
//				vipRes += 'Year'+vipLevel.toString();
//			}
//			return vipRes;
//		}
	
	
	
	}
}