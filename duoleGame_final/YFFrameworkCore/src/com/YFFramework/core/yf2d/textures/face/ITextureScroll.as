package com.YFFramework.core.yf2d.textures.face
{
	import flash.geom.Point;
	
	/**
	 * author : 夜枫
	 * 时间 ：2011-12-14 下午01:34:58
	 */
	public interface ITextureScroll extends ITextureBase
	{
		function scroll(offsetX:Number,offsetY:Number):void;
		function scrollTo(px:Number,py:Number):void;
		
		function getCoordinate():Point;
	}
}