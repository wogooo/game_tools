package com.YFFramework.game.core.module.market.view.simpleView
{
	/**
	 * 寄售、求购信息基础item
	 * @version 1.0.0
	 * creation time：2013-6-5 下午2:45:49
	 * 
	 */
	import com.YFFramework.core.text.HTMLUtil;
	import com.YFFramework.core.ui.abs.AbsView;
	import com.YFFramework.core.utils.common.ClassInstance;
	import com.YFFramework.game.core.global.manager.EquipBasicManager;
	import com.YFFramework.game.core.global.manager.PropsBasicManager;
	import com.YFFramework.game.core.global.util.TypeProps;
	import com.YFFramework.game.core.global.view.tips.EquipTipMix;
	import com.YFFramework.game.core.global.view.tips.PropsTip;
	import com.YFFramework.game.core.global.view.tips.TipUtil;
	import com.YFFramework.game.core.module.ModuleManager;
	import com.YFFramework.game.core.module.market.data.vo.MarketRecord;
	import com.YFFramework.game.core.module.market.source.MarketSource;
	import com.YFFramework.game.core.module.notice.model.NoticeType;
	import com.YFFramework.game.core.module.notice.model.NoticeUtils;
	import com.YFFramework.game.gameConfig.URLTool;
	import com.dolo.ui.controls.Button;
	import com.dolo.ui.controls.IconImage;
	import com.dolo.ui.managers.UI;
	import com.dolo.ui.tools.AutoBuild;
	import com.dolo.ui.tools.Xdis;
	import com.dolo.ui.tools.Xtip;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	public class ConsignPurchaseItem extends AbsView
	{
		//======================================================================
		//       public property
		//======================================================================
		
		//======================================================================
		//       private property
		//======================================================================
		private var _icon:IconImage;
		
		private var _itemName:TextField;
		
		/**使用等级限制
		 */		
		private var _level:TextField;
		
		private var _moneyType:Sprite;
		
		private var _price:TextField;
		
		private var _playerName:TextField;
		
		/**寄售时就是购买；求购时是出售 
		 */		
		private var _buyBtn:Button;
		
		private var _record:MarketRecord;
		
		private var _type:int;
		//======================================================================
		//        constructor
		//======================================================================
		
		public function ConsignPurchaseItem()
		{
			var mc:Sprite=ClassInstance.getInstance("marketItem");
			
			AutoBuild.replaceAll(mc);
			
			_icon=Xdis.getChild(mc,"icon_iconImage");
			_itemName=Xdis.getChild(mc,"itemName");
			_level=Xdis.getChild(mc,"level");
			_moneyType=Xdis.getChild(mc,"moneyType");
			_price=Xdis.getChild(mc,"price");
			_playerName=Xdis.getChild(mc,"pname");
			_buyBtn=Xdis.getChild(mc,"do_button");		
			_buyBtn.y=7.85;
			addChild(mc);
		}
		
		override public function set y(value:Number):void
		{
			super.y = value;
		}
		
		//======================================================================
		//        public function
		//======================================================================
		public function setContent(type:int,record:MarketRecord):void
		{
			_record=record;
			
			_type=type;
			
			if(type == MarketSource.CONSIGH)
			{
				_buyBtn.label=NoticeUtils.getStr(NoticeType.Notice_id_100039);
			}
			else
			{
				_buyBtn.label=NoticeUtils.getStr(NoticeType.Notice_id_100040);
			}
			
			var color:String='';
			var quality:int;
			
			if(record.equip != null)
			{
				_icon.url = EquipBasicManager.Instance.getURL(record.equip.template_id);
				Xtip.registerLinkTip(_icon,EquipTipMix,TipUtil.equipTipInitFunc,0,record.equip.template_id,false,record.equip);
				
				quality=EquipBasicManager.Instance.getEquipBasicVo(record.equip.template_id).quality;
				color=TypeProps.getQualityColor(quality);
				_itemName.htmlText = HTMLUtil.createHtmlText(EquipBasicManager.Instance.getEquipBasicVo(record.equip.template_id).name,
										15,color);
				
				_level.text = EquipBasicManager.Instance.getEquipBasicVo(record.equip.template_id).level.toString();
			}
			else if(record.props != null)
			{
				_icon.url = PropsBasicManager.Instance.getURL(record.props.templateId);
				Xtip.registerLinkTip(_icon,PropsTip,TipUtil.propsTipInitFunc,0,record.props.templateId,record.props);
				
				quality=PropsBasicManager.Instance.getPropsBasicVo(record.props.templateId).quality;
				color=TypeProps.getQualityColor(quality);
				_itemName.htmlText = HTMLUtil.createHtmlText(PropsBasicManager.Instance.getPropsBasicVo(record.props.templateId).name,
					15,color);
				
				_level.text = PropsBasicManager.Instance.getPropsBasicVo(record.props.templateId).level.toString();
				
			}
			else if(record.itemType > 0 && record.itemId > 0)
			{
				if(record.itemType == TypeProps.ITEM_TYPE_EQUIP)
				{
					_icon.url = EquipBasicManager.Instance.getURL(record.itemId);
					Xtip.registerLinkTip(_icon,EquipTipMix,TipUtil.equipTipInitFunc,0,record.itemId);
					
					quality=EquipBasicManager.Instance.getEquipBasicVo(record.itemId).quality;
					color=TypeProps.getQualityColor(quality);
					_itemName.htmlText = HTMLUtil.createHtmlText(EquipBasicManager.Instance.getEquipBasicVo(record.itemId).name,
						15,color);
					
					_level.text = EquipBasicManager.Instance.getEquipBasicVo(record.itemId).level.toString();
					
				}
				else
				{
					_icon.url = PropsBasicManager.Instance.getURL(record.itemId);
					Xtip.registerLinkTip(_icon,PropsTip,TipUtil.propsTipInitFunc,0,record.itemId);
					
					quality=PropsBasicManager.Instance.getPropsBasicVo(record.itemId).quality;
					color=TypeProps.getQualityColor(quality);
					_itemName.htmlText = HTMLUtil.createHtmlText(PropsBasicManager.Instance.getPropsBasicVo(record.itemId).name,
						15,color);
					
					_level.text = PropsBasicManager.Instance.getPropsBasicVo(record.itemId).level.toString();
					
				}
			}
			else if(record.saleMoneyType > 0)
			{
				if(record.saleMoneyType == TypeProps.MONEY_DIAMOND)
				{
					_icon.url=URLTool.getCommonAssets("diamond.png");
					_itemName.text=NoticeUtils.getMoneyTypeStr(TypeProps.MONEY_DIAMOND);				
				}
				else
				{
					_icon.url=URLTool.getCommonAssets("silver.png");
					_itemName.text=NoticeUtils.getMoneyTypeStr(TypeProps.MONEY_SILVER);				
				}
				_level.text='1';
			}
			
			if(record.moneyType == TypeProps.MONEY_DIAMOND)
			{
				_moneyType.addChild(ClassInstance.getInstance("diamond"));
			}
			else
			{
				_moneyType.addChild(ClassInstance.getInstance("silver"));
			}
			
			_price.text=record.price.toString();
			_playerName.text=record.playerName;
			
			_buyBtn.addEventListener(MouseEvent.CLICK,onBuy);
			
		}
				
		override public function dispose(e:Event=null):void
		{
			UI.removeAllChilds(_moneyType);
			Xtip.clearLinkTip(_icon);
			_icon.clear();
		}
		//======================================================================
		//        private function
		//======================================================================
		
		//======================================================================
		//        event handler
		//======================================================================
		private function onBuy(e:MouseEvent):void
		{
			ModuleManager.moduleShop.openMarketBuyWindow(_type,_record);
		}
		//======================================================================
		//        getter&setter
		//======================================================================
		
		
	}
} 