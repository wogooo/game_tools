package com.YFFramework.game.core.module.login.model
{
	/**
	 *  处理服务端返回来的消息
	 * @author yefeng
	 *2012-5-14下午11:36:00
	 */
	public class LoginVo
	{
		
		/**角色名称
		 */
		public var name:String;
		
		/** 角色性别v
		 */
		public var sex:int;
		
		/** 角色职业
		 */
		public var carrer:int;
		
		
		/**角色动态id 
		 */
		public var dyId:String;
		
		/**等级
		 */		
		public var level:int;
		
		
		/**
		 * 进入场景后的 外形所需要的id   是物品静态 id  通过静态id拿到皮肤id  
		 */
		/** 套装的 的静态id 
		 */
		public var clothBasicId:int;
		
		/**套装的静态id 
		 */
		public var weaponBasicId:int;


		/**当前hp
		 */
		public  var hp:int;
		
		/**最大血量
		 */
		public var maxHp:int;
		
		/**当前经验
		 */
		public var exp:int;
		
		/**最大经验 也就是升级经验
		 */
		public var maxExp:int;
		
		
		public function LoginVo()
		{
		}
	}
}