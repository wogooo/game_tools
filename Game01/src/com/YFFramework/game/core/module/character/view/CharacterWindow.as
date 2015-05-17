package com.YFFramework.game.core.module.character.view
{
	/**人物面板
	 * @author yefeng
	 *2012-8-21下午9:55:37
	 */
	import com.YFFramework.core.ui.abs.GameWindow;
	import com.YFFramework.core.ui.yfComponent.controls.YFTabMenu;
	import com.YFFramework.game.core.global.lang.Lang;
	
	public class CharacterWindow extends GameWindow
	{
		
		private var _characterBodyWindnow:CharacterBodyView;
		private var _tabMenu:YFTabMenu;
		public function CharacterWindow()
		{
			super(380, 430);
		}
		override protected function initUI():void
		{
			super.initUI();
			/// tabMenu 创建
			_tabMenu=new YFTabMenu(60);
			addChild(_tabMenu);
			_tabMenu.y=_bgTop.y+_bgTop.height+2;
			_tabMenu.x=20;
			_tabMenu.addItem({name:Lang.ZhuangBei,index:1},"name");
			_tabMenu.setSelectIndex(0);
			/// 装备装备面板
			_characterBodyWindnow=new CharacterBodyView();
			addChild(_characterBodyWindnow);
			_characterBodyWindnow.y=_bgTop.y+_bgTop.height+30;
			_characterBodyWindnow.x=20
			initLabel();
		}
		
		override protected function addEvents():void
		{
			super.addEvents();
		}
		
		
		override protected function removeEvents():void
		{
			super.removeEvents();
		}
		
		/**
		 */		
		private function initLabel():void
		{
			
		}
		
	}
}