package com.YFFramework.game.core.module.mapScence.model
{
	/** 推开 或者拉取 角色时 的通讯  瞬间改变 该角色在服务端的位置     该通迅并不需要返回  只是改变 拉取 推离角色在服务端的位置
	 * @author yefeng
	 *2012-10-13下午3:31:50
	 */
	public class BackSlideMoveVo
	{
		public var dyId:String;
		
		/**该角色的当前坐标
		 */ 
		public var mapX:int;
		/**该角色的当前坐标
		 */		
		public var mapY:int;
		/**推离，或者拉取角色的 最终到达的位置
		 */ 
		public var endX:int;
		public var endY:int;
		public function BackSlideMoveVo()
		{
		}
	}
}