package com.YFFramework.core.yf2d.extension.face
{
	import com.YFFramework.core.yf2d.display.DisplayObjectContainer2D;
	
	import flash.geom.Point;

	/**
	 *  
	 * @author yefeng
	 * 2013 2013-6-20 下午12:46:30 
	 */
	public interface IYF2dMovie extends IReflection
	{
		function getIntersect(parentPt:Point,parentContainer:DisplayObjectContainer2D=null):Boolean;
		
	}
}