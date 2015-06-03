package com.YFFramework.game.core.module.mapScence.events
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
		
		
		/**主角移动完成触发 用来清除行走路线
		 */
		public static const HeroMoveComplete:String=Path+"HeroMoveComplete";
		
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
		
		/** 角色复活
		 */		
		public static const C_RoleRevive:String=Path+"C_RoleRevive";

		
		/** 主角发生瞬移
		 */		
		public static const C_BlinkMove:String=Path+"C_BlinkMove";
		/** 推开角色 或者拉取角色   进行通讯 告知服务端该角色的位置发生改变   
		 */				
		public static const C_BackSlideMove:String=Path+"C_BackSlideMove";
		
		/**  服务端返回拉取结果  
		 */		
	//	public static const S_BackSlideMove:String=Path+"S_BackSlideMove";
		/**玩家切换坐骑状态
		 */		
		public static const C_Mounting:String=Path+"C_Mounting";
		/** 下坐骑
		 */		
		public static const C_DisMounting:String=Path+"C_DisMounting";
		
		/**  主角请求上坐骑
		 */		
		public static const RequestMount:String=Path+"RequestMount";
		/** 主角请求打坐
		 */
		public static const RequestSit:String=Path+"RequestSit";
		
		/**请求打坐
		 */ 
		public static const C_Sit:String=Path+"C_Sit";
		/**请求离开打坐状态
		 */		
		public static const C_OutSit:String=Path+"C_OutSit";
		/**人物停止移动
		 */		
//		public static const C_HeroStopMove:String=Path+"C_HeroStopMove";
//		/**人物停止移动
//		 */		
//		public static const S_HeroStopMove:String=Path+"S_HeroStopMove";

		
		/**开始战斗  无点  群攻
		 */ 
		public static  const C_FightMore:String=Path+"C_FightMore";
		/**开始战斗    有点  群攻
		 */ 
		public static  const C_FightMore_Pt:String=Path+"C_FightMore_Pt";

		/**有点的击退
		 */
		public static  const C_FightMore_PtBeatBack:String=Path+"C_FightMore_PtBeatBack";

		/**无点的击退
		 */
		public static  const C_FightMoreBeatBack:String=Path+"C_FightMoreBeatBack";

		 
		
		
		
		/** 怪物正在处于移动中
		 */ 
		public static const C_MonsterMoving:String=Path+"C_MonsterMoving";
		
		/**怪物开始移动
		 */ 
		public static const C_MonsterBeginMove:String=Path+"C_MonsterBeginMove";
		
		
		
		
		///////////////////怪物  ai 通讯
		/**客户端通知服务端 该怪物需要停止移动
		 */
		public static const C_MonsterStopMove:String=Path+"C_MonsterStopMove";
		
		
		
		////  宠物 
		
		/**宠物发生移动
		 */		
		public static const C_PetMoving:String=Path+"C_PetMoving";
		
		

		/**拉取宠物
		 */ 
		public static const C_PullPet:String=Path+"C_PullPet";
		
		/**玩家拾取 掉落物品
		 */
		public static const C_GetDropGoods:String=Path+"C_GetDropGoods";
	
		/**获取大量的掉落物品
		 */
		public static const C_GetMoreDropGoods:String=Path+"C_GetMoreDropGoods";
		
		
		///// 跳转到目标点
		/**跳转到目标点
		 */		
		public static const C_SKipToPoint:String=Path+"C_SKipToPoint";
	

		
		////UI 通讯
		/**移除鼠标效果
		 */		
		public static const RemoveMouseEffect:String=Path+"RemoveMouseEffect";		
		/**删除死亡怪物 人物死亡 不触发
		 */		
		public static const DeleteDeadMonster:String=Path+"DeleteDeadMonster";
		
		///请求采集
		/**请求采集
		 */		
		public static const C_RequestGather:String=Path+"C_RequestGather";
	
		
		/**检测路径
		 */
		public static const CheckPath:String=Path+"CheckPath";
		
		/**战斗 发送复活技能 主角复活   移除  复活面板
		 */
		public static const FightForRevive:String=Path+"FightForRevive";
		
		/**角色 宠物 怪物 死亡
		 */
		public static const PlayerDead:String=Path+"PlayerDead"
		
		/**主角死亡停止移动
		 */
//		public static const HeroDeadToStopMove:String=Path+"HeroDeadToStopMove";
		
		

		public function MapScenceEvent()
		{
		}
	}
}