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
		/** 默认状态
		 */
		public static const StateNone:int=-1;
		/**切磋状态 将要处理的事件    人物  先向  目标 靠近 然后 发起  切磋 
		 */		
		public static const ToCompete:int=1;
		/** 交易状态    将要处理的事件 人物  先向  目标 靠近 然后 发起交易
		 */		
		public static const ToTrade:int=2;
		/** 向目标点靠近后打开npc面板
		 */		
		public static const ToOpenNPCWindow:int=3;
		/**任务时,向目标点靠近 去攻击怪物 
		 */		
		public static const ToFightMonster:int=4;

		
//		public var openNPCWindowParam:Object;
//		public static const To
		/** 是否处于战斗状态   处于战斗状态人物不能进行移动  只有处于非战斗状态人物才能进行移动  处于锁定状态下
		 */
		private var _isLock:Boolean;
		
		/**人物将要做的事情，可能是走到某点，由于该点是在播放技能的过程中产生的  技能播完后 走到该点    也可能是将要对某个对象发起攻击
		 * 类型为  playerView 或者point 
		 */
		private var _willDo:Object;
		/**任务时 向目标点靠近    任务将要做的事情
		 */	
		public var taskWinDoVo:TaskWillDoVo;
		
		/** 假如攻击类型为人的话 触发的技能id
		 */		
		public var skillId:int;
		/**是否为攻击技能  当willDo 为point时 可能 为目标点技能    也可能为玩家将要行走到的目标点
		 */		
		public var isAtkSkill:Boolean;
		
		/**将要做的状态类型 比如切磋   
		 */		
		private var _state:int;
		private var _lockTime:Number;
		public function HeroState()
		{
			isLock=false;
			_state=StateNone;
		}
		/**设置默认值 最好 给值1 int 型即可   设置 为 1  将会清掉 其他数据 这里赋值时请注意
		 */		
		public function set willDo(value:Object):void
		{
			_willDo=value;
			if(_willDo==null||_willDo ==1)
			{
				skillId=-1;
				isAtkSkill=false;
				_state=StateNone;
//				openNPCWindowParam=null;
				taskWinDoVo=null;
			}
			else if(value is Point==false)
			{
				isAtkSkill=false;
			}
		}
		/**设置默认值
		 */		
		public function setDefaultWillDo():void
		{
			willDo=1;
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
		/**设置状态
		 */		
		public function get state():int
		{
			return _state;
		}
		/**设置状态
		 */		
		public function set state(value:int):void
		{
			 _state=value;
//			 if(_state==StateNone)openNPCWindowParam=null;
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