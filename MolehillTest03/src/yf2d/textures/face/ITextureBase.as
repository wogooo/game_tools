package yf2d.textures.face
{
	import flash.geom.Rectangle;

	/**
	 * author : 夜枫
	 * 时间 ：2011-12-12 下午07:52:17
	 * 
	 * 贴图接口
	 */
	public interface ITextureBase 
	{
		/**得到UV大小   里面有四个数字 前面两个代表 在贴图中的位置坐标 xy 后面两个代表咋贴图中的宽高  也就是  (x,y,w,h) ///在 贴图中的百分比 
		 */		
		function  getUVData(scaleY:Number=1):Vector.<Number>;
		/**得到 当前显示贴图大小
		 */		
		function get textureRect():Rectangle;
		
		/**共享一张BitmapData
		 */		
		function clone():ITextureBase;
		
		/**释放内存
		 */
		function dispose():void;
		
	}
}