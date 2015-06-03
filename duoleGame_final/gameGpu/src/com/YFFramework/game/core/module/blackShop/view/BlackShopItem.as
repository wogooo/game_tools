package com.YFFramework.game.core.module.blackShop.view
{
	/**
	 * @author jina;
	 * @version 1.0.0
	 * creation time：2013-9-24 下午5:29:26
	 */
	import com.CMD.GameCmd;
	import com.YFFramework.core.text.HTMLUtil;
	import com.YFFramework.game.core.global.manager.PropsBasicManager;
	import com.YFFramework.game.core.global.model.PropsBasicVo;
	import com.YFFramework.game.core.global.util.TypeProps;
	import com.YFFramework.game.core.global.view.tips.PropsTip;
	import com.YFFramework.game.core.global.view.tips.TipUtil;
	import com.YFFramework.game.core.module.blackShop.data.BlackShopBasicManager;
	import com.YFFramework.game.core.module.blackShop.data.BlackShopBasicVo;
	import com.dolo.ui.controls.Button;
	import com.dolo.ui.controls.IconImage;
	import com.dolo.ui.managers.UI;
	import com.dolo.ui.tools.AutoBuild;
	import com.dolo.ui.tools.Xdis;
	import com.dolo.ui.tools.Xtip;
	import com.msg.black_shop.CBuyBSItem;
	import com.net.MsgPool;
	
	import flash.display.Sprite;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	public class BlackShopItem extends EventDispatcher
	{
		//======================================================================
		//       public property
		//======================================================================
		
		//======================================================================
		//       private property
		//======================================================================
		private var _ui:Sprite;
		
		private var _itemName:TextField;
		private var _price:TextField;
		private var _itemNum:TextField;
		private var _iconImg:IconImage;
		private var _buyBtn:Button;
		private var _priceIcon:Sprite;
		
		private var _index:int;//位置
		private var _propsInfo:PropsBasicVo;
		
		//======================================================================
		//        constructor
		//======================================================================
		
		public function BlackShopItem(ui:Sprite)
		{
			_ui=ui;
			AutoBuild.replaceAll(_ui);
			
			_itemName=Xdis.getChild(_ui,'mname');
			_price=Xdis.getChild(_ui,'orgPrice');
			_itemNum=Xdis.getChild(_ui,'price');
			_iconImg=Xdis.getChild(_ui,'buy_iconImage');
			_priceIcon=Xdis.getChild(_ui,'moneyType1');
			_buyBtn=Xdis.getChild(_ui,'buy_button');
			_buyBtn.addEventListener(MouseEvent.CLICK,onBuyClick);
		}
		
		//======================================================================
		//        public function
		//======================================================================
		/** 
		 * @param index 从1开始
		 * @param bsId
		 * @param num
		 * 
		 */		
		public function updateView(index:int,bsId:int,num:int):void
		{
			clearContent();
			
			_index=index;
			
			_propsInfo=PropsBasicManager.Instance.getPropsBasicVo(bsId);
			_itemName.htmlText=HTMLUtil.createHtmlText(_propsInfo.name,12,TypeProps.getQualityColor(_propsInfo.quality));
			_iconImg.url=PropsBasicManager.Instance.getURL(bsId);
			Xtip.registerLinkTip(_iconImg,PropsTip,TipUtil.propsTipInitFunc,0,bsId);
			
			var blackShopInfo:BlackShopBasicVo=BlackShopBasicManager.Instance.getBlackShopBasicVo(bsId);
			_priceIcon.addChild(TypeProps.getMoneyTypeIcon(blackShopInfo.money_type));
			_price.text=blackShopInfo.money.toString();		
			
			updateNum(num);
		}
		
		public function updateBuyRsp():void
		{
			updateNum(0);
		}
		//======================================================================
		//        private function
		//======================================================================
		private function updateNum(num:int):void
		{
			_itemNum.text=num.toString()+'/1';
			
			if(num == 0)
				_buyBtn.enabled=false;
			else
				_buyBtn.enabled=true;
		}
		
		private function clearContent():void
		{
			_propsInfo=null;
			_iconImg.clear();
			Xtip.clearLinkTip(_iconImg);
			UI.removeAllChilds(_priceIcon);
		}
		//======================================================================
		//        event handler
		//======================================================================
		private function onBuyClick(e:MouseEvent):void
		{
			var msg:CBuyBSItem=new CBuyBSItem();
			msg.gridIndex=_index;
			MsgPool.sendGameMsg(GameCmd.CBuyBSItem,msg);
		}
		//======================================================================
		//        getter&setter
		//======================================================================
		
		
	}
} 