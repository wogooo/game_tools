package com.YFFramework.game.core.module.mapScence.view
{
	import com.YFFramework.core.event.YFEvent;
	import com.YFFramework.core.ui.movie.BitmapMovieClip;
	import com.YFFramework.core.ui.movie.data.ActionData;
	import com.YFFramework.core.utils.net.SourceCache;
	import com.YFFramework.game.core.global.manager.CommonEffectURLManager;

	/**技能点  图像显示
	 * @author yefeng
	 * 2013 2013-3-26 下午6:01:09 
	 */
	public class SkillPointSelectView extends BitmapMovieClip
	{
		public function SkillPointSelectView()
		{
			super();
		}
		override protected function initUI():void
		{
			super.initUI();
			var url:String=CommonEffectURLManager.SkillPointSelectView;
			loadData(url);
		}
		/**子类调用
		 */		
		protected function loadData(url:String):void
		{
			var actionData:ActionData=SourceCache.Instance.getRes2(url) as ActionData;
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
			var actionData:ActionData=SourceCache.Instance.getRes2(url) as ActionData;
			initData(actionData);
			playDefault();
		}
		
		
	}
}