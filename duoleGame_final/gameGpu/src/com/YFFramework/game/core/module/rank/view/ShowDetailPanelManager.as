package com.YFFramework.game.core.module.rank.view
{
	import com.YFFramework.core.ui.yfComponent.PopUpManager;
	import com.YFFramework.game.core.module.pet.model.PetDyVo;
	import com.YFFramework.game.core.module.rank.control.RankModule;
	import com.YFFramework.game.core.module.rank.data.OtherHeroDyVo;
	import com.YFFramework.game.core.module.rank.data.OtherHeroPetDyManager;
	import com.dolo.common.ObjectPool;
	
	import flash.utils.Dictionary;

	/**
	 * @version 1.0.0
	 * creation time：2013-6-27 下午5:44:34
	 * 
	 */
	public class ShowDetailPanelManager
	{
		//======================================================================
		//       public property
		//======================================================================
		
		//======================================================================
		//       private property
		//======================================================================
		private static var _instance:ShowDetailPanelManager;
		
		private var _petDict:Dictionary=new Dictionary();
		private var _heroDict:Dictionary=new Dictionary();
		//======================================================================
		//        constructor
		//======================================================================
		
		public function ShowDetailPanelManager()
		{
		}
		
		//======================================================================
		//        public function
		//======================================================================
		public function characterReq(playerId:int,isRank:Boolean=false):void
		{
			RankModule.instance.otherPlayerReq(playerId,isRank);
		}
		
		public function petReq(petId:int,isRank:Boolean=false):void
		{
			RankModule.instance.otherPetReq(petId,isRank);
		}
		
//		public function characterResp(playerId:int,isRank:Boolean=false):ShowDetailInfoPanel
//		{
//			if(isRank == false)
//			{
//				var win:ShowDetailInfoWindow;
//				if(_heroDict[playerId] == null)
//				{
//					win=new ShowDetailInfoWindow(OtherHeroPetDyManager.SHOW_CHARACTER);
//					win.initWinByHero(OtherHeroPetDyManager.instance.getOtherCharacter(playerId));
//				}
//				else
//					win=_heroDict[playerId];
//				win.open();
//				_heroDict[playerId]=win;
//			}
//			else
//			{
//				var _panel:ShowDetailInfoPanel=new ShowDetailInfoPanel();
//				_panel.showRankCharacter(OtherHeroPetDyManager.instance.getOtherCharacter(playerId));
//				return _panel;
//			}
//			return null;
//		}
		
//		public function petResp(petId:int,isRank:Boolean=false):ShowDetailInfoPanel
//		{
//			if(isRank == false)
//			{
//				var win:ShowDetailInfoWindow;
//				if(_petDict[petId] == null)
//				{
//					win=new ShowDetailInfoWindow(OtherHeroPetDyManager.SHOW_PET);
//					win.initWinByPet(OtherHeroPetDyManager.instance.getPet(petId));
//				}
//				else
//					win=_petDict[petId];
//				win.open();
//				_petDict[petId]=win;
//			}
//			else
//			{
//				var _panel:ShowDetailInfoPanel=new ShowDetailInfoPanel();
//				_panel.showRankPet(OtherHeroPetDyManager.instance.getPet(petId));
//				return _panel;
//			}
//			return null;
//		}
		
//		public function returnPanel(panel:ShowDetailInfoPanel):void
//		{
//			panel.dispose();
//		}
		
		public function removeHeroWin(playerId:int):void
		{
			delete _heroDict[playerId];
		}
		
		public function removePetWin(petId:int):void
		{
			delete _petDict[petId];
		}
		//======================================================================
		//        private function
		//======================================================================
		
		//======================================================================
		//        event handler
		//======================================================================
		
		//======================================================================
		//        getter&setter
		//======================================================================
		public static function get instance():ShowDetailPanelManager
		{
			if(_instance == null)
				_instance = new ShowDetailPanelManager();
			return _instance;
		}

	}
} 