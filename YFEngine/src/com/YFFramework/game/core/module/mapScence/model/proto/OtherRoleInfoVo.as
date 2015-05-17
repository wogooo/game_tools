package com.YFFramework.game.core.module.mapScence.model.proto
{
	import com.YFFramework.core.center.pool.AbsPool;

	/**其他角色进入视野vo
	 * 2012-8-3 下午3:02:43
	 *@author yefeng
	 */
	public class OtherRoleInfoVo extends AbsPool
	{
		/**角色id
		 */ 
		public  var roleId:String;
		
		/** 角色进入场景的 位置 
		 */
		public var mapX:int;
		/** 角色进入场景的 位置 
		 */
		public var mapY:int;
		
		/** 角色名称
		 */
		public var name:String;

		/** 套装的 的静态id ///或者是怪物的静态id 
		 */
		public var clothBasicId :int;
		
		/**套装的静态id 
		 */
		public var weaponBasicId :int;
		
		
		/**对象类型   为宠物 还是人物还是怪物 
		 */		
		public var playerType:int;
		/** 人物状态  是 正常行走战斗 还是打坐  还是在坐骑上  TypeRole.Player_
		 */		
		public var state:int;
		
		/**  活动对象的血量百分比  需要在该值的基础上除以10000
		 */		
		public var hpPercent:int;
		
		public function OtherRoleInfoVo()
		{
		}
		
		/**注册对象池
		 */		
		override protected function regObject():void
		{
			regPool(10);
		}

		override public function reset():void
		{
			roleId=null;
			mapX=0;
			mapY=0;
			name=null;
			clothBasicId=0;
			weaponBasicId=0;
		}
		
	}
}