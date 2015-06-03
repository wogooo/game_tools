package com.YFFramework.game.core.module.market.view.panel.purchase
{
	/**
	 * 求购窗口下的——求购物品
	 * @version 1.0.0
	 * creation time：2013-6-1 下午4:03:19
	 * 
	 */
	import com.YFFramework.core.event.YFEvent;
	import com.YFFramework.core.event.YFEventCenter;
	import com.YFFramework.core.text.HTMLUtil;
	import com.YFFramework.core.utils.common.ClassInstance;
	import com.YFFramework.game.core.global.DataCenter;
	import com.YFFramework.game.core.global.manager.EquipBasicManager;
	import com.YFFramework.game.core.global.manager.PropsBasicManager;
	import com.YFFramework.game.core.global.model.EquipBasicVo;
	import com.YFFramework.game.core.global.model.ItemDyVo;
	import com.YFFramework.game.core.global.model.PropsBasicVo;
	import com.YFFramework.game.core.global.util.BytesUtil;
	import com.YFFramework.game.core.global.util.DragManager;
	import com.YFFramework.game.core.global.util.TypeProps;
	import com.YFFramework.game.core.global.util.ZHitTester;
	import com.YFFramework.game.core.module.bag.Interface.IMoveGrid;
	import com.YFFramework.game.core.module.chat.manager.ChatTextUtil;
	import com.YFFramework.game.core.module.chat.model.ChatData;
	import com.YFFramework.game.core.module.chat.model.ChatType;
	import com.YFFramework.game.core.module.market.data.manager.MarketDyManager;
	import com.YFFramework.game.core.module.market.data.vo.MarketRecord;
	import com.YFFramework.game.core.module.market.event.MarketEvent;
	import com.YFFramework.game.core.module.market.source.MarketSource;
	import com.YFFramework.game.core.module.market.view.simpleView.ItemIcon;
	import com.YFFramework.game.core.module.market.view.window.SiftItemWindow;
	import com.YFFramework.game.core.module.notice.manager.NoticeManager;
	import com.YFFramework.game.core.module.notice.model.NoticeType;
	import com.YFFramework.game.core.module.notice.model.NoticeUtils;
	import com.YFFramework.game.core.module.skill.model.DragData;
	import com.dolo.ui.controls.Button;
	import com.dolo.ui.controls.CheckBox;
	import com.dolo.ui.controls.NumericStepper;
	import com.dolo.ui.controls.RadioButton;
	import com.dolo.ui.managers.UI;
	import com.dolo.ui.tools.Xdis;
	import com.msg.market_pro.CUpWant;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.FocusEvent;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.utils.Dictionary;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;
	
	public class PurchaseItemPanel extends EventDispatcher
	{
		//======================================================================
		//       public property
		//======================================================================
		
		//======================================================================
		//       private property
		//======================================================================
		private var _mc:MovieClip;
		
		private var _itemIcon:ItemIcon;
		
//		private var _sliverRadioBtn:RadioButton;
		private var _diamondRadioBtn:RadioButton;
		
//		private var _sliverNumView:MovieClip;
		private var _diamondNumView:MovieClip;
		
		private var _numStepper:NumericStepper;
		
		private var _moneyTypeImage:Sprite;//求购总价前的货币类型图标
		
//		private var silver:Sprite;
		private var diamond:Sprite;
		
		private var _resetBtn:Button;
		private var _purchaseBtn:Button;
		
		private var _sendToChat:CheckBox;
		
		private var _moneyTotalNum:TextField;
		
//		private var _siftItemWindow:SiftItemWindow;
		
		private var _item:ItemDyVo;
		
		//以下两个变量是为了实时输入文本框
		protected var _inputCheckLaterTime:int = 1000;
		protected var _inputCheckLaterTimeID:int;
		//======================================================================
		//        constructor
		//======================================================================
		
		public function PurchaseItemPanel(mc:MovieClip)
		{
			_mc=mc;
			
//			_siftItemWindow=siftWindow;
			
			//初始化物品图标
			var iconFixPos:Sprite=Xdis.getChild(_mc,"itemIcon");
			_itemIcon=new ItemIcon();
			_itemIcon.setIconType(MarketSource.PURCHASE);
			_itemIcon.x=iconFixPos.x;
			_itemIcon.y=iconFixPos.y;
			_mc.addChild(_itemIcon);
			
//			_sliverRadioBtn=Xdis.getChild(_mc,"silver_pur_radioButton");
			_diamondRadioBtn=Xdis.getChild(_mc,"diamond_pur_radioButton");
//			_diamondRadioBtn.group.addEventListener(Event.CHANGE,onRadioBtnChange);
			
//			_sliverNumView=Xdis.getChild(_mc,"silverInput");
			_diamondNumView=Xdis.getChild(_mc,"diamondInput");
			
//			_sliverNumView.num.addEventListener(Event.CHANGE,InputChange);
//			_sliverNumView.num.addEventListener(FocusEvent.FOCUS_OUT,checkInputNum);
			
			_diamondNumView.num.addEventListener(Event.CHANGE,InputChange);
			_diamondNumView.num.addEventListener(FocusEvent.FOCUS_OUT,checkInputNum);
			
//			(_sliverNumView.num as TextField).restrict='0-9';
			(_diamondNumView.num as TextField).restrict='0-9';
			
			_numStepper=Xdis.getChild(_mc,"num_numericStepper");
			_numStepper.addEventListener(Event.CHANGE,itemNumChange);
			
			_moneyTypeImage=Xdis.getChild(_mc,"moneyType");
			
//			silver=ClassInstance.getInstance("silver") as Sprite;
			diamond=ClassInstance.getInstance("diamond") as Sprite;
			_moneyTypeImage.addChild(diamond);
			
			_resetBtn=Xdis.getChild(_mc,"reset_button");
			_resetBtn.label=NoticeUtils.getStr(NoticeType.Notice_id_100037);
			_resetBtn.addEventListener(MouseEvent.CLICK,onReset);
			
			_purchaseBtn=Xdis.getChild(_mc,"consign_button");
			_purchaseBtn.label=NoticeUtils.getStr(NoticeType.Notice_id_100038);
			_purchaseBtn.addEventListener(MouseEvent.CLICK,onPurchase);
			
			_sendToChat=Xdis.getChild(_mc,"sendToChat_checkBox");
			_sendToChat.textField.wordWrap=true;
			_sendToChat.textField.multiline=true;
			_sendToChat.textField.width=125;
			_sendToChat.textField.height=40;
			
			_moneyTotalNum=Xdis.getChild(_mc,"moneyNum");
			
			_mc.addEventListener(MouseEvent.MOUSE_UP,dragComplete);
			YFEventCenter.Instance.addEventListener(MarketEvent.CLEAR_PERCHASE_ITEM,clearPurchasePanel);
		}
		
		//======================================================================
		//        public function
		//======================================================================		
		public function resetPanel():void
		{
			_itemIcon.disposeContent();
			
//			_sliverRadioBtn.selected=true;
//			_sliverNumView.visible=true;
//			_sliverNumView.num.text='';
			
//			_diamondRadioBtn.selected=false;
//			_diamondNumView.visible=false;
			_diamondNumView.num.text='';
			
			_numStepper.text='1';
			_numStepper.minimum=1;
			_numStepper.maximum=99;
			
			_moneyTotalNum.text='0';
			
//			changeMoneyType(TypeProps.MONEY_SILVER);
			
			_purchaseBtn.enabled=false;
			_sendToChat.selected=false;
			
			_item=null;
		}
		
		public function moveToPurchaseItem(item:ItemDyVo):void
		{
			resetPanel();
			_item=item;
			_itemIcon.setTemplateIcon(item.type,item.id);
			if(item.type == TypeProps.ITEM_TYPE_EQUIP)
			{
				_numStepper.text='1';
				_numStepper.minimum=1;
				_numStepper.maximum=1;
			}
		}
		//======================================================================
		//        private function
		//======================================================================
//		private function changeMoneyType(type:int):void
//		{
//			switch(type)
//			{
//				case TypeProps.MONEY_SILVER:
//					UI.removeAllChilds(_moneyTypeImage);
//					_moneyTypeImage.addChild(silver);
//					break;
//				case TypeProps.MONEY_DIAMOND:
//					UI.removeAllChilds(_moneyTypeImage);
//					_moneyTypeImage.addChild(diamond);
//					break;
//			}
//		}
		
		private function checkCanConsigned():void
		{
			if(_itemIcon.icon == null)
			{
				_purchaseBtn.enabled=false;
			}
			else
			{
//				if(_sliverRadioBtn.selected)
//				{
//					if(_sliverNumView.num.text == '' || int(_sliverNumView.num.text) ==0)
//					{
//						_purchaseBtn.enabled=false;
//					}
//					else
//					{
//						if(Number(_moneyTotalNum.text) <= DataCenter.Instance.roleSelfVo.silver)
//						{
//							checkUpToTenItems();
//						}
//						else
//							_purchaseBtn.enabled=false;
//					}
//				}
//				else
//				{
					if(_diamondNumView.num.text == '' || int(_diamondNumView.num.text) ==0)
					{
						_purchaseBtn.enabled=false;
					}
					else
					{
						if(Number(_moneyTotalNum.text) <= DataCenter.Instance.roleSelfVo.diamond)
						{
							_purchaseBtn.enabled=true;
							checkUpToTenItems();
						}
						else
							_purchaseBtn.enabled=false;
					}
//				}
			}
		}
		
		/** 
		 * 检查是否达到十条记录，并改变寄售按钮
		 */		
		private function checkUpToTenItems():void
		{
			if(MarketDyManager.instance.myPurchaseItemsNum == 10)
			{
				_purchaseBtn.enabled = false;
			}
			else
				_purchaseBtn.enabled = true;
		}
		//======================================================================
		//        event handler
		//======================================================================
//		private function onRadioBtnChange(e:Event):void
//		{
//			if(_sliverRadioBtn.selected)
//			{
//				_sliverNumView.visible=true;
//				_diamondNumView.visible=false;
//				
//				changeMoneyType(TypeProps.MONEY_SILVER);
//			}
//			else
//			{
//				_sliverNumView.visible=false;
//				_diamondNumView.visible=true;
//				
//				changeMoneyType(TypeProps.MONEY_DIAMOND);
//			}
//			checkInputNum();
//			checkCanConsigned();
//		}
		
		private function onReset(e:MouseEvent):void
		{
			resetPanel();
		}
		
		public function InputChange(e:Event):void
		{
			checkCanConsigned();
			if(_inputCheckLaterTime > 0){
				clearTimeout(_inputCheckLaterTimeID);
				_inputCheckLaterTimeID = setTimeout(checkInputNum,_inputCheckLaterTime);
			}else{
				checkInputNum();
			}
		}
		
		/**
		 * 计算当前总价，并判断寄售按钮可用否 
		 * @param e
		 * 
		 */		
		private function checkInputNum(e:FocusEvent=null):void
		{
			var totalNum:Number;
//			if(_sliverRadioBtn.selected)
//			{
//				if(_sliverNumView.num.text != '')
//				{
//					if(int(_sliverNumView.num.text) == 0)
//					{
//						_sliverNumView.num.text='1';
//					}
//				}
//				
//				totalNum=Number(_sliverNumView.num.text)*_numStepper.value;
//				if(totalNum > DataCenter.Instance.roleSelfVo.silver)
//				{
//					_moneyTotalNum.htmlText=HTMLUtil.setFont(totalNum.toString());
//				}
//				else
//				{
//					_moneyTotalNum.text=totalNum.toString();
//				}
//			}
//			else
//			{
				if(_diamondNumView.num.text != '')
				{
					if(int(_diamondNumView.num.text) == 0)
					{
						_diamondNumView.num.text='1';
					}
				}
				
				totalNum=Number(_diamondNumView.num.text)*_numStepper.value;
				if(totalNum > DataCenter.Instance.roleSelfVo.diamond)
				{
					_moneyTotalNum.htmlText=HTMLUtil.setFont(totalNum.toString());
				}
				else
				{
					_moneyTotalNum.text=totalNum.toString();
				}
//			}
			checkCanConsigned();
		}
		
		private function itemNumChange(e:Event):void
		{
			checkInputNum();
		}
		
		private function onPurchase(e:MouseEvent):void
		{
			var msg:CUpWant=new CUpWant();
			var moneyTxt:String;
			msg.itemType=_item.type;
			msg.itemId=_item.id;
			
//			if(_sliverRadioBtn.selected)
//			{
//				msg.priceType = TypeProps.MONEY_SILVER;
//				msg.unitPrice = int(_sliverNumView.num.text);
//				moneyTxt = NoticeUtils.getMoneyTypeStr(TypeProps.MONEY_SILVER);
//			}
//			else
//			{
				msg.priceType = TypeProps.MONEY_DIAMOND;
				msg.unitPrice = int(_diamondNumView.num.text);
				moneyTxt = NoticeUtils.getMoneyTypeStr(TypeProps.MONEY_DIAMOND);
//			}
			msg.wantNumber = _numStepper.value;
			
			if(_sendToChat.selected)
			{
				if(DataCenter.Instance.roleSelfVo.note >= MarketSource.SEND_TO_CHAT_MONEY)
				{
					//发给服务器字符串
					var chatData:ChatData = new ChatData();
					if(_item.type==TypeProps.ITEM_TYPE_EQUIP){
						var bvo:EquipBasicVo = EquipBasicManager.Instance.getEquipBasicVo(_item.id);
						chatData.myType = ChatType.Chat_Type_Basic_Equip;
						chatData.displayName = bvo.name;
						chatData.data = bvo;
						chatData.myQuality = bvo.quality;
						chatData.myId = bvo.template_id;
					}else{
						var pbvo:PropsBasicVo = PropsBasicManager.Instance.getPropsBasicVo(_item.id);
						chatData.myType = ChatType.Chat_Type_Basic_Props;
						chatData.displayName = pbvo.name;
						chatData.data = pbvo;
						chatData.myQuality = pbvo.quality;
						chatData.myId = pbvo.template_id;
					}
					
					var marketRecord:MarketRecord = new MarketRecord();
					marketRecord.itemId = _item.id;
					marketRecord.itemType = _item.type;
					marketRecord.moneyType = msg.priceType;
					marketRecord.number = msg.wantNumber;
					marketRecord.price = msg.unitPrice;
					marketRecord.playerName = DataCenter.Instance.roleSelfVo.roleDyVo.roleName;
				
					var marketRecordObj:Object=BytesUtil.getObject(marketRecord);
					marketRecordObj.recordId = ChatType.getFakeId(ChatType.Chat_Type_Market_Buy);
					
					var chatData2:ChatData = new ChatData();
					chatData2.myType = ChatType.Chat_Type_Market_Buy;
					chatData2.myId = ChatType.Chat_Type_Market_Buy;
					chatData2.myQuality = 2;
					chatData2.displayName = "快速出售";
					chatData2.data = marketRecordObj;
					
					var txt:String = "求购了"+_numStepper.value+"个["+chatData.displayName+","+chatData.myType+","+chatData.myId+"]，单价："+msg.unitPrice+moneyTxt+"，欲售从速！["+chatData2.displayName+","+chatData2.myType+","+chatData2.myId+"]";
					var dict:Dictionary = new Dictionary();
					dict["【"+chatData.displayName+"】"+"_"+chatData.myType+"_"+chatData.myId] = chatData;
					dict["【"+chatData2.displayName+"】"+"_"+chatData2.myType+"_"+chatData2.myId] = chatData2;
					msg.sendWorld = ChatTextUtil.convertSendDataToString(txt,dict);
				}
			}
			
			YFEventCenter.Instance.dispatchEventWith(MarketEvent.CUpWant,msg);
		}
		
		/**
		 * 从筛选窗口到求购面板
		 * @param e
		 * 
		 */		
		private function dragComplete(e:MouseEvent):void
		{
			var fromData:DragData=DragManager.Instance.dragVo as DragData;
			if(fromData && fromData.type == DragData.FROM_SIFT_WINDOW)
			{
				if(MarketDyManager.instance.myPurchaseItemsNum == MarketSource.MY_TOTAL_ITEMS)
				{
					NoticeManager.setNotice(NoticeType.Notice_id_1605);
				}
				else
				{
					var toBox:IMoveGrid = ZHitTester.checkIMoveGrid(IMoveGrid);
					if(toBox)
					{
						_itemIcon.setTemplateIcon(fromData.data.type,fromData.data.id);
						if(fromData.data.type == TypeProps.ITEM_TYPE_EQUIP)
						{
							_numStepper.text='1';
							_numStepper.minimum=1;
							_numStepper.maximum=1;
						}
						 _item=new ItemDyVo(0,fromData.data.type,fromData.data.id);
					}
				}				
			}
		}
		
		private function clearPurchasePanel(e:YFEvent):void
		{
			resetPanel();
		}
		//======================================================================
		//        getter&setter
		//======================================================================
		
		
	}
} 