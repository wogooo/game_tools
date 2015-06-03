package com.YFFramework.game.core.module.market.view.panel.consign
{
	/**
	 * 寄售窗口——寄售货币
	 * @version 1.0.0
	 * creation time：2013-5-30 下午1:17:38
	 * 
	 */
	import com.YFFramework.core.event.YFEventCenter;
	import com.YFFramework.core.utils.common.ClassInstance;
	import com.YFFramework.game.core.global.DataCenter;
	import com.YFFramework.game.core.global.util.BytesUtil;
	import com.YFFramework.game.core.global.util.TypeProps;
	import com.YFFramework.game.core.module.chat.manager.ChatTextUtil;
	import com.YFFramework.game.core.module.chat.model.ChatData;
	import com.YFFramework.game.core.module.chat.model.ChatType;
	import com.YFFramework.game.core.module.market.data.manager.MarketDyManager;
	import com.YFFramework.game.core.module.market.data.vo.MarketRecord;
	import com.YFFramework.game.core.module.market.event.MarketEvent;
	import com.YFFramework.game.core.module.market.source.MarketSource;
	import com.YFFramework.game.core.module.notice.manager.NoticeManager;
	import com.YFFramework.game.core.module.notice.model.NoticeType;
	import com.YFFramework.game.core.module.notice.model.NoticeUtils;
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
	
	public class ConsignMoneyPanel extends EventDispatcher
	{
		//======================================================================
		//       public property
		//======================================================================
		
		//======================================================================
		//       private property
		//======================================================================
		private var _mc:MovieClip;
		
		private var _sliverRadioBtn:RadioButton;
		private var _diamondRadioBtn:RadioButton;
		
		private var _sliverNumView:MovieClip;
		private var _diamondNumView:MovieClip;
		
		private var _moneyTypeTxt:TextField;
		private var _price:TextField;
		
		private var _numStepper:NumericStepper;
		
		private var _moneyTypeImage:Sprite;//寄售总价前的货币类型图标
		
		private var silver:Sprite;
		private var diamond:Sprite;
		
		private var _resetBtn:Button;
		private var _consignBtn:Button;
		
		private var _sendToChat:CheckBox;
		
		private var _moneyTotalNum:TextField;
		
		//以下两个变量是为了实时输入文本框
		protected var _inputCheckLaterTime:int = 1000;
		protected var _inputCheckLaterTimeID:int;
		//======================================================================
		//        constructor
		//======================================================================
		
		public function ConsignMoneyPanel(mc:MovieClip)
		{
			_mc=mc;
			
			_sliverRadioBtn=Xdis.getChild(_mc,"silver_se_radioButton");
			_diamondRadioBtn=Xdis.getChild(_mc,"diamond_se_radioButton");
			_diamondRadioBtn.group.addEventListener(Event.CHANGE,onRadioBtnChange);
			
			_sliverNumView=Xdis.getChild(_mc,"silverInput");
			_diamondNumView=Xdis.getChild(_mc,"diamondInput");
			
			_sliverNumView.num.addEventListener(Event.CHANGE,InputChange);
			_sliverNumView.num.addEventListener(FocusEvent.FOCUS_OUT,checkInputNum);
			
			_diamondNumView.num.addEventListener(Event.CHANGE,InputChange);
			_diamondNumView.num.addEventListener(FocusEvent.FOCUS_OUT,checkInputNum);
			
			
			(_sliverNumView.num as TextField).restrict='0-9';
			(_diamondNumView.num as TextField).restrict='0-9';
			TextField(_sliverNumView.num).maxChars=7;
			TextField(_diamondNumView.num).maxChars=7;
			
			_moneyTypeTxt=Xdis.getChild(_mc,"moneyTypeTxt");
			
			_price=Xdis.getChild(_mc,"price");
			_price.restrict='0-9';
			_price.addEventListener(FocusEvent.FOCUS_OUT,checkPrice);
			_price.addEventListener(Event.CHANGE,InputChange);
			
			_numStepper=Xdis.getChild(_mc,"num_numericStepper");
			_numStepper.addEventListener(Event.CHANGE,itemNumChange);
			
			_moneyTypeImage=Xdis.getChild(_mc,"moneyTypeIcon");
			
			silver=ClassInstance.getInstance("silver") as Sprite;
			diamond=ClassInstance.getInstance("diamond") as Sprite;
			
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

			resetPanel();
		}
		
		//======================================================================
		//        public function
		//======================================================================
		public function resetPanel():void
		{	
			_sliverRadioBtn.selected=true;
			_sliverNumView.visible=true;
			_sliverNumView.num.text='';
			
			_diamondRadioBtn.selected=false;
			_diamondNumView.visible=false;
			_diamondNumView.num.text='';
			
			_price.text='';
			
			_numStepper.minimum=1;
			_numStepper.maximum=1;
			_numStepper.enabled=false;
			
			_moneyTotalNum.text='0';
			
			changeMoneyType(TypeProps.MONEY_SILVER);
			
			_consignBtn.enabled=false;
			_sendToChat.selected=false;
		}
		//======================================================================
		//        private function
		//======================================================================
		private function changeMoneyType(type:int):void
		{
			switch(type)
			{
				case TypeProps.MONEY_SILVER:
					UI.removeAllChilds(_moneyTypeImage);
					_moneyTypeImage.addChild(diamond);
					break;
				case TypeProps.MONEY_DIAMOND:
					UI.removeAllChilds(_moneyTypeImage);
					_moneyTypeImage.addChild(silver);
					break;
			}
		}
		
		private function checkCanConsigned():void
		{
			if(_sliverRadioBtn.selected)
			{
				if(MarketDyManager.instance.myConsignItemsNum == 10)
				{
					_consignBtn.enabled = false;
				}
				else
				{
					if(_sliverNumView.num.text == '' || _price.text == '')
					{
						_consignBtn.enabled=false;
					}
					else
					{
						_consignBtn.enabled=true;
					}
				}
				
			}
			else
			{
				if(MarketDyManager.instance.myConsignItemsNum == 10)
				{
					_consignBtn.enabled = false;
					NoticeManager.setNotice(NoticeType.Notice_id_1605);
				}
				else
				{
					if(_diamondNumView.num.text == '' || _price.text == '')
					{
						_consignBtn.enabled=false;
					}
					else
					{
						_consignBtn.enabled=true;
					}
				}
			}
		}
		
		//======================================================================
		//        event handler
		//======================================================================
		private function onRadioBtnChange(e:Event):void
		{
			if(_sliverRadioBtn.selected)
			{
				_sliverNumView.visible=true;
				_diamondNumView.visible=false;
				
				_moneyTypeTxt.text=NoticeUtils.getMoneyTypeStr(TypeProps.MONEY_DIAMOND);//选择银币类型，单价类型就是魔钻
				
				changeMoneyType(TypeProps.MONEY_SILVER);
			}
			else
			{
				_sliverNumView.visible=false;
				_diamondNumView.visible=true;
				
				_moneyTypeTxt.text=NoticeUtils.getMoneyTypeStr(TypeProps.MONEY_SILVER);
				
				changeMoneyType(TypeProps.MONEY_DIAMOND);
			}
			checkInputNum();
		}
		
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
		 * 计算当前总价，并判断寄售按钮可用否 (判断因素有：货币数量，单价)
		 * @param e
		 * 
		 */		
		private function checkInputNum(e:FocusEvent=null):void
		{
			var totalNum:Number;
			if(_sliverRadioBtn.selected)//银币选中，计算魔钻的数量
			{
				if(_sliverNumView.num.text != '')
				{
					if(Number(_sliverNumView.num.text) == 0 && DataCenter.Instance.roleSelfVo.silver > 0)
					{
						_sliverNumView.num.text='1';
					}
					else if(Number(_sliverNumView.num.text) > DataCenter.Instance.roleSelfVo.silver)
					{
						_sliverNumView.num.text=DataCenter.Instance.roleSelfVo.silver.toString();
					}
				}
				
				if(_price.text != '')
				{
					if(int(_price.text) == 0)
						_price.text='1';
					
					totalNum=int(_sliverNumView.num.text)*int(_price.text);
					_moneyTotalNum.text=totalNum.toString();//总价指的是想要卖多少，字不用变红
				}				
			}
			else
			{
				if(_diamondNumView.num.text != '')
				{
					if(Number(_diamondNumView.num.text) == 0 && DataCenter.Instance.roleSelfVo.diamond > 0)
					{
						_diamondNumView.num.text='1';
					}
					else if(Number(_diamondNumView.num.text) > DataCenter.Instance.roleSelfVo.diamond)
					{
						_diamondNumView.num.text=DataCenter.Instance.roleSelfVo.diamond.toString();
					}
				}
				
				if(_price.text != '')
				{
					if(int(_price.text) == 0)
						_price.text='1';
					
					totalNum=Number(_diamondNumView.num.text)*Number(_price.text);
					_moneyTotalNum.text=totalNum.toString();

				}			
			}
			checkCanConsigned();
		}
		
		private function checkPrice(e:FocusEvent):void
		{
			if(_price.text != '')
			{
				if(Number(_price.text) == 0)
				{
					_price.text='1';
				}
			}
			checkInputNum();
			checkCanConsigned();
		}
		
		private function itemNumChange(e:Event):void
		{
			checkInputNum();
		}
		
		private function onConsign(e:MouseEvent):void
		{
			var msg:CUpSale=new CUpSale();
			var moneyTxt:String;
			var priceTxt:String;
			if(_sliverRadioBtn.selected)
			{
				msg.moneyType = TypeProps.MONEY_SILVER;
				msg.saleNumber = int(_sliverNumView.num.text);
				priceTxt = NoticeUtils.getMoneyTypeStr(TypeProps.MONEY_SILVER);
				
				msg.priceType = TypeProps.MONEY_DIAMOND;
				msg.unitPrice = int(_price.text);
				moneyTxt = NoticeUtils.getMoneyTypeStr(TypeProps.MONEY_DIAMOND);
			}
			else
			{
				msg.moneyType = TypeProps.MONEY_DIAMOND;
				msg.saleNumber = int(_diamondNumView.num.text);
				priceTxt = NoticeUtils.getMoneyTypeStr(TypeProps.MONEY_DIAMOND);
				
				msg.priceType = TypeProps.MONEY_SILVER;
				msg.unitPrice = int(_price.text);
				moneyTxt = NoticeUtils.getMoneyTypeStr(TypeProps.MONEY_SILVER);
			}
			
			if(_sendToChat.selected)
			{
				if((DataCenter.Instance.roleSelfVo.silver + DataCenter.Instance.roleSelfVo.note) >= MarketSource.SEND_TO_CHAT_MONEY)
				{
					//发给服务器字符串；把东西转换成String
					
					var chatData:ChatData = new ChatData();
					var marketRecord:MarketRecord = new MarketRecord();
					
					marketRecord.price = msg.unitPrice;
					marketRecord.saleMoneyType = msg.priceType;
					marketRecord.number = msg.saleNumber;
					marketRecord.playerName = DataCenter.Instance.roleSelfVo.roleDyVo.roleName;
					marketRecord.moneyType = msg.moneyType;
					
					var marketRecordObj:Object=BytesUtil.getObject(marketRecord);
					marketRecordObj.recordId = ChatType.getFakeId(ChatType.Chat_Type_Market_Sell);
					
					chatData.data = marketRecordObj;
					chatData.displayName = "快速购买";
					chatData.myId = ChatType.Chat_Type_Market_Sell;
					chatData.myQuality = 2;
					chatData.myType = ChatType.Chat_Type_Market_Sell;

					var txt:String = "寄售了"+msg.saleNumber+priceTxt+"，单价："+msg.unitPrice+moneyTxt+"，欲购从速！["+chatData.displayName+","+chatData.myType+","+chatData.myId+"]";
					var dict:Dictionary = new Dictionary();
					dict["【"+chatData.displayName+"】"+"_"+chatData.myType+"_"+chatData.myId] = chatData;
					msg.sendWorld = ChatTextUtil.convertSendDataToString(txt,dict);
				}
			}
			
			YFEventCenter.Instance.dispatchEventWith(MarketEvent.CUpSale,msg);
		}
		//======================================================================
		//        getter&setter
		//======================================================================
		
		
	}
} 