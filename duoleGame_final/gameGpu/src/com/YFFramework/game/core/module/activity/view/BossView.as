package com.YFFramework.game.core.module.activity.view
{
	import com.YFFramework.core.ui.movie.__BitmapMovieClip;
	import com.YFFramework.game.core.global.TimeManager;
	import com.YFFramework.game.core.global.manager.MonsterBasicManager;
	import com.YFFramework.game.core.global.model.MonsterBasicVo;
	import com.YFFramework.game.core.module.activity.model.ActiveBaseRewardVo;
	import com.YFFramework.game.core.module.activity.model.ActiveBaseVo;
	import com.YFFramework.game.core.module.activity.model.TypeRewardShow;
	import com.YFFramework.game.core.module.autoSetting.manager.FlushPeriodManager;
	import com.YFFramework.game.core.module.autoSetting.manager.FlushUnitManager;
	import com.YFFramework.game.core.module.autoSetting.model.FlushPeriodVo;
	import com.YFFramework.game.core.module.mapScence.world.model.type.TypeRole;
	import com.YFFramework.game.core.module.raid.manager.RaidRewardShowManager;
	import com.YFFramework.game.core.module.raid.model.RaidRewardShowVo;
	import com.dolo.ui.data.ListItem;
	import com.dolo.ui.tools.AutoBuild;
	
	import flash.display.MovieClip;

	/**
	 * @version 1.0.0
	 * creation time：2013-10-28 下午1:51:56
	 */
	public class BossView extends ActiveViewBase
	{
		
		private var _bossData:Vector.<ListItem>;
		private var _now:int;
		public function BossView(mc:MovieClip){
			_showStar=false;
			super(mc);
			_showStar=false;
			_bossData=new Vector.<ListItem>;
		}
		
		protected override function setRender():void
		{
			_list.itemRender = BossRender;
		}
		
		protected override function getActiveBaseVo():ActiveBaseVo
		{
			var vo:FlushPeriodVo=_list.selectedItem.vo;
			var vec:Vector.<RaidRewardShowVo>=RaidRewardShowManager.Instance.getRewardShowVoByIdAndType(TypeRewardShow.TypeBoss,vo.flush_id);
			var actVo:ActiveBaseVo=new ActiveBaseVo;
			actVo.desc="暂无";
			if(vec)
			{
				var i:int,len:int=vec.length;
				for(i=0;i<len;i++)
				{
					var reward:ActiveBaseRewardVo=new ActiveBaseRewardVo;
					reward.id=vec[i].itemId;
					reward.type=vec[i].rewardType;
					actVo.rewards.push(reward);
				}
			}
			return actVo;
		}
		
		public override function onTabUpdate():void
		{
			_list.removeAll();
			var i:int,len:int
			if(_bossData.length==0)
			{
				var flush:Vector.<FlushPeriodVo>=FlushPeriodManager.Instance.getAll();
				len=flush.length;
				for(i=0;i<len;i++)
				{
					var mst:int=FlushUnitManager.Instance.getMonster(flush[i].flush_id);
					var monster:MonsterBasicVo=MonsterBasicManager.Instance.getMonsterBasicVo(mst);
//					if(monster&&monster.monster_type==TypeRole.MonsterType_Boss)
						addBoss(monster,flush[i]);
				}
			}
			_now=TimeManager.getNowTime();
			_bossData.sort(compare);
			
			len=_bossData.length;
			for(i=0;i<len;i++)
			{
				_list.addItem(_bossData[i]);
			}
		}
		
		private function addBoss(monster:MonsterBasicVo,flush:FlushPeriodVo):void
		{
			var item:ListItem=new ListItem();
			item.vo=flush;
			item.name=monster.name;
			item.lv=monster.level;
			item.from_time=TimeManager.getTimeToZero(flush.from_time);
			item.to_time=TimeManager.getTimeToZero(flush.to_time);
			item.id=monster.unit_id;
			_bossData.push(item);
		}
		
		/**
		 *若返回值为负，则表示 A 在排序后的序列中出现在 B 之前。
		 *若返回值为 0，则表示 A 和 B 具有相同的排序顺序。
		 *若返回值为正，则表示 A 在排序后的序列中出现在 B 之后。 
		 */		
		private function compare(A:ListItem,B:ListItem):int
		{
			var enA:Boolean=timeEnable(A.from_time,A.to_time);
			var enB:Boolean=timeEnable(B.from_time,B.to_time);
			if(enA==enB)//同时满足或同时不满足
			{
				return A.lv-B.lv;
			}
			else if(enA)
				return -1;
			else
				return 1;
		}
		
		private function timeEnable(t1:int,t2:int):Boolean
		{
			return (_now>=t1) && (_now<=t2);
		}
		
	}
} 