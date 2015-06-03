package com.YFFramework.game.core.module.raid.view
{
	/**翻牌特效UI 
	 * @author yefeng
	 * 2013 2013-11-6 上午9:46:43 
	 */
	import com.YFFramework.core.event.ParamEvent;
	import com.YFFramework.core.event.YFEvent;
	import com.YFFramework.core.ui.abs.AbsView;
	import com.YFFramework.core.utils.common.ClassInstance;
	import com.YFFramework.core.utils.net.SourceCache;
	import com.YFFramework.game.core.global.manager.CommonEffectURLManager;
	import com.YFFramework.core.ui.movie.MovieClipPlayer;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	
	public class CardMovieView extends AbsView
	{
		/**卡片是否已经加载出来 为 true时 则表示mc 已经加载进来了
		 */
		public static var CardMovieLoaded:Boolean=false;
		/** mc 加载地址来自于  dyUI/commonAssets/cardMovieMC.swf
		 */
		private var _mc:MovieClipPlayer;
		private var _totalFrame:int;
		private var _index:int;
		
		public function CardMovieView(index:int){
			super(false);
			loadMC();
			_index = index;
		}
		
		/**获取index
		 * @return 
		 */		
		public function get index():int{
			return _index;
		}
		
		public function initMC():void
		{
			if(CardMovieLoaded)
			{
				var mc:MovieClip=ClassInstance.getInstance("cardMovieMC");  // cardMovieMC.swf 里的  cardMovieMC链接名
				_mc=new MovieClipPlayer(mc,15);
				addChild(_mc);
			}
		}
		public function playToEnd(startIndex:int=1,complete:Function=null,completeParam:Object=null):void
		{
			_mc.playToEnd(startIndex,complete,completeParam);
		}
		
		override public function dispose(e:Event=null):void
		{
			super.dispose();
			_mc=null;
		}
		
		
		private  function loadMC():void
		{
			if(!CardMovieLoaded)
			{
				addEventListener(CommonEffectURLManager.FlopCardMovie,complete);
				SourceCache.Instance.loadRes(CommonEffectURLManager.FlopCardMovie,null,SourceCache.ExistAllScene,null,{dispatcher:this},false);
			}
			else 
			{
				initMC();
			}
		} 
		private  function complete(e:ParamEvent):void
		{
			var url:String=e.type;
			removeEventListener(CommonEffectURLManager.FlopCardMovie,complete);
			CardMovieLoaded=true;
			initMC();
		}
		
		
		/**进入副本预加载
		 */
		public static function preLoading():void
		{
			if(!CardMovieLoaded)
			{
				SourceCache.Instance.forceLoadRes(CommonEffectURLManager.FlopCardMovie,null,SourceCache.ExistAllScene,null,null,false);
				SourceCache.Instance.addEventListener(CommonEffectURLManager.FlopCardMovie,completeLoad);
			}
		}
		private static function completeLoad(e:YFEvent):void
		{
			SourceCache.Instance.removeEventListener(CommonEffectURLManager.FlopCardMovie,completeLoad);
			CardMovieLoaded=true;
		}
		
		
	}
}