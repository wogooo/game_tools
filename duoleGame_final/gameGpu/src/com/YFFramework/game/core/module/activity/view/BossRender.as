package com.YFFramework.game.core.module.activity.view
{
	import com.YFFramework.core.event.YFEventCenter;
	import com.YFFramework.game.core.global.TimeManager;
	import com.YFFramework.game.core.global.event.GlobalEvent;
	import com.YFFramework.game.core.global.model.FlyBootVo;
	import com.YFFramework.game.core.global.model.TaskWillDoVo;
	import com.YFFramework.game.core.global.util.TypeProps;
	import com.YFFramework.game.core.module.npc.manager.Npc_PositionBasicManager;
	import com.YFFramework.game.core.module.npc.model.Npc_PositionBasicVo;
	import com.dolo.ui.managers.UI;
	import com.dolo.ui.renders.ListRenderBase;
	import com.dolo.ui.tools.AutoBuild;
	import com.dolo.ui.tools.Xdis;
	
	import flash.display.SimpleButton;
	import flash.events.MouseEvent;
	import flash.text.TextField;

	/***
	 *
	 *@author ludingchang 时间：2014-1-16 上午10:44:02
	 */
	public class BossRender extends ListRenderBase
	{
		private var _nameTxt:TextField;
		private var _lvTxt:TextField;
		private var _flushTxt:TextField;
		private var _flyBtn:SimpleButton;
		private var _roadTxt:TextField;
		private var _npcId:int;
		public function BossRender()
		{
			_renderHeight = 28;
		}
		
		override protected function resetLinkage():void
		{
			_linkage = "activity.bossRender";
		}
		
		override protected function onLinkageComplete():void
		{
			AutoBuild.replaceAll(_ui);
			
			_nameTxt = Xdis.getChild(_ui,"nameTxt");
			_lvTxt = Xdis.getChild(_ui,"lvTxt");
			_flushTxt = Xdis.getChild(_ui,"flushTxt");
			_flyBtn = Xdis.getChild(_ui,"flyBtn");
			_roadTxt = Xdis.getChild(_ui,"roadTxt");
		}
		
		/**更新界面
		 * @param item
		 */		
		override protected function updateView(item:Object):void{
			_nameTxt.text = item.name;
			_lvTxt.text = item.lv;
			_flushTxt.text = TimeManager.getTimeStrFromSec(item.from_time)+"-"+TimeManager.getTimeStrFromSec(item.to_time);
			_roadTxt.text = "寻路";
			_roadTxt.addEventListener(MouseEvent.CLICK,onRoad);
			_flyBtn.addEventListener(MouseEvent.CLICK,onFly);
//			_taskVo = item.vo;
			_npcId=item.id;
//			_flyBootVo = item.flyBootVo;
			if(enableTime(item.from_time,item.to_time))
				this.filters=null;
			else
				this.filters=UI.disableFilter;
		}
		
		private function enableTime(t1:int,t2:int):Boolean
		{
			var now:int=TimeManager.getNowTime();
			return now>=t1 && now <=t2;
		}
		
		
		/**寻路点击
		 * @param e
		 */		
		private function onRoad(e:MouseEvent):void{
//			if(_color==TypeProps.COLOR_RED || _color==TypeProps.COLOR_GRAY){
//				NoticeUtil.setOperatorNotice("无法寻路");
//			}else{
				var vo:TaskWillDoVo = new TaskWillDoVo();
				vo.npcDyId = Npc_PositionBasicManager.Instance.getNpc_PositionBasicVo(_npcId).npc_id;
				vo.seach_type=TypeProps.TaskTargetType_Monster;
				YFEventCenter.Instance.dispatchEventWith(GlobalEvent.TaskMoveToNPC,vo);
//			}
		}
		
		/**小飞鞋道具点击
		 * @param e
		 */		
		private function onFly(e:MouseEvent):void{
//			if(_color==TypeProps.COLOR_RED || _color==TypeProps.COLOR_GRAY){
//				NoticeUtil.setOperatorNotice("无法使用传送道具");
//			}else{
			var vo:FlyBootVo=new FlyBootVo;
			var pos:Npc_PositionBasicVo=Npc_PositionBasicManager.Instance.getNpc_PositionBasicVo(_npcId);
			if(!pos) return;
			vo.mapX=pos.pos_x;
			vo.mapY=pos.pos_y;
			vo.mapId=pos.scene_id;
			vo.seach_id=pos.npc_id;
			YFEventCenter.Instance.dispatchEventWith(GlobalEvent.SKipToPlayer,vo);
//			}
		}
		
	}
}