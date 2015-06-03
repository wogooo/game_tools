package com.YFFramework.game.core.module.arena.view
{
	import com.YFFramework.core.center.manager.ResizeManager;
	import com.YFFramework.core.event.YFEventCenter;
	import com.YFFramework.core.net.loader.image_swf.UILoader;
	import com.YFFramework.core.proxy.StageProxy;
	import com.YFFramework.game.core.global.event.GlobalEvent;
	import com.YFFramework.game.core.module.arena.data.ArenaRankManager;
	import com.YFFramework.game.gameConfig.URLTool;
	import com.YFFramework.game.ui.layer.LayerManager;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;

	/**
	 * @author jina;
	 * @version 1.0.0
	 * creation time：2013-10-25 下午5:37:58
	 */
	public class ArenaExitIcon
	{
		//======================================================================
		//       public property
		//======================================================================
		
		//======================================================================
		//       private property
		//======================================================================
		private static var _instance:ArenaExitIcon;
		
		private var _exitIcon:Sprite;
		//======================================================================
		//        constructor
		//======================================================================
		
		public function ArenaExitIcon()
		{
			_exitIcon=new Sprite();
			LayerManager.UILayer.addChild(_exitIcon);
			var loader:UILoader=new UILoader();
			var url:String=URLTool.getActivityIcon(100000);
			loader.initData(url,_exitIcon);
			
			_exitIcon.addEventListener(MouseEvent.CLICK,onClick);
			ResizeManager.Instance.regFunc(resize);
			resize();
		}
		
		//======================================================================
		//        public function
		//======================================================================
		public function showExit():void
		{
			_exitIcon.visible=true;
		}
		
		public function hideExit():void
		{
			_exitIcon.visible=false;
		}
		//======================================================================
		//        private function
		//======================================================================
		private function resize():void
		{
			_exitIcon.x = StageProxy.Instance.stage.stageWidth-300;//目前的图标暂定长宽60
			_exitIcon.y = 120;			
		}
		//======================================================================
		//        event handler
		//======================================================================
		private function onClick(e:MouseEvent):void
		{
			if(ArenaRankManager.instance.curArenaId > 0)
			{
				YFEventCenter.Instance.dispatchEventWith(GlobalEvent.QuitArena);
			}
		}
		//======================================================================
		//        getter&setter
		//======================================================================	
		public static function get instance():ArenaExitIcon
		{
			if(_instance == null) _instance=new ArenaExitIcon();
			return _instance;
		}

	}
} 