package com.YFFramework.core.world.movie.player.parts
{
	/**@author yefeng
	 * 2013 2013-3-28 下午4:49:07 
	 */
	import com.YFFramework.core.event.ParamEvent;
	import com.YFFramework.core.ui.abs.AbsView;
	import com.YFFramework.core.ui.movie.BitmapMovieClip;
	import com.YFFramework.core.ui.movie.data.ActionData;
	import com.YFFramework.core.utils.net.SourceCache;
	import com.YFFramework.core.world.movie.player.PlayerView;
	
	import flash.events.Event;
	import flash.utils.Dictionary;
	
	public class BuffEffectView extends AbsView
	{
		private var _dict:Dictionary;
		private var player:PlayerView;
		public function BuffEffectView(player:PlayerView)
		{
			this.player=player;
			super(false);
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
			var clip:BitmapMovieClip=_dict[url];
			if(clip==null)
			{
				clip=new BitmapMovieClip();
				clip.start();
				addChild(clip);
				_dict[url]=clip;
				var actionData:ActionData=SourceCache.Instance.getRes2(url) as ActionData;
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
		private function onBuffEffectComplete(e:ParamEvent):void
		{
			var url:String=e.type;
			SourceCache.Instance.removeEventListener(url,onBuffEffectComplete);	
			var actionData:ActionData=SourceCache.Instance.getRes2(url) as ActionData;
			var obj:Vector.<Object>=e.param as Vector.<Object>;
			var clip:BitmapMovieClip;
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
			var clip:BitmapMovieClip=_dict[url] as BitmapMovieClip;
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
		
		override public function dispose(e:Event=null):void
		{
			super.dispose();
			_dict=null;
			player=null;
		}
		/**  人物死亡重置
		 * 
		 */
//		public function reset():void
//		{
//			for each(var clip:BitmapMovieClip in _dict)
//			{
//				removeChild(clip);
//				clip.dispose();
//			}
//			_dict=new Dictionary();
//		}
		
		

	}
}