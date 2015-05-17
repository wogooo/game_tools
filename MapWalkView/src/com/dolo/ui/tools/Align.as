package com.dolo.ui.tools
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.utils.Dictionary;
	import flash.display.DisplayObject;
	
	/**
	 *  Align提供的常用的对齐功能
	 * @author flashk
	 * 
	 */
	public class Align
	{
		public static var stage:Stage;
		
		private static var _always:Dictionary = new Dictionary(true);
		private static var _pars:Object = {};
		private static var _index:uint = 0;
		private static var _hasAdd:Boolean = false;
		
		public static function followVerticalOneByOne(target:Sprite):int
		{
			var len:int = target.numChildren;
			var fy:int=0;
			var dis:DisplayObject;
			for(var i:int=0;i<len;i++){
				dis = target.getChildAt(i);
				dis.y = fy;
				fy += Math.round(dis.height);
			}
			return fy;
		}
		
		/**
		 * 将所有子级按网格排列（可设置 widthCount为无限大：单行横向排列，为0，单列竖向排列）
		 * @param target 父级容器
		 * @param gridWidth 网格的横向间距
		 * @param gridHeight  网格的竖向间距
		 * @param widthCount
		 * 
		 */
		public static function gridAllChild(target:Sprite,gridWidth:Number,gridHeight:Number,widthCount:uint,startAt:uint=0,endAt:int=-1):int
		{
			var indexX:int=0;
			var indexY:int=0;
			var dis:DisplayObject
			var len:int = endAt;
			if(len == -1) len =target.numChildren;
			for(var i:int=startAt;i<len;i++){
				dis = target.getChildAt(i);
				dis.x = indexX*gridWidth;
				dis.y = indexY*gridHeight;
				indexX++;
				if(indexX >= widthCount){
					indexX = 0;
					indexY++;
				}
			}
			return indexY*gridHeight;
		}
		
		/**
		 * 居中对齐 
		 * @param target
		 * @param isAlways
		 * @param targetWidth
		 * @param targetHeight
		 * @param parentWidth
		 * @param parentHeight
		 * @param isIntXY
		 * @param isResetZero
		 * 
		 */
		public static function toCenter(target:DisplayObject,isAlways:Boolean=false,
										targetWidth:Number=-1,targetHeight:Number=-1,parentWidth:Number=-1,parentHeight:Number=-1,
										isIntXY:Boolean=true,isResetZero:Boolean=true):void
		{
			if(isAlways){
				_index++;
				_always["key"+_index] = target;
				_pars["key"+_index] = ["Center",targetWidth,targetHeight,parentWidth,parentHeight,isIntXY,isResetZero]
			}
			if( !_hasAdd ){
				stage.addEventListener(Event.RESIZE,resetAlways);
				_hasAdd = true;
			}
			if(targetWidth == -1){
				targetWidth = target.width;
			}
			if(targetHeight == -1) {
				targetHeight = target.height;
			}
			if(parentWidth == -1) {
				parentWidth = stage.stageWidth;
			}
			if(parentHeight == -1) {
				parentHeight = stage.stageHeight;
			}
			target.x = (parentWidth-targetWidth)/2;
			target.y = (parentHeight-targetHeight)/2;
			if(isIntXY){
				target.x = int(target.x);
				target.y = int(target.y);
			}
			if(isResetZero){
				if(target.x < 0) target.x = 0;
				if(target.y < 0) target.y = 0;
			}
		}
		
		/**
		 * 左下角对齐 
		 * @param target
		 * @param isAlways
		 * @param offsetY
		 * @param parentHeight
		 * @param isIntXY
		 * @param isResetZero
		 * 
		 */
		public static function toLeftBottom(target:DisplayObject,isAlways:Boolean=false,offsetY:Number=0,
											parentHeight:Number=-1,isIntXY:Boolean=true,isResetZero:Boolean=false):void
		{
			if(isAlways){
				_index++;
				_always["key"+_index] = target;
				_pars["key"+_index] = ["LeftBottom",offsetY,parentHeight,isIntXY,isResetZero]
			}
			if( !_hasAdd ){
				stage.addEventListener(Event.RESIZE,resetAlways);
				_hasAdd = true;
			}
			if(parentHeight == -1){
				parentHeight = stage.stageHeight;
			}
			target.y = parentHeight+offsetY;
			if(isIntXY){
				target.x = int(target.x);
				target.y = int(target.y);
			}
			if(isResetZero){
				if(target.x < 0) target.x = 0;
				if(target.y < 0) target.y = 0;
			}
		}
		
		/**
		 * 右下角对齐 
		 * @param target
		 * @param isAlways
		 * @param offsetX
		 * @param offsetY
		 * @param parentWidth
		 * @param parentHeight
		 * @param isIntXY
		 * @param isResetZero
		 * 
		 */
		public static function toRightBottom(target:DisplayObject,isAlways:Boolean=false,offsetX:Number=0,offsetY:Number=0,parentWidth:Number=-1,
											 				parentHeight:Number=-1,isIntXY:Boolean=true,isResetZero:Boolean=false):void
		{
			if(isAlways){
				_index++;
				_always["key"+_index] = target;
				_pars["key"+_index] = ["RightBottom",offsetX,offsetY,parentWidth,parentHeight,isIntXY,isResetZero]
			}
			if( !_hasAdd ){
				stage.addEventListener(Event.RESIZE,resetAlways);
				_hasAdd = true;
			}
			if(parentWidth == -1) {
				parentWidth = stage.stageWidth;
			}
			if(parentHeight == -1) {
				parentHeight = stage.stageHeight;
			}
			target.x = parentWidth+offsetX;
			target.y = parentHeight+offsetY;
			if(isIntXY){
				target.x = int(target.x);
				target.y = int(target.y);
			}
			if(isResetZero){
				if(target.x < 0) target.x = 0;
				if(target.y < 0) target.y = 0;
			}
		}
		
		/**
		 * 中间下面对齐 
		 * @param target
		 * @param isAlways
		 * @param targetWidth
		 * @param offsetX
		 * @param offsetY
		 * @param parentWidth
		 * @param parentHeight
		 * @param isIntXY
		 * @param isResetZero
		 * 
		 */
		public static function toMiddleBottom(target:DisplayObject,isAlways:Boolean=false,targetWidth:Number=-1,offsetX:Number=0,offsetY:Number=0,
											  					parentWidth:Number=-1,parentHeight:Number=-1,isIntXY:Boolean=true,isResetZero:Boolean=false):void
		{
			if(isAlways){
				_index++;
				_always["key"+_index] = target;
				_pars["key"+_index] = ["MiddleBottom",targetWidth,offsetX,offsetY,parentWidth,parentHeight,isIntXY,isResetZero]
			}
			if( !_hasAdd ){
				stage.addEventListener(Event.RESIZE,resetAlways);
				_hasAdd = true;
			}
			if(targetWidth == -1) {
				targetWidth = target.width;
			}
			if(parentWidth == -1) {
				parentWidth = stage.stageWidth;
			}
			if(parentHeight == -1) {
				parentHeight = stage.stageHeight;
			}
			target.x = (parentWidth-targetWidth)/2+offsetX;
			target.y = parentHeight+offsetY;
			if(isIntXY){
				target.x = int(target.x);
				target.y = int(target.y);
			}
			if(isResetZero){
				if(target.x < 0) target.x = 0;
				if(target.y < 0) target.y = 0;
			}
		}
		
		/**
		 * 中间顶部对齐 
		 * @param target
		 * @param isAlways
		 * @param targetWidth
		 * @param offsetX
		 * @param parentWidth
		 * @param isIntXY
		 * @param isResetZero
		 * 
		 */
		public static function toMiddleTop(target:DisplayObject,isAlways:Boolean=false,targetWidth:Number=-1,offsetX:Number=0,
										   				parentWidth:Number=-1,isIntXY:Boolean=true,isResetZero:Boolean=true):void
		{
			if(isAlways){
				_index++;
				_always["key"+_index] = target;
				_pars["key"+_index] = ["MiddleTop",targetWidth,offsetX,parentWidth,isIntXY,isResetZero]
			}
			if( !_hasAdd ){
				stage.addEventListener(Event.RESIZE,resetAlways);
				_hasAdd = true;
			}
			if(targetWidth == -1) {
				targetWidth = target.width;
			}
			if(parentWidth == -1) {
				parentWidth = stage.stageWidth;
			}
			target.x = (parentWidth-targetWidth)/2+offsetX;
			if(isIntXY){
				target.x = int(target.x);
				target.y = int(target.y);
			}
			if(isResetZero){
				if(target.x < 0) target.x = 0;
				if(target.y < 0) target.y = 0;
			}
		}
		
		/**
		 * 右对齐 
		 * @param target
		 * @param isAlways
		 * @param offsetX
		 * @param parentWidth
		 * @param isIntXY
		 * @param isResetZero
		 * 
		 */
		public static function toRight(target:DisplayObject,isAlways:Boolean=false,offsetX:Number=0,
									   parentWidth:Number=-1,isIntXY:Boolean=true,isResetZero:Boolean=true):void
		{
			if(isAlways){
				_index++;
				_always["key"+_index] = target;
				_pars["key"+_index] = ["Right",offsetX,parentWidth,isIntXY,isResetZero]
			}
			if( !_hasAdd ){
				stage.addEventListener(Event.RESIZE,resetAlways);
				_hasAdd = true;
			}
			if(parentWidth == -1) {
				parentWidth = stage.stageWidth;
			}
			target.x = parentWidth+offsetX;
			if(isIntXY){
				target.x = int(target.x);
				target.y = int(target.y);
			}
			if(isResetZero){
				if(target.x < 0) target.x = 0;
				if(target.y < 0) target.y = 0;
			}
		}
		
		private static function resetAlways(event:Event):void
		{
			var dis:DisplayObject;
			var par:Array;
			for(var i:Object in _always){
				try{
					dis = _always[i];
					par = _pars[i.toString()];
					switch(par[0]){
						case "Center":
							toCenter(dis,false,par[1],par[2],par[3],par[4],par[5],par[6]);
							break;
						case "LeftBottom":
							toLeftBottom(dis,false,par[1],par[2],par[3],par[4]);
							break;
						case "RightBottom":
							toRightBottom(dis,false,par[1],par[2],par[3],par[4],par[5],par[6]);
							break;
						case "Right":
							toRight(dis,false,par[1],par[2],par[3],par[4]);
							break;
						case "MiddleTop":
							toMiddleTop(dis,false,par[1],par[2],par[3],par[4],par[5]);
							break;
						case "MiddleBottom":
							toMiddleBottom(dis,false,par[1],par[2],par[3],par[4],par[5],par[6],par[7]);
							break;
					}
				} 
				catch(error:Error) {
					
				}
			}
		}
		
		public static function alignToCenter(display:DisplayObject,boxWidth:Number,
											 boxHeight:Number,isIntXY:Boolean=true):void
		{
			display.x = (boxWidth-display.width)/2;
			display.y = (boxHeight-display.height)/2;
			if(isIntXY == true){
				display.x = int(display.x);
				display.y = int(display.y);
			}
		}
		
	}
}