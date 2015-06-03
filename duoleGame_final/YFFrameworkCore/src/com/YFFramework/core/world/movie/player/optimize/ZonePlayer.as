package com.YFFramework.core.world.movie.player.optimize
{
	import com.YFFramework.core.ui.yf2d.view.Abs2dView;
	
	
	/**玩家优化
	 * 2012-11-2 上午11:34:29
	 *@author yefeng
	 */
	public class ZonePlayer extends Abs2dView
	{
		private static var __id:int=0;
		private var __myId:int;
		public function ZonePlayer()
		{
			super();
			++__id;
			__myId=__id;
			SceneZoneManager.Instance.regPlayer(this);
		}

		
		override public function dispose(childrenDispose:Boolean=true):void
		{
			SceneZoneManager.Instance.delPlayer(this);
			super.dispose(childrenDispose);
		}
		public function getID():int
		{
			return __myId;
		}
	}
}