package com.YFFramework.game.core.module.mapScence.model.fight
{
	import com.YFFramework.core.center.pool.AbsPool;

	/**
	 *  客户端返回战斗信息
	 *  群攻   无点  对多人发起攻击   该攻击 不带 目标终点
	 * @author yefeng
	 *2012-9-4下午10:27:39
	 */
	public class FightMoreResultVo extends AbsPool
	{
		/**攻击者动态id 
		 */ 
		public var atkId:String;
		/**受击者玩家的具体信息 保存的时候FightHurtVo 
		 */ 
		public var uAtkArr:Array;
		
		/**使用的技能
		 */ 
		public var skillId:int;
	
		public var skillLevel:int;
		public function FightMoreResultVo()
		{
		}
		
		override public function reset():void
		{
			atkId=null;
			uAtkArr=null;
		}	
		
		
	}
}