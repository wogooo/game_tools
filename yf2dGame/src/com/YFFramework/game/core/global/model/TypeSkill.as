package com.YFFramework.game.core.global.model
{
	/**  技能类型
	 *  具有单一个攻击 和群攻 两种类型
	 * 2012-9-5 下午4:03:10
	 *@author yefeng
	 */
	public class TypeSkill
	{
		
		/** 单一攻击  默认攻击     fightSkill里面的 type 类型     单一技能必须要有目标才能发出,   Much 为发出的技能是多次播放 的   运动性的技能 多个运动鞋性的技能进行播放
		 */  
		public static  const Atk_Single_Default:int=1;
		
		/**没有目标时不能发出技能 发出的技能 为运动技能 具有多次播放攻击 
		 */		
		public static  const Atk_Single_Much:int=2;
		/** 单一攻击    按下鼠标键 或者有目标对象都会触发该技能
		 */		
		public static const Atk_Single_One:int=3;

		/**攻击鼠标点悬停的对象
		 */ 
		public static const Atk_Single_MouseTarget:int=4;
		
		
		/**群攻    有点   发出技能  技能不具有运动速度而是直接播放       圆形检测
		 */ 
		public static  const Atk_Circle_Pt_NoSpeed:int=5;
		
		/**群攻  无点 群攻    没有目标 不发技能    具有速度
		 */ 
		public static  const Atk_Circle_NoPt_Speed:int=6;
		/**群攻  无点 群攻    没有目标 不发技能     技能不具有速度 直接发出
		 */		
		public static  const Atk_Circle_NoPt_NoSpeed:int=7;

		/**  群攻  3条直线检测   有点  点来确定方向    技能是运动的
		 */		
		public static  const Atk_ThreeLine_Pt_Speed:int=8;

		/** 有点 群攻   直线群攻 
		 * 在线上的对象  攻击   技能具有运动速度    根据时间响应战斗      相应的是 运动技能的战斗  一条直线上的战斗 ,只有一个运动技能动画 ，    一个攻击完之后穿过去攻击另一个的效果
		 */ 
		public static const Atk_LineMore_Pt_Speed:int=9;
		
		/** 瞬移
		 */ 
		public static const Atk_BlinkMove:int=10;
		
		
		/**技能 坐标位置   是以 攻击者为参照对象 还是被攻击者为参照对象    1  表示攻击者为参照 2 表示被攻击者为参照
		 */		
		public static const SkillPosition_Atk:int=1;
		/**技能 坐标位置   是以 攻击者为参照对象 还是被攻击者为参照对象    1  表示攻击者为参照 2 表示被攻击者为参照
		 */		
		public static const SkillPosition_UAtk:int=2;

		
		/**  皮肤具有方向
		 */		
		public static const Skin_HasDirection:int=1;
		/**  皮肤不具有方向
		 */
		public static const Skin_NoDirection:int=2;

		
		//////技能产生的特效类型  是拉取人物 还是推离人物 还是 不做任何处理
		
		/**拉取人物
		 */ 
		public static const Effect_Pull:int=1;	
		/**推开人物
		 */		
		public static const Effect_push:int=2;
		/**  对人物不做任何推拉处理
		 */		
		public static const Effect_None:int=3;
		
		public function TypeSkill()
		{
		}
		/**該技能是否具有運動速度
		 */		
		public static function isSpeedSkill(type:int):Boolean
		{
			if(type==Atk_Circle_NoPt_Speed||type==Atk_ThreeLine_Pt_Speed||type==Atk_LineMore_Pt_Speed) return true;
			return false;
		}
	}
}