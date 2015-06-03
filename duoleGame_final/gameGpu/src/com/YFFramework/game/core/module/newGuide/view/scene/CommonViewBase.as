package com.YFFramework.game.core.module.newGuide.view.scene
{
	/**@author yefeng
	 * 2013 2013-7-22 下午2:14:46 
	 */
	import com.YFFramework.core.center.manager.ResizeManager;
	import com.YFFramework.core.event.YFEvent;
	import com.YFFramework.core.proxy.StageProxy;
	import com.YFFramework.core.ui.abs.AbsView;
	import com.YFFramework.core.ui.movie.BitmapMovieClip;
	import com.YFFramework.core.ui.movie.MovieClipPlayer;
	import com.YFFramework.core.ui.movie.data.ActionData;
	import com.YFFramework.core.utils.net.SourceCache;
	import com.YFFramework.game.ui.layer.LayerManager;
	
	import flash.display.MovieClip;
	
	/**挂机
	 */	
	public class CommonViewBase extends AbsView
	{
//		private var _movie:BitmapMovieClip;
		private var _url:String;
		
		protected var _isShow:Boolean;
		
		private var _movieClipPlayer:MovieClipPlayer;
		public function CommonViewBase(url:String)
		{
			_url=url;
			super(false);
			ResizeManager.Instance.regFunc(resize);
			_isShow=false;
			mouseEnabled=mouseChildren=false;
		}
		override protected function initUI():void
		{
			super.initUI();
//			_movie=new BitmapMovieClip();
//			addChild(_movie);
			_movieClipPlayer=new MovieClipPlayer(null,30);
			addChild(_movieClipPlayer);
			SourceCache.Instance.addEventListener(_url,onGuaJiComplete);
			SourceCache.Instance.loadRes(_url,null,SourceCache.ExistAllScene,null,false,false);
		}
		private function onGuaJiComplete(e:YFEvent):void
		{
			var url:String=e.type;
			SourceCache.Instance.removeEventListener(url,onGuaJiComplete);
//			var actionData:ActionData=SourceCache.Instance.getRes2(url) as ActionData;
//			_movie.initData(actionData);
			var mc:MovieClip=SourceCache.Instance.getRes2(url) as MovieClip;
			_movieClipPlayer.initMC(mc,30);
			start();
		}
		
		public function start():void
		{
//			_movie.start();
//			_movie.playDefault();
			_movieClipPlayer.start();
			_movieClipPlayer.playDefault()
		}
		
		public function stop():void
		{
//			_movie.stop();
			_movieClipPlayer.stop();
		}
		protected function resize():void
		{
			x=(StageProxy.Instance.getWidth()-_movieClipPlayer.width)*0.5;
			y=150-35;
		}

		public function show():void
		{
			if(!LayerManager.NoticeLayer.contains(this))LayerManager.NoticeLayer.addChild(this);
			resize();
			_isShow=true;
		}
		public function hide():void
		{
			if(LayerManager.NoticeLayer.contains(this))LayerManager.NoticeLayer.removeChild(this);
			_isShow=false;
		}
		
		/**是否已经显示
		 */
		public function getShow():Boolean
		{
			return _isShow;
		}

		
		
		
	}
}