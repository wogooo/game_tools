package com.YFFramework.game.core.module.shop
{
	import com.YFFramework.core.utils.URLTool;
	import com.YFFramework.core.utils.common.ClassInstance;
	import com.YFFramework.game.core.global.MouseManager;
	import com.YFFramework.game.core.global.MouseStyle;
	import com.YFFramework.game.core.module.shop.vo.ShopBasicVo;
	import com.dolo.common.PageControlUI;
	import com.dolo.ui.controls.TileList;
	import com.dolo.ui.data.ListItem;
	import com.dolo.ui.managers.UI;
	import com.dolo.ui.tools.AutoBuild;
	import com.dolo.ui.tools.Xdis;
	
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;

	/**
	 * 控制显示单个Tab 
	 * @author flashk
	 * 
	 */
	public class NPCShopOneTabView extends PageControlUI
	{
		private var _ui:Sprite;
		
		public function NPCShopOneTabView()
		{
			this.x = 32;
			this.y = 43;
			_pageList = new ShopPageList();
			_ui = ClassInstance.getInstance("ui.ShopItemListShow");
			AutoBuild.replaceAll(_ui);
			this.addChild(_ui);
			_nextBtn = Xdis.getChild(_ui,"nextPage_btn");
			_prevBtn = Xdis.getChild(_ui,"prevPage_btn");
			_pageTxt = Xdis.getChild(_ui,"page_txt");
			initButtonEvents();
			for(var i:int=0;i<_onePageMaxCount;i++){
				_pageList.addItemView(_ui.getChildByName("item"+i) as Sprite);
			}
			this.addEventListener(MouseEvent.ROLL_OVER,onMouseRollOver);
			this.addEventListener(MouseEvent.ROLL_OUT,onMouseRollOut);
		}
		
		/**
		 * 重置为默认鼠标样式 
		 * @param event
		 * 
		 */
		protected function onMouseRollOut(event:MouseEvent):void
		{
			MouseManager.resetToDefaultMouse();
		}
		
		/**
		 * 判断鼠标是否在物品分页区域，如果是，显示买的鼠标样式 
		 * @param event
		 * 
		 */
		protected function onMouseRollOver(event:MouseEvent):void
		{
			if(this.mouseY > 240 || ShopWindow.ins.isBuyMode != true){
				MouseManager.resetToDefaultMouse();
			}else{
				MouseManager.changeMouse(MouseStyle.BUY);
			}
		}
		
		/**
		 * 更新这个Tab的数据和显示 
		 * @param voList
		 * 
		 */
		public function updateList(voList:Vector.<ShopBasicVo>):void
		{
			initData(voList,true);
		}
		
	}
}