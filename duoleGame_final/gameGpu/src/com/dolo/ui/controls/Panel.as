package com.dolo.ui.controls
{
	import com.YFFramework.core.proxy.StageProxy;
	import com.dolo.ui.events.UIEvent;
	import com.dolo.ui.managers.UI;
	import com.dolo.ui.managers.UIManager;
	import com.dolo.ui.sets.Linkage;
	import com.dolo.ui.tools.LibraryCreat;
	import com.dolo.ui.tools.Xtip;
	import com.greensock.TweenLite;
	import com.greensock.easing.Cubic;
	
	import flash.display.DisplayObject;
	import flash.display.InteractiveObject;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;

	/**
	 * 基础面板 
	 * @author flashk
	 * 
	 */
	public class Panel extends UIComponent
	{
		public static var isDragCatchAsBitmap:Boolean = false;
		public static var dragMouseAble:Boolean = true;
		public static var isDragUpdateMost:Boolean = false;
		public static var dragFramRate:int = 5;
		public static var resetFPSTimeOutLaterMS:int = 100;
		public static var isResetRate:Boolean = false;
		public static var dragMax:int = 50;
		public static var dragMaxheight:int = 37;
		
		public var dragAlpha:Number = 0.35;
		
		protected var _isCloseing:Boolean = true;
//		protected var _isOpen:Boolean=false;
		private var _content:DisplayObject;
		protected var _dragArea:Sprite;
		protected var _dragStartXY:Array = [];
		protected var _bakStageRate:int;
		protected var _timeOutID:int;
		protected var _lastW:int;
		protected var _lastH:int;
		protected var _closeButton:SimpleButton;
		protected var _closeButtonLinkage:String;
		protected var _closeButtonX:int;
		protected var _closeButtonY:int;
		protected var _isResizeResetXY:Boolean = true;
		protected var _closeTweenTime:Number = 0.15;
		
		public function Panel()
		{
			resetCloseLinkage();
			_dragArea = new Sprite();
			_dragArea.addEventListener(MouseEvent.MOUSE_DOWN,onDragMouseDown);
			if(_closeButtonLinkage!=null){
				_closeButton = LibraryCreat.getDisplay(_closeButtonLinkage) as SimpleButton;
				_closeButton.addEventListener(MouseEvent.CLICK,close);
				_closeButton.useHandCursor = false;
				_closeButton.x = _closeButtonX;
				_closeButton.y = _closeButtonY;
				Xtip.registerTip(_closeButton,"关闭");
			}
			this.addChild(_dragArea);
			if(_closeButton!=null)	this.addChild(_closeButton);
			this.addEventListener(Event.ADDED_TO_STAGE,onAddToStage);
//			this.addEventListener(Event.REMOVED_FROM_STAGE,onRemoveFromStage);
			this.addEventListener(MouseEvent.MOUSE_DOWN,setToTop);
			this.mouseEnabled = true;
			UI.stage.addEventListener(Event.RESIZE,onStageResize);
		}

		public function get closeTweenTime():Number
		{
			return _closeTweenTime;
		}

		public function set closeTweenTime(value:Number):void
		{
			_closeTweenTime = value;
		}

		/**
		 * 面板是否在窗口更改大小时自动重新定位 
		 */
		public function get isResizeResetXY():Boolean
		{
			return _isResizeResetXY;
		}

		/**
		 * @private
		 */
		public function set isResizeResetXY(value:Boolean):void
		{
			_isResizeResetXY = value;
		}

		/**
		 * 重设关闭按钮的库链接名，它应该是一个 SimpleButton 的链接名，如果不同Panel需要使用不同的关闭按钮和位置，子类覆盖此方法
		 * 
		 */
		protected function resetCloseLinkage():void
		{
			_closeButtonLinkage = Linkage.windowCloseButton;
//			_closeButtonX = 100;
//			_closeButtonY = 2;
		}
		/**进行拖拽
		 */		
		public function setDragTarget(targetObject:InteractiveObject):void
		{
			targetObject.addEventListener(MouseEvent.MOUSE_DOWN,onDragMouseDown);
		}
		/**移除拖拽
		 */		
		public function removeDragTarget(targetObject:InteractiveObject):void
		{
			targetObject.removeEventListener(MouseEvent.MOUSE_DOWN,onDragMouseDown);
		}

		
		override public function dispose():void
		{
			super.dispose();
			if(_dragArea)
				_dragArea.removeEventListener(MouseEvent.MOUSE_DOWN,onDragMouseDown);
			if(_closeButton)
				_closeButton.removeEventListener(MouseEvent.CLICK,close);
			removePanelEvents();
//			onRemoveFromStage();
			_dragStartXY=null;
			_closeButton=null;
			_content = null;
			_closeButton = null;
			_closeButtonLinkage = null;
			_dragArea = null;
		}
		
		public function get isCloseing():Boolean
		{
			return _isCloseing;
		}
		
		/**
		 * 设置窗口显示内容 
		 * @param dis
		 * 
		 */
		public function set content(dis:DisplayObject):void
		{
			_content = dis;
			if(dis == null) return;
			this.addChild(_content);
			if(_dragArea){
				this.addChild(_dragArea);
			}
			if(_closeButton){
				this.addChild(_closeButton);
			}
		}
		
		public function get content():DisplayObject
		{
			return _content;
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
		
		
		public var isOpenUseTween:Boolean=true;
		
		/**
		 * 打开窗口 
		 * 
		 */
		public function open():void
		{
			if(this.parent != null) return;
			_isCloseing = false;
//			_isOpen=true;
			this.scaleX = this.scaleY = 1;
			this.visible = true;
			this.mouseChildren = true;
			this.mouseEnabled = true;
			UIManager.popUpWindowToCenter(this);
			if(isOpenUseTween == true){
				this.alpha = 0;
				TweenLite.to(this,0.25,{alpha:1.0,ease:Cubic.easeOut});
			}else{
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
		
		/**
		 * 关闭窗口，如果需要在关闭窗口时执行其它操作，子类覆盖此方法 
		 * @param event
		 * 
		 */
		public function close(event:Event=null):void
		{
			if(_isCloseing == true) return;
			_isCloseing = true;
//			_isOpen = false;
			this.mouseChildren = false;
			this.mouseEnabled = false;
			if(_closeTweenTime >0){
				TweenLite.to(this,_closeTweenTime,{alpha:0,ease:Cubic.easeOut,onComplete:removeMe});
			}else{
				this.alpha = 0;
				removeMe();
			}
			StageProxy.Instance.setNoneFocus();
		}
		/**窗口是否已经关闭
		 */
//		public function  get hasClose():Boolean
//		{
//			return _hasClose
//		}
		public function closeWithoutTween():void
		{
			if(this.parent) {
				this.parent.removeChild(this);
			}
		}
		
		/**
		 * 关闭Tween到某个位置 
		 * @param toX 目标x位置
		 * @param toY 目标x位置
		 * @param toScaleX 目标x缩放
		 * @param toScaleY 目标x缩放
		 * @param alphaNum 目标alpha
		 * 
		 */
		public function closeTo(toX:int,toY:int,toScaleX:Number=0.02,toScaleY:Number=0.02,alphaNum:Number=0.1,second:Number = 0.45):void
		{
			if(_isCloseing == true) return;
			_isCloseing = true;
			this.mouseChildren = false;
			this.mouseEnabled = false;
			TweenLite.to(this,second,{onComplete:removeMe,ease:Cubic.easeOut,x:toX,y:toY,scaleX:toScaleX,scaleY:toScaleY,alpha:alphaNum});
			StageProxy.Instance.setNoneFocus();
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
		
		protected function removeMe():void
		{
			_isCloseing = false;
			this.y += 500;
			this.visible = false;
			setTimeout(removeMeLater,100);
		}
		
		protected function removeMeLater():void
		{
			this.visible = true;
			this.alpha = 1;
			if(this.parent) {
				this.parent.removeChild(this);
			}
		}
		
		protected function onDragMouseDown(event:MouseEvent=null):void
		{
			//			this.startDrag(false,new Rectangle(-_compoWidth-dragMax,0,UI.stage.stageWidth+_compoWidth,UI.stage.stageHeight-dragMax));
			_dragStartXY = [ this.mouseX,this.mouseY];
			UI.stage.addEventListener(MouseEvent.MOUSE_UP,onStageMouseUp);
			UI.stage.addEventListener(MouseEvent.MOUSE_MOVE,onStageMouseMove);
			if(isDragCatchAsBitmap == true){
				this.cacheAsBitmap = true;
			}
			TweenLite.to(this,0.26,{alpha:dragAlpha});
			_bakStageRate = UI.stage.frameRate;
			UI.stage.mouseChildren = dragMouseAble;
			startDragWindow(event);
		}
		
		protected function onStageMouseUp(event:MouseEvent):void
		{
			UI.stage.removeEventListener(MouseEvent.MOUSE_UP,onStageMouseUp);
			UI.stage.removeEventListener(MouseEvent.MOUSE_MOVE,onStageMouseMove);
			if(isResetRate){
				UI.stage.frameRate = _bakStageRate;
			}
			if(isDragCatchAsBitmap == true){
				this.cacheAsBitmap = false;
			}
			TweenLite.to(this,0.21,{alpha:1.0});
			UI.stage.mouseChildren = true;
			//			this.stopDrag();
			stopDragWindow(event);
		}
		
		protected function onStageMouseMove(event:MouseEvent):void
		{
			if(isResetRate){
				UI.stage.frameRate = dragFramRate;
				clearTimeout(_timeOutID);
				_timeOutID = setTimeout(resetFPS,resetFPSTimeOutLaterMS);
			}
			this.x = UI.stage.mouseX - _dragStartXY[0];
			this.y = UI.stage.mouseY - _dragStartXY[1];
			checkOutside();
			if(isDragUpdateMost){
				event.updateAfterEvent();
			}
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
		
		protected function resetFPS():void
		{
			if(isResetRate){
				UI.stage.frameRate = _bakStageRate;
			}
		}
		
		protected function onAddToStage(event:Event):void
		{
	//		UI.stage.addEventListener(Event.RESIZE,onStageResize);
			checkOutside();
		}
		
		protected function onRemoveFromStage(event:Event=null):void
		{
	//		UI.stage.removeEventListener(Event.RESIZE,onStageResize);
		}
		
		protected function onStageResize(event:Event):void
		{
			if(_isResizeResetXY == false) return;
			var midx:int = int(this.x+_compoWidth/2);
			var midy:int = int(this.y + _compoHeight/2);
			this.x = int(UI.stage.stageWidth/_lastW*midx-_compoWidth/2);
			this.y = int(UI.stage.stageHeight/_lastH*midy-_compoHeight/2);
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
			if(this.y > UI.stage.stageHeight - dragMaxheight) {
				this.y = UI.stage.stageHeight - dragMaxheight;
			}
			if(this.y < 0) {
				this.y = 0;
			}
		}
		
		protected function removePanelEvents():void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE,onAddToStage);
			this.removeEventListener(Event.REMOVED_FROM_STAGE,onRemoveFromStage);
			this.removeEventListener(MouseEvent.MOUSE_DOWN,setToTop);
			UI.stage.removeEventListener(Event.RESIZE,onStageResize);
		}
		/**获取新手引导数据
		 */		
		public function getNewGuideVo():*
		{
			return null;
		}

		
	}
}