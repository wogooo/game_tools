package com.YFFramework.game.core.global.model
{
	import flash.geom.Point;

	/** 地图跳转点配置文件
	 */	
	public class SkipPointBasicVo
	{

		public var id:int;
		public var left:int;
		public var top:int;
		public var bottom:int;
		public var otherMapX:int;
		public var mapId:int;
		public var right:int;
		public var otherMapId:int;
		public var otherMapY:int;

		public function SkipPointBasicVo()
		{
		}
		/**获取跳转点中心坐标
		 */		
		public function getCentPt():Point
		{
			return new Point((left+right)*0.5,(top+bottom)*0.5);
		}
		
	}
}