package com.YFFramework.game.core.global.model
{
	import com.YFFramework.game.core.global.manager.SpeedManager;
	import com.YFFramework.game.core.module.mapScence.world.model.RoleDyVo;

	/**
	 *  主角玩家角色信息
	 * @author yefeng
	 *2012-4-29上午12:04:01
	 */
	public class RoleSelfVo 
	{
	
				
		public var heroState:HeroState;
		/**角色vo  装备等的动态属性全部在这个里面
		 */		
		public var roleDyVo:RoleDyVo;

		
		/**当前经验
		 */ 
		public var exp:int;
		
		
		/** 前一等级
		 */
		public var preExp:int;
		
		/**前一等级
		 */
		public var preLevel:int;
	
		/**最大经验  通过查表
		 */ 
//		public var maxExp:int;
		
		/** PK模式   字符串获取  来自  TypeRole
		 */		
		public var pkMode:int;
		
		
		/**原地复活消耗 5点魔砖
		 */
		public  const YuanDiReviveCost:int=5;
		
		/**魔钻    充值
		 */				
		public var diamond:int;
		/**礼券    充值
		 */
		public var coupon:int;

		/**银币  不绑定 
		 */
//		public var silver:int;
		/**银锭（绑定）   绑定
		 */
		public var note:int;
		
		/**血池 
		 */		
		public var hpPool:int;
		/**魔池 
		 */		
		public var mpPool:int;
		/**宠物血池*/		
		public var petHpPool:int;
		/**人物行走速度
		 */
		public var speedManager:SpeedManager;
		/**是否在战斗状态中
		 */		
		public var isFight:Boolean;
		
		public function RoleSelfVo(){
		//	fightSkillList=new Vector.<int>();
			speedManager=new SpeedManager();
			heroState=new HeroState();
		}
		
		
		
		

	}
}