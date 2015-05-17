package com.YFFramework.core.center.manager.resource
{

	/**
	 * author :夜枫 * 时间 ： 12:58:14 PM
	 * 资源类型中心 
	 * 所有的资源类型都是在该类中进行定义的  单例
	 */
	public class ResourceTypeCenter
	{
		private static var _instance:ResourceTypeCenter;
		////下面是各个物品类型的定义
		
		///首先定义几个大的物品类型   然后再具体定义小的物品  比如食品是一大类    水果  是一小类  肉食 也是一小类   蔬菜也是一小类     苹果 香蕉 梨子 是属于同一类型  即 同一大类 并且同一小类
		
		/***
		 * 
		 *   涉及房屋地图类型的大类 默认是 1 
		 * 
		 * 
		 * 
		 * 
		 ***/
		
		
		/**
		 *   资源编辑器资源   
		 */		
		
		/**  背景地图类型      mian >=10000  表示的是地图资源  每一个 小类 main值表示一张地图  min小类数组表示该地图里面的 npc
		 */		  
	//	public  var TianxiaMap:ResourceType=new ResourceType(10000,1); ///索引 编号 为1 的地图    天下地图
	//	public var XueFeng:ResourceType=new ResourceType(10000,2); ///索引编号为 2的地图 
		public var TanxiaMap_NPC_0:ResourceType=new ResourceType(10000,0);
		
		
		/** 家具类型  默认为 1,1
		 */
		public var furnitureType:ResourceType=new ResourceType(1,1);
		public function ResourceTypeCenter()
		{
			if(_instance) throw new Error("不能直接实例化，请使用Instance属性");
			else init();
		}
		
		public static function get Instance():ResourceTypeCenter
		{
			if(!_instance) _instance=new ResourceTypeCenter();
			return _instance;
		}
		
		
		protected function init():void
		{
			
		}
		
	}
}