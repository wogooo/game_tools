package com.YFFramework.game.core.module.guild.view.guildJoin
{
	import com.YFFramework.game.core.global.view.window.WindowTittleName;
	import com.YFFramework.game.core.module.guild.manager.GuildInfoManager;
	import com.YFFramework.game.core.module.guild.view.guildJoin.rander.GuildInviteRander;
	import com.dolo.ui.controls.List;
	import com.dolo.ui.controls.PopMiniWindow;
	import com.dolo.ui.controls.Window;
	import com.dolo.ui.tools.Xdis;
	
	import flash.display.Sprite;
	import flash.events.Event;
	
	/***
	 *公会邀请窗口
	 *@author ludingchang 时间：2013-7-23 上午11:55:56
	 */
	public class GuildInviteWindow extends PopMiniWindow
	{
		private static const uiName:String="Guild_invite";
		
		private static var _inst:GuildInviteWindow;

		private var _list:List;
		private var _hasInit:Boolean;
		
		public static function get Instence():GuildInviteWindow
		{
			if(!_inst)
				_inst=new GuildInviteWindow;
			return _inst;
		}
		
		public function GuildInviteWindow()
		{
		}
		private function init():void
		{
			if(!_hasInit)
			{
				_hasInit=true;
				
				var sp:Sprite=initByArgument(450,345,uiName,WindowTittleName.GuildInvite);
				_list=Xdis.getChild(sp,"info_list");
				_list.itemRender=GuildInviteRander;
			}
		}
		override public function dispose():void
		{
			_list.removeAll();
		}
		override public function close(event:Event=null):void
		{
			super.close();
			if(_hasInit)
			{
				this.dispose();
				GuildInfoManager.Instence.invite_data.length=0;
			}
		}
		
		public override function update():void
		{
			dispose();
			var list_data:Array=GuildInfoManager.Instence.invite_data;
			var i:int,len:int=list_data.length;
			for(i=0;i<len;i++)
			{
				_list.addItem(list_data[i]);
			}
		}
		public override function open():void
		{
			init();
			update();
			super.open();
		}
	}
}