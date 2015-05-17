package com.YFFramework.game.core.module.mapScence.model.proto
{
	/**宠物向目标玩家靠近 准备攻击
	 * 2012-10-31 下午2:51:29
	 *@author yefeng
	 */
	public class PetMoveToTargetResultVo
	{
		/**宠物 动态id 
		 */
		public var petId:String;
		
		/**目标对象id   targetId   宠物 要靠近的对象   准备发起攻击 
		 */
		public var  tId:String;
		public function PetMoveToTargetResultVo()
		{
		}
	}
}