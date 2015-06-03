package com.YFFramework.game.core.module.im.model
{
	/** 好友 面板的的 动态数据
	 * @author yefeng
	 * 2013 2013-6-22 下午2:27:58 
	 */
	public class IMDyVo
	{
	
		/** 玩家id
		 */		
		public var dyId:int;
		/**玩家名字
		 */		
		public var name:String;
		/**等级
		 */		
		public var level:int;
		/**职业
		 */		
		public var career:int;
		/**性别
		 */		
		public var sex:int;
		/**在线状态 (0:不在线； 1:在线)  只在 TypeIM 里面    Online  Offline
		 */
		public var online:int;
		/**  工会名称
		 */		
		public var guild:String;
		
		public var vipLevel:int;
		public var vipType:int;
		
		public function IMDyVo()
		{
		}
	}
}