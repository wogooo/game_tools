package com.YFFramework.core.world.movie.player.utils
{
	import flash.display.DisplayObject;
	import flash.geom.Matrix;

	/**  人物角色影子创建类
	 * @author yefeng
	 *2012-5-13上午12:10:36
	 */
	public class ShawdowUtil
	{
		/**影子  转换矩阵矩阵  (a=0.719146728515625, b=0.415191650390625, c=-0.35284423828125, d=0.61114501953125, tx=3.75, ty=-2.5999999999999943) 
		 */		
		protected static const shadowMatrix:Matrix=new Matrix(0.92,0.53,0.353,0.61114,3.8,-2.);
		public function ShawdowUtil()
		{
		}
		/**  得到  display 对象的影子矩阵
		 */
		public static function getShadowMatrix(display:DisplayObject):Matrix
		{
			var mat:Matrix=new Matrix();
			mat.concat(display.transform.matrix);
			mat.concat(shadowMatrix);
			return mat;
		}
		
	}
}