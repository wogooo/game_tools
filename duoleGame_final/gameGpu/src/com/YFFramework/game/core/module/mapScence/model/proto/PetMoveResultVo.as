package com.YFFramework.game.core.module.mapScence.model.proto
{
	/**@author yefeng
	 *2012-9-23下午2:08:34
	 */
	import com.YFFramework.game.core.module.mapScence.world.model.PlayerMoveResultVo;
	
	public class PetMoveResultVo extends PlayerMoveResultVo
	{
		/**宠物移动结束的返回
		 */ 
		public var direction:int;
		public function PetMoveResultVo()
		{
			super();
		}
	}
}