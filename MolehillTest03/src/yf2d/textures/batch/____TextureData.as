package yf2d.textures
{
	import flash.display.BitmapData;
	import flash.geom.Rectangle;
	
	/**
	 * author :夜枫
	 * 时间 ：2011-11-25 下午07:42:19
	 */
	public  class TextureData extends BitmapData
	{
		/**  viewRect 属性值 是为了确定该BitmapData在 AtlasData 中的位置   ----- (x,y,width,height)
		 */		
		public var viewRect:Rectangle;
		
		public function TextureData(width:int, height:int, transparent:Boolean=false, fillColor:uint=4.294967295E9)
		{
			super(width, height, transparent, fillColor);
			viewRect=new Rectangle(0,0,width,height);
		}
		
		
	}
}