package app
{
	import com.YFFramework.game.core.global.manager.AstarCache;
	import com.YFFramework.game.core.global.manager.BuffBasicManager;
	import com.YFFramework.game.core.global.manager.CharLevelExperienceBasicManager;
	import com.YFFramework.game.core.global.manager.CharacterPointBasicManager;
	import com.YFFramework.game.core.global.manager.ConfigDataManager;
	import com.YFFramework.game.core.global.manager.ConstMapBasicManager;
	import com.YFFramework.game.core.global.manager.EnhanceEffectBasicManager;
	import com.YFFramework.game.core.global.manager.EquipBasicManager;
	import com.YFFramework.game.core.global.manager.EquipSuitBasicManager;
	import com.YFFramework.game.core.global.manager.FightEffectBasicManager;
	import com.YFFramework.game.core.global.manager.Gather_ConfigBasicManager;
	import com.YFFramework.game.core.global.manager.MonsterBasicManager;
	import com.YFFramework.game.core.global.manager.ParticleBasicManager;
	import com.YFFramework.game.core.global.manager.PetBasicManager;
	import com.YFFramework.game.core.global.manager.PropsBasicManager;
	import com.YFFramework.game.core.global.manager.Scene_PositionBasicManager;
	import com.YFFramework.game.core.global.manager.SearchRoadBasicManager;
	import com.YFFramework.game.core.global.manager.SkillBasicManager;
	import com.YFFramework.game.core.global.manager.SkipPointBasicManager;
	import com.YFFramework.game.core.global.manager.StrRatioManager;
	import com.YFFramework.game.core.global.manager.Trap_ConfigBasicManager;
	import com.YFFramework.game.core.module.AnswerActivity.dataCenter.ActivityBasicManager;
	import com.YFFramework.game.core.module.AnswerActivity.dataCenter.answer.QuestionBasicManager;
	import com.YFFramework.game.core.module.AnswerActivity.dataCenter.answer.QuestionRewardBasicManager;
	import com.YFFramework.game.core.module.DivinePulses.manager.Divine_pulseBasicManager;
	import com.YFFramework.game.core.module.activity.manager.ActiveRewardBasicManager;
	import com.YFFramework.game.core.module.arena.data.ArenaBasicManager;
	import com.YFFramework.game.core.module.autoSetting.manager.FlushPeriodManager;
	import com.YFFramework.game.core.module.autoSetting.manager.FlushPosManager;
	import com.YFFramework.game.core.module.autoSetting.manager.FlushUnitManager;
	import com.YFFramework.game.core.module.bag.data.OpenCellBasicManager;
	import com.YFFramework.game.core.module.blackShop.data.BlackShopBasicManager;
	import com.YFFramework.game.core.module.character.model.TitleBasicManager;
	import com.YFFramework.game.core.module.exchange.manager.Exchange_GetBasicManager;
	import com.YFFramework.game.core.module.exchange.manager.Exchange_MapBasicManager;
	import com.YFFramework.game.core.module.exchange.manager.Exchange_NeedBasicManager;
	import com.YFFramework.game.core.module.feed.manager.FeedBasicVoManager;
	import com.YFFramework.game.core.module.forge.data.EquipAttrBasicManager;
	import com.YFFramework.game.core.module.forge.data.EquipDecompBasicManager;
	import com.YFFramework.game.core.module.forge.data.EquipEnhanceBasicManager;
	import com.YFFramework.game.core.module.forge.data.EquipLevelUpBasicManager;
	import com.YFFramework.game.core.module.forge.data.MergeGemBasicManager;
	import com.YFFramework.game.core.module.gift.manager.New_player_giftBasicManager;
	import com.YFFramework.game.core.module.gift.manager.SignPackageBasicManager;
	import com.YFFramework.game.core.module.giftYellow.manager.Vip_rewardBasicManager;
	import com.YFFramework.game.core.module.growTask.manager.GrowTaskDyManager;
	import com.YFFramework.game.core.module.guild.manager.Guild_BuildingBasicManager;
	import com.YFFramework.game.core.module.mapScence.manager.MapSceneBasicManager;
	import com.YFFramework.game.core.module.market.data.manager.MarketConfigBasicManager;
	import com.YFFramework.game.core.module.market.data.manager.MarketTypeConfigBasicManager;
	import com.YFFramework.game.core.module.mount.manager.MountBasicManager;
	import com.YFFramework.game.core.module.mount.manager.MountLvBasicManager;
	import com.YFFramework.game.core.module.notice.manager.NoticeBasicManager;
	import com.YFFramework.game.core.module.npc.manager.Npc_ConfigBasicManager;
	import com.YFFramework.game.core.module.npc.manager.Npc_PositionBasicManager;
	import com.YFFramework.game.core.module.onlineReward.manager.OnlineRewardBasicManager;
	import com.YFFramework.game.core.module.pet.manager.PetLevelXpManager;
	import com.YFFramework.game.core.module.raid.manager.RaidManager;
	import com.YFFramework.game.core.module.raid.manager.RaidRewardManager;
	import com.YFFramework.game.core.module.raid.manager.RaidRewardShowManager;
	import com.YFFramework.game.core.module.raid.manager.RaidTimeBasicManager;
	import com.YFFramework.game.core.module.rank.data.RankBasicManager;
	import com.YFFramework.game.core.module.shop.data.ShopBasicManager;
	import com.YFFramework.game.core.module.story.manager.StoryBasicManager;
	import com.YFFramework.game.core.module.task.manager.TaskBasicManager;
	import com.YFFramework.game.core.module.task.manager.Task_dialogBasicManager;
	import com.YFFramework.game.core.module.task.manager.Task_libBasicManager;
	import com.YFFramework.game.core.module.task.manager.Task_loopBasicManager;
	import com.YFFramework.game.core.module.task.manager.Task_rewardBasicManager;
	import com.YFFramework.game.core.module.task.manager.Task_run_ringsBasicManager;
	import com.YFFramework.game.core.module.task.manager.Task_targetBasicManager;
	import com.YFFramework.game.core.module.wing.model.WingEnhanceManager;
	
	import flash.utils.ByteArray;

	/**解析json数据 
	 * @author yefeng
	 * 2013 2013-8-15 上午11:32:50 
	 */
	public class DataParse
	{
		/**数据是否已经解析完成
		 */
//		public static var dataComplete:Boolean=false;
		public function DataParse()
		{
		}
		/**解析json数据
		 */		
		public static function parseInt(bytes:ByteArray):void
		{
			bytes.uncompress();
			var childBytes:ByteArray;
			var id:int;
			var len:int;
			var jsonObj:Object;
			while(bytes.bytesAvailable)
			{
				len=bytes.readInt();
				childBytes=new ByteArray();
				bytes.readBytes(childBytes,0,len);
				id=childBytes.readInt();
				jsonObj=childBytes.readObject();
				switch(id)
				{
					case 1001:
						//角色基础属性表
						PropsBasicManager.Instance.cacheData(jsonObj);
						break;
					case 1002:
						//装备基础属性表
						EquipBasicManager.Instance.cacheData(jsonObj);
						break;
					case 1003:
						//套装属性表。
						EquipSuitBasicManager.Instance.cacheData(jsonObj);
						break;
					case 1005:
						//套装属性表。
						EnhanceEffectBasicManager.Instance.cacheData(jsonObj);
						break;
					case 1011:
						PetLevelXpManager.Instance.cacheData(jsonObj);
						break;
					case 1012:
						PetBasicManager.Instance.cacheData(jsonObj);
						break;
					case 1013:
						StrRatioManager.Instance.cacheData(jsonObj);
						break;
					case 1021:
						MountLvBasicManager.Instance.cacheData(jsonObj);
						break;
					case 1022:
						MountBasicManager.Instance.cacheData(jsonObj);
						break;
					case 1031:
						RaidManager.Instance.cacheData(jsonObj);
						break;
					case 1032:
						RaidTimeBasicManager.Instance.cacheData(jsonObj);
						break;
					case 1041:
						GrowTaskDyManager.Instance.cacheData(jsonObj);
						break;
					case 1051:
						FlushPosManager.Instance.cacheData(jsonObj);
						break;
					case 1052:
						FlushUnitManager.Instance.cacheData(jsonObj);
						break;
					case 1053:
						FlushPeriodManager.Instance.cacheData(jsonObj);
						break;
					case 1061:
						NoticeBasicManager.Instance.cacheData(jsonObj);
						break;
					case 1071:
						WingEnhanceManager.Instance.cacheData(jsonObj);
						break;
					case 2001:
						//装备基础属性表
						ShopBasicManager.Instance.cacheData(jsonObj);
						break;
					case 3001:
						//装备基础属性表
						SkillBasicManager.Instance.cacheData(jsonObj);
						break;
					case 3002:
						//装备基础属性表
						FightEffectBasicManager.Instance.cacheData(jsonObj);
						break;
					case 3003:
						//装备基础属性表
						BuffBasicManager.Instance.cacheData(jsonObj);
						break;
					case 3004: //技能陷阱表
						//
						Trap_ConfigBasicManager.Instance.cacheData(jsonObj);
						break;
					case 3005: //技能粒子表
						//
						ParticleBasicManager.Instance.cacheData(jsonObj);
						break;
					case 5001:
						//任务表
						TaskBasicManager.Instance.cacheData(jsonObj);
						break;
					case 5002:
						//任务奖励表
						Task_rewardBasicManager.Instance.cacheData(jsonObj);
						break;
					case 5003:
						//任务奖励表
						//TaskBasicManager.Instance.addTargetData(jsonObj);
						Task_targetBasicManager.Instance.cacheData(jsonObj);
						break;
					case 5004:
						//任务对话表
						Task_dialogBasicManager.Instance.cacheData(jsonObj);
						break;
					case 5005:
						//任务
						Task_loopBasicManager.Instance.cacheData(jsonObj);
						break;
					case 5006:
						//任务库
						Task_libBasicManager.Instance.cacheData(jsonObj);
						break;
					case 5007:
						Task_run_ringsBasicManager.Instance.cacheData(jsonObj);
						break;
					case 7001: ///地图场景表
						MapSceneBasicManager.Instance.cacheData(jsonObj);
						break;
					case 7002: ///地图场景跳转配置表
						SkipPointBasicManager.Instance.cacheData(jsonObj);
						break;
					case 7003: ///地图场景跳转配置表
						SearchRoadBasicManager.Instance.cacheData(jsonObj);
						break;
					case 7010:
						Gather_ConfigBasicManager.Instance.cacheData(jsonObj);
						break;
					case 7020:  ///npc配置表 
						Npc_ConfigBasicManager.Instance.cacheData(jsonObj);
						break;
					case 7021:  ///npc位置刷新表
						Npc_PositionBasicManager.Instance.cacheData(jsonObj);
						break;
					case 7030:  ///id和位置映射表R
						Scene_PositionBasicManager.Instance.cacheData(jsonObj);
						break;
					case 8001:
						MonsterBasicManager.Instance.cacheData(jsonObj);
						break;
					case 9001:
						//角色加点
						CharacterPointBasicManager.Instance.cacheData(jsonObj);
						break;
					case 9002:
						//人物等级经验表
						CharLevelExperienceBasicManager.Instance.cacheData(jsonObj);
						break;
					case 9003:
						ConstMapBasicManager.Instance.cacheData(jsonObj);
						break;
					case 9004://称号配置表
						TitleBasicManager.Instance.cacheData(jsonObj);
						break;
					case 9010://市场分类物品配置表
						MarketConfigBasicManager.Instance.cacheData(jsonObj);
						break;
					case 9011://市场分类名称配置表
						MarketTypeConfigBasicManager.Instance.cacheData(jsonObj);
						break;
					case 9012://排行榜配置表
						RankBasicManager.Instance.cacheData(jsonObj);
						break;
					case 9020://合成宝石配置表
						MergeGemBasicManager.Instance.cacheData(jsonObj);
						break;
					case 9021://装备分解配置表
						EquipDecompBasicManager.Instance.cacheData(jsonObj);
						break;
					case 10001://公会建筑配置表
						Guild_BuildingBasicManager.Instance.cacheData(jsonObj);
						break;
					case 10002://剧情配置表
						StoryBasicManager.Instance.cacheData(jsonObj);
						break;
					case 10010://活动配置表
						ActivityBasicManager.Instance.cacheData(jsonObj);
						break;
					case 10011://答题活动问题配置表
						QuestionBasicManager.Instance.cacheData(jsonObj);
						break;
					case 10012://答题活动奖励配置表
						QuestionRewardBasicManager.Instance.cacheData(jsonObj);
						break;
					case 10020://兑换奖励表
						Exchange_GetBasicManager.Instance.cacheData(jsonObj);
						break;
					case 10021://兑换需求表
						Exchange_NeedBasicManager.Instance.cacheData(jsonObj);
						break;
					case 10022://兑换匹配表
						Exchange_MapBasicManager.Instance.cacheData(jsonObj);
						break;
					case 10030://装备品质进阶
						EquipLevelUpBasicManager.Instance.cacheData(jsonObj);
						break;
					case 10031://装备强化表
						EquipEnhanceBasicManager.Instance.cacheData(jsonObj);
						break;
					case 10040://活动奖励表
						ActiveRewardBasicManager.Instance.cacheData(jsonObj);
						break; 
					case 10041://在线奖励表
						OnlineRewardBasicManager.Instance.cacheData(jsonObj);
						break;
					case 10042://签到礼包表
						SignPackageBasicManager.Instance.cacheData(jsonObj);
						break;
					case 10043://新手礼包表
						New_player_giftBasicManager.Instance.cacheData(jsonObj);
						break;
					case 10050://黑市商店表
						BlackShopBasicManager.Instance.cacheData(jsonObj);
						break;
					case 10060://竞技场表
						ArenaBasicManager.Instance.cacheData(jsonObj);
						break;
					case 10070://a星寻路缓存
						AstarCache.Instance.cache(jsonObj);
						break;
					case 10080://副本奖励表
						RaidRewardManager.Instance.cacheData(jsonObj);
						break;
					case 10090://副本奖励显示表
						RaidRewardShowManager.Instance.cacheData(jsonObj);
						break;
					case 10100://装备属性值计算的属性表
						EquipAttrBasicManager.Instance.cacheData(jsonObj);
						break;
					case 10110://天命神脉
						Divine_pulseBasicManager.Instance.cacheData(jsonObj);
						break;
					case 10120://feed分享
						FeedBasicVoManager.Instence().cacheData(jsonObj);
						break;
					case 10121://黄钻礼包表
						Vip_rewardBasicManager.Instance.cacheData(jsonObj);
						break;
					case 10130://常量数值配置表
						ConfigDataManager.Instance.cacheData(jsonObj);
						break;
					case 10140://时间开启背包格子表
						OpenCellBasicManager.Instance.cacheData(jsonObj);
						break;
				}
			}
		}
		
		
		
		
	}
}