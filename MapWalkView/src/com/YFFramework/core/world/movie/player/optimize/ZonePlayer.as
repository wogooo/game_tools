package com.YFFramework.core.world.movie.player.optimize
{
	import com.YFFramework.core.ui.yf2d.view.Abs2dViewPool;
	
	/**玩家优化
	 * 2012-11-2 上午11:34:29
	 *@author yefeng
	 */
	public class ZonePlayer extends Abs2dViewPool
	{
		public function ZonePlayer()
		{
			super();
			SceneZoneManager.Instance.regPlayer(this);
		}

		
		override public function dispose(childrenDispose:Boolean=true):void
		{
			super.dispose(childrenDispose);
			SceneZoneManager.Instance.delPlayer(this);
		}
		
	}
}