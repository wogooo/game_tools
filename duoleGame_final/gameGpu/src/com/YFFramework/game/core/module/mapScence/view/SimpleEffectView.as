package com.YFFramework.game.core.module.mapScence.view
{
	/**@author yefeng
	 * 2013 2013-3-26 下午5:53:24 
	 */
	import com.YFFramework.core.event.YFEvent;
	import com.YFFramework.core.ui.yf2d.data.ATFActionData;
	import com.YFFramework.core.utils.net.SourceCache;
	import com.YFFramework.core.yf2d.extension.SkillEffect2DView;
	import com.YFFramework.game.core.module.mapScence.world.view.player.PlayerView;
	import com.YFFramework.game.ui.yf2d.view.avatar.EffectPart2DView;
	
	public class SimpleEffectView extends SkillEffect2DView
	{
		public function SimpleEffectView()
		{
			super();
			
		}
		/**子类调用
		 */		
		protected function loadData(url:String):void
		{
			var actionData:ATFActionData=SourceCache.Instance.getRes2(url) as ATFActionData;
			if(actionData==null)
			{
				SourceCache.Instance.addEventListener(url,onCompleteLoad);
				SourceCache.Instance.loadRes(url);
			} 
			else 
			{
				initData(actionData);
				playDefault();
				start();
			}
		}
		
		private function onCompleteLoad(e:YFEvent):void
		{
			var url:String=e.type;
			SourceCache.Instance.removeEventListener(url,onCompleteLoad) ;
			var actionData:ATFActionData=SourceCache.Instance.getRes2(url) as ATFActionData;
			initData(actionData);
			playDefault();
			start();
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