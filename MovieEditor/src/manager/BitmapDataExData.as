package manager
{
	/**保存BitmapDataEx的 所有信息 除了 BitmapData以外 
	 * @author yefeng
	 *20122012-4-10下午10:19:27
	 */
	public class BitmapDataExData
	{
		public var x:int;
		public var y:int;
		/**停留的帧数  默认值 为1    表示停留一帧
		 */
		public var  delay:int;
		/**在方向序列帧中的位置
		 */
		public var frameIndex:int;
		public function BitmapDataExData()
		{
		}
	}
}