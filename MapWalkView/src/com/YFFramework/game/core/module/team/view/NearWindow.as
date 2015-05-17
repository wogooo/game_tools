package com.YFFramework.game.core.module.team.view
{
	import com.YFFramework.core.utils.common.ClassInstance;
	import com.YFFramework.core.world.model.RoleDyVo;
	import com.YFFramework.game.core.module.mapScence.manager.RoleDyManager;
	import com.YFFramework.game.core.module.team.view.render.PlayersRender;
	import com.YFFramework.game.core.module.team.view.render.TeamsRender;
	import com.dolo.ui.controls.List;
	import com.dolo.ui.controls.VScrollBar;
	import com.dolo.ui.controls.Window;
	import com.dolo.ui.data.ListItem;
	import com.dolo.ui.tools.AutoBuild;
	import com.dolo.ui.tools.Xdis;
	
	import flash.display.Sprite;

	/**
	 * @version 1.0.0
	 * creation time：2013-3-29 上午10:58:01
	 * 
	 */
	public class NearWindow extends Window{
		
		private var _mc:Sprite;
		
		private var _players:List;
		private var _teams:List;
		
		public function NearWindow(){
			_mc = initByArgument(270,495,"nearPanel","附近");
			
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
			
			for(var i:int=0;i<teams.length;i++){
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
		
		/**更新附近玩家 
		 * @param players 附近玩家Array
		 */		
		public function updateNearPlayers(players:Array):void{
			_players.removeAll();
			
			for(var i:int=0;i<players.length;i++){
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
} 