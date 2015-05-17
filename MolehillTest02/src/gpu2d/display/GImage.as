package gpu2d.display
{
	import flash.display.BitmapData;
	import flash.display3D.Context3DTextureFormat;
	import flash.display3D.textures.Texture;

	/**
	 * author :夜枫
	 * 时间 ：2011-11-13 下午01:27:28
	 * 
	 * 显示对象 具有交互性的显示对象    		mouseEnable==false 表示不具有交互性   不具有交互性的子对象是  GShape
	 */
	public class GImage extends GQuad
	{
		protected var _bmpData:BitmapData;
		protected var texture:Texture;
		/**
		 * @param bmpData   图像源    bmpData的宽高必须是 2的倍数  
		 * @param width    最后显示的宽
		 * @param height   最后显示的高
		 */
		public function GImage(bmpData:BitmapData,width:Number,height:Number)
		{
			_bmpData=bmpData;
			super(width,height);
			setTexture(bmpData);
		}
		override public function setTexture(bmpData:BitmapData):void
		{
			context3d.setTextureAt(0,null);
			texture=context3d.createTexture(_bmpData.width,_bmpData.height,Context3DTextureFormat.BGRA,false);
			texture.uploadFromBitmapData(_bmpData);
			context3d.setTextureAt(0,texture);

		}
			
		


	}
}