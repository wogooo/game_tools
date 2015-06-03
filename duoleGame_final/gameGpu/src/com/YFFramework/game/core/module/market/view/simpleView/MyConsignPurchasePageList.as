package com.YFFramework.game.core.module.market.view.simpleView
{
	/**
	 * 我的寄售，我的求购专用
	 * @version 1.0.0
	 * creation time：2013-6-5 上午11:37:59
	 * 
	 */
	import com.YFFramework.core.event.YFEventCenter;
	import com.YFFramework.core.utils.common.ClassInstance;
	import com.YFFramework.game.core.global.manager.EquipBasicManager;
	import com.YFFramework.game.core.global.manager.PropsBasicManager;
	import com.YFFramework.game.core.global.util.TypeProps;
	import com.YFFramework.game.core.global.view.tips.EquipTipMix;
	import com.YFFramework.game.core.global.view.tips.PropsTip;
	import com.YFFramework.game.core.global.view.tips.TipUtil;
	import com.YFFramework.game.core.module.market.data.vo.MarketRecord;
	import com.YFFramework.game.core.module.market.event.MarketEvent;
	import com.YFFramework.game.core.module.market.source.MarketSource;
	import com.YFFramework.game.core.module.notice.model.NoticeUtils;
	import com.YFFramework.game.gameConfig.URLTool;
	import com.dolo.common.PageItemListBase;
	import com.dolo.ui.controls.Button;
	import com.dolo.ui.controls.IconImage;
	import com.dolo.ui.managers.UI;
	import com.dolo.ui.tools.AutoBuild;
	import com.dolo.ui.tools.Xdis;
	import com.dolo.ui.tools.Xtip;
	import com.msg.market_pro.CDownSale;
	import com.msg.market_pro.CDownWant;
	
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.utils.Dictionary;
	
	public class MyConsignPurchasePageList extends PageItemListBase
	{
		//======================================================================
		//       public property
		//======================================================================
		
		//======================================================================
		//       private property
		//======================================================================			
		private var _record:MarketRecord;
		
		private var _type:int;
		
		private var _dict:Dictionary;
		//======================================================================
		//        constructor
		//======================================================================
		
		public function MyConsignPurchasePageList(type:int)
		{
			_type = type;
			_dict=new Dictionary();
		}
		
		//======================================================================
		//        public function
		//======================================================================
		/**
		 * 子类覆盖此方法，显示Item内容 
		 * @param data
		 * @param view
		 * 
		 */
		override protected function initItem(data:Object,view:Sprite,index:int):void
		{
			_record = data as MarketRecord;
			
			AutoBuild.replaceAll(view);
			
			var icon:IconImage=Xdis.getChild(view,"icon_iconImage");
//			icon.clear();
			
			var itemName:TextField=Xdis.getChild(view,"itemName");
			
			var moneyType:Sprite=Xdis.getChild(view,"money");
//			UI.removeAllChilds(moneyType);
			
			var price:TextField=Xdis.getChild(view,"price");
			
			var acBtn:Button=Xdis.getChild(view,"ac_button");
			acBtn.addEventListener(MouseEvent.CLICK,onSoldOut);
			
			if(_record.equip != null)
			{
				icon.url = EquipBasicManager.Instance.getURL(_record.equip.template_id);
				Xtip.registerLinkTip(icon,EquipTipMix,TipUtil.equipTipInitFunc,0,_record.equip.template_id,false,_record.equip);
				
				itemName.text = EquipBasicManager.Instance.getEquipBasicVo(_record.equip.template_id).name;
			}
			else if(_record.props != null)
			{
				icon.url = PropsBasicManager.Instance.getURL(_record.props.templateId);
				Xtip.registerLinkTip(icon,PropsTip,TipUtil.propsTipInitFunc,0,_record.props.templateId,_record.props);
				
				itemName.text = PropsBasicManager.Instance.getPropsBasicVo(_record.props.templateId).name;
				
			}
			else if(_record.itemType > 0 && _record.itemId > 0)
			{
				if(_record.itemType == TypeProps.ITEM_TYPE_EQUIP)
				{
					icon.url = EquipBasicManager.Instance.getURL(_record.itemId);
					Xtip.registerLinkTip(icon,EquipTipMix,TipUtil.equipTipInitFunc,0,_record.itemId);
					
					itemName.text = EquipBasicManager.Instance.getEquipBasicVo(_record.itemId).name;
					
				}
				else
				{
					icon.url = PropsBasicManager.Instance.getURL(_record.itemId);
					Xtip.registerLinkTip(icon,PropsTip,TipUtil.propsTipInitFunc,0,_record.itemId);
					
					itemName.text = PropsBasicManager.Instance.getPropsBasicVo(_record.itemId).name;
					
				}
			}
			else if(_record.saleMoneyType > 0)
			{
				if(_record.saleMoneyType == TypeProps.MONEY_DIAMOND)
				{
					icon.url=URLTool.getCommonAssets("diamond.png");
					itemName.text=NoticeUtils.getMoneyTypeStr(TypeProps.MONEY_DIAMOND);				
				}
				else
				{
					icon.url=URLTool.getCommonAssets("silver.png");
					itemName.text=NoticeUtils.getMoneyTypeStr(TypeProps.MONEY_SILVER);				
				}
			}
			
			if(_record.moneyType == TypeProps.MONEY_DIAMOND)
			{
				moneyType.addChild(ClassInstance.getInstance("diamond"));
			}
			else
			{
				moneyType.addChild(ClassInstance.getInstance("silver"));
			}
			
			price.text=_record.price.toString();

			_dict[acBtn]=_record;
		}
		
		override protected function disposeItem(view:Sprite):void
		{
			var icon:IconImage=Xdis.getChild(view,"icon_iconImage");
			Xtip.clearLinkTip(icon);
			icon.clear();
			
			var moneyType:Sprite=Xdis.getChild(view,"money");
			UI.removeAllChilds(moneyType);
			
			var acBtn:Button=Xdis.getChild(view,"ac_button");
			acBtn.removeEventListener(MouseEvent.CLICK,onSoldOut);
			_dict[acBtn]=null;
			delete _dict[acBtn];
		}
		//======================================================================
		//        private function
		//======================================================================
		
		//======================================================================
		//        event handler
		//======================================================================
		private function onSoldOut(e:MouseEvent):void
		{
			var btn:Button=e.currentTarget as Button;
			var data:MarketRecord=_dict[btn];
			if(_type == MarketSource.CONSIGH)
			{
				var msg:CDownSale=new CDownSale();
				msg.recordId=data.recordId;
				YFEventCenter.Instance.dispatchEventWith(MarketEvent.CDownSale,msg);
			}
			else
			{
				var msg1:CDownWant = new CDownWant();
				msg1.recordId=data.recordId;
				YFEventCenter.Instance.dispatchEventWith(MarketEvent.CDownWant,msg1);
			}
		}
		//======================================================================
		//        getter&setter
		//======================================================================
		
		
	}
} 