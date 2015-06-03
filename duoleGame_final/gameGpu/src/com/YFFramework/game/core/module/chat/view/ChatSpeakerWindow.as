package com.YFFramework.game.core.module.chat.view
{
	import com.YFFramework.core.event.YFEventCenter;
	import com.YFFramework.game.core.global.event.GlobalEvent;
	import com.YFFramework.game.core.global.manager.ConstMapBasicManager;
	import com.YFFramework.game.core.global.manager.PropsBasicManager;
	import com.YFFramework.game.core.global.manager.PropsDyManager;
	import com.YFFramework.game.core.global.model.ConstMapBasicVo;
	import com.YFFramework.game.core.global.model.PropsBasicVo;
	import com.YFFramework.game.core.global.util.NoticeUtil;
	import com.YFFramework.game.core.global.util.TypeProps;
	import com.YFFramework.game.core.global.view.tips.PropsTip;
	import com.YFFramework.game.core.global.view.tips.TipUtil;
	import com.YFFramework.game.core.global.view.window.WindowTittleName;
	import com.YFFramework.game.core.module.chat.controller.ModuleChat;
	import com.YFFramework.game.core.module.shop.controller.ModuleShop;
	import com.YFFramework.game.core.module.shop.view.BuyWindow;
	import com.YFFramework.game.core.module.shop.data.ShopBasicManager;
	import com.YFFramework.game.core.module.shop.data.ShopBasicVo;
	import com.dolo.lang.LangBasic;
	import com.dolo.ui.controls.Button;
	import com.dolo.ui.controls.IconImage;
	import com.dolo.ui.controls.NumericStepper;
	import com.dolo.ui.controls.PopMiniWindow;
	import com.dolo.ui.controls.Window;
	import com.dolo.ui.managers.UI;
	import com.dolo.ui.managers.UIManager;
	import com.dolo.ui.tools.TextInputUtil;
	import com.dolo.ui.tools.WindowManager;
	import com.dolo.ui.tools.Xdis;
	import com.dolo.ui.tools.Xtip;
	
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;

	/**
	 * 大喇叭(千里传音)发送编写消息窗口 
	 * @author flashk
	 * 
	 */
	public class ChatSpeakerWindow extends PopMiniWindow
	{
		/**
		 * 输入框最大输入文字 
		 */
		public static var inputMax:int = 50;
		
		private static var _ins:ChatSpeakerWindow;
		
		/**
		 * UI界面Sprite 
		 */
		private var _ui:Sprite;
		/**
		 * 信息用户输入文本 
		 */
		private var _inputTxt:TextField;
		/**
		 * 默认要在输入文本提示的文字 
		 */
		private var _textTipStr:String = "请在这里输入聊天内容（最多50个字）";
		/**
		 * 默认要在输入文本提示的文字的颜色 
		 */
		private var _textTipColor:uint = 0x999999;
		/**
		 * 用户上下翻的输入记录 
		 */
		private var _histroy:TextInputKeyHistroy;
		/**
		 * 表情显示选择 
		 */
		private var _facesView:FacesView;
		/**
		 * 表情打开/关闭按钮 
		 */
		private var _faceBtn:SimpleButton;
		/**
		 * 传音符的模板ID
		 */
		private var _speakerID:int;
		/**
		 * 传音符的固定表ID 
		 */
		private var _constID:int = 298;
		/**
		 *  传音符图标
		 */
		private var _icon:IconImage;
		/**
		 * 数量文本 
		 */
		private var _numTxt:TextField;
		/**
		 * 价格文本 
		 */
		private var _priceTxt:TextField;
		/**
		 * 购买数字选择组件 
		 */
		private var _buyNumStep:NumericStepper;
		/**
		 * 购买按钮 
		 */
		private var _buyBtn:Button;
		/**
		 * 当前用户拥有的传音符数量 
		 */
		private var _itemNum:int;
		/**
		 * 发送按钮 
		 */
		private var _sendButton:Button;
		/**
		 * 取消按钮 
		 */
		private var _cannelButton:Button;
		/**
		 * 数量的默认文本颜色 
		 */
		private var _numColor:uint;
		/**
		 *数量不够(<1)的警告颜色 
		 */
		private var _warnColor:uint = 0xFF0000;
		
		public function ChatSpeakerWindow()
		{
			_ui = initByArgument(340,248,"ChatSpeakerUI",WindowTittleName.speakerTitle);
			_inputTxt = Xdis.getChild(_ui,"input_txt");
			_inputTxt.text = "";
			_inputTxt.maxChars = inputMax;
			TextInputUtil.initDefautText(_inputTxt,_textTipStr,true,0xFFFFFF,_textTipColor);
			_histroy = new TextInputKeyHistroy(_inputTxt);
			_faceBtn = Xdis.getChild(_ui,"face_btn");
			_faceBtn.addEventListener(MouseEvent.CLICK,onFaceBtnClick);
			_speakerID = ConstMapBasicManager.Instance.getTempId(_constID);
			_icon = Xdis.getChild(_ui,"icon_iconImage");
			_icon.url = PropsBasicManager.Instance.getURL(_speakerID);
			_numTxt = Xdis.getChild(_ui,"num_txt");
			_numColor = _numTxt.textColor;
			_priceTxt = Xdis.getChild(_ui,"price_txt");
			_buyNumStep = Xdis.getChild(_ui,"num_numericStepper");
			_buyNumStep.minimum = 1;
			_buyNumStep.maximum = 9999;
			_buyNumStep.maxChars = 4;
			_buyBtn = Xdis.getChild(_ui,"buy_button");
			_buyBtn.addEventListener(MouseEvent.CLICK,onBuyBtnClick);
			_sendButton = Xdis.getChild(_ui,"send_button");
			_sendButton.addEventListener(MouseEvent.CLICK,onSendBtnClick);
			_cannelButton = Xdis.getChild(_ui,"cannel_button");
			_cannelButton.addEventListener(MouseEvent.CLICK,closeTwoWindow);
			YFEventCenter.Instance.addEventListener(GlobalEvent.BagChange,updateInfo);
			var _propsInfo:PropsBasicVo=PropsBasicManager.Instance.getPropsBasicVo(_speakerID);
			Xtip.registerLinkTip(_icon,PropsTip,TipUtil.propsTipInitFunc,0,_propsInfo.template_id);
		}
		
		/**
		 * 发送千里传音检测/发送 
		 * @param event
		 * 
		 */
		protected function onSendBtnClick(event:MouseEvent):void
		{
			if(_itemNum <1){
				NoticeUtil.setOperatorNotice(LangBasic.speakerNone);
				return;
			}
			if(_inputTxt.text.length<1 || (_inputTxt.text == _textTipStr && _inputTxt.textColor == _textTipColor)){
				NoticeUtil.setOperatorNotice("不允许发送空消息");
				UI.stage.focus = _inputTxt;
				return;
			}
			_histroy.putInHistroy();
			ModuleChat.ins.sendSpeaker(_inputTxt.text);
			_inputTxt.text = "";
			UI.stage.focus = _inputTxt;
		}
		
		/**
		 * 购买传音符 
		 * @param event
		 * 
		 */
		protected function onBuyBtnClick(event:MouseEvent):void
		{
			ModuleShop.instance.buyItemDirect(TypeProps.ITEM_TYPE_PROPS,_speakerID,_buyNumStep.value);
		}
		
		public static function getInstance():ChatSpeakerWindow
		{
			if(_ins == null){
				_ins = new ChatSpeakerWindow;
			}
			return _ins;
		}
		
		/**
		 * 插入表情 
		 * @param str
		 * 
		 */
		public function insertString(str:String):void
		{
			UI.insertStringInText(_inputTxt,str,true,true);
		}
		
		/**
		 * 打开 
		 * 
		 */
		override public function open():void
		{
			super.open();
			updateInfo();
		}
		
		/**
		 * 刷新传音符数量/信息 
		 * @param event
		 * 
		 */
		private function updateInfo(event:Object=null):void
		{
			_itemNum= PropsDyManager.instance.getPropsQuantity(_speakerID);
			var _propsInfo:ShopBasicVo=ShopBasicManager.Instance.getShopBasicVoDirect(TypeProps.ITEM_TYPE_PROPS,_speakerID);
			var price:int = _propsInfo.price;
			_numTxt.text = LangBasic.speakerNum.replace("{$1}",String(_itemNum));
			_priceTxt.text = LangBasic.speakerPrice.replace("{$1}",String(price));
			if(_itemNum <1){
				_numTxt.textColor = _warnColor;
			}else{
				_numTxt.textColor = _numColor;
			}
		}
		
		/**
		 * 点击表情按钮打开/关闭表情 
		 * @param event
		 * 
		 */
		protected function onFaceBtnClick(event:MouseEvent=null):void
		{
			if(_facesView == null){
				_facesView = new FacesView();
				_facesView.closeWithOut = [_faceBtn,_inputTxt];
				_facesView.target = this;
			}
			_facesView.switchShowClose();
			UI.stage.focus = _inputTxt;
			updateFaceXY();
		}
		
		/**
		 * 屏幕大小更改时检测/重新更改表情位置 (边界处理)
		 * 
		 */
		public function updateFaceXY():void
		{
			if(_facesView){
				_facesView.x = this.x + 100;
				_facesView.y = this.y+_faceBtn.y + 75;
				if(_facesView.y+_facesView.height>UI.stage.stageHeight){
					_facesView.y = this.y+65;
				}
				if(_facesView.x + _facesView.width > UI.stage.stageWidth-5){
					_facesView.x  = UI.stage.stageWidth-5-_facesView.width;
				}
			}
		}
		
		override protected function onStageResize(event:Event):void
		{
			super.onStageResize(event);
			updateFaceXY();
		}
		
		public function openMe():void
		{
			var hisWindow:Window = ChatSpeakerHistroyWindow.getInstance();
			var hisOpened:Boolean = hisWindow.isOpen;
			if(this.isOpen == false || hisWindow.isOpen == false ){
				this.open();
				hisWindow.open();
				UIManager.centerMultiWindows(this,hisWindow);
				if(hisOpened == false){
					this..switchToTop();
				}
			}else{
				closeTwoWindow();
			}
		}
		
		private function closeTwoWindow(event:Event = null):void
		{
			this.close();
			ChatSpeakerHistroyWindow.getInstance().close();
		}
		
	}
}