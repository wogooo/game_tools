package com.YFFramework.game.core.module.gift.manager
{
	import com.YFFramework.game.core.global.model.ObjectAmount;
	import com.YFFramework.game.core.module.activity.model.ActiveRewardBasicVo;
	import com.YFFramework.game.core.module.bag.data.BagStoreManager;
	import com.YFFramework.game.core.module.gift.model.SignPackageVo;
	import com.YFFramework.game.core.module.gift.model.TypeSignPackage;
	import com.YFFramework.game.core.module.task.enum.RewardTypes;

	/***
	 *礼包数据管理类
	 *@author ludingchang 时间：2013-9-10 上午11:59:51
	 */
	public class GiftManager
	{
		private static var _inst:GiftManager;
		
		public static function get Instence():GiftManager
		{
			return _inst||=new GiftManager;
		}
		/**新手礼包*/
		private var _newPlayerGift:Vector.<SignPackageVo>;
		/**新手签到礼包可领取天数*/
		public var canGetDay:int=1;
		/**签到的最大天数*/
		public static const MAX_GIFT_DAY:int=7;
		public function GiftManager()
		{
		}
		public function get newPlayerGift():Vector.<SignPackageVo>
		{
			if(!_newPlayerGift)
			{
				_newPlayerGift=SignPackageBasicManager.Instance.getSignPackageVo();
			}
			return _newPlayerGift;
		}
		
		public function setNewPlayerGift(package_ids:Array,days:int):void
		{
			var i:int,len:int=newPlayerGift.length;
			canGetDay=days;
			for(i=0;i<len;i++)
			{
				var vo:SignPackageVo=_newPlayerGift[i];
				if(i+1<=days)
				{
					if(package_ids.indexOf(vo.id)==-1)
						vo.state=TypeSignPackage.State_HasGet;
					else
						vo.state=TypeSignPackage.State_CanGet;
				}
				else
					vo.state=TypeSignPackage.State_CannotGet;
			}
		}
	
		public function newPlayerGiftAdd(day:int):void
		{
			canGetDay=day;
			if(day<=MAX_GIFT_DAY)
				_newPlayerGift[day-1].state=TypeSignPackage.State_CanGet;
		}
		
		public function setNewPlayerGiftState(package_id:int,state:int):void
		{
			var i:int,len:int=newPlayerGift.length;
			for(i=0;i<len;i++)
			{
				var vo:SignPackageVo=_newPlayerGift[i];
				if(vo.id==package_id)
				{
					vo.state=state;
					break;
				}
			}
		}
		
		/**是否可以领取签到礼包*/
		public function canGetSignPackage():Boolean
		{
			var i:int,len:int=_newPlayerGift.length;
			for(i=0;i<len;i++)
			{
				if(_newPlayerGift[i].state==TypeSignPackage.State_CanGet)
					return true;
			}
			return false;
		}
		/**是否有可领取礼包*/
		public function hasGift():Boolean
		{
			return canGetSignPackage();
		}
		
		/**自动设置选中的天数*/
		public function findSelectedDay():int
		{
			var i:int,len:int=_newPlayerGift.length;
			for(i=0;i<len;i++)
			{
				if(_newPlayerGift[i].state==TypeSignPackage.State_CanGet)
					return (i+1);
			}
			return canGetDay+1;
		}
		
		/**判断背包是否有足够的格子*/
		public static function checkBagSpace(items:Vector.<ActiveRewardBasicVo>):Boolean
		{
			var i:int,len:int=items.length;
			var eq:Vector.<ObjectAmount>=new Vector.<ObjectAmount>;
			var pp:Vector.<ObjectAmount>=new Vector.<ObjectAmount>;
			var o:ObjectAmount,item:ActiveRewardBasicVo;
			for(i=0;i<len;i++)
			{
				item=items[i];
				o=new ObjectAmount;
				o.amount=item.reward_num;
				o.id=item.reward_id;
				if(item.reward_type==RewardTypes.EQUIP)
					eq.push(o);
				else if(item.reward_type==RewardTypes.PROPS)
					pp.push(o);
			}
			return BagStoreManager.instantce.containsEnoughSpace(eq,pp);
		}
	}
}