package com.YFFramework.game.core.module.forge.view
{
	import com.YFFramework.core.event.YFEvent;
	import com.YFFramework.core.event.YFEventCenter;
	import com.YFFramework.core.ui.abs.AbsView;
	import com.YFFramework.game.core.global.event.GlobalEvent;
	import com.YFFramework.game.core.global.manager.DyModuleUIManager;
	import com.YFFramework.game.core.global.util.UIPositionUtil;
	import com.YFFramework.game.core.global.view.window.WindowTittleName;
	import com.YFFramework.game.core.module.forge.data.ForgeSource;
	import com.YFFramework.game.core.module.forge.view.panel.EquipDisolveCOL;
	import com.YFFramework.game.core.module.forge.view.panel.EquipLevelUp;
	import com.YFFramework.game.core.module.forge.view.panel.EquipSophistication;
	import com.YFFramework.game.core.module.forge.view.panel.EquipStrengthenPanel;
	import com.YFFramework.game.core.module.forge.view.panel.InlayGemCOL;
	import com.YFFramework.game.core.module.forge.view.panel.PropsComposePanel;
	import com.YFFramework.game.core.module.forge.view.panel.RemoveGemCOL;
	import com.YFFramework.game.core.module.newGuide.manager.NewGuideDrawHoleUtil;
	import com.YFFramework.game.core.module.newGuide.manager.NewGuideManager;
	import com.YFFramework.game.core.module.newGuide.model.NewGuideStep;
	import com.YFFramework.game.core.module.newGuide.view.NewGuideMovieClipWidthArrow;
	import com.dolo.ui.controls.Window;
	import com.dolo.ui.managers.TabsManager;
	import com.dolo.ui.managers.UI;
	import com.dolo.ui.tools.Xdis;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point;
	
	public class ForgeWindow extends Window{
		
		private var _tabs:TabsManager;
		private var _ui:Sprite;
		/** 装备强化 */		
		private var _strengthenPanel:EquipStrengthenPanel;
		/** 宝石镶嵌 */		
		private var _inlayGemCOL:InlayGemCOL;
		private var _levelUp:EquipLevelUp;
		/** 宝石摘除 */		
		private var _removeGemCOL:RemoveGemCOL;
		/** 宝石合成 */		
		private var _composeCOL:PropsComposePanel;
		/** 装备洗练 */
		private var _equipSophi:EquipSophistication;
		/** 装备分解 */		
		private var _equipDisolveCOL:EquipDisolveCOL;
		
		/**新手引导层
		 */
		private var _newGuideContainer:AbsView;
		public function ForgeWindow()
		{
			_ui = initByArgument(708,550,"ui.ForgeWindowUI",WindowTittleName.Forge,true,DyModuleUIManager.forgeWinBg);
			setContentXY(28.5,29);
			
			_tabs = new TabsManager();
			
			_newGuideContainer=new AbsView(false);
			
			_strengthenPanel = new EquipStrengthenPanel(Xdis.getChild(_ui,"tabView1"));
			_levelUp = new EquipLevelUp(Xdis.getChild(_ui,"tabView2"),_newGuideContainer);
			_inlayGemCOL = new InlayGemCOL(Xdis.getChild(_ui,"tabView3"));
			_removeGemCOL = new RemoveGemCOL(Xdis.getChild(_ui,"tabView4"));
			_composeCOL = new PropsComposePanel(Xdis.getChild(_ui,"tabView5"));
			_equipSophi = new EquipSophistication(Xdis.getChild(_ui,"tabView6"));
//			_equipDisolveCOL = new EquipDisolveCOL(Xdis.getChild(_ui,"tabView7"));
			
			
			_tabs.initTabs(_ui,"tabs_sp",6);
			_tabs.addEventListener(TabsManager.INDEX_CHANGE,onTabChange);
			
			addChild(_newGuideContainer);  //添加新手引导层
			
			YFEventCenter.Instance.addEventListener(GlobalEvent.MoneyChange,onMoneyChange);
		}
		
		public function get strengthenPanel():EquipStrengthenPanel{
			return _strengthenPanel;
		}
		
		public function get composeCOL():PropsComposePanel
		{
			return _composeCOL;
		}

		public function get inlayGemCOL():InlayGemCOL
		{
			return _inlayGemCOL;
		}
		
		/** 装备分解 */
		public function get equipDisolveCOL():EquipDisolveCOL
		{
			return _equipDisolveCOL;
		}
		
		/** 宝石摘除 */
		public function get removeGemCOL():RemoveGemCOL
		{
			return _removeGemCOL;
		}
		
		/** 装备进阶 */
		public function get levelUp():EquipLevelUp
		{
			return _levelUp;
		}
		
		/** 装备洗练 */
		public function get equipSophi():EquipSophistication
		{
			return _equipSophi;
		}
		
		public function openTab(id:int):void
		{
			_tabs.switchToTab(id);
		}
		
		public function getTabIndex():int
		{
			return _tabs.nowIndex;
		}
		
		override public function close(event:Event=null):void{
			closeTo(UI.stage.stageWidth-370,UI.stage.stageHeight-65,0.02,0.04);
			
			_strengthenPanel.resetPanel();
			_levelUp.resetPanel();
			_inlayGemCOL.resetPanel();
			_removeGemCOL.resetPanel();
			_composeCOL.resetPanel();
//			_equipDisolveCOL.resetPanel();
			_levelUp.resetPanel();
			
			handleHideGuide();
		}
		
		private function onTabChange(e:Event):void
		{
			if(_tabs.nowIndex == ForgeSource.EQUIP_ENHANCE)//装备强化
				_strengthenPanel.initPanel(true);
			else
				_strengthenPanel.initPanel(false);
			
			if(_tabs.nowIndex == ForgeSource.EQUIP_LEVEL_UP)//装备进阶
				_levelUp.initPanel(true);
			else
				_levelUp.initPanel(false);
			
			if(_tabs.nowIndex == ForgeSource.INLAY_GEMS)//镶嵌宝石
				_inlayGemCOL.initPanel(true);
			else
				_inlayGemCOL.initPanel(false);
			
			if(_tabs.nowIndex == ForgeSource.REMOVE_GEMS)//宝石摘除
				_removeGemCOL.initPanel(true);
			else
				_removeGemCOL.initPanel(false);
			
			if(_tabs.nowIndex == ForgeSource.PROPS_COMPOSE)//物品合成
				_composeCOL.initPanel(true);
			else
				_composeCOL.initPanel(false);
			
//			if(_tabs.nowIndex == ForgeSource.EQUIP_DISOLVE)//装备分解
//				_equipDisolveCOL.initPanel(true);
//			else
//				_equipDisolveCOL.initPanel(false);
			
			if(_tabs.nowIndex == ForgeSource.EQUIP_SOPHI)//装备洗练
				_equipSophi.initPanel(true);
			else
				_equipSophi.initPanel(false);
			
//			if(_tabs.nowIndex == ForgeSource.WING_LEVELUP)	_wingLvUp.initPanel();
//			else if(_tabs.nowIndex == ForgeSource.WING_FEATHER)	_wingFeather.initPanel();
		}

		private function onMoneyChange(e:YFEvent):void
		{
			if(isOpen)
			{
				if(_tabs.nowIndex == ForgeSource.PROPS_COMPOSE)
					_composeCOL.updateMoney();
				else if(_tabs.nowIndex == ForgeSource.EQUIP_LEVEL_UP)
					_levelUp.checkMoney();
//				else if(_tabs.nowIndex == ForgeSource.EQUIP_ENHANCE)
//					_strengthenCOL.checkEnhanceBtn();
				else if(_tabs.nowIndex == ForgeSource.EQUIP_SOPHI)
					_equipSophi.checkSophBtn();
			}		
		}	
		
		override public function getNewGuideVo():*
		{
			var trigger:Boolean=levelUp.handleClickEquipNewGuide();
			if(!trigger)
			{
				trigger=levelUp.handleLevelUpBtnGuide();
			}
			if(!trigger)
			{
				trigger=handleGuideCloseWindow();
			}
			if(!trigger)
			{
				trigger=handleHideGuide();
			}
			return trigger;
		}		
		
		/**引导关闭 窗口
		 */
		private function handleGuideCloseWindow():Boolean
		{
			if(NewGuideStep.EquipLevelUpStep==NewGuideStep.EquipLevelUp_ToCloseForageWindow)
			{
//				var pt:Point=UIPositionUtil.getPosition(_closeButton,this);
//				NewGuideMovieClipWidthArrow.Instance.initRect(pt.x,pt.y,_closeButton.width,_closeButton.height,NewGuideMovieClipWidthArrow.ArrowDirection_Left);
//				NewGuideMovieClipWidthArrow.Instance.addToContainer(this);
//				NewGuideStep.EquipLevelUpStep=NewGuideStep.EquipLevelUp_None;
				var pt:Point=UIPositionUtil.getUIRootPosition(_closeButton);
				NewGuideDrawHoleUtil.drawHoleByNewGuideMovieClipWidthArrow(pt.x,pt.y,_closeButton.width,_closeButton.height,NewGuideMovieClipWidthArrow.ArrowDirection_Left,_closeButton);
				NewGuideStep.EquipLevelUpStep=NewGuideStep.EquipLevelUp_None;
				return true;
			}
			return false ;
		}
		/**隐藏引导箭头  关闭按钮时候触发
		 */ 
		private function handleHideGuide():Boolean
		{
			if(NewGuideStep.EquipLevelUpStep==NewGuideStep.EquipLevelUp_None)
			{
				NewGuideMovieClipWidthArrow.Instance.hide();
				NewGuideStep.EquipLevelUpStep=-1;
				NewGuideManager.DoGuide();
				return true;
			}
			return false;
		}

		

		
	}
}