package com.YFFramework.core.world.mapScence.map
{
	/**yf2d实现
	 * 背景地图贴图  256*256大小
	 * @author yefeng
	 *2012-11-20下午9:57:54
	 */
	import yf2d.display.sprite2D.Map2D;
	import yf2d.textures.face.ITextureBase;
	
	public class TileView extends Map2D
	{
		
		public function TileView()
		{
			super(0,0);
			mouseEnabled=false;
		}
		override public function  setTextureData(texture2D:ITextureBase,scaleX:Number=1):void
		{
			super.setTextureData(texture2D,scaleX);
			///设置缩放
			var myW:int=width;
			var myH:int=height;
			this.scaleX=(myW+1)/myW;
			this.scaleY=(myH+1)/myH;
		}
	}
}