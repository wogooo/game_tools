package component.manager.data
{
	import flash.geom.Rectangle;

	/**@author yefeng
	 *20122012-4-16下午11:30:03
	 */
	public class FrameData
	{
		///偏移位置
		public var x:Number;
		public var y:Number;
		/**停留的帧数  默认值 为1    表示停留一帧
		 */
		public var  delay:int;
		
		/**在方向序列帧中的位置
		 */
		public var frameIndex:int;
		
		/**在贴图中的位置区域  x y   width  heigth  
		 */
		public var rect:Rectangle;

		public function FrameData()
		{
		}
	}
}