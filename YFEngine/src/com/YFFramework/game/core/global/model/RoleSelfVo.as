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
		/**当前人物等级
		 */		
		public var level:int;
		
		/**当前血量
		 */ 
		public var hp:int;
		/**最大血量
		 */		
		public var maxHp:int;
		/**当前经验
		 */ 
		public var exp:int;
		/**最大经验
		 */ 
		public var maxExp:int;
		/**   人物金币数量
		 */		
		private var _gold:Number=0;
		/**人物元宝数量
		 */		
		private var _yuanBao:Number=0;
		
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
			level=1;
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
		
		
		/**获取经验百分比
		 */ 
		public function getExpPercent():Number
		{
			return exp/maxExp;
		}
		/**获取血量百分比   乘以 了 10000
		 */		
		public function getHpPercent():int
		{
			return hp*10000/maxHp;
		}

		
		public function updateYuanBao(value:Number):void
		{
			_yuanBao=value;
		}
		public function updateGold(value:Number):void
		{
			_gold=value;
		}
		
		public function get yuanBao():Number
		{
			return _yuanBao;
		}
		
		public function get gold():Number
		{
			return _gold;
		}
		
		

	}
}