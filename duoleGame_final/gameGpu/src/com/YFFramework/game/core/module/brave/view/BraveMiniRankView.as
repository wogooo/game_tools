package com.YFFramework.game.core.module.brave.view
{
	import com.YFFramework.core.center.manager.ResizeManager;
	import com.YFFramework.core.proxy.StageProxy;
	import com.YFFramework.core.utils.common.ClassInstance;
	import com.YFFramework.game.core.global.DataCenter;
	import com.YFFramework.game.core.module.arena.data.ArenaRankManager;
	import com.YFFramework.game.ui.layer.LayerManager;
	import com.dolo.ui.tools.Xdis;
	
	import flash.display.MovieClip;
	import flash.text.TextField;

	/**
	 * @author jina;
	 * @version 1.0.0
	 * creation time：2013-10-22 下午2:00:05
	 */
	public class BraveMiniRankView
	{
		//======================================================================
		//       public property
		//======================================================================
		
		//======================================================================
		//       private property
		//======================================================================
		private const MAX_ITEMS:int=10;
		
		private static var _instance:BraveMiniRankView;
		
		private var _mc:MovieClip;
		private var _items:Array;
		private var _myName:TextField;
		private var _myScore:TextField;
		//======================================================================
		//        constructor
		//======================================================================
		
		public function BraveMiniRankView()
		{
			_mc=ClassInstance.getInstance("braveActivity");
			_mc.mouseChildren=false;
			_mc.mouseEnabled=false;
			
			_items=[];
			
			var item:MovieClip;
			for(var i:int=0;i<MAX_ITEMS;i++)
			{
				item=Xdis.getChild(_mc,"item"+i);
				TextField(item.pName).selectable=false;
				TextField(item.pScore).selectable=false;
				_items.push(item);
			}
			
//			_myName=Xdis.getChild(_mc,"myName");
			_myScore=Xdis.getChild(_mc,"myScore");
//			_myName.text=DataCenter.Instance.roleSelfVo.roleDyVo.roleName;
			TextField(_myScore).selectable=false;
			
			ResizeManager.Instance.regFunc(resizeView);
		}
		
		//======================================================================
		//        public function
		//======================================================================
		public function initView():void
		{
			LayerManager.UILayer.addChild(_mc);
			resizeView();
			updateScore();
		}
		
		public function updateScore():void
		{
			var players:Array=ArenaRankManager.instance.getTop10();
			for(var i:int=0;i<MAX_ITEMS;i++)
			{
				if(players.length > i)
				{
					MovieClip(_items[i]).visible=true;
					TextField(_items[i].pName).text=players[i].name+"：";
					TextField(_items[i].pScore).text=players[i].score+"分";
				}
				else
					MovieClip(_items[i]).visible=false;
			}
			
			_myScore.text=ArenaRankManager.instance.getPlayerScore(DataCenter.Instance.roleSelfVo.roleDyVo.roleName)+"分";
			
		}
		
		public function closeView():void
		{
			if(LayerManager.UILayer.contains(_mc))
				LayerManager.UILayer.removeChild(_mc);
			for(var i:int=0;i<MAX_ITEMS;i++)
			{
				if(_items[i])
				{
					MovieClip(_items[i]).visible=false;
					TextField(_items[i].pName).text='';
					TextField(_items[i].pScore).text='';
				}			
			}
		}
		//======================================================================
		//        private function
		//======================================================================
		private function resizeView():void
		{
			if(_mc.parent)
			{
				_mc.x=StageProxy.Instance.stage.stageWidth-_mc.width;
				_mc.y=(StageProxy.Instance.stage.stageHeight-_mc.height)*0.5;
			}
		}
		//======================================================================
		//        event handler
		//======================================================================
		
		//======================================================================
		//        getter&setter
		//======================================================================

		public static function get instance():BraveMiniRankView
		{
			if(_instance == null) _instance = new BraveMiniRankView;
			return _instance;
		}

	}
} 