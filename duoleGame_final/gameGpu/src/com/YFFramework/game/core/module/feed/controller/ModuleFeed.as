package com.YFFramework.game.core.module.feed.controller
{
	import com.CMD.GameCmd;
	import com.YFFramework.core.center.abs.module.AbsModule;
	import com.YFFramework.core.debug.print;
	import com.YFFramework.core.event.YFEvent;
	import com.YFFramework.core.event.YFEventCenter;
	import com.YFFramework.game.core.global.DataCenter;
	import com.YFFramework.game.core.global.event.GlobalEvent;
	import com.YFFramework.game.core.global.manager.CharacterDyManager;
	import com.YFFramework.game.core.global.manager.EquipBasicManager;
	import com.YFFramework.game.core.global.manager.PetBasicManager;
	import com.YFFramework.game.core.global.model.EquipDyVo;
	import com.YFFramework.game.core.global.util.TypeProps;
	import com.YFFramework.game.core.module.demon.event.DemonEvent;
	import com.YFFramework.game.core.module.feed.event.FeedEvent;
	import com.YFFramework.game.core.module.feed.manager.FeedBasicVoManager;
	import com.YFFramework.game.core.module.feed.manager.FeedManager;
	import com.YFFramework.game.core.module.feed.model.FeedBasicVo;
	import com.YFFramework.game.core.module.feed.model.FeedID;
	import com.YFFramework.game.core.module.giftYellow.manager.YellowAPIManager;
	import com.YFFramework.game.core.module.growTask.event.GrowTaskEvent;
	import com.YFFramework.game.core.module.newGuide.manager.NewGuideManager;
	import com.YFFramework.game.core.module.pet.manager.PetDyManager;
	import com.YFFramework.game.core.module.pet.model.PetDyVo;
	import com.YFFramework.game.core.module.rank.data.RankDyManager;
	import com.YFFramework.game.core.module.rank.source.RankSource;
	import com.YFFramework.game.gameConfig.URLTool;
	import com.msg.enumdef.RspMsg;
	import com.msg.hero.CBeginPay;
	import com.msg.hero.CFeedID;
	import com.msg.hero.SBeginPay;
	import com.msg.hero.SFeedID;
	import com.net.MsgPool;
	
	import flash.external.ExternalInterface;

	/***
	 *feed分享控制类
	 * 应用图标的URL还没写到API里，（不知道url去哪里取）
	 *@author ludingchang 时间：2013-12-4 下午1:52:14
	 */
	public class ModuleFeed extends AbsModule
	{
		private var _feedImg:String;
		public function ModuleFeed()
		{
			super();
			_feedImg=URLTool.getCommonAssets("feed.png");
		}
		public override function init():void
		{ 
			onGameIn();
			YFEventCenter.Instance.addEventListener(GlobalEvent.FeedSend,onFeedSend);//发送分享
			YFEventCenter.Instance.addEventListener(GlobalEvent.HeroLevelUp,onHeroLevelUp);//主角升级
			YFEventCenter.Instance.addEventListener(GrowTaskEvent.PetChange,onOwnPet);//拥有宠物
			YFEventCenter.Instance.addEventListener(GrowTaskEvent.HasHeroEquip,onHasHeroEquip);//拥有装备
			YFEventCenter.Instance.addEventListener(GrowTaskEvent.activity_arena,onActivityArena);//大乱斗活动
			YFEventCenter.Instance.addEventListener(DemonEvent.DemonLevelChange,onDemonLevelChange);//魔族入侵波数增加
			YFEventCenter.Instance.addEventListener(FeedEvent.EquipStrength,onEquipStrength);//装备强化
			YFEventCenter.Instance.addEventListener(GlobalEvent.finishTaskOK,onFinishTaskOK);//完成任务
			YFEventCenter.Instance.addEventListener(FeedEvent.PKWin,onPKWin);//切磋胜利
			YFEventCenter.Instance.addEventListener(FeedEvent.RaidWin,onRaidWin);//通过副本
			YFEventCenter.Instance.addEventListener(FeedEvent.SaveFeedID,onSaveFeedID);//保存feed数据
			YFEventCenter.Instance.addEventListener(FeedEvent.InviteFriends,onInviteFriends);//邀请好友
			YFEventCenter.Instance.addEventListener(GlobalEvent.Recharge,onRecharge);//充值
			//网络消息
			MsgPool.addCallBack(GameCmd.SFeedID,SFeedID,onFeedID);
			MsgPool.addCallBack(GameCmd.SBeginPay,SBeginPay,onBeginPay);//开始充值回复
		}
		
		/**因为这个值需要比其他模块早，所以一初始化就应该请求*/
		private function onGameIn():void
		{
			YFEventCenter.Instance.removeEventListener(GlobalEvent.GameIn,onGameIn);
			
			var msg:CFeedID=new CFeedID;
			MsgPool.sendGameMsg(GameCmd.CFeedID,msg);//msg为空，表示查询
			print(this,"查询feed信息");
		}
		
		private function onRecharge(e:YFEvent):void
		{
			var msg:CBeginPay=new CBeginPay;
			msg.pfkey=YellowAPIManager.Instence.pfkey;
			msg.payItem=YellowAPIManager.Instence.goods_id+"*10*1";
			msg.goodsUrl=YellowAPIManager.Instence.goods_url;
			MsgPool.sendGameMsg(GameCmd.CBeginPay,msg);
			trace(this,"请求充值："+msg);
		}
		
		private function onSaveFeedID(e:YFEvent):void
		{
			var temp:int=e.param as int;
			var msg:CFeedID=new CFeedID;
			msg.feedId=temp;
			MsgPool.sendGameMsg(GameCmd.CFeedID,msg);//msg不为空，表示写数据
			print(this,"写Feed信息  data："+temp);
		}
		
		private function onFeedID(msg:SFeedID):void
		{
			FeedManager.Instence.globle_data=msg.feedId;
			print(this,"收到feed deta:"+msg.feedId);
		}
		
		private function onRaidWin(e:YFEvent):void
		{
			check(FeedID.RAID_WIN);
		}
		
		private function onPKWin(e:YFEvent):void
		{
			check(FeedID.PK_WIN);
		}
		
		private function onFinishTaskOK(e:YFEvent):void
		{
			var task_id:int=e.param as int;
			if(task_id==61)//日常任务的任务ID=61
				check(FeedID.DAY_TASK);
		}
		
		private function onEquipStrength(e:YFEvent):void
		{
			var level:int=e.param as int;
			if(level==10)
				check(FeedID.ITEM_STRENGTHEN_TO_10);
		}
		
		private function onDemonLevelChange(e:YFEvent):void
		{
			var max:int= e.param as int;
			if(max>=1)
				check(FeedID.TD_ENTER);
			else if(max>=30)
				check(FeedID.TD_30_COUNT);
			else if(max>=40)
				check(FeedID.TD_40_COUNT);
			else if(max>=50)
				check(FeedID.TD_50_COUNT);
			else if(max>=60)
				check(FeedID.TD_60_COUNT);
			else if(max>=70)
				check(FeedID.TD_70_COUNT);
			else if(max>=80)
				check(FeedID.TD_80_COUNT);
			else if(max>=90)
				check(FeedID.TD_90_COUNT);
			else if(max>=100)
				check(FeedID.TD_100_COUNT);
		}
		
		private function onActivityArena(e:YFEvent):void
		{//大乱斗排名
			var rank:int=RankDyManager.instance.getMyRankIndex(RankSource.TITLE_ACTIVITY41);
			if(rank==1)
				check(FeedID.PK_1ST);
			else if(rank==2)
				check(FeedID.PK_2ND);
			else if(rank==3)
				check(FeedID.PK_3RD);
		}
		
		private function onHasHeroEquip(e:YFEvent):void
		{
			var equips:Array=CharacterDyManager.Instance.getAllEquips();
			var i:int,len:int=equips.length;
			var eq:EquipDyVo;
			for(i=0;i<len;i++)
			{
				eq=equips[i];
				if(EquipBasicManager.Instance.getEquipBasicVo(eq.template_id).quality==TypeProps.QUALITY_PURPLE)
					check(FeedID.GET_EPIC_ITEM);
			}
		}
		
		private function onOwnPet(e:YFEvent):void
		{
			var pets:Array=PetDyManager.Instance.getPetIdArray();
			var i:int,len:int=pets.length;
			for(i=0;i<len;i++ )
			{
				var pet:PetDyVo=PetDyManager.Instance.getPetDyVo(pets[i]);
				if(PetDyManager.Instance.getGrowQuality(pet.dyId)==5)//橙色宠物
					check(FeedID.GET_EPIC_PET);
				if(PetBasicManager.Instance.getPetConfigVo(pet.basicId).pet_type==6)//小天使
					check(FeedID.GET_PET_ANGLE);
				else if(PetBasicManager.Instance.getPetConfigVo(pet.basicId).pet_type==7)//小恶魔
					check(FeedID.GET_PET_DEVIL);
			}
		}
		
		private function onHeroLevelUp(e:YFEvent):void
		{
			var lv:int=DataCenter.Instance.roleSelfVo.roleDyVo.level;
			if(lv==NewGuideManager.MaxGuideLevel)
				check(FeedID.OVER_NEW_GUIDE);
			else if(lv==40)
				check(FeedID.LEVEL_40);
			else if(lv==50)
				check(FeedID.LEVEL_50);
			else if(lv==60)
				check(FeedID.LEVEL_60);
			else if(lv==70)
				check(FeedID.LEVEL_70);
			else if(lv==80)
				check(FeedID.LEVEL_80);
			else if(lv==90)
				check(FeedID.LEVEL_90);
			else if(lv==100)
				check(FeedID.LEVEL_100);
		}
		
		private function onFeedSend(e:YFEvent):void
		{
			var id:int=e.param as int;
			check(id);
		}
		
		private function check(id:int):void
		{
			if(FeedManager.Instence.shouldShow(id))
			{
				FeedManager.Instence.show(id);
				
				//调用对应API
				callAPI(id);
			}
		}
		
		private function callAPI(id:int):void
		{
			var vo:FeedBasicVo=FeedBasicVoManager.Instence().getFeedBasicVo(id);
			ExternalInterface.call("fusion2.dialog.sendStory",
				{
					title:vo.title,
//					img:vo.img,//这个现在没有，需要问策划；
					img:_feedImg,//只有一个不需要在表里配置，以后如果多就在表里面配置
					summary:vo.story,
					msg:vo.content
				});//调用分享API
			print(this,"调用feed api id=:"+id);
		}
		
		private function onInviteFriends(e:YFEvent):void
		{
			//调用腾讯邀请好友的api
			ExternalInterface.call("fusion2.dialog.invite",
				{
					msg:"小伙伴快来玩《勇者之光》啊~~~~~~~~~~",
					img:_feedImg
					//					receiver:""//默认选好的朋友ID，暂时不填
				});
		}
		
		private function onBeginPay(msg:SBeginPay):void
		{
			if(msg.ret==RspMsg.RSPMSG_SUCCESS)
			{//调用充值API
				var token:String=msg.token;
				var url_param:String=msg.urlParams;
				ExternalInterface.call("fusion2.dialog.buy",
					{
						disturb : true,//道具寄售模式需要
						param:url_param,
						//测试用					param:"v1/m01/10227/pay/exchange_goods?token_id=4021A324754CCD7EA01836261D0AFF7207622&sig=5b9feed5b43b8f8f829d19fb489814e4",
						sandbox:true//沙箱调试模式						
					});
				print(this,"调用充值API  param:"+url_param);
			}
			else
			{
				print(this,"服务端返回：调用充值接口失败");
			}
		}
	}
}