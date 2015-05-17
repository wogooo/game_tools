package com.YFFramework.game.core.module.pet.model
{
	/**@author yefeng
	 *2012-9-16下午10:05:18
	 */
	import com.YFFramework.core.world.model.MonsterDyVo;
	import com.YFFramework.core.world.model.type.TypeRole;
	
	public class PetDyVo extends MonsterDyVo
	{
		/**宠物等级
		 */ 
		public var level:int;
		/**宠物品质 极品多少星
		 */		
		public var quality:int;
		public function PetDyVo()
		{
			super();
			bigCatergory=TypeRole.BigCategory_Pet;

		}
	}
}