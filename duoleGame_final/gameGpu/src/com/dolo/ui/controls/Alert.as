package com.dolo.ui.controls
{
	import com.YFFramework.core.center.manager.update.UpdateManager;
	import com.YFFramework.core.text.HTMLUtil;
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
	import flash.text.TextFormatAlign;

	/**
	 * Alert 提示窗口 
	 * @author flashk
	 * 
	 */
	public class Alert extends Window
	{
		public static var textFormat:TextFormat = new TextFormat("_sans",13,0xFFFFFF,null,null,null,null,null,TextFormatAlign.CENTER);
		public static var titleTextformat:TextFormat = new TextFormat("SimSun,Arial,Microsoft Yahei",14,0xFFFFFF,false,null,null,null,null,"center");
		/**
		 * Alert 默认设置，默认文本的最大宽度  
		 */
		public static var MAX_TXT_WIDTH:int = 400;
		/**
		 * Alert 默认设置，默认文本的最小宽度  
		 */
		public static var MIN_TXT_WIDTH:int = 190;
		/**
		 * 蒙板的颜色 
		 */
		public static var maskColor:uint=0x000000;
		/**
		 * 蒙板的透明度
		 */
		public static var maskAlpha:Number = 0.5;
		public static var clickAlphas:Array = [0.75,0.75,0.75,1,1,1,0.75,0.75,0.75,1,1,1,0.75,0.75,0.75,1];
		
		protected var _btns:Array = [];
		protected var _buttonLabels:Array;
		protected var _txt:TextField;
		protected var _needSendEvent:Boolean = true;
		protected var _closeFunction:Function;
		protected var _mask:Sprite;
		protected var _clickAlphaIndex:uint = 0;
		protected var _eventData:*;
		
		protected var _titleText:TextField;

		override public function dispose():void
		{
			super.dispose();
			_btns = null;
			_buttonLabels = null;
			_closeFunction = null;
			_mask = null;
			_eventData = null;
			_titleText = null;
		}
		
		public function Alert()
		{
			super(MinWindowBg);
			dragAlpha = 1.0;
			titleTextformat.letterSpacing = 0;
			_txt = new TextField ();
			_txt.width = MAX_TXT_WIDTH;
			_txt.multiline = true;
			_txt.wordWrap = true;
			_txt.defaultTextFormat = textFormat;
			_txt.mouseEnabled = false;
//			_txt.border=true;//调试定位用
//			_txt.borderColor=0xff0000;
			_titleText = new TextField();
			_titleText.defaultTextFormat = titleTextformat;
			_titleText.mouseEnabled = false;
			_titleText.defaultTextFormat = titleTextformat;
			this.addChild(_titleText);
		}
		
		public function get eventData():*
		{
			return _eventData;
		}
		
		public function set eventData( value:* ):void
		{
			_eventData = value;
		}
		
		/**
		 * 
		 * @return 返回各个按钮的实例
		 * 
		 */
		public function get buttons():Array
		{
			return _btns;
		}
		
		/**
		 * 返回文本的实例
		 * @return 
		 * 
		 */
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
		 * @param data 需要传递给AlertCloseEvent.data的数据
		 * @param icon 消息窗口的小图标
		 * @param alertWidth 指定Alert框的宽度，-1为自动调整大小
		 * @param alertHeight 指定Alert框的高度，-1为自动调整大小
		 * @see cn.flashk.controls.events.AlertCloseEvent
		 */
		public static function show(text:String ,title:String = "提示",closeFunction:Function = null ,buttonLabels:Array = null,
												isUnableMouse:Boolean = true ,data:*=null, icon:Object = null , alertWidth:int = 0,alertHeight:int=0):Alert
		{
			var alert:Alert = new Alert();
			alert.eventData = data;
			alert.init( text, title, closeFunction, buttonLabels, isUnableMouse, icon, alertWidth, alertHeight );
			alert._closeButton.visible=false;
			return alert;
		}
		
		public function init(text:String ,titleStr:String = "消息",closeFunction:Function = null ,buttonLabels:Array = null,
							 		isUnableMouse:Boolean = true , icon:Object = null , alertWidth:int = 0,alertHeight:int=0):void
		{
			_btns = [];
			_buttonLabels = buttonLabels;
			_closeFunction = closeFunction;
			if( _buttonLabels == null ){
				_buttonLabels = [ "确定" ];
			}
			if(titleStr!="消息"){
				_txt.htmlText = HTMLUtil.createHtmlText(titleStr,14,"FF0000")+"\n\n"+text;
			}else{
				_txt.htmlText = text;
			}
			
			this.addChild( _txt );
			
			_txt.width = _txt.textWidth;
			if( _txt.width < MIN_TXT_WIDTH ){
				_txt.width = MIN_TXT_WIDTH;
			}
			else if(_txt.width > MAX_TXT_WIDTH)
				_txt.width = MAX_TXT_WIDTH;
			_txt.height = _txt.textHeight +10;
			//title = titleStr;
			
			var aw:int;
			var ah:int;
			if( alertWidth != 0 ){
				aw = alertWidth;
				_txt.x=(aw-_txt.width)*0.5;
			}else{
				_txt.x = 40;
				aw = _txt.width+_txt.x*2;
			}
			
			_txt.y = 40;
			if( alertHeight != 0 ){
				ah = alertHeight;
			}else{
				ah = _txt.y + _txt.height+80;
			}
			setSize( aw, ah );
			
			var len:int = _buttonLabels.length;
			var btnGap:int;
			for( var i:int=0; i<len; i++ ){
				var btn:Button = Button.creatNewButton( _buttonLabels[i] );
				btnGap = (_txt.width - btn.width*len)/(len+1);
				btn.x = _txt.x + btnGap*(i+1) + btn.width*i;
				btn.y = ah - 65;
				btn.addEventListener( MouseEvent.CLICK, onBtnClick );
				this.addChild( btn );
				_btns.push( btn );
			}
			
			if( isUnableMouse == true ){
				_mask = new Sprite();
				_mask.graphics.beginFill( maskColor, maskAlpha );
				_mask.graphics.drawRect( 0, 0, 1920*2, 1080*2 );
				_mask.graphics.endFill();
				_mask.addEventListener( MouseEvent.CLICK, onMaskClick );
				_mask.alpha = 0;
				TweenLite.to( _mask, 0.32, { alpha: 1 } );
				UI.topSprite.addChild( _mask );
			}
			UI.topSprite.addChild(this);
			Align.toCenter(this,false,_compoWidth,_compoHeight);
		}
		
		override protected function resetTitleBgLinkage():void{
			
		}
		
		override public function close(event:Event=null):void
		{
//			super.close( event );
			removeMeLater();
			if( _closeFunction != null && _needSendEvent == true ){
				_closeFunction( new AlertCloseEvent( AlertCloseEvent.CLOSE, 0, "close" ) );
			}
			if( _mask && _mask.parent ){
				_mask.parent.removeChild( _mask );
			}
		}
		
		protected function onMaskClick(event:MouseEvent):void
		{
			_clickAlphaIndex = 0;
			UpdateManager.Instance.framePer.regFunc(onMaskClickEnterFrame);
		}
		
		protected function onMaskClickEnterFrame(event:Event=null):void
		{
			if( _clickAlphaIndex >= clickAlphas.length ){
				UpdateManager.Instance.framePer.delFunc(onMaskClickEnterFrame);
				return;
			}
			this.alpha = clickAlphas[ _clickAlphaIndex ];
			_clickAlphaIndex ++;
		}
		
		protected function onBtnClick(event:MouseEvent):void
		{
			_needSendEvent = false;
			this.close (event);
			var btn:Button = event.currentTarget as Button;
			var index:int= 0 ;
			for( var i:int=0; i<_btns.length; i++ ){
				if( btn == _btns [ i ] ){
					index = i;
					break;
				}
			}
			if( _closeFunction != null ){
				var ae:AlertCloseEvent = new AlertCloseEvent( AlertCloseEvent.CLOSE, index+1, btn.label );
				ae.data = _eventData;
				_closeFunction ( ae );
			}
		}
		
	}
}