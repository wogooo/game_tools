package com.YFFramework.game.core.module.pk.view.render
{
	/**@author yefeng
	 * 2013 2013-5-13 下午4:40:52 
	 */
	import com.YFFramework.core.event.YFEventCenter;
	import com.YFFramework.core.utils.math.YFMath;
	import com.YFFramework.game.core.global.DataCenter;
	import com.YFFramework.game.core.global.util.NoticeUtil;
	import com.YFFramework.game.core.global.util.TypeProps;
	import com.YFFramework.game.core.module.ModuleManager;
	import com.YFFramework.game.core.module.mapScence.manager.RoleDyManager;
	import com.YFFramework.game.core.module.pk.event.PKEvent;
	import com.dolo.ui.controls.Button;
	import com.dolo.ui.renders.ListRenderBase;
	import com.dolo.ui.tools.AutoBuild;
	import com.dolo.ui.tools.HTMLFormat;
	import com.dolo.ui.tools.Xdis;
	
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	public class CompeteRender extends ListRenderBase{
		
		private var yes_button:Button;
		private var no_button:Button;
		private var _nameTxt:TextField;	
		public var _dyId:int;
		private var view_button:Button;

		public function CompeteRender(){
			_renderHeight = 70;
		}
		
		override protected function resetLinkage():void{
			_linkage = "uiSkin.Invite";
		}
		
		override protected function onLinkageComplete():void{
			AutoBuild.replaceAll(_ui);
			yes_button = Xdis.getChildAndAddClickEvent(onYes,_ui,"yes_button");
			no_button = Xdis.getChildAndAddClickEvent(onNo,_ui,"no_button");
			view_button = Xdis.getChildAndAddClickEvent(onView,_ui,"view_button");
			view_button.textField.text = "查看信息";
			view_button.textField.textColor = TypeProps.C1ff1e0;
			var format:TextFormat = new TextFormat();
			format.underline = true;
			view_button.textField.setTextFormat(format);
			Xdis.getTextChild(_ui,"dataTxt").text = "邀请你切磋，是否同意？";
			_nameTxt = Xdis.getTextChild(_ui,"nameTxt");
		}
		
		override protected function updateView(item:Object):void{
			_nameTxt.htmlText = HTMLFormat.color(item.name,TypeProps.C5ec700) + HTMLFormat.color("（等级"+item.lv+"）",TypeProps.Cf0f275);
			_dyId = item.dyId;
		}
		
		/**清除对象
		 */
		override public function dispose():void{
			super.dispose();
			yes_button.removeEventListener(MouseEvent.CLICK,onYes);
			no_button.removeEventListener(MouseEvent.CLICK,onNo);
			view_button.removeEventListener(MouseEvent.CLICK,onView);
			view_button=null;
			yes_button=null;
			no_button=null;
			_nameTxt=null;
		}
		
		private function onYes(e:MouseEvent):void{
			if(DataCenter.Instance.roleSelfVo.roleDyVo.competeId>0){
				NoticeUtil.setOperatorNotice("你已在切磋状态中。。。");
			}else if(!RoleDyManager.Instance.getRole(_dyId)){
				NoticeUtil.setOperatorNotice("对方已离开视野范围。。。");
			}else if(YFMath.distance(DataCenter.Instance.roleSelfVo.roleDyVo.mapX,DataCenter.Instance.roleSelfVo.roleDyVo.mapY,RoleDyManager.Instance.getRole(_dyId).mapX,RoleDyManager.Instance.getRole(_dyId).mapY)>320){
				NoticeUtil.setOperatorNotice("距离太远，无法交易。。。");
			}else{
				YFEventCenter.Instance.dispatchEventWith(PKEvent.C_AcceptCompete,_dyId);
			}
			_list.removeItemAt(_index);
			YFEventCenter.Instance.dispatchEventWith(PKEvent.CloseInviteWindow);
		}
		
		private function onNo(e:MouseEvent):void{
			_list.removeItemAt(_index);
			YFEventCenter.Instance.dispatchEventWith(PKEvent.CloseInviteWindow);
		}
		
		private function onView(e:MouseEvent):void{
			ModuleManager.rankModule.otherPlayerReq(_dyId);
		}
	}
}