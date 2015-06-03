package com.YFFramework.game.core.module.shop.view
{
	import com.YFFramework.core.text.HTMLUtil;
	import com.YFFramework.core.utils.common.ClassInstance;
	import com.YFFramework.game.core.global.manager.EquipBasicManager;
	import com.YFFramework.game.core.global.manager.PropsBasicManager;
	import com.YFFramework.game.core.global.model.EquipBasicVo;
	import com.YFFramework.game.core.global.model.PropsBasicVo;
	import com.YFFramework.game.core.global.util.PriceType;
	import com.YFFramework.game.core.global.util.TypeProps;
	import com.YFFramework.game.core.global.view.tips.EquipTip;
	import com.YFFramework.game.core.global.view.tips.PropsTip;
	import com.YFFramework.game.core.global.view.tips.TipUtil;
	import com.YFFramework.game.core.module.bag.source.BagSource;
	import com.YFFramework.game.core.module.shop.controller.ModuleShop;
	import com.YFFramework.game.core.module.shop.data.IconUtils;
	import com.YFFramework.game.core.module.shop.data.ShopBasicVo;
	import com.dolo.common.PageItemListBase;
	import com.dolo.ui.controls.IconImage;
	import com.dolo.ui.managers.UI;
	import com.dolo.ui.tools.Xdis;
	import com.dolo.ui.tools.Xtip;
	import com.msg.enumdef.BindingType;
	import com.msg.enumdef.ItemType;
	
	import flash.display.Sprite;
	import flash.text.TextField;

	/**
	 * 商店翻页 
	 * @author flashk
	 * 
	 */
	public class ShopPageList extends PageItemListBase
	{
		
		public function ShopPageList()
		{
			super();
		}
		
		/**
		 * 渲染器项目划出的显示处理
		 * @param view
		 * 
		 */
//		override protected function onItemOut(view:Sprite):void
//		{
//			view.getChildByName("rollShow").visible = false;
//		}
		
		/**
		 * 渲染器项目划过的显示处理
		 * @param view
		 * 
		 */
//		override protected function onItemOver(view:Sprite):void
//		{
//			view.getChildByName("rollShow").visible = true;
//		}
		
		/**
		 * 渲染器项目被用户选中的显示处理 
		 * @param view
		 * 
		 */
//		override protected function onItemSelect(view:Sprite):void
//		{
//			view.getChildByName("rollShow").visible = true;
//		}
		
		/**
		 * 渲染器项目被用户选中的逻辑处理 
		 * @param view
		 * 
		 */
		override protected function onItemClick(view:Sprite,vo:Object,index:int):void
		{
			if(BagSource.shopMode == BagSource.SHOP_BUY){
				BuyWindow.show();
				BuyWindow.instance.init(vo);
			}
		}
		
		/**
		 * 子类覆盖此方法，显示Item内容 
		 * @param data
		 * @param view
		 * 
		 */
		override protected function initItem(data:Object,view:Sprite,index:int):void
		{
			var vo:ShopBasicVo = data as ShopBasicVo;
			
			var icon:IconImage = view.getChildByName("icon_iconImage") as IconImage;
//			UI.removeAllChilds(icon);
			icon.url = IconUtils.getIconURL(vo);
			
			var txt:TextField = view.getChildByName("t1") as TextField;
			txt.htmlText = HTMLUtil.createHtmlText(ModuleShop.getItemNameByShopVO(vo),12,TypeProps.getQualityColor(ModuleShop.getItemQuality(vo)));
			
			var priceTxt:TextField = view.getChildByName("t2") as TextField;
			priceTxt.text = String(vo.price);
			
			var priceIcon:Sprite = view.getChildByName("priceIcon") as Sprite;
//			UI.removeAllChilds(priceIcon);
			if(vo.money_type == TypeProps.MONEY_DIAMOND)
				priceIcon.addChild(ClassInstance.getInstance("diamond"));
			else if(vo.money_type == TypeProps.MONEY_SILVER)
				trace("ShopPageList 110行，没有银币货币！")
//				priceIcon.addChild(ClassInstance.getInstance("silver"));
			else if(vo.money_type == TypeProps.MONEY_COUPON)
				priceIcon.addChild(ClassInstance.getInstance("coupon"));
			else
				priceIcon.addChild(ClassInstance.getInstance("note"));
			
			var _propsInfo:PropsBasicVo;
			var _equipInfo:EquipBasicVo;
			if(vo.binding_type == ItemType.ITEM_TYPE_EMPTY)
			{
				if(vo.item_type == ItemType.ITEM_TYPE_PROPS){
					_propsInfo=PropsBasicManager.Instance.getPropsBasicVo(vo.item_id);
					Xtip.registerLinkTip(view,PropsTip,TipUtil.propsTipInitFunc,0,_propsInfo.template_id);
				}else if(vo.item_type == ItemType.ITEM_TYPE_EQUIP){
					_equipInfo=EquipBasicManager.Instance.getEquipBasicVo(vo.item_id);
					Xtip.registerLinkTip(view,EquipTip,TipUtil.equipTipInitFunc,0,_equipInfo.template_id);
				}
			}
			else
			{
				if(vo.item_type == ItemType.ITEM_TYPE_PROPS){
					_propsInfo=PropsBasicManager.Instance.getPropsBasicVo(vo.item_id);
					Xtip.registerLinkTip(view,PropsTip,TipUtil.propsTipInitFunc,0,_propsInfo.template_id,null,false,vo.binding_type);
				}else if(vo.item_type == ItemType.ITEM_TYPE_EQUIP){
					_equipInfo=EquipBasicManager.Instance.getEquipBasicVo(vo.item_id);
					Xtip.registerLinkTip(view,EquipTip,TipUtil.equipTipInitFunc,0,_equipInfo.template_id,false,null,false,vo.binding_type);
				}
			}
			
			var lock:Sprite=Xdis.getDisplayObjectChild(view,"lock_mc") as Sprite;
//			UI.removeAllChilds(lock);
			if(vo.binding_type > 0 && vo.binding_type == TypeProps.BIND_TYPE_YES)
				lock.addChild(ClassInstance.getInstance("lock"));
			else
			{
				if(vo.item_type == TypeProps.ITEM_TYPE_PROPS)
				{
					var props:PropsBasicVo=PropsBasicManager.Instance.getPropsBasicVo(vo.item_id);
					if(props.binding_type == TypeProps.BIND_TYPE_YES)
						lock.addChild(ClassInstance.getInstance("lock"));
				}
				else
				{
					var equip:EquipBasicVo=EquipBasicManager.Instance.getEquipBasicVo(vo.item_id);
					if(equip.binding_type == TypeProps.BIND_TYPE_YES)
						lock.addChild(ClassInstance.getInstance("lock"));
				}
			}

		}
		
		override protected function disposeItem(view:Sprite):void
		{
			Xtip.clearLinkTip(view);
			var icon:IconImage = view.getChildByName("icon_iconImage") as IconImage;
			icon.clear();
			
			var priceIcon:Sprite = view.getChildByName("priceIcon") as Sprite;
			UI.removeAllChilds(priceIcon);
			
			var lock:Sprite=Xdis.getDisplayObjectChild(view,"lock_mc") as Sprite;
			UI.removeAllChilds(lock);
			
		}
		
	}
}