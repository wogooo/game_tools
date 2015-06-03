package com.YFFramework.game.core.module.smallMap.model
{
	/**小地图上面点击的  目标点  包含场景  id  以及坐标信息    类似于 怪物区域  信息   只是这个信息是由玩家字节产生的
	 * @author yefeng
	 * 2013 2013-6-7 下午2:02:35 
	 */
	public class SmallMapWorldVo
	{
		/**目标场景id 
		 */		
		public var sceneId:int;
		/** 目标点X坐标 
		 */		
		public var pos_x:int;
		/** 目标点Y坐标 
		 */		
		public var pos_y:int;
		public function SmallMapWorldVo()
		{
		}
	}
}