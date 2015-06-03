package com.dolo.ui.controls
{
	import com.YFFramework.game.core.module.bag.event.BagEvent;
	import com.dolo.ui.managers.BitmapDataCatch;
	import com.dolo.ui.managers.UI;
	import com.dolo.ui.skin.ButtonSkin;
	import com.dolo.ui.skin.Skin;
	import com.dolo.ui.tools.Scale9GridBitmap;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.InteractiveObject;
	import flash.events.Event;
	import flash.events.MouseEvent;

	/**
	 * @version 1.0.0
	 * creation time：2013-7-27 下午4:53:28
	 */
	public class BitmapControl extends UIComponent{
		
		protected var _bp:Scale9GridBitmap;
		protected var _buSkin:ButtonSkin;
		protected var _skinBDs:Vector.<BitmapData> = new Vector.<BitmapData>();
		protected var _isOver:Boolean = false;
		protected var _isDown:Boolean = false;
		protected var _isSelect:Boolean =false;
		protected var _offsetX:Number=0;
		protected var _offsetY:Number=0;
		protected var _showSelect:Boolean;
		protected var _index:int;
		
		public function BitmapControl(skin:ButtonSkin, index:int=0, showSelect:Boolean=true){
			_bp = new Scale9GridBitmap();
			this.addChild(_bp);
			
			_showSelect = showSelect;
			_index = index;
			
			this.addEventListener(MouseEvent.ROLL_OVER,onMouseRollOver);
			this.addEventListener(MouseEvent.ROLL_OUT,onMouseRollOut);
			this.addEventListener(MouseEvent.MOUSE_DOWN,onMouseDown);
			if(_showSelect)	this.addEventListener(MouseEvent.MOUSE_UP,onMouseUp);
			
			changeSkin(skin);
		}
		
		public function removeAllEffect():void{
			this.removeEventListener(MouseEvent.ROLL_OVER,onMouseRollOver);
			this.removeEventListener(MouseEvent.ROLL_OUT,onMouseRollOut);
			this.removeEventListener(MouseEvent.MOUSE_DOWN,onMouseDown);
			if(_showSelect)	this.removeEventListener(MouseEvent.MOUSE_UP,onMouseUp);
		}
		
		/**更换新皮肤 
		 * @param skin
		 */
		public function changeSkin(skin:ButtonSkin):void{
			_buSkin = skin;
			_skinBDs[0] = BitmapDataCatch.getBD(_buSkin.up);
			_skinBDs[1] = BitmapDataCatch.getBD(_buSkin.over);
			_skinBDs[2] = BitmapDataCatch.getBD(_buSkin.down);
			_skinBDs[3] = BitmapDataCatch.getBD(_buSkin.select);
			if(_isOver)	onMouseRollOver();
			else	showBBDefault();
		}
		
		override public function dispose():void{
			super.dispose();
			//if(_bp.bitmapData)	_bp.bitmapData.dispose ();
			_buSkin = null;
			this.removeEventListener(MouseEvent.ROLL_OVER,onMouseRollOver);
			this.removeEventListener(MouseEvent.ROLL_OUT,onMouseRollOut);
			this.removeEventListener(MouseEvent.MOUSE_DOWN,onMouseDown);
			this.removeEventListener(MouseEvent.MOUSE_UP,onMouseUp);
//			var len:int = _skinBDs.length;
//			for( var i:int=0; i<len; i++ ){
//				_skinBDs[i].dispose();
//			}
		}
		
		public function followTargetMouse(target:InteractiveObject):void{
			target.addEventListener(MouseEvent.ROLL_OVER, onMouseRollOver);
			target.addEventListener(MouseEvent.ROLL_OUT, onMouseRollOut);
			target.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			if(_showSelect)	target.addEventListener(MouseEvent.MOUSE_UP,onMouseUp);
		}
		
		public function clearFollowTargetMouse(target:InteractiveObject):void{
			target.removeEventListener(MouseEvent.ROLL_OVER, onMouseRollOver);
			target.removeEventListener(MouseEvent.ROLL_OUT, onMouseRollOut);
			target.removeEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			target.removeEventListener(MouseEvent.MOUSE_UP,onMouseUp);
		}
		
		protected function onMouseUp(e:MouseEvent=null):void{
			if(_isDown){
				select=true;
				this.dispatchEvent(new BagEvent(BagEvent.ITEM_SELECT,_index,true));
			}
		}
		
		protected function onMouseDown(event:MouseEvent=null):void{
			_isDown = true;
			showBBDown();
			UI.stage.addEventListener(MouseEvent.MOUSE_UP,onStageMouseUp);
		}
		
		protected function onStageMouseUp(event:MouseEvent):void{
			_isDown = false;
			UI.stage.removeEventListener(MouseEvent.MOUSE_UP,onStageMouseUp);
			if(_isSelect == false)	onMouseRollOut();
		}
		
		protected function onMouseRollOver(event:MouseEvent=null):void{
			if(_isDown) return;
			_isOver = true;
			if(_isSelect==false)	showBBOver();
		}
		
		protected function onMouseRollOut(event:MouseEvent=null):void{
			if(_isDown) return;
			_isOver = false;
			if(!_isSelect){
				showBBDefault();
			}else	select=true;
		}
		
		protected function showBBDown():void{
			_bp.sourceBitmapData = _skinBDs[2];
			_bp.x=_offsetX;
			_bp.y=_offsetY;
		}
		
		protected function showBBOver():void{
			_bp.sourceBitmapData = _skinBDs[1];
			_bp.x=_offsetX;
			_bp.y=_offsetY;
		}
		
		protected function showBBDefault():void{
			_bp.sourceBitmapData = _skinBDs[0];
			_bp.x=0;
			_bp.y=0;
		}
		
		protected function showBBSelect():void{
			_bp.sourceBitmapData = _skinBDs[3];
			_bp.x=_offsetX;
			_bp.y=_offsetY;
		}
		
		public function set select(value:Boolean):void{
			_isSelect = value;
			_isDown = false;
			if(_isSelect)	showBBSelect();
			else	showBBDefault();
		}
		
		public function get select():Boolean{
			return _isSelect;
		}
		
		public function setXYOffset(x:Number,y:Number):void{
			_offsetX = x;
			_offsetY = y;
		}
		
		public function setShowSelect(value:Boolean):void{
			_showSelect = value;
		}
	}
} 