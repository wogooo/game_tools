package com.YFFramework.game.core.module.mapScence.model.proto
{
	/**
	 *  场景模块通讯命令
	 * 2012-8-3 上午10:36:03
	 *@author yefeng
	 */
	public class CMDMapScence
	{
		
		/**其他角色进入主角可视范围
		 */ 
		public static const S_OtherRoleEnterView:int=100;
		
		/** 主角进入场景 
		 */
		public static const S_HeroEnterMap:int=101;
		
		/**
		 * 其他角色进入 主角 可视范围内
		 */
		public static const S_OtherRoleListEnterView:int=102;
		
		/**
		 *  其他角色列表离开主角的可视范围内    多个角色
		 */
		public static const S_OtherRoleListExitView:int=103;
		
		/**
		 *  其他角色离开主角可视范围  单一角色
		 */
		public static const S_OtherRoleExitView:int=104;
		
		
		
		/** 主角刚开始进行移动   玩家刚开始移动注释掉了,该方法导致人物挑战到其他点出现bug
		 */		
//		public static const C_HeroBeginMovePath:int=105;
//		/**其他角色开始进行移动                        玩家刚开始移动注释掉了,该方法导致人物挑战到其他点出现bug
//		 */		 
//		public static const S_OtherRoleBeginMove:int=106;
		
		/**主角正在移动中   返回 S_OtherRoleMoving
		 */		
		public static const C_HeroMoving:int=107;
		/** 其他角色正处在移动当中
		 */		
		public static const S_OtherRoleMoving:int=107;
		
		
		/**怪物 处于移动当中
		 */ 
		public static const C_MonsterMoving:int=108;
		
		/** 返回怪物处于移动当中
		 */ 
		public static const S_MonsterMoving:int=108;
		
		
		/**
		 * 怪物开始移动
		 */
		public static const S_MonsterBeginMove:int=109;
		
		/**客户端通知服务端怪物开始移动
		 */ 
		public static const C_MonsterBeginMove:int=109;
		
		/**
		 * 怪物进入玩家可视范围
		 */
		public static const S_MonsterEnterView:int=110;
		
		/**
		 * 怪物离开玩家可视范围
		 */
		public static const S_MonsterExitView:int=111;
		
		/**服务端通知客户端怪物停止移动
		 */ 
		public static const S_MonsterStopMove:int=112;
		
		/**怪物停止移动
		 */ 
		public static const C_MonsterStopMove:int=112;
		
		/** 主角请求瞬移
		 */		
		public static const C_BlinkMove:int=113;
		/** 服务端返回瞬移结果
		 */
		public static const S_BlinkMove:int=113;
		/** 推开角色 或者拉取角色   进行通讯 告知服务端该角色的位置发生改变   
		 * 
		 */		
		public static const C_BackSlideMove:int=114;
		/** 推开角色 或者拉取角色  
		 * 返回坐标 与其他屏幕玩家的坐标进行校验
		 */
	//	public static const S_BackSlideMove:int=114;
		
		/**   活动对象离开场景 比如玩家退出 怪物死完 宠物收回等
		 */		
		public static const S_AnimatorExitScence:int=115;
		
		/**怪物死完 离开场景
		 */
		public static const  S_MonsterExitScence:int=116;

		/**人物死完 /宠物死完
		 */
		public static  const S_RoleDead:int=117;
		
		/**发送客户端玩家下坐骑
		 */		
		public static const C_DisMounting:int=119;
		
		/**接收客户端玩家下坐骑
		 */
		public static const S_DisMounting:int=119;
		
		/**发送客户端玩家上坐骑
		 */		
		public static const C_Mounting:int=120;
		
		/**接收客户端玩家下坐骑
		 */
		public static const S_Mounting:int=120;
		/**切换场景
		 */		
		public static const C_ChangeMapScence:int=121;
		
		/**请求打坐
		 */ 
		public static const C_Sit:int=123;
		/**成功打坐返回
		 */		
		public static const S_Sit:int=123;
		/**请求离开打坐状态
		 */		
		public static const C_OutSit:int=124;
		/**返回离开打坐状态
		 */		
		public static const S_outSit:int=124;
		
		/**怪物出生
		 */
		public static const S_MonsterBirth:int=125;
		
		/**人物复活
		 */
		public static const  S_RoleRevive:int=126;
		/**人物复活
		 */
		public static const  C_RoleRevive:int=126;
		
		/**玩家跳到目标点
		 */		
		public static const C_SKipToPoint:int=127;
		/**玩家跳到目标点 跳到目标点
		 */		
		public static const S_SKipToPoint:int=127;

		/**要跳到点为障碍点 不能跳
		 */
		public static const S_FailSKipToPoint:int=128;
		/**主角停止移动
		 */
//		public static const C_HeroStopMove:int=129;
//		/**主角停止移动
//		 */
//		public static const S_HeroStopMove:int=129;

		
		
		
		/**开始战斗
		 */		
		public static const C_FightMore:int=140;
		/**服务端返回开始战斗  群攻
		 */		
		public static const S_FightMore:int=140;
		/** 群攻 带有坐标点
		 */		
		public static const C_FightMorePt:int=141;
		/**服务端返回开始战斗  群攻 带有坐标点
		 */		
		public static const S_FightMorePt:int=141;
		/** 单一战斗
		 */
		public static const C_FightSingle:int=142;
		/**单一战斗 返回
		 */		
		public static const S_FightSingle:int=142;

		
		
		////宠物 
		
		
		/**宠物进入视野
		 */
		public static const  S_PetEnterView:int=150;
		
		/**宠物离开视野
		 */
		public static const  S_PetExitView:int=151;
		
		/**宠物移动
		 */
		public static const  C_PetMoving:int=152;
		/**服务端返回宠物移动
		 */
		public static const  S_PetMoving:int=152;
		
		/**拉取宠物      宠物和人之间的距离太大时采用拉取
		 */ 
		public static const C_PullPet:int=153;
		
		public static const S_PullPet:int=153;
		
		
		/** 宠物向目标对象靠近 准备攻击
		 */
		public static const S_PetMoveToTarget:int=154;
		
		
		
		
		
		
		
		
		
		
		/** 怪物设置目标
		 */
		public static const S_MonsterSetTarget :int =170;
		
		/**
		 * 怪物解除目标
		 */
		public static const S_MonsterFreeTarget :int =171;
		
		/**
		 * 怪物向玩家靠近
		 */
		public static const S_MonsterNearToPlayer :int =172;
		
		/**
		 * 该区域内对玩家进行攻击
		 */
		public static const S_MonsterHitPlayer :int =173;
		
		/**
		 * 怪物在该区域内进行巡逻
		 */
		public static const S_MonsterWalkAround :int =174;
		
		/**怪物回到出生点
		 * */
		public static const S_MonsterMoveBack :int =175;
		
		
		/**掉落物品进入人物视野
		 */
		public static const  S_DropGoodsEnterView:int=180;
		/**拾取 掉落 物品
		 */ 
		public static const C_GetDropGoods:int=181;
		
		/**拾取物品失败  拾取了 不属于自己的物品
		 */
		public static const  S_FailToGetDropGoods:int=182;
		
		public function CMDMapScence()
		{
		}
	}
}