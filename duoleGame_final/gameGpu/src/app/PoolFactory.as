package app
{
	import com.YFFramework.core.ui.yf2d.view.YF2dViewPool;
	import com.YFFramework.core.world.mapScence.map.TileView;
	import com.YFFramework.game.core.module.mapScence.world.view.player.BlinkPlayerMovieClipPool;
	import com.YFFramework.game.ui.yf2d.view.avatar.BuffEffect2DView;
	import com.YFFramework.game.ui.yf2d.view.avatar.EffectPart2DView;
	import com.YFFramework.game.ui.yf2d.view.avatar.YF2dProgressBar;
	import com.YFFramework.game.ui.yf2d.view.avatar.pool.Part2dCombinePool;
	import com.YFFramework.game.ui.yf2d.view.avatar.pool.YF2dMovieClipPool;

	/**将对象池填满
	 * @author yefeng
	 * 2013 2013-7-22 上午10:40:25 
	 */
	public class PoolFactory
	{
		public function PoolFactory()
		{
		}
		public static function initMovie():void
		{
			YF2dMovieClipPool.FillMoviePool();
			Part2dCombinePool.FillPart2dDCombinePool();
			
		}
		public static function initTile():void
		{
			TileView.FillPool();
		}
		public static function initBlinkPool():void
		{
			BlinkPlayerMovieClipPool.FillPool();
			
			
			YF2dViewPool.FillPool();
			
			BuffEffect2DView.FillPool();
			EffectPart2DView.FillPool();
		}
		
		public static function initYF2dProgressBarPool():void
		{
			YF2dProgressBar.FillPool();

		}
			
	}
}