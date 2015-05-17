package com.YFFramework.core.world.mapScence.events
{
	/**  游戏场景中事件
	 * 
	 * @author yefeng
	 *2012-4-20下午11:53:16
	 */
	public class MapScenceEvent
	{
		private static const Path:String="com.YFFramework.game.core.event.";
		
		/**主角发生移动  只有当 地图满足滚屏条件时才触发 
		 */
		public static const HeroMove:String=Path+"HeroMove";
		/** 主角发生移动 ， 只有主角处理   表示主角在移动  摄像机内部触发
		 */		
		public static const HeroMoving:String=Path+"HeroMoving";
		/**主角发生移动  小地图调用该方法
		 */		
		public static const HeroMoveForSmallMap:String=Path+"HeroMoveForSmallMap";

		
		/**人物角色走到目标点
		 */
		public static const HeroMoveTopt:String=Path+"HeroMoveTopt";
		/**对角色进行攻击 
		 */		
	//	public static const FightPlayer:String=Path+"FightPlayer";
		
		/**向目标靠近 准备攻击
		 */ 
		public static const MoveToPlayerForFight:String=Path+"MoveToPlayerForFight";
		
		
		/** 客户端通知服务端  进行场景切换
		 */
		public static const C_ChangeMapScence:String=Path+"C_ChangeMapScence";
//		/** 服务端返回切换场景结果
//		 */		
//		public static const S_ChangeMapScence:String=Path+"S_ChangeMapScence";

		/** 主角发生移动 通知服务端进行广播   主角刚开始移动   ///  玩家刚开始移动注释掉了,该方法导致人物挑战到其他点出现bug
		 */		
//		public static const C_HeroBeginMovePath:String=Path+"C_HeroBeginMovePath";
		/**其他角色开始移动   玩家刚开始移动注释掉了,该方法导致人物挑战到其他点出现bug
		 */		 
//		public static const S_OtherRoleBeginMovePath:String=Path+"S_OtherRoleBeginMovePath";
		
		
		/** 主角切换场景 进入新场景 
		 */ 
//		public static const S_HeroEnterMap:String=Path+"S_HeroEnterMap";
		
		/**其他角色进入可视范围 
		 */ 
//		public static const S_OtherRoleEnterView:String=Path+"S_OtherRoleEnterView";
//		/**其他角色列表进入可视范围
//		 */		
//		public static const S_OtherRoleListEnterView:String=Path+"S_OtherRoleListEnterView";
		
		/**
		 *其他角色离开主角可视范围 
		 */		
//		public static const S_OtherRoleExitView:String=Path+"S_OtherRoleExitView";
		
		
		/**
		 *其他角色列表离开主角可视范围 
		 */		
//		public static const S_OtherRoleListExitView:String=Path+"S_OtherRoleListExitView";
		
		
		/**主角正在移动  处在移动当中
		 */
		public static const C_HeroMoving:String=Path+"C_HeroMoving";
		
		/**其他角色正在进行移动
		 */
		public static const S_otherRoleMoving:String=Path+"S_otherRoleMoving";
		
		/**玩家离线  或者 宠物收回
		 */
		public static const S_AnimatorExitScence:String=Path+"S_AnimatorExitScence";
		
		/** 怪物死亡 离开场景
		 */		
		public static const S_MonsterExitScence:String=Path+"S_MonsterExitScence";
		/**  人物死亡
		 */		
		public static const S_RoleDead:String=Path+"S_RoleDead";
		/** 角色复活
		 */		
		public static const C_RoleRevive:String=Path+"C_RoleRevive";
		/** 角色复活
		 */		
		public static const S_RoleRevive:String=Path+"S_RoleRevive";

		
		/** 主角发生瞬移
		 */		
		public static const C_BlinkMove:String=Path+"C_BlinkMove";
		/** 玩家瞬移 服务端返回
		 */		
		public static const S_BlinkMove:String=Path+"S_BlinkMove";
		/** 推开角色 或者拉取角色   进行通讯 告知服务端该角色的位置发生改变   
		 */				
		public static const C_BackSlideMove:String=Path+"C_BackSlideMove";
		
		/**  服务端返回拉取结果  
		 */		
	//	public static const S_BackSlideMove:String=Path+"S_BackSlideMove";

		/**玩家切换坐骑状态
		 */		
		public static const S_Mounting:String=Path+"S_Mounting";
		/**玩家切换坐骑状态
		 */		
		public static const C_Mounting:String=Path+"C_Mounting";
		/** 下坐骑
		 */		
		public static const C_DisMounting:String=Path+"C_DisMounting";
		/**下坐骑
		 */		
		public static const S_DisMounting:String=Path+"S_DisMounting";
		
		/**  主角请求上坐骑
		 */		
		public static const RequestMount:String=Path+"RequestMount";
		/** 主角请求打坐
		 */
		public static const RequestSit:String=Path+"RequestSit";
		
		/**请求打坐
		 */ 
		public static const C_Sit:String=Path+"C_Sit";
		/**成功打坐返回
		 */		
		public static const S_Sit:String=Path+"S_Sit";
		/**请求离开打坐状态
		 */		
		public static const C_OutSit:String=Path+"C_OutSit";
		/**返回离开打坐状态
		 */		
		public static const S_outSit:String=Path+"S_outSit";
		/**人物停止移动
		 */		
//		public static const C_HeroStopMove:String=Path+"C_HeroStopMove";
//		/**人物停止移动
//		 */		
//		public static const S_HeroStopMove:String=Path+"S_HeroStopMove";

		

		/**开始战斗  多人战斗   无点  群攻  
		 */ 
		public static const S_FightMore:String=Path+"S_FightMore";
		/**开始战斗  无点  群攻
		 */ 
		public static  const C_FightMore:String=Path+"C_FightMore";
		
		/**开始战斗  多人战斗  有点  群攻
		 */ 
		public static const S_FightMore_Pt:String=Path+"S_FightMore_Pt";
		/**开始战斗    有点  群攻
		 */ 
		public static  const C_FightMore_Pt:String=Path+"C_FightMore_Pt";

		
		
		/**开始战斗  单人战斗  一个受击对象
		 */ 
//		public static const S_FightSingle:String=Path+"S_FightSingle";
//		/**开始战斗  单人战斗 一个受击对象
//		 */ 
//		public static  const C_FightSingle:String=Path+"C_FightSingle";

		
		
		
		
		/** 怪物正在处于移动中
		 */ 
		public static const C_MonsterMoving:String=Path+"C_MonsterMoving";
		
		/**怪物开始移动
		 */ 
		public static const C_MonsterBeginMove:String=Path+"C_MonsterBeginMove";
		
		/**  服务端通知 怪物开始移动   客户端 负责寻路然后将信息反馈给服务端 服务端进行广播
		 */ 
		public static const S_MonsterBeginMove:String=Path+"S_MonsterBeginMove";
		
		/** 服务端返回  怪物移动
		 */ 

		public static const S_MonsterMoving:String=Path+"S_MonsterMoving";
		
		/**  怪物进入主角可视范围
		 */ 
		public static const S_MonsterEnterView:String=Path+"S_MonsterEnterView";
		/**  怪物出生
		 */		
		public static const S_MonsterBirth:String=Path+"S_MonsterBirth";


		/**怪物离开主角可视范围
		 */ 
		public static const S_MonsterExitView:String=Path+"S_MonsterExitView";

		
		
		///////////////////怪物  ai 通讯
		
		/**  怪物设置目标对象
		 */ 
		public static const S_MonsterSetTarget:String=Path+"S_MonsterSetTarget";
		
		/**怪物解除目标对象
		 */ 
		public static const S_MonsterFreeTarget:String=Path+"S_MonsterFreeTarget";
		
		/**怪物向人物靠近
		 */ 
		public static const S_MonsterNearToPlayer:String=Path+"S_MonsterNearToPlayer";
		/**服务端通知客户端怪物停止移动
		 */ 
		public static const S_MonsterStopMove:String=Path+"S_MonsterStopMove";
		/**客户端通知服务端 该怪物需要停止移动
		 */
		public static const C_MonsterStopMove:String=Path+"C_MonsterStopMove";
		/**怪物对人进行攻击
		 */ 
		public static const S_MonsterHitPlayer:String=Path+"S_MonsterHitPlayer";
		
		
		
		
		////  宠物 
		
		/**服务端返回宠物进入视野
		 */ 
		public static const S_PetEnterView:String=Path+"S_PetEnterView";
		/**宠物离开视野
		 */		
		public static const S_PetExitView:String=Path+"S_PetExitView";
		/**宠物发生移动
		 */		
		public static const C_PetMoving:String=Path+"C_PetMoving";
		
		/**服务端返回宠物移动
		 */ 
		public static const S_PetMoving:String=Path+"S_PetMoving";

		/**拉取宠物
		 */ 
		public static const C_PullPet:String=Path+"C_PullPet";
		/**服务端返回拉取宠物
		 */ 
		public static const S_PullPet:String=Path+"S_PullPet";
		/**宠物向目标玩家靠近 准备发起攻击
		 */ 
		public static const S_PetMoveToTarget:String=Path+"S_PetMoveToTarget";
		
		/**物品掉落进入人物视野
		 */ 
		public static const S_DropGoodsEnterView:String=Path+"S_DropGoodsEnterView";
		/**玩家拾取 掉落物品
		 */
		public static const C_GetDropGoods:String=Path+"C_GetDropGoods";
		/**拾取物品失败
		 */		
		public static const S_FailToGetDropGoods:String=Path+"S_FailToGetDropGoods";
		
		
		///// 跳转到目标点
		/**跳转到目标点
		 */		
		public static const C_SKipToPoint:String=Path+"C_SKipToPoint";
		/**跳转到目标点
		 */		
		public static const S_SKipToPoint:String=Path+"S_SKipToPoint";
		/**跳转失败 因为跳转到目标点是障碍点 所以跳转失败
		 */		
		public static const S_FailSKipToPoint:String=Path+"S_FailSKipToPoint";

		
		////UI 通讯
		/**移除鼠标效果
		 */		
		public static const RemoveMouseEffect:String=Path+"RemoveMouseEffect";		
		/**删除死亡怪物 人物死亡 不触发
		 */		
		public static const DeleteDeadMonster:String=Path+"DeleteDeadMonster";

		public function MapScenceEvent()
		{
		}
	}
}