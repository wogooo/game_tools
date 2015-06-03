package com.dolo.ui.tools
{
	import com.YFFramework.core.utils.common.ClassInstance;
	import flash.display.Sprite;

	public class ObjectFactory
	{
		
		public static function getNewSprite(linkName:String):Sprite
		{
			return ClassInstance.getInstance(linkName);
		}
		
	}
}