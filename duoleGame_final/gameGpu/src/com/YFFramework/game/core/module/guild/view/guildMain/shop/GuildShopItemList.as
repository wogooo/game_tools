package com.YFFramework.game.core.module.guild.view.guildMain.shop
{
	import com.YFFramework.game.core.global.manager.EquipBasicManager;
	import com.YFFramework.game.core.global.manager.PropsBasicManager;
	import com.YFFramework.game.core.global.model.PropsBasicVo;
	import com.YFFramework.game.core.global.util.NoticeUtil;
	import com.YFFramework.game.core.global.util.TypeProps;
	import com.YFFramework.game.core.global.view.tips.EquipTip;
	import com.YFFramework.game.core.global.view.tips.PropsTip;
	import com.YFFramework.game.core.global.view.tips.TipUtil;
	import com.YFFramework.game.core.module.bag.data.BagStoreManager;
	import com.YFFramework.game.core.module.guild.manager.GuildInfoManager;
	import com.YFFramework.game.core.module.guild.manager.Guild_BuildingBasicManager;
	import com.YFFramework.game.core.module.guild.model.TypeBuilding;
	import com.YFFramework.game.core.module.notice.manager.NoticeManager;
	import com.YFFramework.game.core.module.notice.model.NoticeType;
	import com.YFFramework.game.core.module.notice.model.NoticeUtils;
	import com.YFFramework.game.core.module.shop.controller.ModuleShop;
	import com.YFFramework.game.core.module.shop.data.ShopBasicVo;
	import com.dolo.common.PageItemListBase;
	import com.dolo.lang.LangBasic;
	import com.dolo.ui.controls.Button;
	import com.dolo.ui.controls.IconImage;
	import com.dolo.ui.tools.Xdis;
	import com.dolo.ui.tools.Xtip;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.utils.Dictionary;
	
	/***
	 *
	 *@author ludingchang 时间：2013-9-14 下午3:35:52
	 */
	public class GuildShopItemList extends PageItemListBase
	{

		private var _dic:Dictionary;
		public function GuildShopItemList()
		{
			super();
			_dic=new Dictionary;
		}
		
		override protected function initItem(data:Object, view:Sprite, index:int):void
		{
			var _data:ShopBasicVo=data as ShopBasicVo;
			_dic[view]=_data;
			var name_txt:TextField=Xdis.getTextChild(view,"name_txt");
			var value_txt:TextField=Xdis.getTextChild(view,"value_txt");
			var buy_btn:Button=Xdis.getChildAndAddClickEvent(onBuy,view,"buy_button");
			var icon:IconImage=Xdis.getChild(view,"icon_iconImage");
		
			if(_data.item_type==TypeProps.ITEM_TYPE_PROPS)
			{
				var propsBasicVo:PropsBasicVo=PropsBasicManager.Instance.getPropsBasicVo(_data.item_id);
				name_txt.text=propsBasicVo.name;
				icon.url=PropsBasicManager.Instance.getURL(_data.item_id);
				Xtip.registerLinkTip(icon,PropsTip,TipUtil.propsTipInitFunc,0,_data.item_id);
			}
			else if(_data.item_type==TypeProps.ITEM_TYPE_EQUIP)
			{
				name_txt.text=EquipBasicManager.Instance.getEquipBasicVo(_data.item_id).name;
				icon.url=EquipBasicManager.Instance.getURL(_data.item_id);
				Xtip.registerLinkTip(icon,EquipTip,TipUtil.equipTipInitFunc,0,_data.item_id);
			}
			
			var shopLv:int=GuildInfoManager.Instence.getBuildingLv(TypeBuilding.SHOP);
			var discont:int=Guild_BuildingBasicManager.Instance.getEffectValue(TypeBuilding.SHOP,shopLv);//折扣
			value_txt.text=(_data.price*discont/100).toFixed()+NoticeUtils.getStr(NoticeType.Notice_id_100072);
		}
		
		private function onBuy(e:MouseEvent):void
		{
			var vo:ShopBasicVo=_dic[(e.currentTarget as DisplayObject).parent];
			if(vo == null) return;
			if(BagStoreManager.instantce.checkBagHasEnoughGrids(vo.item_id,1,vo.item_type)==false){
				NoticeUtil.setOperatorNotice(LangBasic.cantPutInBag);
				return;
			}
			var shopLv:int=GuildInfoManager.Instence.getBuildingLv(TypeBuilding.SHOP);
			var discont:int=Guild_BuildingBasicManager.Instance.getEffectValue(TypeBuilding.SHOP,shopLv);//折扣
			if(int(vo.price*discont/100)>GuildInfoManager.Instence.me.contribution)
			{
				NoticeManager.setNotice(NoticeType.Notice_id_1357);
				return;
			}
			ModuleShop.instance.buyItem(vo,1);
		}
		
		override protected function disposeItem(view:Sprite):void
		{
			var buy_btn:Button=Xdis.getChild(view,"buy_button");
			buy_btn.removeMouseClickEventListener(onBuy);
			
			var icon:IconImage=Xdis.getChild(view,"icon_iconImage");
			Xtip.clearLinkTip(icon);
		}
	}
}