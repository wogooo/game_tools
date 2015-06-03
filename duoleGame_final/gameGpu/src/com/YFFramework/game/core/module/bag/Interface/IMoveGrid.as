package com.YFFramework.game.core.module.bag.Interface
{
	
	import com.YFFramework.game.core.global.model.ItemDyVo;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;

	public interface IMoveGrid
	{
//		function dragComplete(toBox:IMoveGrid):void;
//		function cloneIcon():Bitmap;
		function get boxKey():int;
//		function get info():*;
		function get boxType():int;

	}
}