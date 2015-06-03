package com.YFFramework.game.core.module.activity.view
{
	import com.YFFramework.game.core.global.DataCenter;
	import com.YFFramework.game.core.global.model.FlyBootVo;
	import com.YFFramework.game.core.global.util.TypeProps;
	import com.YFFramework.game.core.module.activity.model.ActiveBaseRewardVo;
	import com.YFFramework.game.core.module.activity.model.ActiveBaseVo;
	import com.YFFramework.game.core.module.activity.model.TypeRewardShow;
	import com.YFFramework.game.core.module.npc.manager.Npc_ConfigBasicManager;
	import com.YFFramework.game.core.module.npc.manager.Npc_PositionBasicManager;
	import com.YFFramework.game.core.module.npc.model.Npc_ConfigBasicVo;
	import com.YFFramework.game.core.module.npc.model.Npc_PositionBasicVo;
	import com.YFFramework.game.core.module.raid.manager.RaidManager;
	import com.YFFramework.game.core.module.raid.manager.RaidRewardShowManager;
	import com.YFFramework.game.core.module.raid.model.RaidRewardShowVo;
	import com.YFFramework.game.core.module.raid.model.RaidVo;
	import com.YFFramework.game.core.module.systemReward.data.TypeRewardSource;
	import com.dolo.ui.data.ListItem;
	
	import flash.display.MovieClip;
	import flash.utils.Dictionary;

	/**
	 * @version 1.0.0
	 * creation time：2013-9-11 下午1:27:37
	 */
	public class RaidView extends ActiveViewBase
	{
		
		private var _shilianzhimenId:int=5;//试炼之门副本id
		
		public function RaidView(mc:MovieClip)
		{
			super(mc);
		}
		
		protected override function setRender():void
		{
			_list.itemRender= RaidRender;
		}
		
		/**副本排序
		 * @param x
		 * @param y
		 * @return 
		 */		
		private function sortFunc(x:RaidVo,y:RaidVo):int{
			var lv:int = DataCenter.Instance.roleSelfVo.roleDyVo.level;
			if(x.raidNum<x.raidLimit && lv>=x.minLv && lv<=x.maxLv){
				if(y.raidNum==y.raidLimit || lv<y.minLv || lv>y.maxLv)	return -1;
			}else if(lv<x.minLv || lv>x.maxLv){
				if(y.raidNum==y.raidLimit)	return -1;
				else if(lv>=y.minLv && lv<=y.maxLv)	return 1;
			}else if(x.raidNum==x.raidLimit){
				if(y.raidNum!=y.raidLimit)	return 1;
			}
			if(x.minLv<y.minLv)	return -1;
			else if(x.minLv>y.minLv)	return 1;
			else{
				if(x.raidId>y.raidId)	return -1;
				else	return 1;
			}
			return -1;
		}
		
		/**切换更新
		 */		
		public override function onTabUpdate():void{
			_list.removeAll();
			
			var item:ListItem;
			var arr:Array = RaidManager.Instance.getRaidGroups();
			var raidVoArr:Array = new Array();
			var len:int = arr.length;
			for(var i:int=0;i<len;i++){
				var vo:RaidVo = RaidManager.Instance.getNearestRaidVoByGroupId(arr[i]);
				if(vo!=null)	raidVoArr.push(vo);
			}
			raidVoArr.sort(sortFunc);
			len = raidVoArr.length;
			var firstEntry:Boolean=true;
			for(i=0;i<len;i++){
				vo = RaidVo(raidVoArr[i]);
				if(vo.raidType!=3 && vo.activityId==0 && vo.raidId!=_shilianzhimenId){
					item = new ListItem();
					item.vo = vo;
					item.name = vo.raidName;
					item.lv = vo.minLv;
					item.raidNum = vo.raidNum;
					item.raidLimit = vo.raidLimit;
					if(vo.raidType==1)	item.raidType="单人";
					else	item.raidType="组队";
					item.flyBootVo = new FlyBootVo();
					var dict:Dictionary = Npc_ConfigBasicManager.Instance.getNPCList();
					for each (var npcVo:Npc_ConfigBasicVo in dict){
						if(npcVo.func_type1==3 && npcVo.func_id1==vo.groupId || npcVo.func_type2==3 && npcVo.func_id2==vo.groupId || npcVo.func_type3==3 && npcVo.func_id3==vo.groupId){
							var posVo:Npc_PositionBasicVo=Npc_PositionBasicManager.Instance.getNpcPosVoByNpcBasicId(npcVo.basic_id);
							item.flyBootVo.mapX = posVo.pos_x;
							item.flyBootVo.mapY = posVo.pos_y;
							item.flyBootVo.mapId = posVo.scene_id;
							item.flyBootVo.seach_id = posVo.npc_id;
							item.npcId = posVo.basic_id;
						}
					}
					if(vo.raidNum==vo.raidLimit)	item.color=TypeProps.COLOR_GRAY;
					else if(DataCenter.Instance.roleSelfVo.roleDyVo.level<vo.minLv||DataCenter.Instance.roleSelfVo.roleDyVo.level>vo.maxLv)
						item.color=TypeProps.COLOR_RED;
					else	item.color=TypeProps.COLOR_WHITE;
					
					_list.addItem(item);
					if(firstEntry==true)	_list.selectedItem = item;
					firstEntry=false;
					
				}
			}
		}
		
		protected override function getActiveBaseVo():ActiveBaseVo
		{
			var vo:RaidVo=_list.selectedItem.vo;
			var vec:Vector.<RaidRewardShowVo> = RaidRewardShowManager.Instance.getRewardShowVoByIdAndType(TypeRewardShow.TypeRaid,vo.rewardShowId);
			var activeBaseVo:ActiveBaseVo=new ActiveBaseVo;
			activeBaseVo.desc=vo.raidDesc;
			activeBaseVo.expStar=vo.expStar;
			activeBaseVo.moneyStar=vo.moneyStar;
			activeBaseVo.propsStar=vo.propsStar;
			var i:int,len:int=vec.length;
			for(i=0;i<len;i++)
			{
				var reward:ActiveBaseRewardVo=new ActiveBaseRewardVo;
				reward.id=vec[i].itemId;
				reward.type=vec[i].rewardType;
				activeBaseVo.rewards.push(reward);
			}
			return activeBaseVo;
		}
	}
}