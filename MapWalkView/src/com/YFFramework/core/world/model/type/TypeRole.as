package com.YFFramework.core.world.model.type
{
	import com.YFFramework.core.world.model.MonsterDyVo;
	import com.YFFramework.game.core.global.util.TypeProps;

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
		private static const DefaultMushi_ManCloth:int=200000
		/**牧师人物女
		 */		
		private static const DefaultMushi_WomanCloth:int=200000;
		/**猎人男
		 */		
		private static const DefaultLieRen_ManCloth:int=200000
		/**猎人女
		 */		
		private static const DefaultLieRen_WomanCloth:int=200000;
		/**刺客男
		 */		
		private static const DefaultCike_ManCloth:int=200000
		/**刺客女
		 */		
		private static const DefaultCike_WomanCloth:int=200000;
		
		
		
		
		
		///  角色 大类   对应  ObjectType 表
		/**  玩家类型
		 */
		public static const BigCategory_Player:int=0;
		/**   怪物类型
		 */
		public static const BigCategory_Monster:int=2;
		
		/**当前玩家
		 */
		/**宠物类型
		 */ 
		public static const BigCategory_Pet:int=1;
		
		/** npc 类型
		 */		
		public static const BigCategory_NPC:int=3;
		
		/**物品掉落
		 */ 
		public static const BigCategory_GropGoods:int=6;
		
		/**传送点
		 */		
		public static const BigCategory_SkipWay:int=7;
		
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
		/** PK模式1 
		 */		
		public static const PKMode_1:int=1;
		
		
		
		
		
		
		
		
		/**全体对象进行攻击 
		 * roleDyVo 对象是否在全体攻击的范围内
		 */ 
		public static  function CanFightAll(roleDyVo:MonsterDyVo):Boolean
		{
			//当对象为 怪物   玩家 或者宠物时  可以进行攻击
			if(roleDyVo.bigCatergory==TypeRole.BigCategory_Player||roleDyVo.bigCatergory==TypeRole.BigCategory_Monster||roleDyVo.bigCatergory==TypeRole.BigCategory_Pet)
			{
				return true;
			}
			return false;
		}
		
		/**
		 */		
		public static function getCareerName(career:int):String
		{
			switch(career)
			{
				case TypeProps.CAREER_NEWHAND:
					return "新手";
				case TypeProps.CAREER_WARRIOR:
					return "战士";
				case TypeProps.CAREER_BRAVO:
					return "刺客";
				case TypeProps.CAREER_NEWHAND:
					return "牧师";
				case TypeProps.CAREER_MASTER:
					return "法师";
				case TypeProps.CAREER_HUNTER:
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
				case PKMode_1:
					str="和平";
					break;
			}
			return str;
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
	
	
	
	
	
	}
}