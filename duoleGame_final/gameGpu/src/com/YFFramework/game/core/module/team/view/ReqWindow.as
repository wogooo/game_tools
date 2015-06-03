package com.YFFramework.game.core.module.team.view
{
	import com.YFFramework.game.core.global.view.window.WindowTittleName;
	import com.YFFramework.game.core.module.team.manager.TeamDyManager;
	import com.YFFramework.game.core.module.team.view.render.ReqRender;
	import com.dolo.ui.controls.List;
	import com.dolo.ui.controls.PopMiniWindow;
	import com.dolo.ui.controls.Window;
	import com.dolo.ui.data.ListItem;
	import com.dolo.ui.tools.Xdis;
	
	import flash.display.Sprite;
	import flash.events.Event;

	/**
	 * @version 1.0.0
	 * creation time：2013-4-7 上午10:17:35
	 * 
	 */
	public class ReqWindow extends PopMiniWindow{
		
		private var _mc:Sprite;
		private var _list:List;
		
		public function ReqWindow(){
			_mc = initByArgument(369,345,"invitePanel",WindowTittleName.RequestList);
			_list = Xdis.getChild(_mc,"invite_list");
			_list.itemRender = ReqRender;
		}
		
		public function updateList():void{
			_list.removeAll();
			
			var item:ListItem;
			var reqList:Array=TeamDyManager.Instance.getReqList();
			var len:int=reqList.length;
			for(var i:int=0;i<len;i++){
				item = new ListItem();
				item.name = reqList[i].name;
				item.lv = reqList[i].lv;
				item.dyId = reqList[i].dyId;
				_list.addItem(item);
			}
		}
		
		override public function dispose():void{
			_list.removeAll();
		}
		
		override public function close(event:Event=null):void{
			super.close();
			this.dispose();
		}
	}
} 