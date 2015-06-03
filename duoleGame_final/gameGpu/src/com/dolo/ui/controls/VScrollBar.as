package com.dolo.ui.controls
{
	import com.YFFramework.core.center.manager.update.UpdateManager;
	import com.dolo.ui.managers.UI;
	import com.dolo.ui.tools.ColorMatrix;
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.ColorMatrixFilter;
	import flash.geom.Rectangle;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;
	
	/**
	 * 可设定皮肤滚动条
	 * @author flashk
	 * 
	 */
	public class VScrollBar extends UIComponent
	{
		public static var barClickTopEndSpace:int = 35;
		public static var barHeightLess:int = 1;
		
		public var miniScrollerHeight:int = 18;
		
		protected var _arrowClickMove:Number = 48;
		protected var _autoHideScrollbar:Boolean;
		protected var _ui:Sprite;
		protected var _upBtn:SimpleButton;
		protected var _downBtn:SimpleButton;
		protected var _bar:Sprite;
		protected var _scroll:MovieClip;
		protected var _top:int;
		protected var _clipWidth:int;
		protected var _clipHeight:int;
		protected var _clipY:int;
		protected var _clipX:int;
		protected var _size:Number = -1;
		protected var _target:DisplayObject;
		protected var _scHeight:int;
		protected var _needUpdateScrollY:Boolean = true;
		protected var _nowSCY:int;
		protected var _enterFrameMoveMode:int=0;
		protected var _enterFrameID:int;
		protected var _ableScroll:Boolean;
		protected var _barDragMax:int;
		protected var _isUserDraging:Boolean = false;
		protected var _initSca:Number=1;
		protected var _isAutoHide:Boolean = false;
		protected var _isFirstTarget:Boolean = true;
		
		override public function dispose():void
		{
			super.dispose();
			_ui = null;
			_upBtn = null;
			_downBtn = null;
			_bar = null;
			_scroll = null;
			_target = null;
		}
		
		public function VScrollBar(){
			
		}

		public function get size():Number
		{
			return _size;
		}

		public function get isAutoHide():Boolean
		{
			return _isAutoHide;
		}

		public function set isAutoHide(value:Boolean):void
		{
			_isAutoHide = value;
		}

		public function get arrowClickMove():Number
		{
			return _arrowClickMove;
		}

		public function set arrowClickMove(value:Number):void
		{
			_arrowClickMove = value;
		}

		public function get autoHideScrollbar():Boolean
		{
			return _autoHideScrollbar;
		}

		public function set autoHideScrollbar(value:Boolean):void
		{
			_autoHideScrollbar = value;
		}
		
		/**
		 * 
		 * @param target 显示对象或者文本TextField，如果为TextField，则不需要后面的参数
		 * @param enableHandDrag
		 * @param clipWidth
		 * @param clipHeight
		 * @param clipX
		 * @param clipY
		 * mouseWheel 是否响应 mouseWheel事件
		 */
		public function setTarget(target:DisplayObject,enableHandDrag:Boolean=false, clipWidth:Number=0, clipHeight:Number=0,clipX:Number=0,clipY:Number=0):void 
		{
			_clipWidth = int(clipWidth);
			_clipHeight = int(clipHeight);
			_clipY = int(clipY);
			_clipX = int(clipX);
			var nowRectY:int = _clipY;
			if(_isFirstTarget == false){
				if(_target && _target.scrollRect){
					nowRectY = _target.scrollRect.y;
					if(nowRectY > _size-clipHeight){
						nowRectY = _size-clipHeight;
					}
					if(_size-clipHeight < 0) nowRectY = 0;
				}
			}
			_target = target;
			_target.scrollRect = new Rectangle(_clipX,nowRectY,_clipWidth,_clipHeight);
			_target.addEventListener(MouseEvent.MOUSE_WHEEL,onMouseWheel);
			if(_size == -1){
				updateSize(target.height);
			}else{
				updateSize(_size);
			}
			if(target){
				reupdateScrollerPos();
			}
			_isFirstTarget = false;
		}
		
		public function disableScroll():void{
			if(_target.hasEventListener(MouseEvent.MOUSE_WHEEL)){
				_target.removeEventListener(MouseEvent.MOUSE_WHEEL,onMouseWheel);
			}
		}
		
		/**
		 * 设置滚动条更新 
		 * @param newSize 新的内容的高度
		 * 
		 */
		public function updateSize(newSize:Number=0):void
		{
			_size = newSize;
			var scHeight:int =  int( scrollMaxView/(_size/_clipHeight));
			if(scHeight < miniScrollerHeight){
				scHeight = miniScrollerHeight;
			}
			_scroll.height  = scHeight;
			if(_size <= _clipHeight ){
				_scroll.visible = false;
				_ableScroll = false;
				UI.setEnable(_upBtn,false);
				UI.setEnable(_downBtn,false);
				this.visible = !_isAutoHide;
				if(_isAutoHide == true){
					_target.scrollRect = null;
				}else{
					_target.scrollRect = new Rectangle(_clipX,_clipY,_clipWidth,_clipHeight);
				}
			}else{
				this.visible = true;
				_scroll.visible = true;
				_ableScroll = true;
				checkOutRange();
				updateScrollY();
				var rect:Rectangle = _target.scrollRect;
				if(rect){
					_target.scrollRect = new Rectangle(rect.x,rect.y,_clipWidth,_clipHeight);
				}else{
					_target.scrollRect = new Rectangle(0,0,_clipWidth,_clipHeight);
				}
				UI.setEnable(_upBtn,true);
				UI.setEnable(_downBtn,true);
			}
		}
		
		protected function checkOutRange():void
		{
			var rect:Rectangle = _target.scrollRect;
			if(rect == null) return;
			if(rect.y> (_size-_clipHeight)){
				_nowSCY = (_size-_clipHeight);
				_target.scrollRect = new Rectangle(rect.x,_nowSCY,_clipWidth,_clipHeight);
			}
		}
		
		/**
		 * 滚动到百分比的新位置 
		 * @param percent
		 * 
		 */
		public function scrollTo(percent:Number):void
		{
			scrollToPosition((_size-_clipHeight)*percent);
		}
		
		public function scrollToEnd():void
		{
			scrollTo(1);
		}
		
		/**
		 * 滚动到指定新位置 
		 * @param yPositon
		 * 
		 */
		public function scrollToPosition(yPositon:Number):void
		{
			if(_target == null) return;
			var sy:int = int(yPositon);
//			if(sy < 0 ) sy = 0;
			if(_size > 0 && sy > (_size-_clipHeight)) {
				sy = (_size-_clipHeight);
			}
			var percent:Number = sy/(_size-_clipHeight);
			if(_size <= _clipHeight){
				sy = 0;
			}
			_nowSCY = _clipY+sy;
			_target.scrollRect = new Rectangle(_clipX,_nowSCY,_clipWidth,_clipHeight);
			if(_needUpdateScrollY == true){
				_scroll.y = int((_barDragMax-_top*2-_scroll.height)*percent+_top);
			}
			_needUpdateScrollY = true;
		}
		
		/**
		 * 绑定到FlashCS皮肤 
		 * @param skin
		 * 
		 */
		override public function targetSkin(skin:DisplayObject):void
		{
			_compoHeight = skin.height/skin.scaleY;
			var sca:Number = skin.scaleY;
			_ui = skin as Sprite;
			if(_ui == null) return;
			_upBtn = _ui.getChildByName("up_btn")  as SimpleButton;
			_upBtn.useHandCursor = false;
			_upBtn.addEventListener(MouseEvent.CLICK,onUpClick);
			_upBtn.addEventListener(MouseEvent.MOUSE_DOWN,onUpMouseDown);
			_downBtn = _ui.getChildByName("down_btn") as SimpleButton;
			_downBtn.useHandCursor = false;
			_downBtn.addEventListener(MouseEvent.CLICK,onDownClick);
			_downBtn.addEventListener(MouseEvent.MOUSE_DOWN,onDownMouseDown);
			_scroll = _ui.getChildByName("scroll") as MovieClip;
			_scroll.stop();
			_bar = _ui.getChildByName("bar") as Sprite;
			_bar.addEventListener(MouseEvent.MOUSE_DOWN,onBarClick);
			_top = int(_scroll.y);
			_scroll.addEventListener(MouseEvent.MOUSE_DOWN,startDragScroll);
			_scroll.addEventListener(MouseEvent.MOUSE_OVER,onScrollOver);
			_scroll.addEventListener(MouseEvent.MOUSE_DOWN,onScrollDown);
			_scroll.addEventListener(MouseEvent.MOUSE_OUT,onScrollOut);
			_scroll.filters = [ new ColorMatrixFilter(new ColorMatrix()) ];
			_scroll.visible = false;
			var len:int = _scroll.numChildren;
			for(var i:int=0;i<len;i++){
				var btn:SimpleButton = _scroll.getChildAt(i) as SimpleButton;
				if(btn){
					btn.useHandCursor = false;
				}
			}
			_ui.scaleY = 1;
			_compoHeight = _ui.height;
			resetXY(_ui);
			this.addChild(_ui);
			_ui.addEventListener(MouseEvent.MOUSE_WHEEL,onMouseWheel);
		}
		
		override public function setSize(newWidht:Number, newHeight:Number):void
		{
			var sca:Number = newHeight/_compoHeight;
			super.setSize(newWidht,newHeight);
			_initSca *= sca;
			_downBtn.y = _downBtn.y*sca;
			_bar.scaleY *= sca;
			_barDragMax = int(_bar.height)-barHeightLess;
			if(_scroll.y>maxScrollerPosY){
				_scroll.y = maxScrollerPosY;
			}
			if(_target){
				updateSize(_size);
			}
		}
		
		protected function get scrollMaxView():int
		{
			return _barDragMax-_top*2;
		}
		
		protected function onMouseWheel(event:MouseEvent):void
		{
			addScroll(_arrowClickMove*-event.delta/3);
		}
		
		protected function onUpMouseDown(event:MouseEvent):void
		{
			if(_ableScroll == false) return;
			_enterFrameID = setTimeout(startUpEnterFrame,300);
		}
		
		protected function onDownMouseDown(event:MouseEvent):void
		{
			if(_ableScroll == false) return;
			_enterFrameID = setTimeout(startDownEnterFrame,300);
		}
		
		protected function startDownEnterFrame():void
		{
			_enterFrameMoveMode = 1;
//			UI.stage.addEventListener(Event.ENTER_FRAME,onEnterFrameMove);
			UpdateManager.Instance.framePer.regFunc(onEnterFrameMove);
			UI.stage.addEventListener(MouseEvent.MOUSE_UP,stopEnterFrameMove);
		}
		
		protected function startUpEnterFrame():void
		{
			_enterFrameMoveMode = 2;
			_scroll.cacheAsBitmap = true;
//			UI.stage.addEventListener(Event.ENTER_FRAME,onEnterFrameMove);
			UpdateManager.Instance.framePer.regFunc(onEnterFrameMove);
			UI.stage.addEventListener(MouseEvent.MOUSE_UP,stopEnterFrameMove);
		}
		
		protected function stopEnterFrameMove(event:MouseEvent):void
		{
			setTimeout(resetModeLater,100);
			_scroll.cacheAsBitmap = false;
//			UI.stage.removeEventListener(Event.ENTER_FRAME,onEnterFrameMove);
			UpdateManager.Instance.framePer.delFunc(onEnterFrameMove);
			UI.stage.removeEventListener(MouseEvent.MOUSE_UP,stopEnterFrameMove);
		}
		
		protected function resetModeLater():void
		{
			_enterFrameMoveMode = 0;
		}
		
		protected function onEnterFrameMove(event:Event=null):void
		{
			if(_enterFrameMoveMode == 1){
				addScroll(_arrowClickMove/8);
			}
			if(_enterFrameMoveMode == 2){
				addScroll(-_arrowClickMove/8);
			}
		}
		
		protected function addScroll(addValue:Number):void
		{
			if(_size <= _clipHeight) return;
			addValue = int(addValue);
			_nowSCY += addValue;
			if(_nowSCY > _size-_clipHeight){
				_nowSCY = _size - _clipHeight;
			}
			if(_nowSCY < _clipY ){
				_nowSCY = _clipY;
			}
			_target.scrollRect = new Rectangle(_clipX,_nowSCY,_clipWidth,_clipHeight);
			updateScrollY();
		}
		
		protected function onDownClick(event:MouseEvent):void
		{
			if(_ableScroll == false) return;
			clearTimeout(_enterFrameID);
			if(_enterFrameMoveMode != 0) return;
			addScroll(_arrowClickMove);
		}
		
		protected function onUpClick(event:MouseEvent):void
		{
			if(_ableScroll == false) return;
			clearTimeout(_enterFrameID);
			if(_enterFrameMoveMode != 0) return;
			addScroll(-_arrowClickMove);
		}
		
		protected function updateScrollY():void
		{
			var per:Number = _nowSCY/(_size-_clipHeight);
			_scroll.y = Math.round((_barDragMax-_top*2-scrollHeight)*per+_top);
		}
		
		private function reupdateScrollerPos():void
		{
			if(_target && _target.scrollRect){
				var per:Number = _target.scrollRect.y/(_size-_clipHeight);
				_scroll.y = Math.round((_barDragMax-_top*2-scrollHeight)*per+_top);
				if(_scroll.y>maxScrollerPosY){
					_scroll.y = maxScrollerPosY;
				}
			}
		}
		
		protected function onBarClick(event:MouseEvent):void
		{
			if(_ableScroll == false) return;
			var per:Number = (_bar.mouseY*_initSca-barClickTopEndSpace)/(_barDragMax-barClickTopEndSpace*2);
			if(per < 0 ) per = 0;
			if(per > 1 ) per = 1;
			scrollTo(per);
		}
		
		protected function onScrollOut(event:MouseEvent=null):void
		{
			if(_isUserDraging == true) return;
			_scroll.gotoAndStop(1);
		}
		
		protected function onScrollDown(event:MouseEvent):void
		{
			_scroll.gotoAndStop(3);
		}
		
		protected function onScrollOver(event:MouseEvent):void
		{
			if(_isUserDraging == true) return;
			_scroll.gotoAndStop(2);
		}
		
		protected function get scrollHeight():int
		{
			return _scroll.height;
		}
		
		private function get maxScrollerPosY():Number
		{
			return _barDragMax-_top*2-scrollHeight;
		}
		
		protected function startDragScroll(event:MouseEvent):void
		{
			_scroll.startDrag(false,new Rectangle(_scroll.x,_top,0,_barDragMax-_top*2-scrollHeight));
			UI.stage.addEventListener(MouseEvent.MOUSE_MOVE,updateScroll);
			UI.stage.addEventListener(MouseEvent.MOUSE_UP,onStopScroll);
			_isUserDraging = true;
			UI.stage.mouseChildren = false;
		}
		
		protected function onStopScroll(event:MouseEvent):void
		{
			_scroll.stopDrag();
			UI.stage.removeEventListener(MouseEvent.MOUSE_MOVE,updateScroll);
			UI.stage.removeEventListener(MouseEvent.MOUSE_UP,onStopScroll);
			_isUserDraging = false;
			UI.stage.mouseChildren = true;
			onScrollOut();
			updateScroll();
		}
		
		protected function updateScroll(event:MouseEvent=null):void
		{
			var per:Number = (_scroll.y-_top)/(_barDragMax-_top*2-scrollHeight);
			_needUpdateScrollY = false;
			scrollTo(per);
			if(event){
				event.updateAfterEvent();
			}
		}
		
	}
}