package com.YFFramework.game.core.module.mount.model
{
	/**
	 * @version 1.0.0
	 * creation time：2013-4-24 上午11:21:30
	 * 
	 */
	public class MountBasicVo{

		public var basic_id:int;
		public var mount_type:String;
		public var physique:int;
		public var strength:int;
		public var agility:int;
		public var intell:int;
		public var spirit:int;
//		public var addPhy:int;
//		public var addStr:int;
//		public var addAgi:int;
//		public var addInt:int;
//		public var addSpi:int;
		/**品质：1-白色；2-绿色；3-蓝色；4-紫色；5-橙色； 
		 */
		public var quality:int;
		public var speed:int;
		/**面板显示的速度 
		 */		
		public var displaySpeed:int;
		public var icon_id:int;
//		public var icon_id1:int;
//		public var icon_id2:int;
//		public var icon_id3:int;
//		public var icon_id4:int;
//		public var model_id1:int;
//		public var model_id2:int;
//		public var model_id3:int;
//		public var model_id4:int;
		public var model_id:int;
		/**模型组件数量：1或者2；1的话，直接从mounthead文件读取；2的话分别从mounthead和mountbody读取
		 * Typeprops.MOUNT_PARTS_1
		 */		
		public var parts:int;
		public var advanceId:int;
		public var advancePropId:int;
		public var advancePropNum:int;
	
		public function MountBasicVo(){
		}
	}
} 