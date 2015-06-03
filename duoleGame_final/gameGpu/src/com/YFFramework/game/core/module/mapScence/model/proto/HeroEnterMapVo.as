package com.YFFramework.game.core.module.mapScence.model.proto
{
	/**
	 *  主角进入场景 通讯产生的vo 
	 * 2012-8-3 上午10:43:13
	 *@author yefeng
	 */
	public class HeroEnterMapVo
	{
		/** 角色 进入的场景 id  
		 */
		public var  mapId:int;
		
		/** 角色进入场景的 位置 
		 */
		public var  mapX:int;
		/** 角色进入场景的 位置 
		 */
		public var mapY:int;
		
				
		public function HeroEnterMapVo()
		{
		}
	}
}