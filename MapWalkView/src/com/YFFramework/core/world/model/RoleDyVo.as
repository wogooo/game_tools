package com.YFFramework.core.world.model
{
	import com.YFFramework.core.world.model.type.EquipCategory;
	import com.YFFramework.core.world.model.type.TypeRole;
	import com.YFFramework.game.core.module.pet.model.PetDyVo;

	/** 角色vo
	 * @author yefeng
	 *2012-4-22上午11:09:54
	 */
	public class RoleDyVo extends PetDyVo
	{
		/**是否在坐骑上 值为 TypeRole.Player__里面  三种状态 正常  坐骑  打坐 三种状态
		 */
		public var state:int;
		/**人物性别 
		 */
		public var sex:int;
		
		/**职业
		 */
		public var career:int;

		public function RoleDyVo()
		{
			bigCatergory=TypeRole.BigCategory_Player;
		}
		
	}
}