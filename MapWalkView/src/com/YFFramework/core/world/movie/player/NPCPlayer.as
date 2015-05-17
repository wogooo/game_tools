package com.YFFramework.core.world.movie.player
{
	import com.YFFramework.core.world.model.MonsterDyVo;
	
	/**NPC  播放器
	 * 2012-10-22 下午7:57:29
	 *@author yefeng
	 */
	public class NPCPlayer extends PlayerView
	{
		
		public function NPCPlayer(roleDyVo:MonsterDyVo=null)
		{
			super(roleDyVo);
		}
		override protected function initBloodLayer():void
		{
			
		}
		override public function updateHp():void
		{
			
		}

	}
}