package com.YFFramework.game.core.module.market.view.panel.consign
{
	/**
	 * 寄售窗口下的——寄售物品
	 * @version 1.0.0
	 * creation time：2013-5-30 下午1:14:32
	 * 
	 */
	import com.YFFramework.core.event.YFEvent;
	import com.YFFramework.core.event.YFEventCenter;
	import com.YFFramework.core.utils.common.ClassInstance;
	import com.YFFramework.game.core.global.DataCenter;
	import com.YFFramework.game.core.global.event.GlobalEvent;
	import com.YFFramework.game.core.global.manager.EquipBasicManager;
	import com.YFFramework.game.core.global.manager.EquipDyManager;
	import com.YFFramework.game.core.global.manager.PropsBasicManager;
	import com.YFFramework.game.core.global.manager.PropsDyManager;
	import com.YFFramework.game.core.global.model.EquipBasicVo;
	import com.YFFramework.game.core.global.model.EquipDyVo;
	import com.YFFramework.game.core.global.model.ItemDyVo;
	import com.YFFramework.game.core.global.model.PropsBasicVo;
	import com.YFFramework.game.core.global.model.PropsDyVo;
	import com.YFFramework.game.core.global.util.BytesUtil;
	import com.YFFramework.game.core.global.util.DragManager;
	import com.YFFramework.game.core.global.util.NoticeUtil;
	import com.YFFramework.game.core.global.util.TypeProps;
	import com.YFFramework.game.core.global.util.ZHitTester;
	import com.YFFramework.game.core.module.bag.Interface.IMoveGrid;
	import com.YFFramework.game.core.module.chat.manager.ChatTextUtil;
	import com.YFFramework.game.core.module.chat.model.ChatData;
	import com.YFFramework.game.core.module.chat.model.ChatType;
	import com.YFFramework.game.core.module.market.data.manager.MarketConfigBasicManager;
	import com.YFFramework.game.core.module.market.data.manager.MarketDyManager;
	import com.YFFramework.game.core.module.market.data.vo.MarketRecord;
	import com.YFFramework.game.core.module.market.event.MarketEvent;
	import com.YFFramework.game.core.module.market.source.MarketSource;
	import com.YFFramework.game.core.module.market.view.simpleView.ItemIcon;
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
	import com.msg.market_pro.CUpSale;
	
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
	
	public class ConsignItemPanel extends EventDispatcher
	{
		//======================================================================
		//       public property
		//======================================================================
		
		//======================================================================
		//       private property
		//======================================================================
		//以下两个变量是为了实时输入文本框
		protected var _inputCheckLaterTime:int = 1000;
		protected var _inputCheckLaterTimeID:int;
		
		private var _mc:MovieClip;
			
		private var _itemIcon:ItemIcon;
		
//		private var _sliverRadioBtn:RadioButton;
		private var _diamondRadioBtn:RadioButton;
		
//		private var _sliverNumView:MovieClip;
		private var _diamondNumView:MovieClip;
		
		private var _numStepper:NumericStepper;
		
		private var _moneyTypeImage:Sprite;//寄售总价前的货币类型图标
		
//		private var silver:Sprite;
		private var diamond:Sprite;
		
		private var _resetBtn:Button;
		private var _consignBtn:Button;
		
		private var _sendToChat:CheckBox;
		
		private var _moneyTotalNum:TextField;
		
		private var _item:ItemDyVo;
		//======================================================================
		//        constructor
		//======================================================================
		
		public function ConsignItemPanel(mc:MovieClip)
		{
			_mc=mc;
			
			//初始化物品图标
			var iconFixPos:Sprite=Xdis.getChild(_mc,"itemIcon");
			_itemIcon=new ItemIcon();
			_itemIcon.setIconType(MarketSource.CONSIGH);
			_itemIcon.x=iconFixPos.x;
			_itemIcon.y=iconFixPos.y;
			_mc.addChild(_itemIcon);
			
//			_sliverRadioBtn=Xdis.getChild(_mc,"silver_ga_radioButton");
			_diamondRadioBtn=Xdis.getChild(_mc,"diamond_ga_radioButton");
			_diamondRadioBtn.selected=true;
			
//			_diamondRadioBtn.group.addEventListener(Event.CHANGE,onRadioBtnChange);
			
//			_sliverNumView=Xdis.getChild(_mc,"silverInput");
			_diamondNumView=Xdis.getChild(_mc,"diamondInput");
			
//			_sliverNumView.num.addEventListener(Event.CHANGE,InputChange);
//			_sliverNumView.num.addEventListener(FocusEvent.FOCUS_OUT,checkInputNum);
			
			_diamondNumView.num.addEventListener(Event.CHANGE,InputChange);
			_diamondNumView.num.addEventListener(FocusEvent.FOCUS_OUT,checkInputNum);
			
//			TextField(_sliverNumView.num).restrict='0-9';
			TextField(_diamondNumView.num).restrict='0-9';
//			TextField(_sliverNumView.num).maxChars=7;
			TextField(_diamondNumView.num).maxChars=7;
			
			_numStepper=Xdis.getChild(_mc,"num_numericStepper");
			_numStepper.addEventListener(Event.CHANGE,itemNumChange);
			
			_moneyTypeImage=Xdis.getChild(_mc,"moneyTypeIcon");	
			
//			silver=ClassInstance.getInstance("silver") as Sprite;
			diamond=ClassInstance.getInstance("diamond") as Sprite;
			_moneyTypeImage.addChild(diamond);
			
			_resetBtn=Xdis.getChild(_mc,"reset_button");
			_resetBtn.addEventListener(MouseEvent.CLICK,onReset);
			
			_consignBtn=Xdis.getChild(_mc,"consign_button");
			_consignBtn.addEventListener(MouseEvent.CLICK,onConsign);
			
			_sendToChat=Xdis.getChild(_mc,"sendToChat_checkBox");
			_sendToChat.textField.wordWrap=true;
			_sendToChat.textField.multiline=true;
			_sendToChat.textField.width=125;
			_sendToChat.textField.height=40;
			
			_moneyTotalNum=Xdis.getChild(_mc,"moneyNum");
			
			_mc.addEventListener(MouseEvent.MOUSE_UP,dragComplete);
			YFEventCenter.Instance.addEventListener(MarketEvent.CLEAR_CONSIGNMENT_ITEM,clearConsignPanel);
			
			resetPanel();
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
			_numStepper.maximum=1;
			
			_moneyTotalNum.text='0';
			
//			changeMoneyType(TypeProps.MONEY_SILVER);
			
			_consignBtn.enabled=false;
			_sendToChat.selected=false;
			
			_item=null;
			
			//这里泥煤的不能重置啊！不然就永远记录不下来上一个位置
//			MarketSource.curLockPos=0;
//			MarketSource.lastLockPos=0;
		}
		
		public function consignItem(item:ItemDyVo):void
		{
			resetPanel();
			
			_itemIcon.setIcon(item.type,item.id);
			_item=item;
			
			if(item.type == TypeProps.ITEM_TYPE_EQUIP)
			{
				_numStepper.minimum=1;
				_numStepper.maximum=1;
			}
			else
			{
				_numStepper.minimum=1;
				_numStepper.maximum=PropsDyManager.instance.getPropsInfo(item.id).quantity;
			}
			_numStepper.value=1;
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
				_consignBtn.enabled=false;
			}
			else
			{
//				if(_sliverRadioBtn.selected)
//				{
//					if(_sliverNumView.num.text == '' || int(_sliverNumView.num.text) ==0)
//					{
//						_consignBtn.enabled=false;
//					}
//					else
//					{
//						checkUpToTenItems();
//					}
//				}
//				else
//				{
					if(_diamondNumView.num.text == '' || int(_diamondNumView.num.text) ==0)
					{
						_consignBtn.enabled=false;
					}
					else
					{
						checkUpToTenItems();
					}
//				}
			}
			
			
		}
		
		/** 
		 * 检查是否达到十条记录，并改变寄售按钮
		 */		
		private function checkUpToTenItems():void
		{
			if(MarketDyManager.instance.myConsignItemsNum == 10)
			{
				_consignBtn.enabled = false;
				NoticeManager.setNotice(NoticeType.Notice_id_1605);
			}
			else
				_consignBtn.enabled = true;
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
//		}
		
		private function onReset(e:MouseEvent):void
		{
			if(MarketSource.curLockPos > 0)
			{
				YFEventCenter.Instance.dispatchEventWith(GlobalEvent.UnlockItem,MarketSource.curLockPos);
				
				//一定要在清除图标的地方把下面两个变量设为0
				MarketSource.curLockPos=0;
				MarketSource.lastLockPos=0;
			}			
			
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
		private function checkInputNum(e:Event=null):void
		{
			if(_item == null) return;
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
//				_moneyTotalNum.text=totalNum.toString();
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
				_moneyTotalNum.text=totalNum.toString();
//			}
			checkCanConsigned();
		}
		
		private function itemNumChange(e:Event):void
		{
			checkInputNum();
		}
		
		private function onConsign(e:MouseEvent):void
		{
			//服务器还没返回呢，你重置个毛啊！
//			MarketSource.curLockPos=0;
//			MarketSource.lastLockPos=0;
			
			var msg:CUpSale=new CUpSale();
			msg.itemPos=_item.pos;
			var moneyTxt:String;
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
			msg.saleNumber = _numStepper.value;
			
			if(_sendToChat.selected)
			{
				if(DataCenter.Instance.roleSelfVo.note >= MarketSource.SEND_TO_CHAT_MONEY)
				{
					//发给服务器字符串；把东西转换成String
					var chatData:ChatData = new ChatData();
					var chatData2:ChatData=new ChatData();
					var marketRecord:MarketRecord = new MarketRecord();
					if(_item.type==TypeProps.ITEM_TYPE_EQUIP){
						var dyVo:EquipDyVo;
						var bvo:EquipBasicVo;
						dyVo = EquipDyManager.instance.getEquipInfo(_item.id);
						bvo = EquipBasicManager.Instance.getEquipBasicVo(dyVo.template_id);
						chatData.myType = ChatType.Chat_Type_Equip;
						chatData.displayName = bvo.name;
						chatData.data = dyVo;
						chatData.myQuality = bvo.quality;
						chatData.myId = dyVo.equip_id;
						marketRecord.equip = dyVo;
					}else{
						var pvo:PropsDyVo;
						var pbvo:PropsBasicVo;
						pvo = PropsDyManager.instance.getPropsInfo(_item.id);
						pbvo = PropsBasicManager.Instance.getPropsBasicVo(pvo.templateId);
						chatData.myType = ChatType.Chat_Type_Props;
						chatData.displayName = pbvo.name;
						chatData.data = pvo;
						chatData.myQuality = pbvo.quality;
						chatData.myId = pvo.propsId;
						marketRecord.props = pvo;
					}
					marketRecord.price = msg.unitPrice;
					marketRecord.number = _numStepper.value;
					marketRecord.playerName = DataCenter.Instance.roleSelfVo.roleDyVo.roleName;
					marketRecord.moneyType = msg.priceType;
					
					var marketRecordObj:Object=BytesUtil.getObject(marketRecord);
					marketRecordObj.recordId = ChatType.getFakeId(ChatType.Chat_Type_Market_Sell);
					
					chatData2.data = marketRecordObj;
					chatData2.displayName = "快速购买";
					chatData2.myId = ChatType.Chat_Type_Market_Sell;
					chatData2.myQuality = 2;
					chatData2.myType = ChatType.Chat_Type_Market_Sell;
					
					var txt:String = "寄售了"+_numStepper.value+"个["+chatData.displayName+","+chatData.myType+","+_item.id+"]，单价："+msg.unitPrice+moneyTxt+"，欲购从速！["+chatData2.displayName+","+chatData2.myType+","+chatData2.myId+"]";
					var dict:Dictionary = new Dictionary();
					dict["【"+chatData.displayName+"】"+"_"+chatData.myType+"_"+_item.id] = chatData;
					dict["【"+chatData2.displayName+"】"+"_"+chatData2.myType+"_"+chatData2.myId] = chatData2;
					msg.sendWorld = ChatTextUtil.convertSendDataToString(txt,dict);
				}
			}
			YFEventCenter.Instance.dispatchEventWith(MarketEvent.CUpSale,msg);
		}
		
		/**
		 * 从背包移动到寄售物品 
		 * @param e
		 * 
		 */		
		private function dragComplete(e:MouseEvent):void
		{
			//要先判断这个物品在不在配置表里,有没有十条记录交给服务器了
			var fromData:DragData=DragManager.Instance.dragVo as DragData;
			
			if(fromData && fromData.type == DragData.FROM_BAG)
			{
				var tmpId:int;
				if(fromData.data.type == TypeProps.ITEM_TYPE_EQUIP)
				{
					tmpId=EquipDyManager.instance.getEquipInfo(fromData.data.id).template_id;
				}
				else
				{
					tmpId=PropsDyManager.instance.getPropsInfo(fromData.data.id).templateId;
				}
				if(MarketConfigBasicManager.Instance.getItemInfo(fromData.data.type,tmpId) == null)
				{
					NoticeManager.setNotice(NoticeType.Notice_id_1611);
					return;
				}
				
				var toBox:IMoveGrid = ZHitTester.checkIMoveGrid(IMoveGrid);
				if(toBox)
				{
					if(fromData.data.bound == false)
					{
						var pos:int=0;
						if(fromData.data.type == TypeProps.ITEM_TYPE_EQUIP)
						{
							pos=EquipDyManager.instance.getEquipPosFromBag(fromData.data.id);
						}
						else
						{
							pos=PropsDyManager.instance.getPropsPosFromBag(fromData.data.id);
						}
						var item:ItemDyVo=new ItemDyVo(pos,fromData.data.type,fromData.data.id);
						YFEventCenter.Instance.dispatchEventWith(MarketEvent.MOVE_TO_CONSIGN_ITEM,item);
					}
				}
			}
		}
		
		private function clearConsignPanel(e:YFEvent):void
		{
			if(e.param)
			{
				resetPanel();
				
				var pos:int=(e.param as ItemDyVo).pos;
				YFEventCenter.Instance.dispatchEventWith(GlobalEvent.UnlockItem,pos);
				
				//一定要在清除图标的地方把下面两个变量设为0
				MarketSource.curLockPos=0;
				MarketSource.lastLockPos=0;
			}		
			
		}
		//======================================================================
		//        getter&setter
		//======================================================================
		
		
	}
} 