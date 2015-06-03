package com.YFFramework.game.core.module.npc.model
{
	/**缓存 Npc_Position 表    也就是npc 刷新表
	 */	
	public class Npc_PositionBasicVo
	{
		/** npc刷新id  也就是唯一id 动态id 
		 */		
		public var npc_id:int;
		/**对应的 静态npc id
		 */		
		public var basic_id:int;
		/**场景id 
		 */		
		public var scene_id:int;
		/**  该 npc动态ID  对应的地图坐标
		 */		
		public var pos_y:int;
		/**  该 npc动态ID  对应的地图坐标
		 */		
		public var pos_x:int;
		
		/**小地图描述
		 */		
		public  var small_map_des:String;
		
		/**小地图上标记点 比如怪物点 npc 的样式id  具体值和 资源文件cursorUI.fla的链接名一一对应 
		 */		
		public var styleId:int;
		/**小地图上的显示类型  （0-不显示，1-怪物分布，2-功能NPC，3-其他NPC,4 --传送点） 5  移动npc   具体 值在  TypeRole.SmallMapShowType_
		 */		
		public var type:int;
		
		/**移动路径
		 */
		public var path:Array;
		
		public function Npc_PositionBasicVo()
		{
		}
	}
}