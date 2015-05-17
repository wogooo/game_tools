package com.YFFramework.game.core.module.backpack.view
{
	import com.YFFramework.core.debug.print;
	import com.YFFramework.core.event.ParamEvent;
	import com.YFFramework.core.event.YFEventCenter;
	import com.YFFramework.core.ui.abs.AbsUIView;
	import com.YFFramework.core.ui.layer.LayerManager;
	import com.YFFramework.core.ui.yfComponent.controls.YFList;
	import com.YFFramework.core.ui.yfComponent.events.YFControlEvent;
	import com.YFFramework.game.core.global.lang.Lang;
	import com.YFFramework.game.core.global.manager.GoodsBasicManager;
	import com.YFFramework.game.core.module.backpack.events.BackpackEvent;
	import com.YFFramework.game.core.module.backpack.model.BackPackUtil;
	import com.YFFramework.game.core.module.backpack.model.UseEquipGoodsVo;
	import com.YFFramework.game.ui.display.GoodsIconView;
	
	import flash.events.Event;
	
	/**  背包下拉菜单
	 * 下拉菜单 
	 * 2012-8-20 下午4:20:39
	 *@author yefeng
	 */
	public class BackpackMenuListView extends AbsUIView
	{
		protected var _menuList:YFList;
		private static var _instance:BackpackMenuListView;
		/**选中对象的动态vo 
		 */
		protected var _goodsIconView:GoodsIconView;
		
		private var _objArr:Array;
		public function BackpackMenuListView(autoRemove:Boolean=false)
		{
			super(autoRemove);
		}
		public static function get Instance():BackpackMenuListView
		{
			if(!_instance) _instance=new BackpackMenuListView();
			return _instance;
		}
		override protected function initUI():void
		{
			super.initUI();
			_objArr=[{name:Lang.Shi_Yong,index:BackPackUtil.Use},{name:Lang.Zhan_Shi,index:BackPackUtil.Show},{name:Lang.Diu_Qi,index:BackPackUtil.Drop}];
			_menuList=new YFList(50,0,5);
			for each (var obj:Object in _objArr)
			{
				_menuList.addItem(obj,"name");
				addChild(_menuList);
			}
		}
		
		/**显示
		 */		
		public function show(targtet:GoodsIconView):void
		{
			_goodsIconView=targtet;
			if(!LayerManager.MenuListLayer.contains(this))
			{
				LayerManager.MenuListLayer.addChild(this);
				///重置当前选中的listItem  没有一个进行选中
				_menuList.setNullSelect();
			}
			this.x=LayerManager.MenuListLayer.mouseX+10;
			this.y=LayerManager.MenuListLayer.mouseY;
			var isEquipVo:Boolean=GoodsBasicManager.Instance.isEquip(_goodsIconView.goodsDyVo.basicId);
			////是否为 药水等消耗性物品 
			var isMedicine:Boolean=GoodsBasicManager.Instance.isMedicine(_goodsIconView.goodsDyVo.basicId);
			if(isEquipVo||isMedicine)  ////当为可以直接使用的物品
			{
				if(!_menuList.containsItem(_objArr[0]))_menuList.addItemAt(_objArr[0],"name",0);
			}
			else   ///当为不可直接使用的物品时
			{
				if(_menuList.containsItem(_objArr[0]))_menuList.removeItem(_objArr[0]);
			}
		}
		/**隐藏
		 */		
		public function hide():void
		{
			if(LayerManager.MenuListLayer.contains(this))LayerManager.MenuListLayer.removeChild(this);
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
				case BackPackUtil.Use:
					//使用 
					///是否为装备 
					var isEquipVo:Boolean=GoodsBasicManager.Instance.isEquip(_goodsIconView.goodsDyVo.basicId);
					////是否为 药水等消耗性物品 
					var isMedicine:Boolean=GoodsBasicManager.Instance.isMedicine(_goodsIconView.goodsDyVo.basicId);
					if(isEquipVo)
					{ ////当为装备物品时
						var useEquipGoodsVo:UseEquipGoodsVo=new UseEquipGoodsVo();
						useEquipGoodsVo.dyId=_goodsIconView.goodsDyVo.dyId;
					//	YFEventCenter.Instance.dispatchEvent(new YFEvent(BackpackEvent.C_EquipGoods,useEquipGoodsVo));
						YFEventCenter.Instance.dispatchEventWith(BackpackEvent.C_EquipGoods,useEquipGoodsVo);
					}
					else if(isMedicine)////消耗性道具  也就是 药水  等
					{
						///使用物品消耗性物品   发送  给 BackpackIconCDView处理
						_goodsIconView.dispatchEvent(new ParamEvent(BackpackEvent.PlayCD,_goodsIconView.goodsDyVo));/////播放CD动画
					}
					break;
				case BackPackUtil.Show:
					//展示
					print(this,"展示功能暂时没有....");
					break;
				case BackPackUtil.Drop:
					//丢弃  通知   BackpackWindow 进行物品删除操作
					YFEventCenter.Instance.dispatchEventWith(BackpackEvent.NoticeOtherViewDeleteGoodsVo,_goodsIconView.goodsDyVo.dyId);
					break;
			}
		}

		override public function dispose(e:Event=null):void
		{
			super.dispose();	
		}
	}
}