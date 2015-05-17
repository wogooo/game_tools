package com.YFFramework.game.core.module.shop
{
	import com.YFFramework.core.utils.common.ClassInstance;
	import com.YFFramework.game.core.global.DataCenter;
	import com.YFFramework.game.core.global.MouseManager;
	import com.YFFramework.game.core.global.manager.EquipBasicManager;
	import com.YFFramework.game.core.global.manager.PropsBasicManager;
	import com.YFFramework.game.core.global.model.EquipBasicVo;
	import com.YFFramework.game.core.global.model.PropsBasicVo;
	import com.YFFramework.game.core.global.util.PriceType;
	import com.YFFramework.game.core.global.util.TypeProps;
	import com.YFFramework.game.core.global.view.tips.EquipTip;
	import com.YFFramework.game.core.global.view.tips.PropsTip;
	import com.YFFramework.game.core.global.view.tips.TipUtil;
	import com.YFFramework.game.core.module.shop.vo.IconUtils;
	import com.YFFramework.game.core.module.shop.vo.ShopBasicVo;
	import com.dolo.ui.controls.Button;
	import com.dolo.ui.controls.IconImage;
	import com.dolo.ui.controls.NumericStepper;
	import com.dolo.ui.controls.Window;
	import com.dolo.ui.managers.UI;
	import com.dolo.ui.tools.AutoBuild;
	import com.dolo.ui.tools.Xdis;
	import com.dolo.ui.tools.Xtip;
	import com.msg.enumdef.MoneyType;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;

	public class BuyWindow extends Window
	{
		private static var _ins:BuyWindow;
		
		private var _ui:Sprite;
		private var _icon:IconImage;
		private var _nameTxt:TextField;
		private var _priceTxt:TextField;
		private var _vo:ShopBasicVo;
		private var _numStep:NumericStepper;
		private var _buyButton:Button;
		private var _priceColor:uint;
		private var _priceUnableColor:uint = 0xFF0000;
		private var _priceTypeIcon:IconImage;
		
		public function BuyWindow()
		{
			setSize(255,185);
			_ui = ClassInstance.getInstance("ui.BuyUI");
			content = _ui;
			AutoBuild.replaceAll(_ui);
			title = "购买";
			_icon = Xdis.getChild(_ui,"icon_iconImage");
			_nameTxt = Xdis.getChild(_ui,"t1");
			_priceTxt = Xdis.getChild(_ui,"price");
			_numStep = Xdis.getChild(_ui,"num_numericStepper");
			_buyButton = Xdis.getChild(_ui,"buy_button");
			_priceTypeIcon = Xdis.getChild(_ui,"priceType_iconImage");
			_buyButton.addEventListener(MouseEvent.CLICK,onBuyClick);
			_numStep.minimum = 1;
			_numStep.maximum = 90000;
			_numStep.maxChars = 5;
			_numStep.value = 1;
			_numStep.addEventListener(Event.CHANGE,updatePrice);
			_priceColor = _priceTxt.textColor;
		}
		
		protected function onBuyClick(event:MouseEvent):void
		{
			close();
			ModuleShop.ins.buyItem(_vo,_numStep.value);
		}
		
		public static function get ins():BuyWindow
		{
			return _ins;
		}
		
		public static function show():BuyWindow
		{
			if(_ins == null) {
				_ins = new BuyWindow();
			}else{
				_ins.reset();
			}
			if(_ins.isOpen == false){
				_ins.open();
			}else{
				_ins.switchToTop();
			}
			if(_ins.mouseX > 0 && _ins.mouseX < _ins.compoWidth && _ins.mouseY > 0 && _ins.mouseY < _ins.compoHeight){
				MouseManager.resetToDefaultMouse();
			}
			return _ins;
		}
		
		public function reset():void
		{
			_numStep.value = 1;
			_priceTypeIcon.clear();
		}
		
		public function init(voData:Object,buyCount:int=1):void
		{
			var vo:ShopBasicVo = voData as ShopBasicVo;
			_vo = vo;
			_icon.url = IconUtils.getIconURL(vo);
			_nameTxt.text = ModuleShop.getItemNameByShopVO(vo);
			_numStep.value = buyCount;
			updatePrice();
			_priceTypeIcon.linkage = PriceType.getLinkageByMoneyType(vo.money_type);
			if(vo.item_type == TypeProps.ITEM_TYPE_PROPS){
				var _propsInfo:PropsBasicVo=PropsBasicManager.Instance.getPropsBasicVo(vo.item_id);
				Xtip.registerLinkTip(_icon,PropsTip,TipUtil.propsTipInitFunc,0,_propsInfo.template_id);
			}else if(vo.item_type == TypeProps.ITEM_TYPE_EQUIP){
				var _equipInfo:EquipBasicVo=EquipBasicManager.Instance.getEquipBasicVo(vo.item_id);
				Xtip.registerLinkTip(_icon,EquipTip,TipUtil.equipTipInitFunc,0,_equipInfo.template_id);
			}
		}
		
		private function updatePrice(event:Event = null):void
		{
			var priNum:int = _vo.price*int(_numStep.value);
			_priceTxt.text = String(priNum);
			var nowVol:int;
			switch(_vo.money_type){
				case MoneyType.MONEY_DIAMOND:
					nowVol = DataCenter.Instance.roleSelfVo.diamond;
					break;
				case MoneyType.MONEY_COUPON:
					nowVol = DataCenter.Instance.roleSelfVo.coupon;
					break;
				case MoneyType.MONEY_SILVER:
					nowVol = DataCenter.Instance.roleSelfVo.silver;
					break;
				case MoneyType.MONEY_NOTE:
					nowVol = DataCenter.Instance.roleSelfVo.note;
					break;
			}
			if(priNum>nowVol){
				UI.setEnable(_buyButton,false);
				_priceTxt.textColor = _priceUnableColor;
			}else{
				UI.setEnable(_buyButton,true);
				_priceTxt.textColor = _priceColor;
			}
		}
		
	}
}