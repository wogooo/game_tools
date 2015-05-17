package com.YFFramework.game.core.global.model
{
	import com.YFFramework.core.utils.HashMap;
	import com.YFFramework.core.world.model.RoleDyVo;
	import com.YFFramework.game.core.global.manager.SpeedManager;

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
		protected var _roleDyVo:RoleDyVo;

		
		
		/**当前经验
		 */ 
		public var exp:int;
	
		/**最大经验  通过查表
		 */ 
//		public var maxExp:int;
		
		/** PK模式   字符串获取  来自  TypeRole
		 */		
		public var pkMode:int;
		
		
		/**魔钻
		 */				
		public var diamond:int;
		/**礼券
		 */
		public var coupon:int;

		/**银币
		 */
		public var silver:int;
		/**银锭（绑定）
		 */
		public var note:int;

		/**人物行走速度
		 */
		public var speedManager:SpeedManager;
		
		/**队友列表   dyId  ...roleDyVo
		 */		
		public var teamPlayers:HashMap;
		
		/**好友列表
		 */		
		public var friendPlayers:HashMap;
		
		public function RoleSelfVo()
		{
		//	fightSkillList=new Vector.<int>();
			speedManager=new SpeedManager();
			heroState=new HeroState();
			teamPlayers=new HashMap();
			friendPlayers=new HashMap();
		}
		/**  当前角色动态vo 
		 */
		public function get roleDyVo():RoleDyVo
		{
			return _roleDyVo;
		}

		/**
		 * @private
		 */
		public function set roleDyVo(value:RoleDyVo):void
		{
			_roleDyVo = value;
		}
		
		
		
		

	}
}