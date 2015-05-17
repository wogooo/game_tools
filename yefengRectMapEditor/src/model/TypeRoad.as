package model
{
	/**路点类型  
	 * 2012-7-12
	 *	@author yefeng
	 */
	public class TypeRoad
	{
		public static const Block:int=0;//障碍
		public static const Walk:int=1;//可走
		
		public static const AlphaWalk:int=2;//消隐点
		public static const Skip:int=3;///跳转点
		
		/**水域点
		 */
		public static const WaterPt:int=4;
		/**可飞点2 
		 */
		public static const Fly2:int=5;
		public function TypeRoad()
		{
		}
	}
}