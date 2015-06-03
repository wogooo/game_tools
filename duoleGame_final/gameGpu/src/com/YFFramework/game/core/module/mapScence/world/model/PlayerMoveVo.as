package com.YFFramework.game.core.module.mapScence.world.model
{
	import flash.geom.Point;

	/**每  10 帧 平均  60像素  通讯一次
	 * 角色移动产生的vo 
	 * 2012-7-30 上午11:06:06
	 *@author yefeng
	 */
	public class PlayerMoveVo extends PlayerClientMoveVo
	{
		
		/** 角色当前位置    
		 */		
		public var curentPostion:Point;
		public function PlayerMoveVo()
		{
		}
		

	}
}