package com.YFFramework.core.ui.movie.data
{
	/**@author yefeng
	 *2012-4-22下午1:53:57
	 */
	public class TypeDirection
	{
		/**上
		 */
		public static const Up:int=1;
		/**右上
		 */
		public static const RightUp:int=2;
		
		/**右
		 */
		public static const Right:int=3;
		/**右下
		 */
		public static const RightDown:int=4;
		/**下
		 */
		public static const Down:int=5;
		/**左下
		 */
		public static const LeftDown:int=6;
		/**左
		 */
		public static const Left:int=7;
		/**左上
		 */
		public static const LeftUp:int=8;
		public function TypeDirection()
		{
		}
		
		
		
		
		/**得到反方向
		 */
		public static function getOppsiteDirection(direction:int):int
		{
			var oppSide:int;
			switch(direction) 
			{
				case Up:
					oppSide=Down;
					break;
				case RightUp:
					oppSide=LeftDown;
					break;
				case Right:
					oppSide=Left;
					break;
				case RightDown:
					oppSide=LeftUp;
					break;
				case Down:
					oppSide=Up;
					break;
				case LeftDown:
					oppSide=RightUp;
					break;
				case Left:
					oppSide=Right;
					break;
				case LeftUp:
					oppSide=RightDown;
					break;
			}
			return oppSide;
		}
		
	}
}