package com.YFFramework.game.core.module.team.view
{
	import com.YFFramework.game.core.global.view.window.WindowTittleName;
	import com.YFFramework.game.core.module.mapScence.manager.RoleDyManager;
	import com.YFFramework.game.core.module.mapScence.world.model.RoleDyVo;
	import com.YFFramework.game.core.module.team.view.render.PlayersRender;
	import com.YFFramework.game.core.module.team.view.render.TeamsRender;
	import com.dolo.ui.controls.List;
	import com.dolo.ui.controls.PopMiniWindow;
	import com.dolo.ui.data.ListItem;
	import com.dolo.ui.tools.Xdis;
	
	import flash.display.Sprite;
	import flash.events.Event;

	/**
	 * @version 1.0.0
	 * creation time：2013-3-29 上午10:58:01
	 * 
	 */
	public class NearWindow extends PopMiniWindow{
		
		private var _mc:Sprite;
		
		private var _players:List;
		private var _teams:List;
		
		public function NearWindow(){
			_mc = initByArgument(300,505,"nearPanel",WindowTittleName.TeamTitle);
			
			_players = Xdis.getChild(_mc,"players_list");
			_players.itemRender = PlayersRender;
			
			_teams = Xdis.getChild(_mc,"teams_list");
			_teams.itemRender = TeamsRender;
		}
		
		/**更新附近队伍 
		 * @param teams 附近队伍Array
		 */	
		public function updateNearTeams(teams:Array):void{
			_teams.removeAll();
			
			if(teams){
				var len:int=teams.length;
				for(var i:int=0;i<len;i++){
					var role:RoleDyVo = RoleDyManager.Instance.getRole(teams[i].dyId) as RoleDyVo;
					if(role){
						var item:ListItem = new ListItem();
						item.name = role.roleName;
						item.lv = role.level;
						item.memberNum = teams[i].memberNumber;
						item.dyId = teams[i].dyId;
						_teams.addItem(item);
					}
				}
			}
		}
		
		/**更新附近玩家 
		 * @param players 附近玩家Array
		 */
		public function updateNearPlayers(players:Array):void{
			_players.removeAll();
			
			if(players){
				var len:int=players.length;
				for(var i:int=0;i<len;i++){
					var role:RoleDyVo = RoleDyManager.Instance.getRole(players[i].dyId) as RoleDyVo;
					if(role){
						var item:ListItem = new ListItem();
						item.career = role.career;
						item.sex = role.sex;
						item.name = role.roleName;
						item.lv = role.level;
						item.status = "战斗力："+players[i].power;
						item.memberNum = players[i].memberNumber;
						item.dyId = players[i].dyId;
						_players.addItem(item);
					}
				}
			}
		}
		
		/**清除对象
		 */		
		override public function dispose():void{
			_players.removeAll();
			_teams.removeAll();
		}
		
		override public function close(event:Event=null):void{
			super.close();
			this.dispose();
		}
	}
} 