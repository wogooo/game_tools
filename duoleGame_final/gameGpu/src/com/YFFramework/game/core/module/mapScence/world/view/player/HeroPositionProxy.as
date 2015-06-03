package com.YFFramework.game.core.module.mapScence.world.view.player
{
	import com.YFFramework.core.map.rectMap.RectMapUtil;
	
	import flash.geom.Point;

	public class HeroPositionProxy
	{
		
		
		/**flash 舞台上的坐标
		 */		
		public static  var x:int;
		/**flash 舞台上的坐标
		 */		
		public static var y:int;
		/**世界坐标
		 */		
		public static var mapX:int;
		/**世界坐标
		 */		
		public static var mapY:int;
		
		/**角色的当前方向
		 */ 
		public static var direction:int;
		
		
		private static var _tilePt:Point;
		public function HeroPositionProxy()
		{
		}
		
		public static function getTilePositon():Point
		{
			_tilePt=RectMapUtil.getTilePosition(mapX,mapY);
			return _tilePt;
		}
		
	}
}