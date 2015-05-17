package com.YFFramework.game.core.module.mapScence.model
{
	/**  人物跳跃产生的vo 
	 * 2012-7-31 下午12:31:19
	 *@author yefeng
	 */
	public class JumpVo
	{
		/**跳跃者的id 
		 */
		public var id:int;
		
		/**跳跃的起始坐标 与 终点坐标
		 */		
		public var startX:int;
		public var startY:int;
		public var endX:int;
		public var endY:int;
		
		/**产生跳跃时的速度
		 */
		public var speed:int;
		
		public function JumpVo()
		{
		}
	}
}