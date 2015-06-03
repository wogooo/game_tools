package com.YFFramework.core.ui.yf2d.graphic
{
	import com.YFFramework.core.ui.movie.data.ActionData;

	/**@author yefeng
	 * 2013 2013-8-21 上午11:01:25 
	 */
	public interface IGraphicPlayer
	{
		function initData(actionData:ActionData):void;
		
		function clear():void;
		
	}
}