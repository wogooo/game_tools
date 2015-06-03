package com.YFFramework.game.core.global.manager
{
	import com.YFFramework.core.utils.HashMap;
	import com.YFFramework.game.core.global.DataCenter;
	import com.YFFramework.game.core.global.model.ItemDyVo;
	import com.YFFramework.game.core.global.model.PropsBasicVo;
	import com.YFFramework.game.core.global.model.PropsDyVo;
	import com.YFFramework.game.core.global.util.TypeProps;
	import com.YFFramework.game.core.module.bag.data.BagStoreManager;
	import com.YFFramework.game.core.module.bag.data.BagTimerManager;
	import com.YFFramework.game.core.module.bag.source.BagSource;
	import com.YFFramework.game.core.module.market.source.MarketSource;
	import com.YFFramework.game.core.module.trade.manager.TradeDyManager;
	import com.msg.common.ItemConsume;
	import com.msg.item.CharacterProps;
	import com.msg.item.Unit;
	import com.msg.storage.Cell;
	
	import flashx.textLayout.elements.BreakElement;

	/**
	 * @version 1.0.0
	 * creation time：2013-3-14 下午2:39:02
	 */
	public class PropsDyManager
	{
		//======================================================================
		//       public property
		//======================================================================
		
		//======================================================================
		//       private property
		//======================================================================
		private static var _instance:PropsDyManager;
		
		private var _propsList:HashMap;
		//======================================================================
		//        constructor
		//======================================================================
		
		public function PropsDyManager()
		{
			_propsList=new HashMap();
			
		}
		
		//======================================================================
		//        public function
		//======================================================================
		public static function get instance():PropsDyManager
		{
			if(_instance == null)
				_instance=new PropsDyManager();
			return _instance;
		}
		
		public function setPropsList(props:Array):void
		{
			var len:int=props.length;
			for(var i:int=0;i<len;i++)
			{
				var propsDyVo:PropsDyVo=new PropsDyVo();
				propsDyVo.propsId=(props[i] as CharacterProps).propsId;
				propsDyVo.templateId=(props[i] as CharacterProps).templateId;
				propsDyVo.quantity=(props[i] as CharacterProps).quantity;
				propsDyVo.obtain_time=(props[i] as CharacterProps).obtainTime;
				propsDyVo.binding_type=CharacterProps(props[i]).bindingAttr;
				_propsList.put(propsDyVo.propsId,propsDyVo);
				
				//加入时效性道具的处理
				if(propsDyVo.obtain_time > 0)//目前只有有效时间
					BagTimerManager.instance.addTimer(TypeProps.ITEM_TYPE_PROPS,propsDyVo.propsId);
			}
		}
		
		public function delProps(propsId:int):void
		{
			if(_propsList.get(propsId))
			{
				_propsList.remove(propsId);
			}
		}
		
		/**
		 * 返回所有道具列表
		 * @return 是propsDyVo结构
		 * 
		 */		
		public function getPropsArray():Array
		{
			return _propsList.values();
		}
		
		/**
		 * 修改道具数量 
		 * @param propsId
		 * @param quantity
		 * 
		 */		
		public function motifyPropsNum(propsId:int,quantity:int):void
		{
			var props:PropsDyVo=_propsList.get(propsId);
			props.quantity=quantity;
//			trace("修改道具数量：","propsId",propsId,"pos",getPropsPosFromBag(propsId))
			var pos:int=getPropsPosFromBag(propsId);
			var cell:Cell=new Cell();
			cell.item=new Unit();
			cell.pos=pos;
			cell.item.type=TypeProps.ITEM_TYPE_PROPS;
			cell.item.id=propsId;
//			trace("接受:propsId",propsId,"pos",pos)
			BagStoreManager.instantce.setNewPackCells([cell]);
		}
		
		/**返回服务器发来的道具列表，不包括详细信息
		 * @param propsId 动态（唯一）id
		 * @return CharacterProps->props_id,template_id,quantity,obtain_time
		 */		
		public function getPropsInfo(propsId:int):PropsDyVo{		
			return _propsList.get(propsId);
		}
		
		/**交易系统、寄售系统 添加后扩展的getPropsQuantity
		 * 获取背包里指定的道具的绑定和不绑定之和；（不包括锁定道具的数量）
		 * @param templateId1	道具的绑定或不绑定的静态id
		 * @return int	指定的道具的绑定和不绑定之和(不包括交易锁定道具的数量)
		 */	
		public function getPropsQuantity(templateId:int):int{
			var num:int = 0;
			var packArr:Array = BagStoreManager.instantce.getAllPackArray();
			for each(var item:ItemDyVo in packArr){
				var props:PropsDyVo = PropsDyManager.instance.getPropsInfo(item.id);
				if(props){	
					if(props.templateId==templateId)	num+=props.quantity;
				}
			}
			num -= TradeDyManager.Instance.getLockItemQuantity(templateId);
			if(MarketSource.ConsignmentStatus==true){
				var pos:int = MarketSource.curLockPos;
				var itemVo:ItemDyVo = BagStoreManager.instantce.getPackInfoByPos(MarketSource.curLockPos);
				if(itemVo){
					props=_propsList.get(itemVo.id);
					if(props){
						if(props.templateId==templateId) num-= props.quantity;
					}
				}
			}
			return num;
		}
		
		/**找到某个绑定或不绑定道具的数量
		 * @param templateId
		 * @param bound 绑不绑定
		 * @return 
		 */		
		public function getBoundPropsQuantity(templateId:int,bound:int):int
		{
			var num:int=0;
			var packArr:Array = BagStoreManager.instantce.getAllPackArray();
			var props:PropsDyVo;
			for each(var item:ItemDyVo in packArr)
			{
				props = PropsDyManager.instance.getPropsInfo(item.id);
				if(props)
				{
					if(props.templateId==templateId && props.binding_type == bound)	
					{
						num+=props.quantity;
					}
				}
			}
			return num;
		}
		
		/**交易系统添加后扩展的getFirstPropsPos(注意例如宠物驯养，喂养道具会有加血优先级，现在暂时没有)
		 * 获取指定道具在背包的第一个位置。先返回绑定指定道具的第一位置，后返回非绑定指定道具位置的第一位置(不包括交易锁定的道具)
		 * @param templateId1	指定道具的绑定静态id或非绑定静态id
		 * @return int	该道具的第一位置，没有的话返回0
		 */	
		public function getFirstPropsPos(templateId1:int):int{
			var packArr:Array = BagStoreManager.instantce.getAllPackArray();
			for each(var bindItem:ItemDyVo in packArr){
				var props:PropsDyVo = PropsDyManager.instance.getPropsInfo(bindItem.id);
				if(props){	
					if(props.templateId==templateId1 && props.binding_type==TypeProps.BIND_TYPE_YES)	return bindItem.pos;
				}
			}
			
			for each(var unBindItem:ItemDyVo in packArr){
				var unBindProps:PropsDyVo = PropsDyManager.instance.getPropsInfo(unBindItem.id);
				if(unBindProps){
					if(unBindProps.templateId==templateId1 && unBindProps.binding_type==TypeProps.BIND_TYPE_NO && !TradeDyManager.Instance.isLockItem(unBindProps.propsId,TypeProps.ITEM_TYPE_PROPS)){
						if(MarketSource.ConsignmentStatus==true){
							if(MarketSource.curLockPos!=unBindItem.pos)	return unBindItem.pos;
						}else{
							return unBindItem.pos;
						}
					}
				}
			}
			return 0;
		}
		
		/**获取指定物品的对应位置和数量
		 * @param templateId	指定物品的templateId
		 * @param quantity		指定物品要使用的数量
		 * @return Array		ItemConsume，协议定义，包括位置和数量
		 */	
		public function getPropsPosArray(templateId:int,quantity:int):Array{
			var packArr:Array=BagStoreManager.instantce.getAllPackArray();
			
			var propsPosArr:Array = new Array();
			var pos:int=0;
			var item:ItemConsume;
			
			for each(var bindItem:ItemDyVo in packArr){
				var props:PropsDyVo = PropsDyManager.instance.getPropsInfo(bindItem.id);
				if(props){
					if(props.templateId==templateId && props.binding_type==TypeProps.BIND_TYPE_YES){
						item = new ItemConsume();
						item.pos = bindItem.pos;
						if(quantity<props.quantity)	item.number = quantity;
						else	item.number = props.quantity;
						quantity -= item.number;
						propsPosArr.push(item);
						if(quantity==0)	break;
					}
				}
				
				if(quantity>0){
					for each(var unBindItem:ItemDyVo in packArr){
						var unBindProps:PropsDyVo = PropsDyManager.instance.getPropsInfo(unBindItem.id);
						if(unBindProps){
							if(unBindProps.templateId==templateId && unBindProps.binding_type==TypeProps.BIND_TYPE_NO && 
								!TradeDyManager.Instance.isLockItem(unBindProps.propsId,TypeProps.ITEM_TYPE_PROPS) && 
								(MarketSource.ConsignmentStatus==false || (MarketSource.ConsignmentStatus==true && 
									MarketSource.curLockPos!=unBindItem.pos))){
								item = new ItemConsume();
								item.pos = unBindItem.pos;
								if(quantity<unBindProps.quantity)	item.number = quantity;
								else	item.number = unBindProps.quantity;
								quantity -= item.number;
								propsPosArr.push(item);
								if(quantity==0)	break;
							}
						}
					}
				}
			}
			return propsPosArr;
		}

		/**
		 * 找给定绑定性的道具位置数组
		 * @param templateId
		 * @param bound
		 * @param quantity
		 * @return 类型：ItemConsume
		 */		
		public function getPropsPosAryByBound(templateId:int,bound:int,quantity:int):Array
		{
			var packArr:Array=BagStoreManager.instantce.getAllPackArray();
			
			var propsPosArr:Array = new Array();
			var pos:int=0;
			var item:ItemConsume;
			
			for each(var itemVo:ItemDyVo in packArr){
				var props:PropsDyVo = PropsDyManager.instance.getPropsInfo(itemVo.id);
				if(props){
					if(props.templateId == templateId && props.binding_type == bound){
						item = new ItemConsume();
						item.pos = itemVo.pos;
						if(quantity<props.quantity)	item.number = quantity;
						else	item.number = props.quantity;
						quantity -= item.number;
						propsPosArr.push(item);
						if(quantity==0)	break;
					}
				}
			}
			return propsPosArr;
		}
		
		/**
		 * 看这个道具是否在背包里 
		 * @param templateId
		 * @return 
		 */		
		public function checkPropsIsInBag(templateId:int):Boolean
		{
			var packArr:Array=BagStoreManager.instantce.getAllPackArray();
			for each(var item:ItemDyVo in packArr)
			{
				var prop:PropsDyVo = PropsDyManager.instance.getPropsInfo(item.id);
				if(prop)
				{
					if(prop.templateId==templateId)
					{
						return true;
					}
				}	
			}
			return false;
		}
		
		
		
		/**在背包取得某道具的位置 
		 * @param propsId
		 * @return 
		 * 
		 */		
		public function getPropsPosFromBag(propsId:int):int
		{
			var packArr:Array=BagStoreManager.instantce.getAllPackArray();
			
			for each(var item:ItemDyVo in packArr)
			{
				if(item.type == TypeProps.ITEM_TYPE_PROPS)
				{
					if(item.id == propsId)
					{
						return item.pos;
					}
				}
			}
			
			return 0;
		}
		
		
		
		
		
		/**
		 * 在仓库取得某道具的位置 
		 * @param propsId
		 * @return 
		 * 
		 */		
		public function getPropsPosFromDepot(propsId:int):int
		{
			var depotArr:Array=BagStoreManager.instantce.getAllDepotArray();
			
			for(var i:int=0;i<depotArr.length;i++)
			{
				if(depotArr[i].type == TypeProps.ITEM_TYPE_PROPS)
				{
					if(depotArr[i].id == propsId)
					{
						return depotArr[i].pos;
					}
				}
			}	
			return 0;	
		}
		
		/**
		 * 根据templateId在背包里查找道具
		 * @param templateId
		 * @return 返回0就是没有这个道具
		 * 
		 */		
//		public function getFirstPropsFromBag(templateId:int):int
//		{
//			var packArr:Array=BagStoreManager.instantce.getAllPackArray();
//			
//			for each(var item:ItemDyVo in packArr)
//			{
//				if(item.type == TypeProps.ITEM_TYPE_PROPS)
//				{
//					var myTemplateId:int=(_propsList.get(item.id) as PropsDyVo).templateId;
////					var basicVo:PropsBasicVo=PropsBasicManager.Instance.getPropsBasicVo(templateId);
//					if(templateId == myTemplateId)
//					{
//						return item.pos;
//					}
//				}
//			}
//			
//			return 0;
//		}
		
		
		/**获取背包中  道具  道具类型  为  propType 的第一个道具 
		 *  该方法用于小飞鞋 等单独特殊类型的道具  通过类型找道具
		 * 返回的是该道具在背包的位置  没有则返回小于0的数字   有道具 则返回值必须大于 0 
		 */
		public function getFirstPropsPostionFromBagByPropType(propType:int):int
		{
			var arr:Array=PropsBasicManager.Instance.getAllBasicVoByType(propType);
			if(arr.length>0) 
			{
				var propBasicVo:PropsBasicVo=arr[0];
				return getFirstPropsPos(propBasicVo.template_id);
			}
			return -1; 
		} 
		
		
		/**获取最低级的宠物药的位置Id 
		 * @return int	最低级的宠物药的位置Id,没有的话return -1
		 */		
		public function getFirstPetDrugPos():int{
			var petDrugs:Array = PropsBasicManager.Instance.getAllBasicVoByType(TypeProps.PROPS_TYPE_PET_FEED);
			petDrugs.sortOn("level");
			for(var i:int=0;i<petDrugs.length;i++){
				var pos:int = getFirstPropsPos(petDrugs[i].template_id);
				if(pos>0)	return pos;
			}
			return -1;
		}
		
		/**获取第一位置的人物药品，没有的话返回-1
		 * @return 
		 */		
		public function getFirstDrugPos():int{
			var hpDrugs:Array = PropsBasicManager.Instance.getAllBasicVoByType(TypeProps.PROPS_TYPE_HP_DRUG);
			hpDrugs.sortOn("level");
			for(var i:int=0;i<hpDrugs.length;i++){
				if(DataCenter.Instance.roleSelfVo.roleDyVo.level<hpDrugs[i].level)	break;
				var pos:int = getFirstPropsPos(hpDrugs[i].template_id);
				if(pos>0)	return pos;
			}
			return -1;
		}
		
		/**获取第一位置的人物魔品，没有的话返回-1
		 * @return 
		 */	
		public function getFirstMPDrugPos():int{
			var mpDrugs:Array = PropsBasicManager.Instance.getAllBasicVoByType(TypeProps.PROPS_TYPE_MP_DRUG);
			mpDrugs.sortOn("level");
			for(var i:int=0;i<mpDrugs.length;i++){
				if(DataCenter.Instance.roleSelfVo.roleDyVo.level<mpDrugs[i].level)	break;
				var pos:int = getFirstPropsPos(mpDrugs[i].template_id);
				if(pos>0)	return pos;
			}
			return -1;
		}
	}
} 