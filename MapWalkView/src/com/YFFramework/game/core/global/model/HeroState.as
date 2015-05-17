package com.YFFramework.game.core.global.model
{
	import flash.geom.Point;
	import flash.utils.getTimer;

	/**  主角的当前状态 
	 * 2012-9-5 上午10:57:19
	 *@author yefeng
	 */
	public class HeroState
	{
		/** 是否处于战斗状态   处于战斗状态人物不能进行移动  只有处于非战斗状态人物才能进行移动  处于锁定状态下
		 */
		private var _isLock:Boolean;
		
		/**人物将要做的事情，可能是走到某点，由于该点是在播放技能的过程中产生的  技能播完后 走到该点    也可能是将要对某个对象发起攻击
		 * 类型为  playerView 或者point 
		 */
		private var _willDo:Object;
		/** 假如攻击类型为人的话 触发的技能id
		 */		
		public var skillId:int;
		/**是否为攻击技能  当willDo 为point时 可能 为目标点技能    也可能为玩家将要行走到的目标点
		 */		
		public var isAtkSkill:Boolean;

		private var _lockTime:Number;
		public function HeroState()
		{
			isLock=false;
		}
		
		public function set willDo(value:Object):void
		{
			_willDo=value;
			if(_willDo==null)
			{
				skillId=-1;
				isAtkSkill=false;
			}
			else if(value is Point==false)
			{
				isAtkSkill=false;
			}
		}
		
		public function get willDo():Object
		{
			return _willDo;
		}
		public function set  isLock(value:Boolean):void
		{
			
			_isLock=value;
			_lockTime=getTimer();
		}
		
		public function get isLock():Boolean
		{
			if(_isLock)
			{
				if(getTimer()-_lockTime>=1500)_isLock=false
			}
			return _isLock;
		}
		
		
		
		
	}
}