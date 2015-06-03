package com.YFFramework.game.core.global.model
{
	/** 副本和NPC相关联的数据vo 
	 * @author yefeng
	 * 2013 2013-6-7 下午3:38:04 
	 */
	public class RaidNPCVo
	{
		/**要进入的副本id  的 groupId  
		 */		
		public var raidId:int;
		/**和该副本关联的  npcId 
		 */		
		public var npcId:int;
		
		public var propsArr:Array=new Array();
		
		public function RaidNPCVo()
		{
		}
	}
}