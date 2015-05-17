package com.YFFramework.game.core.module.mapScence.view
{
	/**@author yefeng
	 * 2013 2013-3-26 下午5:53:24 
	 */
	import com.YFFramework.core.event.YFEvent;
	import com.YFFramework.core.ui.yf2d.data.YF2dActionData;
	import com.YFFramework.core.ui.yf2d.view.avatar.EffectPart2DView;
	import com.YFFramework.core.ui.yf2d.view.avatar.YF2dMovieClip;
	import com.YFFramework.core.utils.net.SourceCache;
	import com.YFFramework.core.world.movie.player.PlayerView;
	
	public class SimpleEffectView extends YF2dMovieClip
	{
		public function SimpleEffectView()
		{
			super();
			
		}
		/**子类调用
		 */		
		protected function loadData(url:String):void
		{
			var actionData:YF2dActionData=SourceCache.Instance.getRes2(url) as YF2dActionData;
			if(actionData==null)
			{
				SourceCache.Instance.addEventListener(url,onCompleteLoad);
				SourceCache.Instance.loadRes(url);
			}
			else 
			{
				initData(actionData);
				playDefault();
			}
		}
		
		private function onCompleteLoad(e:YFEvent):void
		{
			var url:String=e.type;
			SourceCache.Instance.removeEventListener(url,onCompleteLoad) ;
			var actionData:YF2dActionData=SourceCache.Instance.getRes2(url) as YF2dActionData;
			initData(actionData);
			playDefault();
		}
		
		override public function removeFromParent(_dispose:Boolean=false):Boolean
		{
			var effectPartView:EffectPart2DView=parent as EffectPart2DView;
			if(effectPartView)
			{
				var player:PlayerView=effectPartView.parent as PlayerView; /// downpartView.parent
				if(player) 
				{
					player.removeRoleSelect(this);
				}
			}
			return true;
		}
	}
}