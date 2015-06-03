package com.dolo.ui.tools
{
	import com.YFFramework.core.utils.common.ClassInstance;
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.utils.getDefinitionByName;
	import flash.display.SimpleButton;
	import flash.display.Shape;

	/**
	 * 实例创建工厂
	 * @author Administrator
	 * 
	 */
	public class LibraryCreat
	{
		
		public static var loader:Loader = new Loader();
		
		public static function getSprite(linkName:String):Sprite
		{
			return ClassInstance.getInstance(linkName) as Sprite;
		}
		
		public static function getDisplay(linkName:String):DisplayObject
		{
			return ClassInstance.getInstance(linkName);
		}
		
		public static function getObject(linkName:String):Object
		{
			return ClassInstance.getInstance(linkName);
		}
		
		public static function creatHitSimpleButton():SimpleButton
		{
			var sim:SimpleButton = new SimpleButton();
			var sh:Shape = new Shape();
			sh.graphics.beginFill(0xFF0000,0);
			sh.graphics.drawRect(0,0,100,100);
			sh.graphics.endFill();
			sim.upState = sh;
			sim.hitTestState = sh;
			sim.useHandCursor = false;
			return sim;
		}
		
	}
}