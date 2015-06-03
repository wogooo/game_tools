package com.YFFramework.game.core.module.trade.view.render
{
	import com.YFFramework.core.event.YFEventCenter;
	import com.YFFramework.core.utils.math.YFMath;
	import com.YFFramework.game.core.global.DataCenter;
	import com.YFFramework.game.core.global.util.NoticeUtil;
	import com.YFFramework.game.core.global.util.TypeProps;
	import com.YFFramework.game.core.module.mapScence.manager.RoleDyManager;
	import com.YFFramework.game.core.module.trade.events.TradeEvent;
	import com.YFFramework.game.core.module.trade.manager.TradeDyManager;
	import com.dolo.ui.controls.Button;
	import com.dolo.ui.renders.ListRenderBase;
	import com.dolo.ui.tools.AutoBuild;
	import com.dolo.ui.tools.HTMLFormat;
	import com.dolo.ui.tools.Xdis;
	import com.msg.trade.CAcceptTradeReq;
	
	import flash.events.MouseEvent;
	import flash.text.TextField;

	/**
	 * @version 1.0.0
	 * creation time：2013-5-2 上午11:14:41
	 * 
	 */
	public class TradeRender extends ListRenderBase{
		
		private var yes_button:Button;
		private var no_button:Button;
		private var _nameTxt:TextField;
		private var _dyId:int;
		
		public function TradeRender(){
			_renderHeight = 70;
		}
		
		override protected function resetLinkage():void{
			_linkage = "uiSkin.Invite";
		}
		
		override protected function onLinkageComplete():void{
			AutoBuild.replaceAll(_ui);
			yes_button = Xdis.getChildAndAddClickEvent(onYes,_ui,"yes_button");
			no_button = Xdis.getChildAndAddClickEvent(onNo,_ui,"no_button");
			Xdis.getChild(_ui,"view_button").visible=false;
			Xdis.getTextChild(_ui,"dataTxt").text = "邀请你交易，是否同意？";
			_nameTxt = Xdis.getTextChild(_ui,"nameTxt");
		}
		/**更新界面
		 * @param item
		 */		
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
			yes_button=null;
			no_button=null;
			_nameTxt=null;
		}
		/**接受交易
		 * @param e
		 */		
		private function onYes(e:MouseEvent):void{
			if(TradeDyManager.isTrading==true){
				NoticeUtil.setOperatorNotice("您已在交易中，无法再进行交易。。。");
			}else if(RoleDyManager.Instance.getRole(_dyId)==null){
				NoticeUtil.setOperatorNotice("对方已离开视野范围。。。");
			}else if(YFMath.distance(DataCenter.Instance.roleSelfVo.roleDyVo.mapX,DataCenter.Instance.roleSelfVo.roleDyVo.mapY,RoleDyManager.Instance.getRole(_dyId).mapX,RoleDyManager.Instance.getRole(_dyId).mapY)>320){
				NoticeUtil.setOperatorNotice("距离太远，无法交易。。。");
			}else{
				var msg:CAcceptTradeReq=new CAcceptTradeReq();
				msg.otherId = _dyId;
				YFEventCenter.Instance.dispatchEventWith(TradeEvent.AcceptTrade,msg);
			}
			_list.removeItemAt(_index);
			YFEventCenter.Instance.dispatchEventWith(TradeEvent.CloseInviteWindow);
		}
		/**拒绝交易
		 * @param e
		 */		
		private function onNo(e:MouseEvent):void{
			_list.removeItemAt(_index);
			YFEventCenter.Instance.dispatchEventWith(TradeEvent.CloseInviteWindow);
		}
	}
} 