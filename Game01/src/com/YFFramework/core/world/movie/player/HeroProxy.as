package com.YFFramework.core.world.movie.player
{
	/**当前玩家 代理 保存其坐标位置  
	 * 
	 * 2012-7-4
	 *	@author yefeng
	 */
	public class HeroProxy
	{
		/**flash 舞台上的坐标
		 */		
		public static var x:int;
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
		public function HeroProxy()
		{
		}
	}
}