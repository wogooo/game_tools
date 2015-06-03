package com.YFFramework.game.core.module.mapScence.model.proto
{
	import com.YFFramework.core.center.pool.AbsPool;

	/** 其他角色离开你主角视野 进行移出的vo
	 * @author yefeng
	 *2012-8-4上午10:05:44
	 */
	public class RemoveOtherRoleVo extends AbsPool
	{
		/**移出角色的动态id 
		 */
		public var roleId:uint;
		public function RemoveOtherRoleVo()
		{
		}
		override public function reset():void
		{
			roleId=0;
		}
		override protected function regObject():void
		{
			regPool(5);
		}
	}
}