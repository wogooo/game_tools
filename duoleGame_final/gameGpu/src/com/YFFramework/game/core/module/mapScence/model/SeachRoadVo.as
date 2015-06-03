package com.YFFramework.game.core.module.mapScence.model
{
	import com.YFFramework.game.core.module.npc.model.Npc_PositionBasicVo;

	/**跨场景寻路的数据模型
	 * @author yefeng
	 * 2013 2013-5-25 上午10:32:56 
	 */
	public class SeachRoadVo
	{
		/**  要走到的 目标场景   保存的是 场景 id  roadArr 是保存的下一个场景的 id 
		 */		
		public var roadArr:Array;
		/**要走到的npc动态id  该id 大于0 表示  npc 等于0  则表示 坐标  坐标   为npc_posX  npc_posY
		 */		
		public var npcDyId:int;
		/** npc静态id  为 0 则表示坐标点
		 */		
		public var npcBasicId:int;
		
		/** 该npcDyId 对应的坐标点
		 */		
		public var npc_posX:int;
		public var npc_posY:int;
		public function SeachRoadVo()
		{
		}
	}
}