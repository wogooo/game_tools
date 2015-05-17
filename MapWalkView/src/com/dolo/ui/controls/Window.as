package com.dolo.ui.controls
{
	import com.dolo.ui.events.UIEvent;
	import com.dolo.ui.managers.UI;
	import com.dolo.ui.managers.UIManager;
	import com.dolo.ui.sets.Linkage;
	import com.dolo.ui.tools.AutoBuild;
	import com.dolo.ui.tools.LibraryCreat;
	import com.dolo.ui.tools.Xtip;
	import com.greensock.TweenLite;
	import com.greensock.easing.Cubic;
	
	import flash.display.DisplayObject;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFormat;

	/**
	 * 游戏基础窗口 
	 * @author Administrator
	 * 
	 */
	public class Window extends UIComponent
	{
		public static var titleTextformat:TextFormat = new TextFormat("SimSun,Arial,Microsoft Yahei",14,0xFFFFFF,false,null,null,null,null,"center");
		public static var contentX:int = 8;
		public static var contentY:int = 42;
		public static var titleHeight:int = 45;
		public static var dragMax:int = 38;
		public static var closeX:int = 42;
		public static var closeY:int = 8;
		
		protected var _content:DisplayObject;
		protected var _titleText:TextField;
		protected var _background:Sprite;
		protected var _dragArea:Sprite;
		protected var _middleUI:Sprite;
		protected var _closeButton:SimpleButton;
		protected var _lastW:int;
		protected var _lastH:int;
		
		public function Window()
		{
			super();
			_dragArea = new Sprite();
			_dragArea.graphics.beginFill(0,0);
			_dragArea.graphics.drawRect(0,0,100,titleHeight);
			_dragArea.addEventListener(MouseEvent.MOUSE_DOWN,onDragMouseDown);
			_titleText = new TextField();
			_titleText.defaultTextFormat = titleTextformat;
			_titleText.mouseEnabled = false;
			_titleText.y = 15;
			_background = LibraryCreat.getSprite(Linkage.windowBackground);
			_middleUI = LibraryCreat.getSprite(Linkage.windowMiddle);
			_closeButton = LibraryCreat.getDisplay(Linkage.windowCloseButton) as SimpleButton;
			_closeButton.addEventListener(MouseEvent.CLICK,close);
			_closeButton.useHandCursor = false;
			Xtip.registerTip(_closeButton,"关闭窗口");
			this.addChildAt(_background,0);
			this.addChild(_middleUI);
			this.addChild(_dragArea);
			this.addChild(_titleText);
			this.addChild(_closeButton);
			this.addEventListener(Event.ADDED_TO_STAGE,onAddToStage);
			this.addEventListener(Event.REMOVED_FROM_STAGE,onRemoveFromStage);
			this.addEventListener(MouseEvent.MOUSE_DOWN,setToTop);
		}
		
		/**
		 * 直接使用参数初始化窗口 
		 * 
		 * @param windowWidth 窗口宽度
		 * @param windowHeight 窗口高度
		 * @param contentLinkName 窗口内容在CS库里的链接名
		 * @param titleString 窗口标题
		 * @param isAutoBuildContent 是否在窗口初始化完成后对窗口内容使用自动UI构建
		 * @return 
		 * 
		 */
		public function initByArgument(windowWidth:int,windowHeight:int,contentLinkName:String,
									   titleString:String="",isAutoBuildContent:Boolean=true):Sprite
		{
			var tmpUI:Sprite = LibraryCreat.getSprite(contentLinkName);
			content = tmpUI;
			setSize( windowWidth,windowHeight);
			title = titleString;
			if(isAutoBuildContent==true){
				AutoBuild.replaceAll(tmpUI);
			}
			return tmpUI;
		}

		/**
		 * 返回关闭按钮的实例 
		 * @return 
		 * 
		 */
		public function get closeButton():SimpleButton
		{
			return _closeButton;
		}
		
		/**
		 * 将窗口切换到最顶层 
		 * 
		 */
		public function switchToTop():void
		{
			if(this.parent){
				this.parent.setChildIndex(this,this.parent.numChildren-1);
			}
		}

		public function setToTop(event:MouseEvent=null):void
		{
			if(_closeButton){
				if(_closeButton.mouseX > 0 && _closeButton.mouseX < _closeButton.width 
					&& _closeButton.mouseY > 0 && _closeButton.mouseY <_closeButton.height) return;
			}
			switchToTop();
		}
		
		/**
		 * 切换窗口的打开关闭 
		 * 
		 */
		public function switchOpenClose():void
		{
			if(isOpen == true){
				close();
			}else{
				open();
			}
		}
		
		protected function onAddToStage(event:Event):void
		{
			UI.stage.addEventListener(Event.RESIZE,onStageResize);
			_background.cacheAsBitmap = true;
			checkOutside();
		}
		
		protected function onRemoveFromStage(event:Event):void
		{
			_background.cacheAsBitmap = false;
			UI.stage.removeEventListener(Event.RESIZE,onStageResize);
		}
		
		protected function onStageResize(event:Event):void
		{
			this.x = int(UI.stage.stageWidth/_lastW*this.x);
			this.y = int(UI.stage.stageHeight/_lastH*this.y);
			checkOutside();
		}
		
		protected function checkOutside():void
		{
			_lastW = UI.stage.stageWidth;
			_lastH = UI.stage.stageHeight;
			if(this.x > UI.stage.stageWidth - dragMax) {
				this.x = UI.stage.stageWidth - dragMax;
			}
			if(this.x < -_compoWidth + dragMax) {
				this.x = -_compoWidth + dragMax;
			}
			if(this.y > UI.stage.stageHeight - dragMax) {
				this.y = UI.stage.stageHeight - dragMax;
			}
			if(this.y < 0) {
				this.y = 0;
			}
		}
		
		public function update():void
		{
			
		}
		
		public function get content():DisplayObject
		{
			return _content;
		}
		
		/**
		 * 设置窗口显示内容 
		 * @param dis
		 * 
		 */
		public function set content(dis:DisplayObject):void
		{
			_content = dis;
			_content.x = contentX;
			_content.y = contentY;
			this.addChild(_content);
		}
		
		/**
		 * 设置窗口标题 
		 * @param value
		 * 
		 */
		public function set title(value:String):void
		{
			_titleText.htmlText = value;
		}
		
		/**
		 * 打开窗口 
		 * 
		 */
		public function open():void
		{
			UIManager.popWindow(this);
			this.alpha = 0;
			TweenLite.to(this,0.25,{alpha:1.0,ease:Cubic.easeOut});
		}
		
		/**
		 * 关闭窗口，如果需要在关闭窗口时执行其它操作，子类覆盖此方法 
		 * @param event
		 * 
		 */
		public function close(event:Event=null):void
		{
			TweenLite.to(this,0.15,{alpha:0,ease:Cubic.easeOut,onComplete:removeMe});
		}
		
		protected function removeMe():void
		{
			if(this.parent) {
				this.parent.removeChild(this);
				this.alpha = 1;
			}
		}
		
		/**
		 * 判断窗口当前是否已经打开 
		 * @return 
		 * 
		 */
		public function get isOpen():Boolean
		{
			if(this.parent) return true;
			return false;
		}
		
		override public function setSize(newWidht:Number, newHeight:Number):void
		{
			super.setSize(newWidht,newHeight);
			_background.width = _compoWidth;
			_background.height = _compoHeight;
			_dragArea.width = _compoWidth-40;
			_middleUI.x = int(_compoWidth/2);
			_titleText.width = _compoWidth-50*2;
			_titleText.x = 50;
			_closeButton.x = _compoWidth - closeX;
			_closeButton.y = closeY;
		}
		
		protected function onDragMouseDown(event:MouseEvent):void
		{
			this.startDrag(false,new Rectangle(-_compoWidth-dragMax,0,UI.stage.stageWidth+_compoWidth,UI.stage.stageHeight-dragMax));
			UI.stage.addEventListener(MouseEvent.MOUSE_UP,onStageMouseUp);
			startDragWindow(event);
		}
		
		protected function onStageMouseUp(event:MouseEvent):void
		{
			this.stopDrag();
			stopDragWindow(event);
		}
		
		/**
		 * 如果需要在用户按下鼠标拖动时处理，覆盖此方法 
		 * @param event
		 * 
		 */
		protected function startDragWindow(event:MouseEvent):void
		{
			this.dispatchEvent(new UIEvent(UIEvent.USER_DRAG_WINDOWN_START));
		}
		
		/**
		 * 如果需要在用户弹起鼠标停止拖动时处理，覆盖此方法 
		 * @param event
		 * 
		 */
		protected function stopDragWindow(event:MouseEvent):void
		{
			this.dispatchEvent(new UIEvent(UIEvent.USER_DRAG_WINDOWN_STOP));
		}
			
	}
}