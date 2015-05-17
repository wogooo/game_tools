package com.YFFramework.core.world.model
{
	import com.YFFramework.core.center.pool.AbsPool;
	import com.YFFramework.core.center.pool.IPool;

	/**@author yefeng
	 *2012-8-5上午11:44:00
	 */
	public class PlayerClientMoveVo extends AbsPool
	{
		/**发生移动的角色id 
		 */
		public var id:String;
		/**角色移动速度
		 */
		public var speed:Number;
		
		/** 角色的移动路径 
		 */
		public var path:Array;
		public function PlayerClientMoveVo()
		{
		}
		
		
		/**子类重写
		 * 重置对象至初始状态
		 */		
		override public function reset():void
		{
			id=null;
			speed=0;
		}
	}
}