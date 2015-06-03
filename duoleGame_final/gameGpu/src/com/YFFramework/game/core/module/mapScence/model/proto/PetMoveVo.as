package com.YFFramework.game.core.module.mapScence.model.proto
{
	import com.YFFramework.game.core.module.mapScence.world.model.MonsterMoveVo;
	
	/**2012-9-20 下午1:56:09
	 *@author yefeng
	 */
	public class PetMoveVo extends MonsterMoveVo
	{
		/**宠物移动结束后站立的方向
		 */ 
		public var direction:int;
		public function PetMoveVo()
		{
			super();
		}
	}
}