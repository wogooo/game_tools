package com.dolo.ui.managers
{
	import com.dolo.ui.tools.Align;
	import com.dolo.ui.tools.ColorMatrix;
	import com.dolo.ui.tools.Xtip;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.InteractiveObject;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.MouseEvent;
	import flash.filters.ColorMatrixFilter;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	import flash.utils.getTimer;

	/**
	 * UI基础辅助 
	 * @author flashk
	 * 
	 */
	public class UI
	{
		public static var disableColorMat:ColorMatrix;
		public static var disableFilter:Array;
		public static var isUserMouseDown:Boolean = false;
		public static var topSprite:DisplayObjectContainer;
		public static var characterColorMat:ColorMatrix;
		public static var characterFilter:Array;
		
		private static var displayCount:int
		
		private static var _stage:Stage;

		public static function get stage():Stage
		{
			return _stage;
		}
		
		public static function removeAllChilds(targetSprite:Sprite):void
		{
			while(targetSprite && targetSprite.numChildren>0){
				targetSprite.removeChildAt(0);
			}
		}
		
		public static function setTextEndInput(txt:TextField,isFocus:Boolean = false):void
		{
			if(isFocus){
				_stage.focus = txt;
			}
			txt.setSelection(txt.text.length,txt.text.length);
		}
		
		public static function insertStringInText(txt:TextField,addStr:String,isFocus:Boolean = false,checkMax:Boolean=false):Boolean
		{
			if(isFocus){
				_stage.focus = txt;
			}
			if(checkMax){
				if(txt.maxChars > 0 && txt.text.length+addStr.length>txt.maxChars){
					return false;
				}
			}
			txt.replaceText(txt.selectionBeginIndex,txt.selectionEndIndex,addStr);
			var index:int = txt.selectionBeginIndex+addStr.length;
			txt.setSelection(index,index);
			return true;
		}
		
		/**
		 * 判断当前是否为用户键盘文本输入状态 
		 * @return 
		 * 
		 */
		public static function get isInTextInputState():Boolean
		{
			var foTxt:TextField = UI.stage.focus as TextField;
			if(foTxt && foTxt.type == TextFieldType.INPUT) return true;
			return false;
		}
		
		public static function setXY(target:DisplayObject,x:Number,y:Number,isIntXY:Boolean=true):void
		{
			if(isIntXY == true){
				target.x = int(x);
				target.y = int(y);
			}else{
				target.x = x;
				target.y = y;
			}
		}
		
		public static function setMouseAble(target:Sprite,able:Boolean):void
		{
			if(target == null) return; 
			target.mouseChildren = able;
			target.mouseEnabled  = able;
		}
		public static function setToTop(target:DisplayObject):void
		{
			if(target && target.parent){
				target.parent.setChildIndex(target,target.parent.numChildren-1);
			}
		}

		public static function init(stageRef:Stage,topLayer:Sprite):void
		{
			_stage = stageRef;
			topSprite = topLayer;
			disableColorMat = new ColorMatrix();
			disableColorMat.adjustBrightness(-20);
			disableColorMat.adjustContrast(-40);
			disableColorMat.adjustSaturation(-100);
			disableFilter = [ new ColorMatrixFilter(disableColorMat) ];
			
			characterColorMat = new ColorMatrix();
			characterColorMat.adjustBrightness(58);
			characterColorMat.adjustContrast(-6);
			characterColorMat.adjustSaturation(-62);
			characterColorMat.adjustHue(-19);
			characterFilter = [new ColorMatrixFilter(characterColorMat)];
			
			Align.stage = _stage;
			Align.addResizeEvents();
			_stage.addEventListener(MouseEvent.MOUSE_DOWN,onStageMouseDown);
			_stage.addEventListener(MouseEvent.MOUSE_UP,onStageMouseUp);
			Xtip.stage = _stage;
		}
		
		protected static function onStageMouseUp(event:MouseEvent):void
		{
			isUserMouseDown = false;
		}
		
		protected static function onStageMouseDown(event:MouseEvent):void
		{
			isUserMouseDown = true;
		}
		
		/**
		 * 禁用按钮，Sprite等可操作对象，并变为灰色 
		 * @param target 目标对象
		 * @param isAble 禁用(false)还是恢复可点击(true)
		 * 
		 */
		public static function setEnable(target:DisplayObject,isAble:Boolean,isDisableMouseEvent:Boolean=true):void
		{
			if(isAble == false){
				target.filters = disableFilter;
			}else{
				target.filters = null;
			}
			if(isDisableMouseEvent == true && target is InteractiveObject){
				InteractiveObject(target).mouseEnabled = isAble;
				if(target is DisplayObjectContainer){
					DisplayObjectContainer(target).mouseChildren = isAble;
				}
			}
		}
		
		/**
		 * 修改颜色值 
		 * @param target
		 * @param brightness
		 * @param contrast
		 * @param saturation
		 * @param hue
		 * 
		 */
		public static function setHSB(target:DisplayObject,brightness:int,contrast:int,saturation:int,hue:int):void
		{
			var mat:ColorMatrix = new ColorMatrix();
			mat.adjustBrightness(brightness);
			mat.adjustContrast(contrast);
			mat.adjustSaturation(saturation);
			mat.adjustHue(hue);
			disableFilter = [ new ColorMatrixFilter(mat) ];
			}
		
		public static function isEnable(target:InteractiveObject):Boolean
		{
			if(target.filters == null) return true;
			if(target.filters.length==0) return true;
			return false;
		}
		
		
		/**
		 * 返回总共有多少个子对象 
		 * @param target
		 * @return 
		 * 
		 */
		public static function countDisplayObject(target:DisplayObjectContainer):int
		{
			var t:int = getTimer();
			displayCount = 0;
			displayObjectIndex(target);
			return displayCount;
		}
		
		private static  function displayObjectIndex(target:DisplayObjectContainer):void
		{
			var len:int = target.numChildren;
			displayCount += len;
			while(len){
				len--;
				if(target){
					try{
						var tar:DisplayObjectContainer =target.getChildAt(len) as DisplayObjectContainer
						if(tar && tar.numChildren > 0){
							displayObjectIndex(tar);
						}
					}catch(e:Error){}
				}
			}
		}
		
	}
}