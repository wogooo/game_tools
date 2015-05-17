package com.YFFramework.core.world.model
{
	import com.YFFramework.core.world.model.type.EquipCategory;
	
	import flash.utils.Dictionary;

	/** 角色vo
	 * @author yefeng
	 *2012-4-22上午11:09:54
	 */
	public class RoleDyVo extends MonsterDyVo
	{
		
		
		/**已经装备的部位 长度固定           没有装备的部位的值为 0  装备了的部位的值为其具体的id 值
		 */
//		public var equipedArr:Vector.<int>;
		
		/**坐骑动态id   mountId 拿到  mount的  skinId     坐骑也当做装备处理
		 */
//		public var mountDyId:int;
		
		
		/**是否在坐骑上 
		 */
		public var isMount:Boolean;
		
		
		/**职业
		 */
		public var career:int;
		
		/**人物性别 
		 */
		public var sex:int;
		
		public function RoleDyVo()
		{
		}
		
		override protected function initData():void
		{
			/**已经装备的部位 长度固定           没有装备的部位的值为 0  装备了的部位的值为其具体的id 值
			 */
			equipedArr=new Vector.<String>(EquipCategory.ModelLen,true);
		}
	}
}