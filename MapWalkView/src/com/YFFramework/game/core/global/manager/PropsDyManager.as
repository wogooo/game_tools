package com.YFFramework.game.core.global.manager
{
	import com.YFFramework.core.utils.HashMap;
	import com.YFFramework.game.core.global.model.ItemDyVo;
	import com.YFFramework.game.core.global.model.PropsBasicVo;
	import com.YFFramework.game.core.global.model.PropsDyVo;
	import com.YFFramework.game.core.global.util.TypeProps;
	import com.YFFramework.game.core.module.bag.source.PackSource;
	import com.msg.item.CharacterProps;
	import com.msg.item.Unit;
	import com.msg.storage.Cell;

	/**
	 * @version 1.0.0
	 * creation time：2013-3-14 下午2:39:02
	 * 
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
		
		private var propsList:HashMap;
		//======================================================================
		//        constructor
		//======================================================================
		
		public function PropsDyManager()
		{
			propsList=new HashMap();
			
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
			for(var i:int=0;i<props.length;i++)
			{
				var propsDyVo:PropsDyVo=new PropsDyVo();
				propsDyVo.propsId=(props[i] as CharacterProps).propsId;
				propsDyVo.templateId=(props[i] as CharacterProps).templateId;
				propsDyVo.quantity=(props[i] as CharacterProps).quantity;
				propsDyVo.obtain_time=(props[i] as CharacterProps).obtainTime;
				propsList.put(propsDyVo.propsId,propsDyVo);
			}
		}
		
		public function getPropsArray():Array
		{
			return propsList.values();
		}
		
		/**
		 * 修改道具数量 
		 * @param propsId
		 * @param quantity
		 * 
		 */		
		public function motifyPropsNum(propsId:int,quantity:int):void
		{
			var props:PropsDyVo=propsList.get(propsId);
			props.quantity=quantity;
			propsList.put(propsId,props);
			
			var pos:int=getPropsPostion(propsId);
			var cell:Cell=new Cell();
			cell.item=new Unit();
			cell.pos=pos;
			cell.item.type=TypeProps.ITEM_TYPE_PROPS;
			cell.item.id=propsId;
//			trace("接受:propsId",propsId,"pos",pos)
			BagStoreManager.instantce.setNewPackCells([cell]);
		}
		
		/**
		 * 返回服务器发来的道具列表，不包括详细信息
		 * @param propsId 动态（唯一）id
		 * @return CharacterProps->props_id,template_id,quantity,obtain_time
		 * 
		 */		
		public function getPropsInfo(propsId:int):PropsDyVo
		{		
			return propsList.get(propsId);
		}
		
		/**
		 * 背包指定templateId之和
		 * @param templateId 传入任意模板id都可以
		 * @return 
		 * 
		 */			
		public function getPropsQuantity(templateId1:int):int
		{
			var num:int=0;
			var packArr:Array=BagStoreManager.instantce.getAllPackArray();
			var templateId2:int=getAnotherTemplateId(templateId1);//找到另一个同子类的模板id
			
			//首先找出给定模板id在背包共有多少数量
			for each(var item:ItemDyVo in packArr)
			{
				var prop:PropsDyVo = PropsDyManager.instance.getPropsInfo(item.id);
				if(prop)
				{
					if(prop.templateId == templateId1 || (templateId2 > 0 && prop.templateId == templateId2))
					{
						num += prop.quantity;
					}
				}
			}
			
			return num;
		}
		
		/**
		 * 得到某个道具在背包的第一个位置，注意例如宠物驯养，喂养道具会有加血优先级，现在暂时没有
		 * @param enum
		 * @return 
		 * 
		 */		
		public function getFirstPropsPos(templateId1:int):int
		{
			//注意例如宠物驯养，喂养道具会有加血优先级，现在暂时没有
			var packArr:Array=BagStoreManager.instantce.getAllPackArray();			
			var templateId2:int=getAnotherTemplateId(templateId1);//找到另一个同子类的模板id
			
			var pos1:int=0;
			var pos2:int=0;
			
			for each(var item1:ItemDyVo in packArr)
			{
				var props1:PropsDyVo = PropsDyManager.instance.getPropsInfo(item1.id);
				if(props1)
				{
					if(props1.templateId==templateId1)
					{
						pos1=item1.pos;
					}
				}
			}
			
			if(templateId2 > 0)
			{
				for each(var item2:ItemDyVo in packArr)
				{
					var props2:PropsDyVo = PropsDyManager.instance.getPropsInfo(item2.id);
					if(props2)
					{
						if(props2.templateId==templateId2)
						{
							pos2=item2.pos;
						}
					}
				}
			}
			
			//就是四种情况都考虑到
			if(pos1 > 0 && pos2 > 0)//首先是绑定不绑定都有位置，肯定优先给定绑定的位置
			{
				if(PropsBasicManager.Instance.getPropsBasicVo(templateId1).binding_type == TypeProps.BIND_TYPE_YES)
				{
					return pos1;
				}
				else
					return pos2;
			}
			else if(pos1 > 0 && pos2 == 0)//中间两种情况就是只有一个地方有位置了，谁有位置谁返回
				return pos1;
			else if(pos1 == 0 && pos2 > 0)
				return pos2;
			else//最后就是什么位置都没有就为0
				return 0;
			
		}
		
		/**
		 * 看这个道具是否在背包里 
		 * @param templateId
		 * @return 
		 * 
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
		
		public static function getQualityColor(quality:int):String
		{
			switch(quality)
			{
				case TypeProps.QUALITY_WHITE:
					return 'FFFFFF';
				case TypeProps.QUALITY_GREEN:
					return '00FF00';
				case TypeProps.QUALITY_BLUE:
					return '0000FF';
				case TypeProps.QUALITY_PURPLE:
					return 'DB70DB';
				case TypeProps.QUALITY_ORANGE:
					return 'FF7F00';
				case TypeProps.QUALITY_RED:
					return 'FF0000';
				default:
					return '';
			}
		}
		
		/**
		 * 取得某道具的位置 
		 * @param propsId
		 * @return 
		 * 
		 */		
		public function getPropsPostion(propsId:int):int
		{
			var packArr:Array=BagStoreManager.instantce.getAllPackArray();
			
			for(var i:int=0;i<packArr.length;i++)
			{
				if(packArr[i].type == TypeProps.ITEM_TYPE_PROPS)
				{
					if(packArr[i].id == propsId)
					{
						return packArr[i].pos;
					}
				}
			}
			
			return 0;
			
		}
		
		/**获取最低级的宠物药的位置Id 
		 * @return 最低级的宠物药的位置Id,没有的话return -1
		 */		
		public function getFirstPetDrugPos():int{
			var petDrugs:Array = PropsBasicManager.Instance.getAllBasicVoByType(TypeProps.BIG_PROPS_TYPE_FEED);
			petDrugs.sortOn("level");
			for(var i:int=0;i<petDrugs.length;i++){
				if(getPropsQuantity(petDrugs[i].template_id)>0){
					return getFirstPropsPos(petDrugs[i].template_id);
				}
			}
			return -1;
		}
		
		//======================================================================
		//        private function
		//======================================================================
		/**
		 * 知道一个templateId，找到另一个templateId 
		 * @param templateId
		 * @return 
		 * 
		 */		
		private function getAnotherTemplateId(templateId:int):int
		{
			//首先知道是什么子类
			var ass_id:int=PropsBasicManager.Instance.getPropsBasicVo(templateId).ass_id;
			
			return ass_id;
		}
		//======================================================================
		//        event handler
		//======================================================================
		
		//======================================================================
		//        getter&setter
		//======================================================================
		
		
	}
} 