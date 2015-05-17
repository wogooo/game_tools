package yf2d.textures.batch
{
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	/**作用是创建材质Texture 创建完Texture后 该类型对象就可以dispose释放了
	 * author :夜枫
	 * 时间 ：2011-11-30 下午08:10:00
	 */
	public class AtlasData extends BitmapData
	{
		public function AtlasData(width:int=2048, height:int=2048)
		{
			super(width, height, true, 0x000000);   //第三分参数必须为true 为了达到透明效果
		}
		
/*		override public function copyPixels(sourceBitmapData:BitmapData, sourceRect:Rectangle, destPoint:Point, alphaBitmapData:BitmapData=null, alphaPoint:Point=null, mergeAlpha:Boolean=false):void
		{
			super.copyPixels(sourceBitmapData,sourceRect,destPoint,alphaBitmapData,alphaPoint,mergeAlpha);
		}
*/			
	}
}