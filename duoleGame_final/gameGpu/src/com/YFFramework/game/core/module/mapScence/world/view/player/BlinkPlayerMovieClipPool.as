package com.YFFramework.game.core.module.mapScence.world.view.player
{
	import com.YFFramework.core.yf2d.extension.ATFMovieClip;
	import com.YFFramework.game.ui.yf2d.view.avatar.pool.YF2dMovieClipArray;

	/**@author yefeng
	 * 2013 2013-7-8 下午6:08:26 
	 */
	public class BlinkPlayerMovieClipPool
	{
		/**Yf2dMovieClip对象池
		 */		
		private static var yf2dMovieClipArr:YF2dMovieClipArray=new YF2dMovieClipArray(30);//20

		public function BlinkPlayerMovieClipPool()
		{
		}
		public static function getYF2dMovieClip():ATFMovieClip
		{
			var movie:ATFMovieClip;
			if(yf2dMovieClipArr.length>0)
			{
				movie=yf2dMovieClipArr.pop();
				movie.initFromPool();
			}
			else movie=new ATFMovieClip();
			return movie;
		}
		/**将yf2dMovieClip    添加到对象池
		 */		
		public static function toYF2dMovieClipPool(yf2dMovieClip:ATFMovieClip):void
		{
			if(yf2dMovieClipArr.canPush())
			{
				yf2dMovieClip.disposeToPool();
				yf2dMovieClipArr.push(yf2dMovieClip);
			}
			else yf2dMovieClip.dispose();
		}
		
		public static function FillPool():void
		{
			var movie:ATFMovieClip;
			var len:int=yf2dMovieClipArr.length;
			for(var i:int=0;i!=len;++i)
			{
				movie=new ATFMovieClip();
				movie.disposeToPool();
				yf2dMovieClipArr.push(movie);
			}
		}
			

	}
}