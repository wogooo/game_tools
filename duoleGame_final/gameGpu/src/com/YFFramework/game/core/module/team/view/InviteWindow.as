package com.YFFramework.game.core.module.team.view
{
	import com.YFFramework.core.event.YFEvent;
	import com.YFFramework.core.event.YFEventCenter;
	import com.YFFramework.core.utils.common.ClassInstance;
	import com.YFFramework.game.core.global.view.window.WindowTittleName;
	import com.YFFramework.game.core.module.mapScence.manager.RoleDyManager;
	import com.YFFramework.game.core.module.mapScence.world.model.RoleDyVo;
	import com.YFFramework.game.core.module.team.events.TeamEvent;
	import com.YFFramework.game.core.module.team.manager.TeamDyManager;
	import com.YFFramework.game.core.module.team.view.render.InviteRender;
	import com.dolo.ui.controls.List;
	import com.dolo.ui.controls.PopMiniWindow;
	import com.dolo.ui.controls.Window;
	import com.dolo.ui.data.ListItem;
	import com.dolo.ui.tools.Xdis;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;

	/**
	 * @version 1.0.0
	 * creation time：2013-4-2 下午4:47:03
	 * 邀请窗口
	 */
	public class InviteWindow extends PopMiniWindow{
		
		private var _mc:Sprite;
		private var _list:List;
		
		public function InviteWindow(){
			_mc = initByArgument(369,345,"invitePanel",WindowTittleName.TeamInvite);
			_list = Xdis.getChild(_mc,"invite_list");
			_list.itemRender = InviteRender;
			
			YFEventCenter.Instance.addEventListener(TeamEvent.CloseInviteWindow,onClose);
		}
		/**更新列表
		 */		
		public function updateList():void{
			var item:ListItem;
			var inviteList:Array=TeamDyManager.Instance.getInviteList();
			var len:int=inviteList.length;
			for(var i:int=0;i<len;i++){
				item = new ListItem();
				item.name = inviteList[i].name;
				item.lv = inviteList[i].lv;
				item.dyId = inviteList[i].dyId;
				_list.addItem(item);
			}
			TeamDyManager.Instance.emptyInviteList();
		}
		
		override public function dispose():void{
			_list.removeAll();
		}
		
		override public function close(event:Event=null):void{
			super.close();
			this.dispose();
		}
		
		private function onClose(e:YFEvent):void{
			if(_list.length==0)	this.close();
		}
	}
} 