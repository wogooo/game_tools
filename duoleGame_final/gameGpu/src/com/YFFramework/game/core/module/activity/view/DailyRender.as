package com.YFFramework.game.core.module.activity.view
{
	import com.YFFramework.game.core.global.model.FlyBootVo;
	import com.YFFramework.game.core.module.AnswerActivity.dataCenter.ActivityBasicVo;
	import com.dolo.ui.renders.ListRenderBase;
	import com.dolo.ui.tools.AutoBuild;
	import com.dolo.ui.tools.Xdis;
	
	import flash.display.SimpleButton;
	import flash.text.TextField;

	/**
	 * @version 1.0.0
	 * creation time：2013-10-25 下午5:38:08
	 */
	public class DailyRender extends ListRenderBase{
		
		private var _nameTxt:TextField;
		private var _lvTxt:TextField;
		private var _statusTxt:TextField;
		private var _countTxt:TextField;
		private var _roadTxt:TextField;
		private var _flyBtn:SimpleButton;
		private var _color:uint;
		private var _activityVo:ActivityBasicVo;
		private var _flyBootVo:FlyBootVo;
		private var _npcId:int;
		
		public function DailyRender(){
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
			
			_roadTxt.text = "";
			_flyBtn.visible=false;
		}
		
		override protected function updateView(item:Object):void{
			_color = item.color;
			_nameTxt.text = item.name;
			_nameTxt.textColor = _color;
			_lvTxt.text = item.lv;
			_lvTxt.textColor = _color;
			_countTxt.text = item.timeDesc;
			_countTxt.textColor = _color;
			
			
			//_roadTxt.addEventListener(MouseEvent.CLICK,onRoad);
			//_flyBtn.addEventListener(MouseEvent.CLICK,onFly);
			_activityVo = item.vo;
//			_npcId=item.npcId;
//			_flyBootVo = item.flyBootVo;
		}
//		/**寻路点击 
//		 * @param e
//		 */		
//		private function onRoad(e:MouseEvent):void{
//			if(_color==TypeProps.COLOR_RED || _color==TypeProps.COLOR_GRAY){
//				NoticeUtil.setOperatorNotice("无法寻路");
//			}else{
//				var vo:TaskWillDoVo = new TaskWillDoVo();
//				vo.npcDyId = Npc_PositionBasicManager.Instance.getNPCPositonBasicVo(_npcId).npc_id;
//				YFEventCenter.Instance.dispatchEventWith(GlobalEvent.TaskMoveToNPC,vo);
//			}
//		}
//		
//		/**飞鞋点击
//		 * @param e
//		 */		
//		private function onFly(e:MouseEvent):void{
//			if(_color==TypeProps.COLOR_RED || _color==TypeProps.COLOR_GRAY){
//				NoticeUtil.setOperatorNotice("无法使用小飞鞋");
//			}else{
//				YFEventCenter.Instance.dispatchEventWith(GlobalEvent.SKipToPlayer,_flyBootVo);
//			}
//		}
	}
} 