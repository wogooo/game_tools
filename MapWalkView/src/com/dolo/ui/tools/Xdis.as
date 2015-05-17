package com.dolo.ui.tools
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.InteractiveObject;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.text.TextField;
	import flash.events.MouseEvent;

	/**
	 * Display显示对象辅助类 
	 * @author Administrator
	 * 
	 */
	public class Xdis
	{
		
		/**
		 * 禁止容器和子级的鼠标事件
		 */ 
		public static function setMouseUnableContainer(dis:InteractiveObject,isUnableMouse:Boolean = true):void
		{
			dis.mouseEnabled = !isUnableMouse;
			if(dis is DisplayObjectContainer){
				DisplayObjectContainer(dis).mouseEnabled = !isUnableMouse;
				DisplayObjectContainer(dis).mouseChildren = !isUnableMouse;
			}
		}
		
		public static function moveY(dis:DisplayObject,my:Number,isCheck:Boolean=true):void
		{
			dis.y += my;
			if(isCheck == true){
				if(dis.y < 0 ) dis.y = 0;
			}
		}
		
		/**
		 * 将显示对象的x和y坐标取整
		 */ 
		public static function intXY(dis:DisplayObject):void
		{
			dis.x = int(dis.x);
			dis.y = int(dis.y);
		}
		
		/**
		 * 将显示对象放到容器的中间
		 */ 
		public static function toCenter(dis:DisplayObject,parentWidth:Number,parentHeight:Number,disWidth:Number=0,disHeight:Number=0):void
		{
			if(disWidth == 0) {
				disWidth = dis.width;
			}
			if(disHeight == 0) {
				disHeight = dis.height;
			}
			dis.x = int((parentWidth-disWidth)/2);
			dis.y = int((parentHeight-disHeight)/2);
		}
		
		/**
		 * 返回多层子级显示对象，对象命名字符串按照从外到里顺序传递
		 * 
		 * 
		 */ 
		public static function getChild(parentContainer:DisplayObjectContainer,... args):*
		{
			var dis:DisplayObject = parentContainer;
			var len:int = args.length;
			for(var i:int=0;i<len;i++){
				dis = DisplayObjectContainer(dis).getChildByName(String(args[i]));
			}
			return dis;
		}
		
		/**
		 *  返回多层子级显示对象，并给按钮之类添加MouseEvent.Click事件。对象命名字符串按照从外到里顺序传递
		 * @param clickCallFunction
		 * @param parentContainer
		 * @param args
		 * @return 
		 * 
		 */
		public static function getChildAndAddClickEvent(clickCallFunction:Function,parentContainer:DisplayObjectContainer,... args):*
		{
			var dis:DisplayObject = parentContainer;
			var len:int = args.length;
			for(var i:int=0;i<len;i++){
				dis = DisplayObjectContainer(dis).getChildByName(String(args[i]));
			}
			if(dis){
				dis.addEventListener(MouseEvent.CLICK,clickCallFunction);
			}
			return dis;
		}
		
		public static function getTextChild(parentContainer:DisplayObjectContainer,... args):TextField
		{
			var dis:DisplayObject = parentContainer;
			var len:int = args.length;
			for(var i:int=0;i<len;i++){
				dis = DisplayObjectContainer(dis).getChildByName(String(args[i]));
			}
			return dis as TextField;
		}
		
		public static function getSpriteChild(parentContainer:DisplayObjectContainer,... args):Sprite
		{
			var dis:DisplayObject = parentContainer;
			var len:int = args.length;
			for(var i:int=0;i<len;i++){
				dis = DisplayObjectContainer(dis).getChildByName(String(args[i]));
			}
			return dis as Sprite;
		}
		
		public static function getDisplayObjectChild(parentContainer:DisplayObjectContainer,... args):DisplayObject
		{
			var dis:DisplayObject = parentContainer;
			var len:int = args.length;
			for(var i:int=0;i<len;i++){
				dis = DisplayObjectContainer(dis).getChildByName(String(args[i]));
			}
			return dis as DisplayObject;
		}
		
		public static function getSimpleButtonChild(parentContainer:DisplayObjectContainer,... args):SimpleButton
		{
			var dis:DisplayObject = parentContainer;
			var len:int = args.length;
			for(var i:int=0;i<len;i++){
				dis = DisplayObjectContainer(dis).getChildByName(String(args[i]));
			}
			return dis as SimpleButton;
		}
		
		public static function getMovieClipChild(parentContainer:DisplayObjectContainer,... args):MovieClip
		{
			var dis:DisplayObject = parentContainer;
			var len:int = args.length;
			for(var i:int=0;i<len;i++){
				dis = DisplayObjectContainer(dis).getChildByName(String(args[i]));
			}
			return dis as MovieClip;
		}
		
		/**
		 * 清除目标 Sprite 最上面到指定fromIndex的所有子级显示对象
		 */
		public static function clearChildrens(sprite:Sprite,fromIndex:uint=0):void
		{
			for(var i:int=sprite.numChildren-1;i>=fromIndex;i--){
				sprite.removeChildAt(i);
			}
		}
		
		public static function sortChilds(sprite:Sprite,value:Number):void
		{
			for(var i:int=0;i<sprite.numChildren;i++){
				sprite.getChildAt(i).y = i*value;
			}
		}
		
	}
}