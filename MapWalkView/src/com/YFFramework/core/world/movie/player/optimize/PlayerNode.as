package com.YFFramework.core.world.movie.player.optimize
{
	

	/**2012-11-2 上午9:28:19
	 *@author yefeng
	 */
	public class PlayerNode
	{
		public var playerView:ZonePlayer;
		
		public var zone:ScenceZone;
		public function PlayerNode(playerView:ZonePlayer)
		{
			this.playerView=playerView;
		}
		public function dispose():void
		{
			playerView=null;
			zone=null;
		}
	}
}