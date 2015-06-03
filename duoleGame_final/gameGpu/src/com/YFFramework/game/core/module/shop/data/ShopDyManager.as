package com.YFFramework.game.core.module.shop.data
{
	import com.YFFramework.game.core.global.manager.EquipDyManager;
	import com.YFFramework.game.core.global.manager.PropsDyManager;
	import com.YFFramework.game.core.global.model.EquipDyVo;
	import com.YFFramework.game.core.global.model.ItemDyVo;
	import com.YFFramework.game.core.global.model.PropsDyVo;
	import com.YFFramework.game.core.global.util.TypeProps;

	/**
	 * 用来处理商店回购
	 * @version 1.0.0
	 * creation time：2013-5-7 下午4:49:47
	 */
	public class ShopDyManager
	{
		//======================================================================
		//       public property
		//======================================================================
		
		//======================================================================
		//       private property
		//======================================================================
		private static var _instance:ShopDyManager;
		
		private var clientList:Vector.<Object>;
		private var serverList:Array;
		//======================================================================
		//        constructor
		//======================================================================
		
		public function ShopDyManager()
		{
			clientList=new Vector.<Object>();
			serverList=[];
		}
		
		//======================================================================
		//        public function
		//======================================================================
		public static function get instance():ShopDyManager
		{
			if(_instance == null) _instance=new ShopDyManager();
			return _instance;
		}
		
		/**
		 * 卖之前客户端保存的出售物品 
		 * @param item
		 * 
		 */		
		public function saveClientBackList(item:ItemDyVo):void
		{
			//先搜索下在clientList有没有同样道具或装备（id）相同，如果有先覆盖之
			var len:int=clientList.length;
			for(var i:int=0;i<len;i++)
			{
				if(clientList[i].type == TypeProps.ITEM_TYPE_PROPS)
				{
					if(item.id == (clientList[i].info as PropsDyVo).propsId)
					{
						clientList[i].info=PropsDyManager.instance.getPropsInfo(item.id);
						return;
					}
				}
				else
				{
					if(item.id == (clientList[i].info as EquipDyVo).equip_id)
					{
						clientList[i].info=EquipDyManager.instance.getEquipInfo(item.id);
						return;
					}
				}
			}
			
			var obj:Object=new Object();
			if(item.type == TypeProps.ITEM_TYPE_PROPS)
			{
				obj={type:item.type,info:PropsDyManager.instance.getPropsInfo(item.id)};
				clientList.push(obj);
			}
			else
			{
				obj={type:item.type,info:EquipDyManager.instance.getEquipInfo(item.id)};
				clientList.push(obj);
			}
			
			if(clientList.length == 10)
			{
				clientList.shift();
			}
		}
		
		/**
		 * 暂存(转化)服务器发来的回购列表 
		 * @param items
		 * 
		 */		
		public function saveServerBackList(items:Array):Array
		{
			serverList=[];
			
			var len:int=items.length;
			for(var i:int=0;i<len;i++)
			{
				var itemDyVo:ItemDyVo=new ItemDyVo(items[i].pos,items[i].item.type,items[i].item.id);
				serverList.push(itemDyVo);
			}
			return serverList;
		}
		
		/**
		 * 返回最近出售的物品 
		 * @return 
		 * 
		 */		
		public function getLastItem():Object
		{
			var serverLastItem:ItemDyVo=serverList[serverList.length-1];//服务器发来回购列表最新的出售物品请求
			
			var len:int=clientList.length;
			for(var i:int=len-1;i>=0;i--)//在客户端存的数据里寻找这条信息
			{
				var obj:Object=clientList[i];
				if(obj != null)
				{
					if(obj.type == TypeProps.ITEM_TYPE_PROPS)
					{
						var propsId:int=(obj.info as PropsDyVo).propsId;
						if(propsId == serverLastItem.id)
							return obj;
					}
					else
					{
						var equipId:int=(obj.info as EquipDyVo).equip_id;
						if(equipId == serverLastItem.id)
							return obj;
					}
						
				}
					
			}
			return null;
		}
		
		/** 返回之前卖出东西的信息，是个object类型{type,info}(info表示道具就是PropsDyVo，装备就是EquipDyVo) */
		public function getBackListInfo(item:ItemDyVo):Object
		{
			var len:int=clientList.length;
			for(var i:int=0;i<len;i++)
			{
				var obj:Object=clientList[i];
				if(obj)
				{
					if(obj.type == item.type)
					{
						
						if(item.type == TypeProps.ITEM_TYPE_PROPS)
						{
							var propsId:int=(obj.info as PropsDyVo).propsId;
							if(propsId == item.id)
								return obj;
						}
						else
						{
							var equipId:int=(obj.info as EquipDyVo).equip_id;
							if(equipId == item.id)
								return obj;
						}
					}
				}
			}
			return null;
			
		}
		
		/**
		 * 服务器的上一次回购列表长度 
		 * @return 
		 * 
		 */		
		public function getListLength():int
		{
			return serverList.length;
		}
		//======================================================================
		//        private function
		//======================================================================
		
		//======================================================================
		//        event handler
		//======================================================================
		
		//======================================================================
		//        getter&setter
		//======================================================================
		
		
	}
} 