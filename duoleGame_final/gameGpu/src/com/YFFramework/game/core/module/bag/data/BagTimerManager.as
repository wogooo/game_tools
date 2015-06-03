package com.YFFramework.game.core.module.bag.data
{
	import com.YFFramework.core.center.manager.update.TimeOut;
	import com.YFFramework.core.event.YFEvent;
	import com.YFFramework.core.event.YFEventCenter;
	import com.YFFramework.game.core.global.TimeManager;
	import com.YFFramework.game.core.global.manager.EquipBasicManager;
	import com.YFFramework.game.core.global.manager.EquipDyManager;
	import com.YFFramework.game.core.global.manager.PropsBasicManager;
	import com.YFFramework.game.core.global.manager.PropsDyManager;
	import com.YFFramework.game.core.global.model.EquipBasicVo;
	import com.YFFramework.game.core.global.model.EquipDyVo;
	import com.YFFramework.game.core.global.model.PropsBasicVo;
	import com.YFFramework.game.core.global.model.PropsDyVo;
	import com.YFFramework.game.core.global.util.TypeProps;
	import com.YFFramework.game.core.module.bag.event.BagEvent;
	import com.YFFramework.game.core.module.notice.manager.NoticeManager;
	import com.YFFramework.game.core.module.notice.model.NoticeType;
	import com.YFFramework.game.core.module.notice.model.NoticeUtils;
	
	import flash.utils.Dictionary;
	import flash.utils.Timer;

	/**
	 * @author jina;
	 * @version 1.0.0
	 * creation time：2013-8-6 上午9:04:18
	 */
	public class BagTimerManager
	{
		//======================================================================
		//       public property
		//======================================================================
		
		//======================================================================
		//       private property
		//======================================================================
		private static var _instance:BagTimerManager;
		
		private var _equipTimerDict:Dictionary;
		private var _propsTimerDict:Dictionary;
		
		private var _otherRoleEquipTimerDict:Dictionary;
		private var _otherRolePropsTimerDict:Dictionary;
		//======================================================================
		//        constructor
		//======================================================================
		
		public function BagTimerManager()
		{
			_equipTimerDict=new Dictionary();
			_propsTimerDict=new Dictionary();
			_otherRoleEquipTimerDict=new Dictionary();
			_otherRolePropsTimerDict=new Dictionary();
		}
		
		//======================================================================
		//        public function
		//======================================================================
		/**
		 * 
		 * @param type
		 * @param id
		 * @param aging
		 * @param obtainTime 获得时间，自1970年以来的秒数
		 * @param remain 剩余时间,格式为：600的字符串,以秒为单位
		 * @param deadLine 截止时间,格式为：197008312400的字符串
		 * 
		 */			
		public function addTimer(itemType:int,itemId:int):void
		{
			var timer:TimeOut;
			if(itemType == TypeProps.ITEM_TYPE_EQUIP)
			{
				//暂时只有剩余时间，以后要大改！
				var edyVo:EquipDyVo=EquipDyManager.instance.getEquipInfo(itemId);
				var eBsVo:EquipBasicVo=EquipBasicManager.Instance.getEquipBasicVo(edyVo.template_id);
				timer=new TimeOut(int(eBsVo.remain_time*1000),equipEndTime,itemId);
				timer.start();
				_equipTimerDict[itemId]=timer;
			}
			else
			{
				var pDyVo:PropsDyVo=PropsDyManager.instance.getPropsInfo(itemId);
				var pBsVo:PropsBasicVo=PropsBasicManager.Instance.getPropsBasicVo(pDyVo.templateId);
				timer=new TimeOut(int(pBsVo.remain_time*1000),propsEndTime,itemId);
				timer.start();
				_propsTimerDict[itemId]=timer;
			}
		}
		
		public function deleteTimer(type:int,id:int):void
		{
			if(type == TypeProps.ITEM_TYPE_EQUIP)
			{
				if(_equipTimerDict[id])
				{
					var dyVo:EquipDyVo=EquipDyManager.instance.getEquipInfo(id);
					if(dyVo)
					{
						var vo:EquipBasicVo=EquipBasicManager.Instance.getEquipBasicVo(dyVo.template_id);
						NoticeManager.setNotice(NoticeType.Notice_id_305,-1,NoticeUtils.setColorText(vo.name,vo.quality));
						
						_equipTimerDict[id]=null;
						delete _equipTimerDict[id];
					}
					
				}
				
			}
			else
			{
				if(_propsTimerDict[id])
				{
					var pdyVo:PropsDyVo=PropsDyManager.instance.getPropsInfo(id);
					if(pdyVo)
					{
						var pvo:PropsBasicVo=PropsBasicManager.Instance.getPropsBasicVo(pdyVo.templateId);
						NoticeManager.setNotice(NoticeType.Notice_id_305,-1,NoticeUtils.setColorText(pvo.name,vo.quality));
						
						_propsTimerDict[id]=null;
						delete _propsTimerDict[id];
					}
					
				}
				
			}
		}
		
		/** 暂时只有装备
		 * @param type
		 * @param id
		 * @return 
		 * 
		 */		
		public function getPassTime(type:int,id:int):Number
		{
			var timer:TimeOut;
			var passTime:int;
			if(type == TypeProps.ITEM_TYPE_EQUIP)
			{
				timer=_equipTimerDict[id];	
			}
			else
			{
				timer=_propsTimerDict[id];
			}
			passTime = timer.getCrtTime();
			return passTime;
		}
		
		/** 存储其他玩家时效装备信息 */
		public function addOtherEquipTimer(dyVo:EquipDyVo):void
		{
			var eBsVo:EquipBasicVo=EquipBasicManager.Instance.getEquipBasicVo(dyVo.template_id);
			var timer:TimeOut=new TimeOut(int(eBsVo.remain_time*1000),equipEndTime,dyVo.equip_id);
			timer.start();
			_equipTimerDict[dyVo.equip_id]=timer;
		}
		
		/** 存储其他玩家时效道具信息 */
		public function addOtherPropsTimer(dyVo:PropsDyVo):void
		{
			var eBsVo:EquipBasicVo=EquipBasicManager.Instance.getEquipBasicVo(dyVo.templateId);
			var timer:TimeOut=new TimeOut(int(eBsVo.remain_time*1000),equipEndTime,dyVo.propsId);
			timer.start();
			_equipTimerDict[dyVo.propsId]=timer;
		}
		
		/** 排行榜等存储其他玩家有时效信息装备 */
		public function getOtherPassTimer(type:int,id:int):Number
		{
			var timer:TimeOut;
			var passTime:int;
			if(type == TypeProps.ITEM_TYPE_EQUIP)
			{
				timer=_otherRoleEquipTimerDict[id];	
			}
			else
			{
				timer=_otherRolePropsTimerDict[id];
			}
			passTime = timer.getCrtTime();
			return passTime;
		}
		
		/** 删除其他玩家时效性道具 */
		public function deleteOtherTimer(type:int,id:int):void
		{
			if(type == TypeProps.ITEM_TYPE_EQUIP)
			{
				if(_otherRoleEquipTimerDict[id])
				{				
					_equipTimerDict[id]=null;
					delete _equipTimerDict[id];		
				}
			}
			else
			{
				if(_otherRolePropsTimerDict[id])
				{						
					_propsTimerDict[id]=null;
					delete _propsTimerDict[id];
				}
				
			}
		}
		//======================================================================
		//        private function
		//======================================================================
		/** 返回自1970年到当前时间的毫秒数
		 * @return  
		 */		
		private function getCurrentDate():Number
		{
			var today:Date=new Date();
			return today.time;
		}
		//======================================================================
		//        event handler
		//======================================================================
		private function equipEndTime(obj:Object):void
		{
			var pos:int=0;
			var id:int=obj as int;
			pos=EquipDyManager.instance.getEquipPosFromBag(id);
			if(pos > 0)
				YFEventCenter.Instance.dispatchEventWith(BagEvent.BAG_CDelItemReq,pos);
			else
			{
				pos = EquipDyManager.instance.getEquipPosFromRole(id);
				if(pos > 0)
					YFEventCenter.Instance.dispatchEventWith(BagEvent.BAG_CDelItemReq,pos);
				else
				{
					pos = EquipDyManager.instance.getEquipPosFromDepot(id);
					if(pos > 0)
						YFEventCenter.Instance.dispatchEventWith(BagEvent.BAG_CDelItemReq,pos);
				}
			}
		}
		
		private function propsEndTime(obj:Object):void
		{
			var pos:int=0;
			var id:int=obj as int;
			pos=PropsDyManager.instance.getPropsPosFromBag(id);
			if(pos > 0)
				YFEventCenter.Instance.dispatchEventWith(BagEvent.BAG_CDelItemReq,pos);
			else
			{
				pos = PropsDyManager.instance.getPropsPosFromDepot(id);
				if(pos > 0)
					YFEventCenter.Instance.dispatchEventWith(BagEvent.BAG_CDelItemReq,pos);
			}
		}
		//======================================================================
		//        getter&setter
		//======================================================================
		
		public static function get instance():BagTimerManager
		{
			if(_instance == null)
				_instance=new BagTimerManager();
			return _instance;
		}

	}
} 