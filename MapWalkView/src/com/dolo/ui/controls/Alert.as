package com.dolo.ui.controls
{
	import com.dolo.ui.events.AlertCloseEvent;
	import com.dolo.ui.managers.UI;
	import com.dolo.ui.tools.Align;
	import com.greensock.TweenLite;
	
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;

	/**
	 * Alert 提示窗口 
	 * @author flashk
	 * 
	 */
	public class Alert extends Window
	{
		public static var textFormat:TextFormat = new TextFormat("Arial",12,0xFFFFFF);
		public static var titleTextformat:TextFormat = new TextFormat("SimSun,Arial,Microsoft Yahei",14,0xFFFFFF,false,null,null,null,null,"center");
		//Alert 默认设置，默认文本的最大宽度 
		public static var maxTextWidth:int = 200;
		public static var maskColor:uint=0x000000;
		public static var maskAlpha:Number = 0.6;
		public static var clickAlphas:Array = [0.8,0.8,0.8,1,1,1,0.8,0.8,0.8,1,1,1,0.8,0.8,0.8,1];
		
		protected var _btns:Array = [];
		protected var _buttonLabels:Array;
		protected var _txt:TextField;
		protected var _needSendEvent:Boolean = true;
		protected var _closeFunction:Function;
		protected var _mask:Sprite;
		protected var _clickAlphaIndex:uint = 0;

		public function Alert()
		{
			titleTextformat.letterSpacing = 0;
			_txt = new TextField();
			_txt.x = 20;
			_txt.width = maxTextWidth;
			_txt.multiline = true;
			_txt.wordWrap = true;
			_txt.defaultTextFormat = textFormat;
			_txt.y = 55;
			_txt.mouseEnabled = false;
			_titleText.defaultTextFormat = titleTextformat;
		}
		
		public function get buttons():Array
		{
			return _btns;
		}
		
		public function get textField():TextField
		{
			return _txt;
		}
		
		/**
		 * 弹出一个提示框，以通知用户或者让用户处理完此消息前不得进行其他操作，如果不希望显示关闭按钮，可以对返回的Alert实例设置showCloseButton属性
		 * @param text 要显示的消息，可以使用flash支持的HTML文本。
		 * @param title 消息窗口的标题
		 * @param closeFunction 监听此窗口关闭的函数，函数应该只有一个参数，类型为AlertCloseEvent，如果不提供此函数，同样可以监听close事件，但close事件没有任何反应用户操作哪个按钮的属性
		 * @param buttonLabels 消息窗口要显示按钮的标签，不限个数，之后你可以通过Alert实例的buttons属性来访问这些按钮，比如添加图标和重新排列等等，如["删除","放弃","重新来过"]
		 * @param isUnableMouse 弹出消息后是否允许用户操作下面的界面。如果为true，可以设置Alert.maskColor和Alert.maskAlpha来更改颜色和透明度
		 * @param icon 消息窗口的小图标
		 * @param alertWidth 指定Alert框的宽度，-1为自动调整大小
		 * @param alertHeight 指定Alert框的高度，-1为自动调整大小
		 * @see cn.flashk.controls.events.AlertCloseEvent
		 */
		public static function show(text:String ,title:String = "消息",closeFunction:Function = null ,buttonLabels:Array = null,
												isUnableMouse:Boolean = true , icon:Object = null , alertWidth:int = 0,alertHeight:int=0):Alert
		{
			var alert:Alert = new Alert();
			alert.init(text,title,closeFunction,buttonLabels,isUnableMouse,icon,alertWidth,alertHeight);
			return alert;
		}
		
		public function init(text:String ,titleStr:String = "消息",closeFunction:Function = null ,buttonLabels:Array = null,
							 		isUnableMouse:Boolean = true , icon:Object = null , alertWidth:int = 0,alertHeight:int=0):void
		{
			_btns = [];
			_buttonLabels = buttonLabels;
			_closeFunction = closeFunction;
			if(_buttonLabels == null){
				_buttonLabels = ["确定"];
			}
			_txt.height = 500;
			_txt.htmlText = text;
			_txt.height = _txt.textHeight +10;
			title = titleStr;
			this.addChild(_txt);
			var aw:int;
			var ah:int;
			if(alertWidth != 0){
				aw = alertWidth;
			}else{
				aw = _txt.width+_txt.x*2;
			}
			if(alertHeight != 0){
				ah = alertHeight;
			}else{
				ah = _txt.y + _txt.height+80;
			}
			setSize(aw,ah);
			var len:int = _buttonLabels.length;
			for(var i:int=0;i<len;i++){
				var btn:Button = Button.creatNewButton(_buttonLabels[i]);
				var stx:int = (aw-btn.width*_buttonLabels.length-(_buttonLabels.length-1)*30)/2;
				btn.x = stx+i*(aw/_buttonLabels.length-30);
				btn.y = ah - 55;
				btn.addEventListener(MouseEvent.CLICK,onBtnClick);
				this.addChild(btn);
				_btns.push(btn);
			}
			if(isUnableMouse == true){
				_mask = new Sprite();
				_mask.graphics.beginFill(maskColor,maskAlpha);
				_mask.graphics.drawRect(0,0,1920*2,1080*2);
				_mask.addEventListener(MouseEvent.CLICK,onMaskClick);
				_mask.alpha = 0;
				TweenLite.to(_mask,0.32,{alpha:1});
				UI.topSprite.addChild(_mask);
			}
			UI.topSprite.addChild(this);
			Align.toCenter(this,false,_compoWidth,_compoHeight);
		}
		
		override public function close(event:Event=null):void
		{
			super.close(event);
			if(_closeFunction != null && _needSendEvent == true){
				_closeFunction(new AlertCloseEvent(AlertCloseEvent.CLOSE,0,"close"));
			}
			if(_mask && _mask.parent){
				_mask.parent.removeChild(_mask);
			}
		}
		
		protected function onMaskClick(event:MouseEvent):void
		{
			_clickAlphaIndex = 0;
			this.addEventListener(Event.ENTER_FRAME,onMaskClickEnterFrame);
		}
		
		protected function onMaskClickEnterFrame(event:Event):void
		{
			if(_clickAlphaIndex >= clickAlphas.length){
				this.removeEventListener(Event.ENTER_FRAME,onMaskClickEnterFrame);
				return;
			}
			this.alpha = clickAlphas[_clickAlphaIndex];
			_clickAlphaIndex++;
		}
		
		protected function onBtnClick(event:MouseEvent):void
		{
			_needSendEvent = false;
			this.close();
			var btn:Button = event.currentTarget as Button;
			var index:int= 0 ;
			for(var i:int=0;i<_btns.length;i++){
				if(btn == _btns[i]){
					index = i;
					break;
				}
			}
			if(_closeFunction != null){
				_closeFunction(new AlertCloseEvent(AlertCloseEvent.CLOSE,index+1,btn.label));
			}
		}
		
	}
}