package com.YFFramework.game.core.module.character.view
{
	import com.YFFramework.core.debug.print;
	import com.YFFramework.core.event.ParamEvent;
	import com.YFFramework.core.event.YFEventCenter;
	import com.YFFramework.core.ui.abs.AbsView;
	import com.YFFramework.core.ui.layer.LayerManager;
	import com.YFFramework.core.ui.yfComponent.controls.YFList;
	import com.YFFramework.core.ui.yfComponent.events.YFControlEvent;
	import com.YFFramework.game.core.global.lang.Lang;
	import com.YFFramework.game.core.module.character.events.CharacterEvent;
	
	import flash.events.Event;
	
	/** 人物角色下拉菜单
	 * 下拉菜单
	 * 2012-8-23 下午3:10:48
	 *@author yefeng
	 */
	public class CharacterListView extends AbsView
	{
		
		/**卸下
		 */		
		private static const XieXiaIndex:int=1;
		/**展示
		 */
		private static const ZhanShiIndex:int=2;
		protected var _menuList:YFList;

		protected var _objArr:Array;
		public function CharacterListView(autoRemove:Boolean=false)
		{
			super(autoRemove);
		}
		
		override protected function initUI():void
		{
			super.initUI();
			_objArr=[{name:Lang.XieXia,index:XieXiaIndex},{name:Lang.Zhan_Shi,index:ZhanShiIndex}];
			_menuList=new YFList(50,5);
			for each (var obj:Object in _objArr)
			{
				_menuList.addItem(obj,"name");
			}
		}
		
		override protected function addEvents():void
		{
			super.addEvents();
			_menuList.addEventListener(YFControlEvent.Select,onSelect);
		}
		
		override protected function removeEvents():void
		{
			super.removeEvents();
			_menuList.removeEventListener(YFControlEvent.Select,onSelect);
		}
		
		private function onSelect(e:ParamEvent):void
		{
			var data:Object=_menuList.getSelectData();
			switch(data.index)
			{
				case XieXiaIndex:  ////卸下装备 
					
					break;
				case ZhanShiIndex:  ///展示装备
					print(this,"展示装备...");
					break;
			}
		}
		/**通知服务端脱下装备
		 */		
		private function noticePutOffEquip(dyId:String):void
		{
			YFEventCenter.Instance.dispatchEventWith(CharacterEvent.C_PutOffEquip,dyId);
		}
		public function show():void
		{
			if(!LayerManager.MenuListLayer.contains(this))
			{
				LayerManager.MenuListLayer.addChild(this);
				_menuList.setNullSelect();
			}
			this.x=LayerManager.MenuListLayer.mouseX+10;
			this.y=LayerManager.MenuListLayer.mouseY;
		}
		
		public function hide():void
		{
			if(LayerManager.MenuListLayer.contains(this)) LayerManager.MenuListLayer.removeChild(this);
		}

		
	}
}