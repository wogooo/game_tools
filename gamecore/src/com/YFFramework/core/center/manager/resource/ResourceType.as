package com.YFFramework.core.center.manager.resource
{
	/**
	 * author :夜枫 * 时间 ： 12:54:04 PM
	 * 
	 * 资源类型  该资源分大类和小类
	 */
	public class ResourceType
	{
		
		/** 资源大类
		 */
		public var mainType:int;
		/**资源小类
		 */		
		public var subType:int;		
		public function ResourceType(main:int=0,sub:int=0)
		{
			this.mainType=main;
			this.subType=sub;
		}
	}
}