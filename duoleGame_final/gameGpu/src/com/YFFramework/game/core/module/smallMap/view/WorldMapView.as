package com.YFFramework.game.core.module.smallMap.view
{
	/**@author yefeng
	 * 2013 2013-6-8 上午10:04:42 
	 *  世界地图UI 
	 */
	import com.YFFramework.core.net.loader.image_swf.UILoader;
	import com.YFFramework.core.ui.abs.AbsView;
	import com.YFFramework.game.gameConfig.URLTool;
	import com.YFFramework.game.core.module.mapScence.world.model.MapSceneBasicVo;
	import com.YFFramework.game.core.module.mapScence.manager.MapSceneBasicManager;
	
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.utils.Dictionary;

	/** 世界地图UI 
	 */	
	public class WorldMapView extends AbsView
	{
		
		/** 点击世界地图区块后的回调 
		 */		
		public var worldMapCallBack:Function;
		/** 世界地图地址
		 */		
		private static const WorldMapURL:String=URLTool.getCommonAssets("worldMap.swf");
		private var _mc:MovieClip;
		public function WorldMapView()
		{
			super(false);
		}
		/** 初始化加载
		 */		
		public function initLoad():void
		{
			if(_mc==null)
			{
				var loader:UILoader=new UILoader();
				loader.loadCompleteCallback=callBack;
				loader.initData(WorldMapURL);
			}
		}
		/**回调
		 */		
		private function callBack(mc:MovieClip,data:Object):void
		{ 
			_mc=mc;
			addChild(_mc);
			_mc.addEventListener(MouseEvent.CLICK,onClick);
		}
		/**处理地图区块事件
		 */		
		private function onClick(e:MouseEvent):void
		{
			var dict:Dictionary=MapSceneBasicManager.Instance.getDict();
			for each(var mapSceneBasicVo:MapSceneBasicVo in dict)
			{
				if(e.target==_mc["map"+mapSceneBasicVo.mapId])
				{
					worldMapCallBack(mapSceneBasicVo.mapId);
					return ;
				}
			}
				
		}
		
		
	}
}