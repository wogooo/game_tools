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
		public static var topSprite:Sprite;
		
		private static var _stage:Stage;

		public static function get stage():Stage
		{
			return _stage;
		}
		
		public static function removeAllChilds(targetSprite:Sprite):void
		{
			while(targetSprite.numChildren>0){
				targetSprite.removeChildAt(0);
			}
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

		public static function init(stageRef:Stage,topLayer:Sprite):void
		{
			_stage = stageRef;
			topSprite = topLayer;
			disableColorMat = new ColorMatrix();
			disableColorMat.adjustBrightness(-20);
			disableColorMat.adjustContrast(-40);
			disableColorMat.adjustSaturation(-100);
			disableFilter = [ new ColorMatrixFilter(disableColorMat) ];
			Align.stage = _stage;
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
		public static function setEnable(target:InteractiveObject,isAble:Boolean,isDisableMouseEvent:Boolean=true):void
		{
			if(isAble == false){
				target.filters = disableFilter;
			}else{
				target.filters = null;
			}
			if(isDisableMouseEvent == true){
				target.mouseEnabled = isAble;
				if(target is DisplayObjectContainer){
					DisplayObjectContainer(target).mouseChildren = isAble;
				}
			}
		}
		
		public static function isEnable(target:InteractiveObject):Boolean
		{
			if(target.filters == null) return true;
			if(target.filters.length==0) return true;
			return false;
		}
		
	}
}