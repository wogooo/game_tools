package com.YFFramework.game.core.module.mapScence.model.proto
{
	/**
	 * 怪物停止移动协议vo 
	 * @author yefeng
	 *2012-9-24下午9:43:43
	 */
	import com.YFFramework.core.center.pool.AbsPool;
	
	public class MonsterStopMoveResultVo extends AbsPool
	{
		public var dyId:String;
		
		/**怪物的最终位置
		 */ 
		public var mapX:int;
		/**怪物的最终位置
		 */ 
		public var mapY:int;
		public function MonsterStopMoveResultVo()
		{
			super();
		}
		
		override public function reset():void
		{
			super.reset();
			dyId=null;
		}
	}
}