package com.YFFramework.core.yf2d.textures.face
{
	/**  地图编辑器用  用于扩展   
	 * author : 夜枫
	 */
	public interface ITextureAnimate extends ITextureBase
	{
		/**
		 * @param value  要显示的帧数  默认为0 表示显示第一帧
		 */		
		function setFrame(value:uint):void;
	}
}