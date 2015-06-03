package com.YFFramework.game.core.module.systemReward.manager
{
	import com.YFFramework.game.core.global.model.ObjectAmount;
	import com.YFFramework.game.core.module.AnswerActivity.dataCenter.answer.QuestionRewardBasicManager;
	import com.YFFramework.game.core.module.AnswerActivity.dataCenter.answer.QuestionRewardBasicVo;
	import com.YFFramework.game.core.module.bag.data.BagStoreManager;
	import com.YFFramework.game.core.module.raid.manager.RaidManager;
	import com.YFFramework.game.core.module.raid.manager.RaidRewardManager;
	import com.YFFramework.game.core.module.raid.model.RaidRewardVo;
	import com.YFFramework.game.core.module.raid.model.RaidVo;
	import com.YFFramework.game.core.module.systemReward.data.RewardItemVo;
	import com.YFFramework.game.core.module.systemReward.data.RewardVo;
	import com.YFFramework.game.core.module.systemReward.data.TypeRewardSource;
	import com.YFFramework.game.core.module.task.enum.RewardTypes;
	import com.YFFramework.game.core.module.task.manager.TaskBasicManager;
	import com.YFFramework.game.core.module.task.manager.Task_rewardBasicManager;
	import com.YFFramework.game.core.module.task.model.Task_rewardBasicVo;
	import com.msg.rewardsystem.RewardInfo;

	/***
	 *系统奖励数据管理类
	 *@author ludingchang 时间：2013-9-4 下午1:48:10
	 */
	public class SystemRewardManager
	{
		private static var _inst:SystemRewardManager;
		
		public static function get Instence():SystemRewardManager
		{
			return _inst||=new SystemRewardManager;
		}
		/**当前显示的数据*/
		public var current:RewardVo;
		/**所有礼包，里面存储的是 <code>RewardVo</code>*/
		public var packages:Array;
		public function SystemRewardManager()
		{
			packages=[];
		}
		/**
		 *添加礼包 
		 * @param datas <code>RewardInfo</code>
		 * 
		 */		
		public function addData(info:RewardInfo):void
		{
			var rewardVo:RewardVo=transRewardInfoToVo(info);
			packages.push(rewardVo);
			packages.sortOn("expiration_time",Array.NUMERIC);
		}
		
		/**
		 *移除数据 
		 * @param id，唯一ID
		 * 
		 */		
		public function removeData(id:int):void
		{
			var i:int,len:int=packages.length;
			var vo:RewardVo;
			for(i=0;i<len;i++)
			{
				vo=packages[i];
				if(vo.id==id)
				{
					packages.splice(i,1);
					break;
				}
			}
		}
		
		/**清空数据*/
		public function clearData():void
		{
			packages.length=0;
		}
		
		/**
		 *设置数据（会把原有的数据清空） 
		 * @param data <code>RewardInfo</code>
		 * 
		 */		
		public function setPackagesData(data:Array):void
		{
			var i:int,len:int=data.length;
			packages.length=0;
			for(i=0;i<len;i++)
			{
				var rewardVo:RewardVo=transRewardInfoToVo(data[i]);
				packages.push(rewardVo);
			}
			packages.sortOn("expiration_time",Array.NUMERIC);
		}
		
		/**检查背包是否有足够的格子来存放当前选中的礼包获得的奖励*/
		public function checkBagNumber():Boolean
		{
			if(current)
				return checkBagByVo([current]);
			return false;
		}
		/**检查背包是否有足够的格子来存放所有礼包获得的奖励*/
		public function checkBagAll():Boolean
		{
			return checkBagByVo(packages);
		}
		
		private function checkBagByVo(vos:Array):Boolean
		{
			var j:int,len2:int=vos.length;
			var vo:RewardVo;
			var eq:Vector.<ObjectAmount>=new Vector.<ObjectAmount>;
			var pp:Vector.<ObjectAmount>=new Vector.<ObjectAmount>;
			var i:int,len:int;
			var o:ObjectAmount;
			var item:RewardItemVo;
			for(j=0;j<len2;j++)
			{
				vo=vos[j];
				len=vo.items.length;
				for(i=0;i<len;i++)
				{
					item=vo.items[i];
					o=new ObjectAmount;
					o.amount=item.num;
					o.id=item.id;
					if(item.type==RewardTypes.EQUIP)
						eq.push(o);
					else if(item.type==RewardTypes.PROPS)
						pp.push(o);
				}
			}
			return BagStoreManager.instantce.containsEnoughSpace(eq,pp);
		}
		
		
		/**将<code>RewardInfo</code>解析成<code>RewardVo</code>*/
		private function transRewardInfoToVo(info:RewardInfo):RewardVo
		{
			var vo:RewardVo=new RewardVo;
			vo.expiration_time=info.rewardTime+7*24*3600;
			vo.id=info.rsId;
			vo.items=[];
			vo.type=info.rewardType;
			var j:int,len2:int,item:RewardItemVo;
			switch(vo.type)
			{
				case TypeRewardSource.Task:
					var taskName:String=TaskBasicManager.Instance.getTaskBasicVo(info.rewardId).name;
					vo.name=taskName;
					var task:Vector.<Task_rewardBasicVo>=Task_rewardBasicManager.Instance.getTaskRewards(info.rewardId);
					len2=task.length;
					for(j=0;j<len2;j++)
					{
						var temp:Task_rewardBasicVo=task[j];
						item=new RewardItemVo;
						item.id=temp.rw_id;
						item.num=temp.rw_num;
						item.type=temp.rw_type;
						vo.items.push(item);
					}
					break;
				case TypeRewardSource.Question:
					var question:QuestionRewardBasicVo=QuestionRewardBasicManager.Instance.getQuestionRewardBasicVo(info.rewardId);
					vo.name="智者千虑("+question.right_number+"题)";
					item=new RewardItemVo;
					item.id=question.item_id;
					item.num=question.item_number;
					item.type=RewardTypes.PROPS;
					vo.items.push(item);
					break;
				case TypeRewardSource.Compensation:
					vo.expiration_time=info.keepTime+info.rewardTime;
					vo.name=info.title+":"+info.matter;
					var rewards:Array=info.rewardGmInfo;
					len2=rewards.length;
					for(j=0;j<len2;j++)
					{
						item=new RewardItemVo;
						item.type=rewards[j].templateType;
						if(rewards[j].hasTemplateId)
							item.id=rewards[j].templateId;
						item.num=rewards[j].num;
						vo.items.push(item);
					}
					break;
				case TypeRewardSource.Copy:
					vo.name="副本奖励";
					var raidRewardVo:RaidRewardVo=RaidRewardManager.Instance.getRaidRewardVo(info.rewardId);
					item=new RewardItemVo;
					item.id=raidRewardVo.itemId;
					item.num=raidRewardVo.itemNumber;
					item.type=raidRewardVo.itemType;
					vo.items.push(item);
					break;
			}
			return vo;
		}
		
	}
}