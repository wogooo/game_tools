package com.YFFramework.game.core.module.shop
{
	import com.YFFramework.game.core.global.manager.EquipBasicManager;
	import com.YFFramework.game.core.global.manager.PropsBasicManager;
	import com.YFFramework.game.core.global.model.EquipBasicVo;
	import com.YFFramework.game.core.global.model.PropsBasicVo;
	import com.YFFramework.game.core.global.util.PriceType;
	import com.YFFramework.game.core.global.view.tips.EquipTip;
	import com.YFFramework.game.core.global.view.tips.PropsTip;
	import com.YFFramework.game.core.global.view.tips.TipUtil;
	import com.YFFramework.game.core.module.shop.vo.IconUtils;
	import com.YFFramework.game.core.module.shop.vo.ShopBasicVo;
	import com.dolo.common.PageItemListBase;
	import com.dolo.ui.controls.IconImage;
	import com.dolo.ui.tools.Xtip;
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
		override protected function onItemOut(view:Sprite):void
		{
			view.getChildByName("rollShow").visible = false;
		}
		
		/**
		 * 渲染器项目划过的显示处理
		 * @param view
		 * 
		 */
		override protected function onItemOver(view:Sprite):void
		{
			view.getChildByName("rollShow").visible = true;
		}
		
		/**
		 * 渲染器项目被用户选中的显示处理 
		 * @param view
		 * 
		 */
		override protected function onItemSelect(view:Sprite):void
		{
			view.getChildByName("rollShow").visible = true;
		}
		
		/**
		 * 渲染器项目被用户选中的逻辑处理 
		 * @param view
		 * 
		 */
		override protected function onItemClick(view:Sprite,vo:Object,index:int):void
		{
			if(ShopWindow.ins.isBuyMode == true){
				BuyWindow.show();
				BuyWindow.ins.init(vo);
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
			icon.url = IconUtils.getIconURL(vo);
			var txt:TextField = view.getChildByName("t1") as TextField;
			txt.text = ModuleShop.getItemNameByShopVO(vo);
			var priceTxt:TextField = view.getChildByName("t2") as TextField;
			priceTxt.text = String(vo.price);
			var priceTypeIcon:IconImage = view.getChildByName("priceType_iconImage") as IconImage;
			priceTypeIcon.linkage = PriceType.getLinkageByMoneyType(vo.money_type);
			if(vo.item_type == ItemType.ITEM_TYPE_PROPS){
				var _propsInfo:PropsBasicVo=PropsBasicManager.Instance.getPropsBasicVo(vo.item_id);
				Xtip.registerLinkTip(view,PropsTip,TipUtil.propsTipInitFunc,0,_propsInfo.template_id);
			}else if(vo.item_type == ItemType.ITEM_TYPE_EQUIP){
				var _equipInfo:EquipBasicVo=EquipBasicManager.Instance.getEquipBasicVo(vo.item_id);
				Xtip.registerLinkTip(view,EquipTip,TipUtil.equipTipInitFunc,0,_equipInfo.template_id);
			}
		}
		
	}
}