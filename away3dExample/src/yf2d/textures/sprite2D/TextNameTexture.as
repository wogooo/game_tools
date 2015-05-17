package yf2d.textures.sprite2D
{
	import flash.display.BitmapData;
	import flash.display3D.textures.Texture;
	import flash.geom.Rectangle;
	
	import yf2d.textures.face.ITextureBase;
	import yf2d.utils.getTwoPower;
	
	/**主角色的名称    高度 为  16  宽度 为64  只能显示5个名字 也就是只能打出五个字
	 * 2012-11-21 上午11:36:21
	 *@author yefeng
	 */
	public class TextNameTexture implements ITextureBase
	{
		
		public static const Width:int=64;
		public static const Height:int=16;
		
		private static const uvData:Vector.<Number>=Vector.<Number>([0,0,1,1]);
		private static const _rect:Rectangle=new Rectangle(0,0,Width,Height);
		public function TextNameTexture()
		{
			
		}
		public function getUVData(scaleY:Number=1):Vector.<Number>
		{
			return uvData;
		}
		
		public function get rect():Rectangle
		{
			return _rect;
		}
		
		public function clone():ITextureBase
		{
			var txture:TextNameTexture=new TextNameTexture();
			return txture;
		}
		public function dispose():void
		{
			
		}

		
	}
}