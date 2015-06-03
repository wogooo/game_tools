package com.YFFramework.game.core.module.im.view.render
{
	/**@author yefeng
	 * 2013 2013-6-22 下午5:20:21 
	 */
	import com.YFFramework.core.event.YFEventCenter;
	import com.YFFramework.game.core.global.util.TypeProps;
	import com.YFFramework.game.core.module.im.event.IMEvent;
	import com.YFFramework.game.core.module.im.model.RequestFriendVo;
	import com.dolo.ui.controls.Button;
	import com.dolo.ui.renders.ListRenderBase;
	import com.dolo.ui.tools.AutoBuild;
	import com.dolo.ui.tools.HTMLFormat;
	import com.dolo.ui.tools.Xdis;
	
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	public class FriendListRender extends ListRenderBase
	{
		private var yes_button:Button;
		private var no_button:Button;
		private var _nameTxt:TextField;	
		
		/**请求好友列表的数据 vo 
		 */		
		private var _requestFriendVo:RequestFriendVo;
		
		public function FriendListRender()
		{
			super();
			_renderHeight = 70;
		}
		override protected function resetLinkage():void
		{
			_linkage = "uiSkin.Invite";
		}
		override protected function onLinkageComplete():void{
			AutoBuild.replaceAll(_ui);
			yes_button = Xdis.getChildAndAddClickEvent(onYes,_ui,"yes_button");
			no_button = Xdis.getChildAndAddClickEvent(onNo,_ui,"no_button");
			Xdis.getChild(_ui,"view_button").visible=false;
			Xdis.getTextChild(_ui,"dataTxt").text = "请求添加为好友，是否同意？";
			Xdis.getTextChild(_ui,"dataTxt").width=300;
			Xdis.getTextChild(_ui,"dataTxt").mouseEnabled=false;
			_nameTxt = Xdis.getTextChild(_ui,"nameTxt");
		}
		
		override protected function updateView(item:Object):void
		{
			_requestFriendVo=item as RequestFriendVo;  
			_nameTxt.htmlText = HTMLFormat.color(_requestFriendVo.name,TypeProps.C5ec700);
		}
		
		/**清除对象
		 */
		override public function dispose():void{
			yes_button.removeEventListener(MouseEvent.CLICK,onYes);
			no_button.removeEventListener(MouseEvent.CLICK,onNo);
			super.dispose();
			yes_button=null;
			no_button=null;
			_nameTxt=null;
		}
		
		private function onYes(e:MouseEvent):void
		{
			//同意添加好友
			YFEventCenter.Instance.dispatchEventWith(IMEvent.C_AcceptAddFriend,_requestFriendVo.dyId);
			_list.removeItemAt(_index);
			YFEventCenter.Instance.dispatchEventWith(IMEvent.CheckCloseFriendListWindow);
		}
		
		private function onNo(e:MouseEvent):void
		{
			_list.removeItemAt(_index);
			YFEventCenter.Instance.dispatchEventWith(IMEvent.CheckCloseFriendListWindow);
		}


	}
}