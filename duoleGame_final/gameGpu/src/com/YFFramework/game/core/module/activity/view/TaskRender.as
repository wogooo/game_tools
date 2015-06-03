package com.YFFramework.game.core.module.activity.view
{
	import com.YFFramework.core.event.YFEventCenter;
	import com.YFFramework.game.core.global.event.GlobalEvent;
	import com.YFFramework.game.core.global.model.FlyBootVo;
	import com.YFFramework.game.core.global.model.TaskWillDoVo;
	import com.YFFramework.game.core.global.util.NoticeUtil;
	import com.YFFramework.game.core.global.util.TypeProps;
	import com.YFFramework.game.core.module.npc.manager.Npc_PositionBasicManager;
	import com.YFFramework.game.core.module.raid.model.RaidVo;
	import com.YFFramework.game.core.module.task.model.TaskBasicVo;
	import com.dolo.ui.renders.ListRenderBase;
	import com.dolo.ui.tools.AutoBuild;
	import com.dolo.ui.tools.Xdis;
	
	import flash.display.SimpleButton;
	import flash.events.MouseEvent;
	import flash.text.TextField;

	/**
	 * @version 1.0.0
	 * creation time：2013-10-23 下午1:51:18
	 */
	public class TaskRender extends ListRenderBase{
		
		private var _nameTxt:TextField;
		private var _lvTxt:TextField;
		private var _countTxt:TextField;
		private var _roadTxt:TextField;
		private var _flyBtn:SimpleButton;
		private var _color:uint;
		private var _taskVo:TaskBasicVo;
		private var _flyBootVo:FlyBootVo;
		private var _npcId:int;
		
		public function TaskRender(){
			_renderHeight = 28;
		}
		
		override protected function resetLinkage():void{
			_linkage = "activity.taskRender";
		}
		
		override protected function onLinkageComplete():void{
			AutoBuild.replaceAll(_ui);
			_nameTxt = Xdis.getChild(_ui,"nameTxt");
			_lvTxt = Xdis.getChild(_ui,"lvTxt");
			_countTxt = Xdis.getChild(_ui,"countTxt");
			_flyBtn = Xdis.getChild(_ui,"fly_btn");
			_roadTxt = Xdis.getChild(_ui,"roadTxt");
		}
		/**更新界面
		 * @param item
		 */		
		override protected function updateView(item:Object):void{
			_color = item.color;
			_nameTxt.text = item.name;
			_nameTxt.textColor = _color;
			_lvTxt.text = item.lv;
			_lvTxt.textColor = _color;
			_countTxt.text = item.taskNum+"/"+item.taskLimit;
			_countTxt.textColor = _color;
			_roadTxt.text = "寻路";
			_roadTxt.addEventListener(MouseEvent.CLICK,onRoad);
			_flyBtn.addEventListener(MouseEvent.CLICK,onFly);
			_taskVo = item.vo;
			_npcId=item.npcId;
			_flyBootVo = item.flyBootVo;
		}
		/**寻路点击
		 * @param e
		 */		
		private function onRoad(e:MouseEvent):void{
			if(_color==TypeProps.COLOR_RED || _color==TypeProps.COLOR_GRAY){
				NoticeUtil.setOperatorNotice("无法寻路");
			}else{
				var vo:TaskWillDoVo = new TaskWillDoVo();
				vo.npcDyId = Npc_PositionBasicManager.Instance.getNPCPositonBasicVo(_npcId).npc_id;
				YFEventCenter.Instance.dispatchEventWith(GlobalEvent.TaskMoveToNPC,vo);
			}
		}
		
		/**小飞鞋道具点击
		 * @param e
		 */		
		private function onFly(e:MouseEvent):void{
			if(_color==TypeProps.COLOR_RED || _color==TypeProps.COLOR_GRAY){
				NoticeUtil.setOperatorNotice("无法使用传送道具");
			}else{
				YFEventCenter.Instance.dispatchEventWith(GlobalEvent.SKipToPlayer,_flyBootVo);
			}
		}
	}
} 