package com.YFFramework.game.ui.yf2d.view.avatar
{
	/**@author yefeng
	 * 2013 2013-5-16 下午1:43:08 
	 */
	import com.YFFramework.core.yf2d.extension.SkillEffect2DView;
	import com.YFFramework.core.yf2d.extension.ATFMovieClip;
	import com.YFFramework.game.core.module.mapScence.world.view.player.PlayerView;
	import com.YFFramework.game.ui.yf2d.view.avatar.pool.YF2dMovieClipPool;
	
	/**处理带url的特效
	 */	
	public class EffectURL2DView extends BuffEffect2DView
	{
		public function EffectURL2DView(player:PlayerView)
		{
			super(player);
		}
		
		override public function deleteEffect(url:String):void
		{
			var clip:SkillEffect2DView=_dict[url] as SkillEffect2DView;
			if(clip)
			{
				if(contains(clip)) removeChild(clip);
				clip.stop();
//				clip.dispose();
				YF2dMovieClipPool.toSkillEffect2DViewPool(clip);
			}
			_dict[url]=null;
			delete _dict[url];
		}
		/**删除所有对象
		 */
		public function deleteAll():void
		{
			for (var url:String in _dict)
			{
				deleteEffect(url);
			}
		}

	}
}