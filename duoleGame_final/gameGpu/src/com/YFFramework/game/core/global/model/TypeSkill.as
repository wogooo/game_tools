package com.YFFramework.game.core.global.model
{
	

	/**  技能类型
	 *  具有单一个攻击 和群攻 两种类型
	 * 2012-9-5 下午4:03:10
	 *@author yefeng
	 */
	public class TypeSkill
	{
		
		/**职业技能(人物技能) */		
		public static const BigCategory_Career:int=0;
		/**通用技能(人物技能) */		
		public static const BigCategory_Common:int=1;
		/** 工会技能(人物技能) */
		public static const BigCategory_union:int=2;
		/** 宠物技能(宠物技能) */
		public static const BigCategory_Pet:int=3;
		/////////////////////////////////////////////////// 技能表字段
		//////////// 技能表 skill use_type字段类型   使用类型
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
		
		/**瞬移
		 */
		public static const UseType_Blink:int=6;
		
		//使用限制   use_limit    配置表 use_limit字段
		/**没有任何使用限制 
		 */		
		public static const UseLimit_None:int=0;
		/**  只有战斗状态能够使用的 技能
		 */		
		public static const UseLimit_Fight:int=2;
		/** 只有非战斗状态才能使用的技能
		 */		
		public static const UseLimit_NoFight:int=3;
		///特殊技能类型  
		
		public static const SpecialEffetType_None:int=0;
		/** 冲锋
		 */		
		public static const SpecialEffetType_Assault:int=1;

		/**复活    对目标使用
		 */		
		public static const SpecialEffetType_Revive:int=2;
		/** 净化
		 */		
		public static const SpecialEffetType_Clean:int=3;
		/**击退
		 */		
		public static const SpecialEffetType_BeatBack:int=4;
		/**挑衅
		 */		
		public static const SpecialEffetType_Provok:int=5;
		/**瞬移
		 */		
		public static const SpecialEffetType_Blink:int=6;
		/**瞬步
		 */		
		public static const SpecialEffetType_SkipStep:int=7;
		/** 召唤
		 */		
		public static const SpecialEffetType_Call:int=8;
		/**扣魔
		 */
		public static const SpecialEffetType_SubMp:int=9;
//		/**增加技能伤害
//		 */
//		public static const SpecialEffetType_AddDamage:int=10;
//		/**添加buff时间
//		 */
//		public static const SpecialEffetType_AddBuffTime:int=11;
//		/**增加陷阱时间
//		 */
//		public static const SpecialEffetType_AddTrapTime:int=12;


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
		
		/**自己
		 */
		public static const AffectGroup_Self:int=9;
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
		
		/**具有目标点   飞行技能   技能  飞行到目标点  产生爆炸  并且对爆炸周围产生伤害的  播放效果
		 */
		public static const Fight_Effect_5:int=5;
		/**11 代表瞬步
		 */
		public static const Special_Fight_Effect_11:int=11;
		/** 12代表冲锋
		 */			
		public static const Special_Fight_Effect_12:int=12;

		/**13 瞬移
		 */
		public static const Special_Fight_Effect_13:int=13;

		
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
		public static const FightType_BlinkMove:int=4;

		
		/**开关技能
		 */
		public static const FightType_Switch:int=5;


		/**  皮肤具有方向
		 */		
		public static const Skin_HasDirection:int=1;
		/**  皮肤不具有方向
		 */
		public static const Skin_NoDirection:int=2;
		/** 单一方向进行  8方向旋转
		 */
		public static const Skin_RotateDirection:int=3;

		

		/**天空层特效 有旋转特效   也就是根究位置来旋转
		 * 运动技能旋转
		 */
		public static const  MoveSkillType_Rotate:int=1;
		/**运动技能不旋转
		 * 天空层不进行旋转
		 */
		public static const  MoveSkillType_NoRotate:int=2;
		
		
		
		
		////处理 buff类型   //对应  buff表的说明
		
		/**定身
		 */
		public static const Buff_DingShen:int=5;
		
		/**晕眩
		 */
		public static const Buff_YunXuan:int=6;
		/**沉默
		 */
		public static const Buff_ChenMo:int=7;
		
		
		
		/** buff显示在上层
		 */
		public static const BuffLayer_Up:int=1;

		/** buff显示在下层
		 */
		public static const BuffLayer_Down:int=2;
		
		/**显示buff图标*/
		public static const BuffShow_yes:int=1;
		/**不显示buff图标*/
		public static const BuffShow_no:int=0;
		
		
		
		
		
		//粒子特效配置
		/**粒子上层特效
		 */
		public static const ParticleLayer_Up:int=1;
		
		/**粒子下层特效
		 */
		public static const ParticleLayer_Down:int=0;

		
		/**不进行旋转
		 */
		public static const ParticleLayer_Rotate_NONE:int=0;

		/** 360度 旋转
		 */
		public static const ParticleLayer_Rotate_360:int=1;
		/**随机旋转
		 */
		public static const ParticleLayer_Rotate_Random:int=2;
		
		
		/**粒子跟随类型
		 */
		public static const ParticleType_Follow:int=0;

		/**作为释放点类型  
		 */
		public static const ParticleType_Point:int=1;

		
		
		
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
				case UseType_Blink: //瞬移
					return FightType_BlinkMove;
					break;
				case UseType_Switch:
					return FightType_Switch;
					break;
			}
			return -1;
		}
		
		
	}
}