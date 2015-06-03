package com.YFFramework.game.core.module.shop.view
{
	import com.YFFramework.core.event.YFEvent;
	import com.YFFramework.core.event.YFEventCenter;
	import com.YFFramework.core.text.HTMLUtil;
	import com.YFFramework.core.utils.common.ClassInstance;
	import com.YFFramework.game.core.global.DataCenter;
	import com.YFFramework.game.core.global.MouseManager;
	import com.YFFramework.game.core.global.event.GlobalEvent;
	import com.YFFramework.game.core.global.manager.EquipBasicManager;
	import com.YFFramework.game.core.global.manager.EquipDyManager;
	import com.YFFramework.game.core.global.manager.PropsBasicManager;
	import com.YFFramework.game.core.global.manager.PropsDyManager;
	import com.YFFramework.game.core.global.model.EquipBasicVo;
	import com.YFFramework.game.core.global.model.PropsBasicVo;
	import com.YFFramework.game.core.global.util.NoticeUtil;
	import com.YFFramework.game.core.global.util.TypeProps;
	import com.YFFramework.game.core.global.view.tips.EquipTip;
	import com.YFFramework.game.core.global.view.tips.EquipTipMix;
	import com.YFFramework.game.core.global.view.tips.PropsTip;
	import com.YFFramework.game.core.global.view.tips.TipUtil;
	import com.YFFramework.game.core.module.bag.data.BagStoreManager;
	import com.YFFramework.game.core.module.guild.manager.GuildInfoManager;
	import com.YFFramework.game.core.module.guild.manager.Guild_BuildingBasicManager;
	import com.YFFramework.game.core.module.guild.model.TypeBuilding;
	import com.YFFramework.game.core.module.market.data.vo.MarketRecord;
	import com.YFFramework.game.core.module.market.source.MarketSource;
	import com.YFFramework.game.core.module.notice.model.NoticeType;
	import com.YFFramework.game.core.module.notice.model.NoticeUtils;
	import com.YFFramework.game.core.module.shop.controller.ModuleShop;
	import com.YFFramework.game.core.module.shop.data.IconUtils;
	import com.YFFramework.game.core.module.shop.data.ShopBasicVo;
	import com.YFFramework.game.gameConfig.URLTool;
	import com.dolo.lang.LangBasic;
	import com.dolo.ui.controls.Alert;
	import com.dolo.ui.controls.Button;
	import com.dolo.ui.controls.IconImage;
	import com.dolo.ui.controls.NumericStepper;
	import com.dolo.ui.controls.PopMiniWindow;
	import com.dolo.ui.managers.UI;
	import com.dolo.ui.tools.AutoBuild;
	import com.dolo.ui.tools.Xdis;
	import com.dolo.ui.tools.Xtip;
	import com.msg.common.ItemConsume;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;

	public class BuyWindow extends PopMiniWindow
	{
		private static var _ins:BuyWindow;
		
		private const DEFAULT_COLOR:uint=0xFDF3AB;
		private const RED_COLOR:uint = 0xFF0000;
		
		private var _ui:Sprite;
		private var _icon:IconImage;
		/**物品名称  */		
		private var _nameTxt:TextField;
		/**单价框  */		
		private var _price:TextField;
		/**总价框  */		
		private var _totalPriceTxt:TextField;
		private var _lock:Sprite;
		
		private var _shopVo:ShopBasicVo;
		private var _record:MarketRecord;
		
		private var _numStep:NumericStepper;
		
		private var _buyButton:Button;
		
		private var _priceTypeSp:Sprite;
		private var _totalMoneySp:Sprite;
		
		private var _marketType:int;
		private var _marketItem:Object;
		
		public function BuyWindow()
		{
			_ui = initByArgument(255,200,"ui.BuyUI");
			setContentXY(34,33);
			tittleBgUI.visible=false;
//			title = "购买";//回头改用美术字
			
			AutoBuild.replaceAll(_ui);		
			
			_icon = Xdis.getChild(_ui,"icon_iconImage");
			_nameTxt = Xdis.getChild(_ui,"t1");
			_price=Xdis.getChild(_ui,"price");
			_totalPriceTxt = Xdis.getChild(_ui,"totalPrice");
			_numStep = Xdis.getChild(_ui,"num_numericStepper");
			
			_buyButton = Xdis.getChild(_ui,"buy_button");
			
			_priceTypeSp = Xdis.getChild(_ui,"moneyType1");
			_totalMoneySp = Xdis.getChild(_ui,"moneyType2");
			
			_lock=Xdis.getChild(_ui,"lock_mc");
			
			_numStep.addEventListener(Event.CHANGE,updateAllMoney);
			YFEventCenter.Instance.addEventListener(GlobalEvent.MoneyChange,onMoneyChange);
			YFEventCenter.Instance.addEventListener(GlobalEvent.BagChange,updateMarket);
		}
		
		private function onMoneyChange(event:YFEvent):void
		{
			if(_shopVo)
			{
				checkShopBtn();		
			}
			if(_record)
			{
				checkMarketBtnEnabled();
			}
		}
		
		private function updateMarket(e:YFEvent):void
		{
			if(_marketType > 0 && _marketType == MarketSource.PURCHASE && _record != null)
			{
				initMarket(_marketType,_record);
			}
		}
		
		private function updateAllMoney(e:Event):void
		{
			if(_shopVo)
			{
				checkShopBtn();	
			}
			if(_record)
			{
				checkMarketBtnEnabled();
			}
		}
		
		public static function get instance():BuyWindow
		{
			return _ins ||= new BuyWindow();
		}
		
		public static function show():BuyWindow
		{
			if(_ins == null)
			{
				_ins = new BuyWindow();
			}
			else
			{
				_ins.reset();
			}
			
			if(_ins.isOpen == false)
			{
				_ins.open();
			}
			else
			{
				_ins.switchToTop();
			}
			
			if(_ins.mouseX > 0 && _ins.mouseX < _ins.compoWidth && _ins.mouseY > 0 && _ins.mouseY < _ins.compoHeight)
			{
				MouseManager.resetToDefaultMouse();
			}
			return _ins;
		}
		
		private function reset():void
		{
			_numStep.value = 1;
			
			_shopVo=null;
			_buyButton.removeEventListener(MouseEvent.CLICK,onBuyClick);
			
			//以下市场专用
			_record=null;
			_marketType=0;
			_marketItem=null;
			_buyButton.removeEventListener(MouseEvent.CLICK,marketBuyClick);
			_buyButton.removeEventListener(MouseEvent.CLICK,marketSaleClick);
			
			_numStep.maximum=0;
			_numStep.minimum=0;
			_numStep.textField.textColor=DEFAULT_COLOR;
			
//			title='购买';////回头改用美术字
			
			_icon.clear();
			Xtip.clearLinkTip(_icon);
		}	
		
		/**
		 * 基本是通用的，商店、商城、临时购买什么的
		 * @param voData 类型会转化为ShopBasicVo
		 * @param defaultBuyNum
		 * 
		 */		
		public function init(voData:Object,defaultBuyNum:int=1):void
		{
			reset();
			
			_shopVo = voData as ShopBasicVo;
			
			_icon.url = IconUtils.getIconURL(_shopVo);
			
			_nameTxt.text = ModuleShop.getItemNameByShopVO(_shopVo);
			
			_numStep.minimum = 1;
			_numStep.maximum = 9999;
			_numStep.maxChars = 4;
			_numStep.value = defaultBuyNum;
		
			checkShopBtn();
			
			changeMoneyType(_priceTypeSp,_shopVo.money_type);
			changeMoneyType(_totalMoneySp,_shopVo.money_type);
			
			if(_shopVo.item_type == TypeProps.ITEM_TYPE_PROPS){
				var _propsInfo:PropsBasicVo=PropsBasicManager.Instance.getPropsBasicVo(_shopVo.item_id);
				Xtip.registerLinkTip(_icon,PropsTip,TipUtil.propsTipInitFunc,0,_propsInfo.template_id);
			}else if(_shopVo.item_type == TypeProps.ITEM_TYPE_EQUIP){
				var _equipInfo:EquipBasicVo=EquipBasicManager.Instance.getEquipBasicVo(_shopVo.item_id);
				Xtip.registerLinkTip(_icon,EquipTip,TipUtil.equipTipInitFunc,0,_equipInfo.template_id);
			}
			
			
			UI.removeAllChilds(_lock);
			if(_shopVo.binding_type > 0 && _shopVo.binding_type == TypeProps.BIND_TYPE_YES)
				_lock.addChild(ClassInstance.getInstance("lock"));
			else
			{
				if(_shopVo.item_type == TypeProps.ITEM_TYPE_PROPS)
				{
					var props:PropsBasicVo=PropsBasicManager.Instance.getPropsBasicVo(_shopVo.item_id);
					if(props.binding_type == TypeProps.BIND_TYPE_YES)
						_lock.addChild(ClassInstance.getInstance("lock"));
				}
				else
				{
					var equip:EquipBasicVo=EquipBasicManager.Instance.getEquipBasicVo(_shopVo.item_id);
					if(equip.binding_type == TypeProps.BIND_TYPE_YES)
						_lock.addChild(ClassInstance.getInstance("lock"));
				}
			}
			
			_buyButton.label='购买';
			_buyButton.addEventListener(MouseEvent.CLICK,onBuyClick);
			
		}
		
		protected function onBuyClick(event:MouseEvent):void
		{
			if(_shopVo == null) return;
			if(BagStoreManager.instantce.checkBagHasEnoughGrids(_shopVo.item_id,_numStep.value,_shopVo.item_type)==false){
				Alert.show(LangBasic.cantPutInBag,LangBasic.shop);
				return;
			}
			
			ModuleShop.instance.buyItem(_shopVo,_numStep.value);
			close();
		}
		
		/**
		 * 针对市场的方法 
		 * @param type 是寄售还是求购
		 * @param record 信息
		 * 
		 */		
		public function initMarket(type:int,record:MarketRecord):void
		{
			reset();
			
			_record=record;
			_marketType=type;
			
			_price.text=record.price.toString();
			
			UI.removeAllChilds(_lock);
			
			changeMoneyType(_priceTypeSp,record.moneyType);
			changeMoneyType(_totalMoneySp,record.moneyType);
			
			_numStep.minimum=1;//不管出售还是购买，最小值都是1
			if(type == MarketSource.CONSIGH)
			{
//				title = "购买";////回头改用美术字
				_buyButton.label=NoticeUtils.getStr(NoticeType.Notice_id_100039);
				
				_numStep.maximum=record.number;
				
				_buyButton.addEventListener(MouseEvent.CLICK,marketBuyClick);
			}
			else
			{
//				title = "出售";////回头改用美术字
				_buyButton.label=NoticeUtils.getStr(NoticeType.Notice_id_100040);
								
				_buyButton.addEventListener(MouseEvent.CLICK,marketSaleClick);
			}
			
			var color:String='';
			var quality:int;		
			
			if(record.equip != null)
			{
				_icon.url = EquipBasicManager.Instance.getURL(record.equip.template_id);
				Xtip.registerLinkTip(_icon,EquipTipMix,TipUtil.equipTipInitFunc,0,record.equip.template_id,false,record.equip);
				
				quality=EquipBasicManager.Instance.getEquipBasicVo(record.equip.template_id).quality;
				color=TypeProps.getQualityColor(quality);
				_nameTxt.htmlText = HTMLUtil.createHtmlText(EquipBasicManager.Instance.getEquipBasicVo(record.equip.template_id).name,
					15,color);
				
				_marketItem=new Object();
				_marketItem.type=TypeProps.ITEM_TYPE_EQUIP;
				_marketItem.id=record.equip.template_id;
				
			}
			else if(record.props != null)
			{
				_icon.url = PropsBasicManager.Instance.getURL(record.props.templateId);
				Xtip.registerLinkTip(_icon,PropsTip,TipUtil.propsTipInitFunc,0,record.props.templateId,record.props);
				
				quality=PropsBasicManager.Instance.getPropsBasicVo(record.props.templateId).quality;
				color=TypeProps.getQualityColor(quality);
				_nameTxt.htmlText = HTMLUtil.createHtmlText(PropsBasicManager.Instance.getPropsBasicVo(record.props.templateId).name,
					15,color);
				
				_marketItem=new Object();
				_marketItem.type=TypeProps.ITEM_TYPE_PROPS;
				_marketItem.id=record.props.templateId;

			}
			else if(record.itemType > 0 && record.itemId > 0)
			{
				if(record.itemType == TypeProps.ITEM_TYPE_EQUIP)
				{
					_icon.url = EquipBasicManager.Instance.getURL(record.itemId);
					Xtip.registerLinkTip(_icon,EquipTipMix,TipUtil.equipTipInitFunc,0,record.itemId);
					
					quality=EquipBasicManager.Instance.getEquipBasicVo(record.itemId).quality;
					color=TypeProps.getQualityColor(quality);
					_nameTxt.htmlText = HTMLUtil.createHtmlText(EquipBasicManager.Instance.getEquipBasicVo(record.itemId).name,
						15,color);
					
				}
				else
				{
					_icon.url = PropsBasicManager.Instance.getURL(record.itemId);
					Xtip.registerLinkTip(_icon,PropsTip,TipUtil.propsTipInitFunc,0,record.itemId);
					
					quality=PropsBasicManager.Instance.getPropsBasicVo(record.itemId).quality;
					color=TypeProps.getQualityColor(quality);
					_nameTxt.htmlText = HTMLUtil.createHtmlText(PropsBasicManager.Instance.getPropsBasicVo(record.itemId).name,
						15,color);
					

				}
				
				_marketItem=new Object();
				_marketItem.type=record.itemType;
				_marketItem.id=record.itemId;
				
				if(type == MarketSource.PURCHASE)//求购时，记得只能出售非绑定道具
				{
					var num:int = Math.min(record.number,
						BagStoreManager.instantce.getAllNonBoundItems(record.itemType,record.itemId));
					if(num == 0)
						_numStep.maximum=_numStep.minimum=0;
					else
						_numStep.maximum=num;
				}
				
			}
			else if(record.saleMoneyType > 0)
			{
				if(record.saleMoneyType == TypeProps.MONEY_DIAMOND)
				{
					_icon.url=URLTool.getCommonAssets("diamond.png");
					_nameTxt.text=NoticeUtils.getMoneyTypeStr(TypeProps.MONEY_DIAMOND);
							
				}
				else
				{
					_icon.url=URLTool.getCommonAssets("silver.png");
					_nameTxt.text=NoticeUtils.getMoneyTypeStr(TypeProps.MONEY_SILVER);						
				}
				
				_marketItem=new Object();
				_marketItem.type=3;
				
			}
			
			checkMarketBtnEnabled();
		}
		
		private function checkShopBtn(event:Event = null):void
		{
			if(_shopVo == null) return;
			var nowVol:int;
			var discount:int=100;//折扣
			switch(_shopVo.money_type){
				case TypeProps.MONEY_DIAMOND:
					nowVol = DataCenter.Instance.roleSelfVo.diamond;
					break;
				case TypeProps.MONEY_COUPON:
					nowVol = DataCenter.Instance.roleSelfVo.coupon;
					break;
				case TypeProps.MONEY_SILVER:
					trace("buyWindow414行，没有银币这个货币！")
					break;
				case TypeProps.MONEY_NOTE:
					nowVol = DataCenter.Instance.roleSelfVo.note;
					break;
				case TypeProps.MONEY_GUILD_CONTRIBUTION:
					nowVol =  GuildInfoManager.Instence.me.contribution;
					var guildShopLv:int=GuildInfoManager.Instence.getBuildingLv(TypeBuilding.SHOP);
					discount=Guild_BuildingBasicManager.Instance.getEffectValue(TypeBuilding.SHOP,guildShopLv);
					break;
			}
			
			var priNum:int = _shopVo.price*int(_numStep.value)*discount/100;
			_totalPriceTxt.text = String(priNum);
			_price.text = (_shopVo.price*discount/100).toFixed();
			
			
			if(priNum>nowVol){
				UI.setEnable(_buyButton,false);
				_totalPriceTxt.textColor = RED_COLOR;
			}else{
				UI.setEnable(_buyButton,true);
				_totalPriceTxt.textColor = DEFAULT_COLOR;
			}
		}
		
		/** 判断出售（求购）按钮是否可用
		 */		
		private function checkMarketBtnEnabled():void
		{
			if(_marketType == 0) return;
			
			if(_numStep.maximum == 0)//不可用
			{
				UI.setEnable(_buyButton,false);
				_numStep.textField.textColor = RED_COLOR;
				_totalPriceTxt.textColor = RED_COLOR;
				_totalPriceTxt.text = '0';
			}
			else
			{
				var needMoney:int = _record.price*int(_numStep.value);
				_totalPriceTxt.text = String(needMoney);
				var hasMoney:int;//人物身上已有钱数
				switch(_record.moneyType)
				{
					case TypeProps.MONEY_DIAMOND:
						hasMoney = DataCenter.Instance.roleSelfVo.diamond;
						break;
					case TypeProps.MONEY_SILVER:
						trace("buyWindow464行，没有银币货币！")
//						hasMoney = DataCenter.Instance.roleSelfVo.silver;
						break;
				}
				
				if(needMoney > hasMoney)//不可用
				{
					UI.setEnable(_buyButton,false);
					_numStep.textField.textColor=RED_COLOR;
					_totalPriceTxt.textColor = RED_COLOR;
				}
				else
				{
					UI.setEnable(_buyButton,true);
					_numStep.textField.textColor=DEFAULT_COLOR;
					_totalPriceTxt.textColor = DEFAULT_COLOR;
				}
			}	
			
		}
		
		private function marketBuyClick(e:MouseEvent):void
		{
			if(_marketItem == null) return;
			
			if(_marketItem.type != 3)//魔钻和银币的类型是3，id不填
			{
				if(BagStoreManager.instantce.checkBagHasEnoughGrids(_marketItem.id,_numStep.value,_marketItem.type)==false){
					Alert.show(LangBasic.cantPutInBag,LangBasic.shop);
					return;
				}
			}
			
			close();
			ModuleShop.instance.marketBuy(_record.recordId,_numStep.value);
					
		}
		
		private function marketSaleClick(e:MouseEvent):void
		{
			if(_marketItem == null) return;
			
			if(BagStoreManager.instantce.checkBagHasEnoughGrids(_marketItem.id,_numStep.value,_marketItem.type)==false){
				Alert.show(LangBasic.cantPutInBag,LangBasic.shop);
				return;
			}
			
			close();
			if(_marketItem.type == TypeProps.ITEM_TYPE_PROPS)
			{
					ModuleShop.instance.marketSale(_record.recordId,PropsDyManager.instance.getPropsPosArray(_marketItem.id,_numStep.value));
			}
			else
			{
				var itemConsume:ItemConsume=new ItemConsume();
				itemConsume.number=1;
				itemConsume.pos=EquipDyManager.instance.getEquipPosFromBagByTemplateId(_marketItem.id);
				ModuleShop.instance.marketSale(_record.recordId,[itemConsume]);
			}
		}
		
		private function changeMoneyType(sp:Sprite,type:int):void
		{
			UI.removeAllChilds(sp);
			switch(type)
			{
				case TypeProps.MONEY_NOTE:				
					sp.addChild(ClassInstance.getInstance("note"));
					break;
				case TypeProps.MONEY_DIAMOND:
					sp.addChild(ClassInstance.getInstance("diamond"));
					break;
				case TypeProps.MONEY_COUPON:
					sp.addChild(ClassInstance.getInstance("coupon"));
					break;
			}
		}
		
	}
}