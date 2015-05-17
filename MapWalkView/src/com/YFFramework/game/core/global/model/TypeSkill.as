package com.YFFramework.game.core.global.model
{
	/**  技能类型
	 *  具有单一个攻击 和群攻 两种类型
	 * 2012-9-5 下午4:03:10
	 *@author yefeng
	 */
	public class TypeSkill
	{
		
		/**职业技能
		 */		
		public static const BigCategory_Career:int=0;
		/**通用技能
		 */		
		public static const BigCategory_Common:int=1;

		/** 工会技能
		 */
		public static const BigCategory_union:int=2;

		
		/////////////////////////////////////////////////// 技能表字段
		//////////// 技能表 skill use_type字段类型
		/**  该技能作用于人，只有人才会发出技能，没有人是不会发出技能的
		 */
		public static const UseType_Player:int=1;
		/** 该技能作用于目标点  也就是对地， 需要给一个目标点 才能释放技能 
		 */		
		public static const UseType_Point:int=2;
		/**直接施法 ,  不需要任何条件 ，直接释放技能
		 */		
		public static const UseType_Fire:int=3;
		/**  被动技能
		 */		
		public static const UseType_Passive:int=4;
		/**开关技能
		 */
		public static const UseType_Switch:int=5;

		///// 技能表 目标类型 affect_group
		/**敌方所有 
		 */		
		public static const AffectGroup_Enemy:int=1;
		/**敌方角色
		 */		
		public static const AffectGroup_EnemyRole:int=2;
		/**敌方宠物
		 */		
		public static const AffectGroup_EnemyPet:int=3;
		/**敌方怪物
		 */		
		public static const AffectGroup_EnemyMonster:int=4;
		/**友方所有
		 */		
		public static const AffectGroup_Freind:int=5;
		/**友方角色
		 */		
		public static const AffectGroup_FreindRole:int=6;
		/**友方宠物
		 */		
		public static const AffectGroup_FreindPet:int=7;
		/**友方死亡角色  
		 */
		public static const AffectGroup_FreindDeadRole:int=8;
		/**所有角色
		 */		
		public static const AffectGroup_All:int=10;

		/////技能作用的类型 range_shape 字段
		/**圆形
		 */		
		public static const RangeShape_Circle:int=1;
		/** 直线
		 */		
		public static const RangeShape_Line:int=2;
		/**扇形
		 */		
		public static const RangeShape_Sector:int=3;
		/**  无类型 ，单机人物 直接触发，不用进行任何检测的吗，默认技能 ，单人攻击
		 */		
		public static const RangeShape_None:int=4;

		////特效播放类型
		//		1：  更新战斗   这里是直接响应战斗    受击者直接根据数据表播放数据
		//		
		//		2：定点  具有 一个目标点       受击者 技能播放 加上了技能的运动速度     一个运动技能   也就是造成直线攻击的效果 
		//		
		//		3： 根据时间响应战斗      相应的是 运动技能的战斗 多个运动技能动画 ，      一个受击者  一个运动技能动画 
		//		
		//		4：  攻击一个玩家    产生的效果是   技能多次攻击  就是多击效果  多个运动技能打到一个玩家身上
		//		
		//		5： 更新   技能无速度 但有目标点  在    updateFight1  的 基础修改个 天空层的技能  天空层特效定位 是根据鼠标来定位的

		/**1：  更新战斗   这里是直接响应战斗    受击者直接根据数据表播放数据
		 */		
		public static const Fight_Effect_1:int=1;
		/**2：定点  具有 一个目标点       受击者 技能播放 加上了技能的运动速度     一个运动技能   也就是造成直线攻击的效果 
		 */		
		public static const Fight_Effect_2:int=2;
		/**3： 根据时间响应战斗      相应的是 运动技能的战斗 多个运动技能动画 ，      一个受击者  一个运动技能动画 
		 */		
		public static const Fight_Effect_3:int=3;
		
		
		/**4： 更新   技能无速度 但有目标点  在    updateFight1  的 基础修改个 天空层的技能  天空层特效定位 是根据鼠标来定位的
		 */
		public static const Fight_Effect_4:int=4;
		
		/**5：  攻击一个玩家    产生的效果是   技能多次攻击  就是多击效果  多个运动技能打到一个玩家身上
		 */
		public static const Fight_Effect_5:int=5;

		
		//////客户端程序配置     使用变量   转化   UseType  为 客户端需要的类型
		/**有目标点的攻击  对   零到多人
		 */		
		public static const FightType_MorePt:int=1;
		/**多人攻击  ,有目标才发起攻击  没有目标则不发起攻击  
		 */		
		public static const FightType_MoreRole:int=2;
		/**  不管有没有目标点 都进行攻击   零到多人
		 */		
		public static const FightType_MoreAll:int=3;
		
		/** 瞬移
		 */ 
		public static const FightType_BlinkMove:int=5;


		/**  皮肤具有方向
		 */		
		public static const Skin_HasDirection:int=1;
		/**  皮肤不具有方向
		 */
		public static const Skin_NoDirection:int=2;
		
		

		/**天空层特效 有旋转特效   也就是根究位置来旋转
		 * 运动技能旋转
		 */
		public static const  MoveSkillType_Rotate:int=1;
		/**运动技能不旋转
		 * 天空层不进行旋转
		 */
		public static const  MoveSkillType_NoRotate:int=2;

		
		public function TypeSkill()
		{
		}
		/**获取攻击类型
		 * use_type   技能使用类型
		 */		
		public static function getFightType(use_type:int):int
		{
			switch(use_type)
			{
				/////只对人
				case UseType_Player:
					return FightType_MoreRole;
					break;
				///只对点
				case UseType_Point:
					return FightType_MorePt;
					break;
				case UseType_Fire:
					return FightType_MoreAll;
					break;
//				case UseType_Passive:
//				 	break;
//				case UseType_Switch:
//					 break;
			}
			return -1;
		}
		
		
		
		
	}
}