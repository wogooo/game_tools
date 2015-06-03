package com.YFFramework.game.core.global.model
{
	/**小飞鞋数据vo  用来 进行  小飞鞋 传送
	 * @author yefeng
	 * 2013 2013-6-21 上午11:35:46 
	 */
	public class FlyBootVo
	{
		/**跳转到的场景 id 
		 */		
		public var mapId:int;
		/**跳转到的目标x 
		 */		
		public var mapX:int;
		/**跳转到目标 y
		 */		
		public var mapY:int;
		
		
		/**小飞鞋在背包里的位置 ， 这个 变量的值不需要赋值，程序内部自动赋值
		 */
		public var flyItemPos:int;
		
		
		///跳转到目标玩家 打开窗口 时候 需要设置该值 
		/**当需要传送玩家附近时 ，需要设置该值   跳转到目标点 则不需要设置该值
		 *  大部分情况是npc_id
		 */		
		public var seach_id:int;
		
		/**类型    除去 打怪 类型 和   采集类型 其他类型全部作为 找 npc类型处理     当seach_id >0 时     其值在  TaskTargetType_类型里面
		 */
		public var seach_type:int=-1;
		
		public function FlyBootVo()
		{
		}
	}
}