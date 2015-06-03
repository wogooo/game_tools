package com.YFFramework.game.core.module.trade.view
{
	import com.YFFramework.core.event.YFEventCenter;
	import com.YFFramework.core.utils.math.YFMath;
	import com.YFFramework.game.core.global.DataCenter;
	import com.YFFramework.game.core.global.util.NoticeUtil;
	import com.YFFramework.game.core.global.util.TypeProps;
	import com.YFFramework.game.core.global.view.window.WindowTittleName;
	import com.YFFramework.game.core.module.mapScence.manager.RoleDyManager;
	import com.YFFramework.game.core.module.trade.events.TradeEvent;
	import com.YFFramework.game.core.module.trade.manager.TradeDyManager;
	import com.YFFramework.game.core.module.trade.model.TradeInviteDyVo;
	import com.dolo.ui.controls.Button;
	import com.dolo.ui.controls.PopMiniWindow;
	import com.dolo.ui.tools.AutoBuild;
	import com.dolo.ui.tools.HTMLFormat;
	import com.dolo.ui.tools.Xdis;
	import com.msg.trade.CAcceptTradeReq;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;

	/**
	 * @version 1.0.0
	 * creation time：2013-5-2 上午11:31:47
	 * 交易邀请框 - 只有一个邀请时出现
	 */
	public class TradeAlert extends PopMiniWindow{
		
		private var _mc:MovieClip;
		private var yes_button:Button;
		private var no_button:Button;
		private var _dyId:int;
		
		public function TradeAlert(){
			_mc = initByArgument(300,160,"inviteAlert",WindowTittleName.tradeReqTitle) as MovieClip;
			AutoBuild.replaceAll(_mc);
			yes_button = Xdis.getChildAndAddClickEvent(onYes,_mc,"yes_button");
			no_button = Xdis.getChildAndAddClickEvent(onNo,_mc,"no_button");
			var view_button:Button = Xdis.getChild(_mc,"view_button");
			view_button.visible=false;
			
			var statusTxt:TextField=_mc.statusTxt;
			statusTxt.text="邀请你交易，是否同意？";
			statusTxt.textColor=TypeProps.Cfff0b6;
		}
		
		/**更新窗口信息
		 */		
		override public function update():void{
			var tradeDyVo:TradeInviteDyVo = TradeDyManager.Instance.getTradeList()[0];
			_mc.nameTxt.htmlText = HTMLFormat.color(tradeDyVo.name,TypeProps.C5ec700) + HTMLFormat.color("（等级"+tradeDyVo.lv+")",TypeProps.Cf0f275);
			_dyId = tradeDyVo.dyId;
			TradeDyManager.Instance.emptyTradeList();
		}
		
		/**关闭窗口 
		 * @param event
		 */		
		override public function close(event:Event=null):void{
			super.close();
			this.dispose();
		}
		
		/**清除对象
		 */		
		override public function dispose():void{
			yes_button.removeEventListener(MouseEvent.CLICK,onYes);
			no_button.removeEventListener(MouseEvent.CLICK,onNo);
			yes_button=null;
			no_button=null;
			_mc=null;
			super.dispose();
		}
		
		/**同意按钮点击
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
			this.close();
		}
		
		/**拒绝按钮点击
		 * @param e
		 */		
		private function onNo(e:MouseEvent):void{
			this.close();
		}
	}
} 