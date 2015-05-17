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
		
		/**主角发生移动
		 */
		public static const HeroMove:String=Path+"HeroMove";
		
		/**人物角色走到目标点
		 */
		public static const HeroMoveTopt:String=Path+"HeroMoveTopt";
		/**对角色进行攻击 
		 */		
		public static const FightPlayer:String=Path+"FightPlayer";
		
		
		/** 客户端通知服务端  进行场景切换
		 */
		public static const C_ChangeBgMap:String=Path+"C_ChangeBgMap";
		/** 主角发生移动 通知服务端进行广播   主角刚开始移动
		 */		
		public static const C_HeroBeginMovePath:String=Path+"C_HeroBeginMovePath";
		/**其他角色开始移动
		 */		
		public static const S_OtherRoleBeginMovePath:String=Path+"S_OtherRoleBeginMovePath";
		
		
		/** 主角切换场景 进入新场景 
		 */ 
		public static const S_HeroEnterMap:String=Path+"S_HeroEnterMap";
		
		/**其他角色进入可视范围 
		 */ 
		public static const S_OtherRoleEnterView:String=Path+"S_OtherRoleEnterView";
		/**其他角色列表进入可视范围
		 */		
		public static const S_OtherRoleListEnterView:String=Path+"S_OtherRoleListEnterView";
		
		/**
		 *其他角色离开主角可视范围 
		 */		
		public static const S_OtherRoleExitView:String=Path+"S_OtherRoleExitView";
		
		
		/**
		 *其他角色列表离开主角可视范围 
		 */		
		public static const S_OtherRoleListExitView:String=Path+"S_OtherRoleListExitView";
		
		/**主角正在移动  处在移动当中
		 */
		public static const C_HeroMoving:String=Path+"C_HeroMoving";
		
		/**其他角色正在进行移动
		 */
		public static const S_otherRoleMoving:String=Path+"S_otherRoleMoving";
		
		/**玩家离线
		 */
		public static const S_playerExit:String=Path+"S_playerExit";
		/**玩家切换坐骑状态
		 */		
		public static const S_MountChange:String=Path+"S_MountChange";
		
		public function MapScenceEvent()
		{
		}
	}
}