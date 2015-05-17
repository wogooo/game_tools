package com.YFFramework.core.world.movie.player.optimize
{
	import com.YFFramework.core.center.pool.AbsUIPool;
	
	import flash.events.Event;
	
	/**玩家优化
	 * 2012-11-2 上午11:34:29
	 *@author yefeng
	 */
	public class ZonePlayer extends AbsUIPool
	{
		public function ZonePlayer(autoRemove:Boolean=false)
		{
			SceneZoneManager.Instance.regPlayer(this);
			super(autoRemove);
		}
		
		
//		override public function set x(value:Number):void
//		{
//			super.x=value;
//			SceneZoneManager.Instance.updatePlayerZone(this);
//		}
//		override public function set y(value:Number):void
//		{
//			super.y=value;
//			SceneZoneManager.Instance.updatePlayerZone(this);
//		}
		
		override public function dispose(e:Event=null):void
		{
			super.dispose(e);
			SceneZoneManager.Instance.delPlayer(this);
		}
		

		
		
		
	}
}