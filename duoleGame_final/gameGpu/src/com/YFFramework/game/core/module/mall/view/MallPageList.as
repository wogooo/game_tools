package com.YFFramework.game.core.module.mall.view
{
	/**
	 * @version 1.0.0
	 * creation time：2013-4-27 下午4:22:26
	 * 
	 */
	import com.YFFramework.core.utils.common.ClassInstance;
	import com.YFFramework.game.core.global.manager.EquipBasicManager;
	import com.YFFramework.game.core.global.manager.PropsBasicManager;
	import com.YFFramework.game.core.global.model.EquipBasicVo;
	import com.YFFramework.game.core.global.model.PropsBasicVo;
	import com.YFFramework.game.core.global.util.TypeProps;
	import com.YFFramework.game.core.global.view.tips.EquipTip;
	import com.YFFramework.game.core.global.view.tips.EquipTipMix;
	import com.YFFramework.game.core.global.view.tips.PropsTip;
	import com.YFFramework.game.core.global.view.tips.TipUtil;
	import com.YFFramework.game.core.module.ModuleManager;
	import com.YFFramework.game.core.module.shop.data.ShopBasicManager;
	import com.YFFramework.game.core.module.shop.data.ShopBasicVo;
	import com.dolo.common.PageItemListBase;
	import com.dolo.ui.controls.Button;
	import com.dolo.ui.controls.IconImage;
	import com.dolo.ui.managers.UI;
	import com.dolo.ui.renders.ListRenderBase;
	import com.dolo.ui.tools.AutoBuild;
	import com.dolo.ui.tools.Xdis;
	import com.dolo.ui.tools.Xtip;
	import com.msg.enumdef.ItemType;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.utils.Dictionary;
	
	public class MallPageList extends PageItemListBase
	{
		//======================================================================
		//       public property
		//======================================================================
		
		//======================================================================
		//       private property
		//======================================================================
//		private var _mc:MovieClip;
		
		private var _itemName:TextField;
		private var _orgPrice:TextField;
		private var _price:TextField;
		private var _type:int;//道具还是装备
		private var _shopPos:int;//在商店里的位置
		private var _icon:IconImage;
		private var _buyBtn:Button;
		
//		private var _templateId:int;
		
		private var _dict:Dictionary;
		//======================================================================
		//        constructor
		//======================================================================
		
		public function MallPageList()
		{
			_dict=new Dictionary();
		}
		
		//======================================================================
		//        public function
		//======================================================================	
		override protected function initItem(data:Object,view:Sprite,index:int):void
		{
			var vo:ShopBasicVo = data as ShopBasicVo;
			
			_buyBtn= Xdis.getChild(view,"buy_button");
			_itemName=Xdis.getTextChild(view,"mname");
			_orgPrice=Xdis.getTextChild(view,"orgPrice");
			_price=Xdis.getTextChild(view,"price");
			_icon=Xdis.getChild(view,"buy_iconImage");
			
			var _propsInfo:PropsBasicVo;
			var _equipInfo:EquipBasicVo;
			if(vo.binding_type == ItemType.ITEM_TYPE_EMPTY)
			{
				if(vo.item_type == ItemType.ITEM_TYPE_PROPS){
					_propsInfo=PropsBasicManager.Instance.getPropsBasicVo(vo.item_id);
					_icon.url = PropsBasicManager.Instance.getURL(vo.item_id);
					_itemName.text=PropsBasicManager.Instance.getPropsBasicVo(vo.item_id).name;
					Xtip.registerLinkTip(_icon,PropsTip,TipUtil.propsTipInitFunc,0,_propsInfo.template_id);
				}else if(vo.item_type == ItemType.ITEM_TYPE_EQUIP){
					_equipInfo=EquipBasicManager.Instance.getEquipBasicVo(vo.item_id);
					_icon.url=EquipBasicManager.Instance.getURL(vo.item_id);
					_itemName.text=EquipBasicManager.Instance.getEquipBasicVo(vo.item_id).name;
					Xtip.registerLinkTip(_icon,EquipTip,TipUtil.equipTipInitFunc,0,_equipInfo.template_id);
				}
			}
			else
			{
				if(vo.item_type == ItemType.ITEM_TYPE_PROPS){
					_propsInfo=PropsBasicManager.Instance.getPropsBasicVo(vo.item_id);
					_icon.url = PropsBasicManager.Instance.getURL(vo.item_id);
					_itemName.text=PropsBasicManager.Instance.getPropsBasicVo(vo.item_id).name;
					Xtip.registerLinkTip(_icon,PropsTip,TipUtil.propsTipInitFunc,0,_propsInfo.template_id,null,false,vo.binding_type);
				}else if(vo.item_type == ItemType.ITEM_TYPE_EQUIP){
					_equipInfo=EquipBasicManager.Instance.getEquipBasicVo(vo.item_id);
					_icon.url=EquipBasicManager.Instance.getURL(vo.item_id);
					_itemName.text=EquipBasicManager.Instance.getEquipBasicVo(vo.item_id).name;
					Xtip.registerLinkTip(_icon,EquipTip,TipUtil.equipTipInitFunc,0,_equipInfo.template_id,false,null,false,vo.binding_type);
				}
			}
			
			var moneyType1:Sprite = view.getChildByName("moneyType1") as Sprite;
			var moneyType2:Sprite = view.getChildByName("moneyType2") as Sprite;
//			UI.removeAllChilds(moneyType1);
//			UI.removeAllChilds(moneyType2);
			if(vo.money_type == TypeProps.MONEY_DIAMOND)
			{
				moneyType1.addChild(ClassInstance.getInstance("diamond"));
				moneyType2.addChild(ClassInstance.getInstance("diamond"));
			}
			else if(vo.money_type == TypeProps.MONEY_SILVER)
			{
				trace("MallPageItemList 123行没有银币这个货币")
//				moneyType1.addChild(ClassInstance.getInstance("silver"));
//				moneyType2.addChild(ClassInstance.getInstance("silver"));
			}
			else if(vo.money_type == TypeProps.MONEY_COUPON)
			{
				moneyType1.addChild(ClassInstance.getInstance("coupon"));
				moneyType2.addChild(ClassInstance.getInstance("coupon"));
			}
			else
			{
				moneyType1.addChild(ClassInstance.getInstance("note"));
				moneyType2.addChild(ClassInstance.getInstance("note"));
			}
			
			_orgPrice.text=vo.org_price.toString();
			
			_price.text=vo.price.toString();
			
			_shopPos=vo.pos;
			
			_buyBtn.addEventListener(MouseEvent.CLICK,onBuyClick);
			
			_dict[_buyBtn]=vo;
		}
		
		override protected function disposeItem(view:Sprite):void
		{
			_buyBtn= Xdis.getChild(view,"buy_button");
			_buyBtn.removeEventListener(MouseEvent.CLICK,onBuyClick);
			_dict[_buyBtn]=null;
			delete _dict[_buyBtn];
			
			_icon=Xdis.getChild(view,"buy_iconImage");
			Xtip.clearLinkTip(_icon);
			_icon.clear();
			
			var moneyType1:Sprite = view.getChildByName("moneyType1") as Sprite;
			var moneyType2:Sprite = view.getChildByName("moneyType2") as Sprite;
			UI.removeAllChilds(moneyType1);
			UI.removeAllChilds(moneyType2);
			
		}
		//======================================================================
		//        private function
		//======================================================================
		
		//======================================================================
		//        event handler
		//======================================================================
		private function onBuyClick(e:MouseEvent):void
		{
			var btn:Button=e.currentTarget as Button;
			var data:ShopBasicVo=_dict[btn];
			ModuleManager.moduleShop.openBuySmallWindow(data);
		}
		//======================================================================
		//        getter&setter
		//======================================================================
		
		
	}
} 