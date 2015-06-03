package com.YFFramework.game.core.module.market.view.simpleView
{
	/**
	 * 交易记录
	 * @version 1.0.0
	 * creation time：2013-6-5 上午10:50:08
	 * 
	 */
	import com.YFFramework.core.event.YFEventCenter;
	import com.YFFramework.core.text.HTMLUtil;
	import com.YFFramework.core.ui.abs.AbsView;
	import com.YFFramework.core.utils.common.ClassInstance;
	import com.YFFramework.game.core.global.TimeManager;
	import com.YFFramework.game.core.global.manager.EquipBasicManager;
	import com.YFFramework.game.core.global.manager.PropsBasicManager;
	import com.YFFramework.game.core.global.util.TypeProps;
	import com.YFFramework.game.core.global.view.tips.EquipTipMix;
	import com.YFFramework.game.core.global.view.tips.PropsTip;
	import com.YFFramework.game.core.global.view.tips.TipUtil;
	import com.YFFramework.game.core.module.bag.data.BagStoreManager;
	import com.YFFramework.game.core.module.market.data.vo.MarketRecord;
	import com.YFFramework.game.core.module.market.event.MarketEvent;
	import com.YFFramework.game.core.module.market.source.MarketSource;
	import com.YFFramework.game.core.module.notice.manager.NoticeManager;
	import com.YFFramework.game.core.module.notice.model.NoticeType;
	import com.YFFramework.game.core.module.notice.model.NoticeUtils;
	import com.YFFramework.game.gameConfig.URLTool;
	import com.dolo.ui.controls.Button;
	import com.dolo.ui.controls.IconImage;
	import com.dolo.ui.managers.UI;
	import com.dolo.ui.tools.AutoBuild;
	import com.dolo.ui.tools.Xdis;
	import com.dolo.ui.tools.Xtip;
	import com.msg.market_pro.CGetBackItem;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	public class MarketLogItem extends AbsView
	{
		//======================================================================
		//       public property
		//======================================================================
		
		//======================================================================
		//       private property
		//======================================================================
		private var _date:TextField;
		private var _icon:IconImage;
		private var _itemName:TextField;
		private var _itemStatus:TextField;
		private var _moneyType:Sprite;
		private var _moneyNum:TextField;
		private var _extractBtn:Button;
		
//		private var _silver:Bitmap;
//		private var _diamond:Bitmap;
		
		private var _record:MarketRecord;
		//======================================================================
		//        constructor
		//======================================================================
		
		public function MarketLogItem()
		{
			var mc:Sprite=ClassInstance.getInstance("marketLogItem");
			
			AutoBuild.replaceAll(mc);
			
			_date=Xdis.getChild(mc,"date");
			
			_icon=Xdis.getChild(mc,"icon_iconImage");
			_icon.y=4;
			
			_itemName=Xdis.getChild(mc,"itemName");
			
			_itemStatus=Xdis.getChild(mc,"status");
			
			_moneyType=Xdis.getChild(mc,"moneyType");
			
			_moneyNum=Xdis.getChild(mc,"moneyNum");
			
			_extractBtn=Xdis.getChild(mc,"extract_button");
			_extractBtn.addEventListener(MouseEvent.CLICK,onExtract);
			
			addChild(mc);
			
		}
		
		//======================================================================
		//        public function
		//======================================================================
		public function setContent(record:MarketRecord):void
		{
			_record=record;
			
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
				
			}
			else if(record.props != null)
			{
				_icon.url = PropsBasicManager.Instance.getURL(record.props.templateId);
				Xtip.registerLinkTip(_icon,PropsTip,TipUtil.propsTipInitFunc,0,record.props.templateId,record.props);
				
				quality=PropsBasicManager.Instance.getPropsBasicVo(record.props.templateId).quality;
				color=TypeProps.getQualityColor(quality);
				_itemName.htmlText = HTMLUtil.createHtmlText(PropsBasicManager.Instance.getPropsBasicVo(record.props.templateId).name,
					15,color);
				
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
					
				}
				else
				{
					_icon.url = PropsBasicManager.Instance.getURL(record.itemId);
					Xtip.registerLinkTip(_icon,PropsTip,TipUtil.propsTipInitFunc,0,record.itemId);
					
					quality=PropsBasicManager.Instance.getPropsBasicVo(record.itemId).quality;
					color=TypeProps.getQualityColor(quality);
					_itemName.htmlText = HTMLUtil.createHtmlText(PropsBasicManager.Instance.getPropsBasicVo(record.itemId).name,
						15,color);
					
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
			}
			
			if(record.moneyType == TypeProps.MONEY_DIAMOND)
			{
				_moneyType.addChild(ClassInstance.getInstance("diamond"));
			}
			else
			{
				_moneyType.addChild(ClassInstance.getInstance("silver"));
			}
			
			_date.text=TimeManager.getTimeFormat1(_record.saleTime);
			
			switch(record.status)
			{
				case MarketSource.MARKET_SALE:
					_itemStatus.text=NoticeUtils.getStr(NoticeType.Notice_id_100041);
					break;
				case MarketSource.MARKET_WANT:
					_itemStatus.text=NoticeUtils.getStr(NoticeType.Notice_id_100038);
					break;
				case MarketSource.MARKET_SALE_DOWN:
					_itemStatus.text=NoticeUtils.getStr(NoticeType.Notice_id_100042);
					break;
				case MarketSource.MARKET_WANT_DOWN:
					_itemStatus.text=NoticeUtils.getStr(NoticeType.Notice_id_100043);
					break;
				case MarketSource.MARKET_BUY_IN:
					_itemStatus.text=NoticeUtils.getStr(NoticeType.Notice_id_100044);
					break;
				case MarketSource.MARKET_SALE_OUT:
					_itemStatus.text=NoticeUtils.getStr(NoticeType.Notice_id_100045);
					break;
			}
			
			_moneyNum.text=record.price*record.number+'';
			
		}
		
		override public function dispose(e:Event=null):void
		{
			UI.removeAllChilds(_moneyType);
//			_silver=null;
//			_diamond=null;
			_icon.clear();
			Xtip.clearLinkTip(_icon);
		}
		//======================================================================
		//        private function
		//======================================================================
		
		//======================================================================
		//        event handler
		//======================================================================
		private function onExtract(e:MouseEvent):void
		{
			var hasRoom:Boolean=false;
			if(_record.equip)
				hasRoom= BagStoreManager.instantce.checkBagHasEnoughGrids(_record.equip.equip_id,_record.number,TypeProps.ITEM_TYPE_EQUIP);
			else if(_record.props)
				hasRoom = BagStoreManager.instantce.checkBagHasEnoughGrids(_record.props.templateId,_record.number,TypeProps.ITEM_TYPE_PROPS);
			else if(_record.itemType == TypeProps.ITEM_TYPE_EQUIP)
				hasRoom = BagStoreManager.instantce.checkBagHasEnoughGrids(_record.itemId,_record.number,TypeProps.ITEM_TYPE_EQUIP);
			else if(_record.itemType == TypeProps.ITEM_TYPE_PROPS)
				hasRoom = BagStoreManager.instantce.checkBagHasEnoughGrids(_record.itemId,_record.number,TypeProps.ITEM_TYPE_PROPS);
			else if(_record.saleMoneyType > 0)
				hasRoom = true;
				
			if(hasRoom)
			{
				var msg:CGetBackItem=new CGetBackItem();
				msg.recordId=_record.recordId;
				YFEventCenter.Instance.dispatchEventWith(MarketEvent.CGetBackItem,msg);
			}
			else
				NoticeManager.setNotice(NoticeType.Notice_id_302);
		}
		//======================================================================
		//        getter&setter
		//======================================================================
		
		
	}
} 