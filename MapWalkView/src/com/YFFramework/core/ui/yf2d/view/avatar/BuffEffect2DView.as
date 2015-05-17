package com.YFFramework.core.ui.yf2d.view.avatar
{
	/**@author yefeng
	 * 2013 2013-3-29 下午3:59:16 
	 */
	import com.YFFramework.core.event.YFEvent;
	import com.YFFramework.core.ui.yf2d.data.YF2dActionData;
	import com.YFFramework.core.ui.yf2d.view.Abs2dView;
	import com.YFFramework.core.utils.net.SourceCache;
	import com.YFFramework.core.world.movie.player.PlayerView;
	
	import flash.utils.Dictionary;
	
	public class BuffEffect2DView extends Abs2dView
	{
		private var _dict:Dictionary;
		private var player:PlayerView;

		public function BuffEffect2DView(player:PlayerView)
		{
			this.player=player;
			super();
		}
		
		override protected function initUI():void
		{
			super.initUI();
			_dict=new Dictionary();
		}
		
		override protected function addEvents():void
		{
			super.addEvents();
		}

		/**添加buff特效
		 */		
		public function addEffect(url:String):void
		{
			var clip:YF2dMovieClip=_dict[url];
			if(clip==null)
			{
				clip=new YF2dMovieClip();
				clip.start();
				addChild(clip);
				_dict[url]=clip;
				var actionData:YF2dActionData=SourceCache.Instance.getRes2(url) as YF2dActionData;
				if(actionData)
				{
					clip.initData(actionData);
					clip.playDefault();
				}
				else 
				{
					SourceCache.Instance.addEventListener(url,onBuffEffectComplete);	
					SourceCache.Instance.loadRes(url,player);
				}
			}
		}
		private function onBuffEffectComplete(e:YFEvent):void
		{
			var url:String=e.type;
			SourceCache.Instance.removeEventListener(url,onBuffEffectComplete);	
			var actionData:YF2dActionData=SourceCache.Instance.getRes2(url) as YF2dActionData;
			var obj:Vector.<Object>=e.param as Vector.<Object>;
			var clip:YF2dMovieClip;
			for each(var player:PlayerView in obj)
			{
				if(!player.isPool)
				{
					clip=_dict[url];
					if(clip)
					{
						clip.initData(actionData);
						clip.playDefault();
					}
				}
			}
		}
		
		public function deleteEffect(url:String):void
		{
			var clip:YF2dMovieClip=_dict[url] as YF2dMovieClip;
			if(clip)
			{
				if(contains(clip)) removeChild(clip);
				clip.stop();
				clip.dispose();
			}
			_dict[url]=null;
			delete _dict[url];
			
			if(numChildren==0)
			{
				if(parent)parent.removeChild(this);
			}
		}
		
		override public function dispose(childrenDispose:Boolean=true):void
		{
			super.dispose(childrenDispose);
			_dict=null;
			player=null;
		}
		
		
		
	}
}