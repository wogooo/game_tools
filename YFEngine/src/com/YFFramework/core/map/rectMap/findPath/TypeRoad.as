package com.YFFramework.core.map.rectMap.findPath
{
	/**路点类型  
	 * 2012-7-12
	 *	@author yefeng
	 */
	public class TypeRoad
	{
		/**障碍
		 */		
		public static const Block:int=0;//障碍
		/**可走
		 */
		public static const Walk:int=1;//可走
		
		/**消隐点
		 */
		public static const AlphaWalk:int=2;//消隐点
		/**跳转点
		 */
		public static const Skip:int=3;///跳转点
		
		/**可飞点 1
		 */
		public static const Fly1:int=4;
		/**可飞点2 
		 */
		public static const Fly2:int=5;
		
		
		/** 消隐点角色透明度
		 */
		public static const AlphaColor:Number=0.9;
		/**正常颜色
		 */
		public static const AlphaNormal:Number=1;
		public function TypeRoad()
		{
		}
	}
}