package com.YFFramework.game.core.module.npc.model
{
	/**npc 面板数据 
	 * @author yefeng
	 * 2013 2013-5-10 下午4:37:03 
	 */
	public class NPCFuncVo
	{
		/**  功能id   商店ID，或者其他面板，或程序写好的脚本编号
		 */		
		public var funcId:int;
		/**    功能类型   1-商店、2-传送、0-没有《表示不显示该行对话》 3 表示进副本类型  4  表示工会类型
		 */		
		public var funcType:int;
		
		/** npc动态id 
		 */		
		public var npcDyId:int;
		
		/**  
		 * 是否为关闭副本 类型    副本  会创建 两个类型的 item  一个 是 开启副本类型  一个是关闭副本 类型     true 表示关闭副本类型  false 表示 开启副本类型  
		 */
		public var closeRaid :Boolean;//   
		
		
		/**假为工会类型  时候 显示 的具体内容 具体类型在  TypeNPCFunc-Guild_
		 */		
		public var guidType:int;
		
		
		public function NPCFuncVo()
		{
		}
	}
}