package com.YFFramework.game.core.module.forge.view
{
	import com.dolo.ui.controls.Window;
	import com.dolo.ui.managers.TabsManager;
	import com.dolo.ui.managers.TabsMovieClipManager;
	import com.dolo.ui.tools.Xdis;
	
	import flash.display.Sprite;
	
	public class ForgeWindow extends Window
	{
		private var _tabs:TabsMovieClipManager;
		private var _ui:Sprite;
		private var _strengthenCOL:EquipStrengthenCOL;
		private var _inlayGemCOL:InlayGemCOL;
		private var  _shiftCOL:StrengthenShiftCOL;
		
		public function ForgeWindow()
		{
			_ui = initByArgument(660,523,"ui.ForgeWindowUI","锻造");
			_tabs = new TabsMovieClipManager();
			_tabs.initTabs(_ui,"tabs_sp",6);
			_strengthenCOL = new EquipStrengthenCOL(Xdis.getChild(_ui,"tabView1"));
			_shiftCOL = new StrengthenShiftCOL(Xdis.getChild(_ui,"tabView2"));
			_inlayGemCOL = new InlayGemCOL(Xdis.getChild(_ui,"tabView3"));
		}
		
		public function get shiftCOL():StrengthenShiftCOL
		{
			return _shiftCOL;
		}

		override public function open():void
		{
			super.open();
//			_strengthenCOL.updateBag();
		}
		
		public function updateInlayGemBag():void
		{
			_inlayGemCOL.updateBag();
		}
	}
}