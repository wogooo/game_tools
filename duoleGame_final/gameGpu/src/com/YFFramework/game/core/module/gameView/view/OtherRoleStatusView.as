package com.YFFramework.game.core.module.gameView.view
{
	/**@author yefeng
	 * 2013 2013-3-28 上午11:26:39 
	 */
	import com.YFFramework.core.event.YFEventCenter;
	import com.YFFramework.core.ui.abs.AbsView;
	import com.YFFramework.core.utils.math.YFMath;
	import com.YFFramework.game.core.global.DataCenter;
	import com.YFFramework.game.core.global.event.GlobalEvent;
	import com.YFFramework.game.core.global.manager.CharacterPointBasicManager;
	import com.YFFramework.game.core.global.manager.Gather_ConfigBasicManager;
	import com.YFFramework.game.core.global.manager.MonsterBasicManager;
	import com.YFFramework.game.core.global.manager.PetBasicManager;
	import com.YFFramework.game.core.global.model.HeroState;
	import com.YFFramework.game.core.module.ModuleManager;
	import com.YFFramework.game.core.module.arena.data.ArenaRankManager;
	import com.YFFramework.game.core.module.guild.event.GuildInfoEvent;
	import com.YFFramework.game.core.module.guild.model.GuildInvitePlayerVo;
	import com.YFFramework.game.core.module.im.model.PrivateTalkPlayerVo;
	import com.YFFramework.game.core.module.im.model.RequestFriendVo;
	import com.YFFramework.game.core.module.mapScence.world.model.RoleDyVo;
	import com.YFFramework.game.core.module.mapScence.world.model.type.TypeRole;
	import com.YFFramework.game.core.module.npc.manager.Npc_ConfigBasicManager;
	import com.YFFramework.game.core.module.team.events.TeamEvent;
	import com.dolo.ui.controls.Button;
	import com.dolo.ui.controls.IconImage;
	import com.dolo.ui.controls.Menu;
	import com.dolo.ui.controls.ProgressBar;
	import com.dolo.ui.sets.ButtonTextStyle;
	import com.dolo.ui.tools.AutoBuild;
	import com.dolo.ui.tools.Xdis;
	
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.system.System;
	
	/**角色信息 其他角色的信息
	 */	
	public class OtherRoleStatusView extends AbsView{
		
		/**角色信息
		 */		
		public var roleDyVo:RoleDyVo;
		private var _mc:MovieClip;
		
		private var hp_progressBar:ProgressBar;
		private var mp_progressBar:ProgressBar;

		private var choose_button:Button;
		
		private var _menu:Menu;
		
		/** 图像
		 */		
		private var _imageIcon:IconImage;
		
		public function OtherRoleStatusView(mc:MovieClip){
			_mc=mc;
			super(false);
		}
		
		override protected function initUI():void{
			super.initUI();
			addChild(_mc);
			AutoBuild.replaceAll(_mc);
			hp_progressBar = Xdis.getChild(_mc,"hp_progressBar");
			mp_progressBar = Xdis.getChild(_mc,"mp_progressBar");

			choose_button= Xdis.getChildAndAddClickEvent(onMore,_mc,"choose_button");
			choose_button.label="选";
			choose_button.changeTextColor(new ButtonTextStyle(0xffffff,0xffffff,0xffffff,0xffffff));
			
			_imageIcon=new IconImage();
			addChild(_imageIcon);
			_imageIcon.x=0;
			_imageIcon.y=0;
		}
		
		private function onMore(e:MouseEvent):void{
			//_menu.dispose();
			if(ArenaRankManager.instance.curArenaId!=0)//如果在竞技类活动中就把所有弹出选项屏蔽
				return;
			if(!_menu){
				_menu = new Menu();
				_menu.withoutMouseDownClose.push(choose_button);
				_menu.txtX=5;
				_menu.setSize(36,0);
				switch(roleDyVo.bigCatergory){
					case TypeRole.BigCategory_Player:
						_menu.addItem("　查看",onMenuItemClick);
						_menu.addItem("邀请组队",onMenuItemClick);
						_menu.addItem("　私聊",onMenuItemClick);
						_menu.addItem("　交易",onMenuItemClick);
						_menu.addItem("添加好友",onMenuItemClick);
						_menu.addItem("　切磋",onMenuItemClick);
						_menu.addItem("复制姓名",onMenuItemClick);
						_menu.addItem("邀请入会",onMenuItemClick);
						break;
					case TypeRole.BigCategory_Pet:
						_menu.addItem("　查看",onMenuItemClick);
						break;
				}
			}
			if(DataCenter.Instance.roleSelfVo.roleDyVo.competeId>0)	_menu.disableItem(5);

			if(_menu.isOpen)	_menu.hide();
			else	_menu.show(choose_button,5,20);
		}
		
		/**其他人更多按钮下拉选项 点击
		 * 查看,邀请组队，私聊，交易，添加好友，切磋，复制姓名，邀请入会
		 */
		private function onMenuItemClick(index:uint,label:String):void{
			var pt:Point;
			switch(index){
				case 0:  //查看
					if(roleDyVo.bigCatergory==TypeRole.BigCategory_Player){
						ModuleManager.rankModule.otherPlayerReq(roleDyVo.dyId);
					}
					break;
				case 1://邀请组队
					YFEventCenter.Instance.dispatchEventWith(TeamEvent.InviteReq,roleDyVo);	
					break;
				case 2:  //私聊
					var privateTalkPlayerVo:PrivateTalkPlayerVo=new PrivateTalkPlayerVo();
					privateTalkPlayerVo.dyId=roleDyVo.dyId;
					privateTalkPlayerVo.name=roleDyVo.roleName;
					privateTalkPlayerVo.sex=roleDyVo.sex;
					YFEventCenter.Instance.dispatchEventWith(GlobalEvent.PrivateTalkToOpenWindow,privateTalkPlayerVo);
					break;
				case 3:	//交易
					if(YFMath.distance(roleDyVo.mapX,roleDyVo.mapY,DataCenter.Instance.roleSelfVo.roleDyVo.mapX,DataCenter.Instance.roleSelfVo.roleDyVo.mapY)<=160){
						YFEventCenter.Instance.dispatchEventWith(GlobalEvent.ToTrade,roleDyVo.dyId);
					}else{
						DataCenter.Instance.roleSelfVo.heroState.state=HeroState.ToTrade;
						pt=YFMath.getLinePoint(DataCenter.Instance.roleSelfVo.roleDyVo.mapX,DataCenter.Instance.roleSelfVo.roleDyVo.mapY,roleDyVo.mapX,roleDyVo.mapY,128);
						YFEventCenter.Instance.dispatchEventWith(GlobalEvent.MoveToPlayer,{pt:pt,state:HeroState.ToTrade,dyId:roleDyVo.dyId});
					}					
					break;
				case 4: //好友 
					var requestFriendVo:RequestFriendVo=new RequestFriendVo();
					requestFriendVo.dyId=roleDyVo.dyId;
					requestFriendVo.name=roleDyVo.roleName;
					YFEventCenter.Instance.dispatchEventWith(GlobalEvent.C_RequestAddFriend,requestFriendVo);
					break;
				case 5:		//切磋
					if(YFMath.distance(roleDyVo.mapX,roleDyVo.mapY,DataCenter.Instance.roleSelfVo.roleDyVo.mapX,DataCenter.Instance.roleSelfVo.roleDyVo.mapY)<=160){
						YFEventCenter.Instance.dispatchEventWith(GlobalEvent.C_RequestCompete,{dyId:roleDyVo.dyId,name:roleDyVo.roleName});
					}else{
						DataCenter.Instance.roleSelfVo.heroState.state=HeroState.ToCompete;
						pt=YFMath.getLinePoint(DataCenter.Instance.roleSelfVo.roleDyVo.mapX,DataCenter.Instance.roleSelfVo.roleDyVo.mapY,roleDyVo.mapX,roleDyVo.mapY,128);
						YFEventCenter.Instance.dispatchEventWith(GlobalEvent.MoveToPlayer,{pt:pt,state:HeroState.ToCompete,dyId:roleDyVo.dyId});
					}
					break;
				case 6:		//复制姓名
					System.setClipboard(roleDyVo.roleName);
					break;
				case 7:			//邀请入会
					var player:GuildInvitePlayerVo=new GuildInvitePlayerVo;
					player.dyId=roleDyVo.dyId;
					player.lv=roleDyVo.level;
					player.guildName="";
					YFEventCenter.Instance.dispatchEventWith(GuildInfoEvent.InvatePlayer,player);
					break;
			}
		}
		
		public function updateInfo():void{
			if(roleDyVo){
				var url:String;
				switch(roleDyVo.bigCatergory){
					case TypeRole.BigCategory_Player:
					case TypeRole.BigCategory_Pet:
						_mc.level.text=roleDyVo.level+"";
						_mc.player_name.text=roleDyVo.roleName;
						_mc.hp_tf.text=roleDyVo.hp+"/"+roleDyVo.maxHp;
						_mc.mp_tf.text=roleDyVo.mp+"/"+roleDyVo.maxMp;
						mp_progressBar.percent=roleDyVo.mp/roleDyVo.maxMp;
						hp_progressBar.percent=roleDyVo.hp/roleDyVo.maxHp;

						if(roleDyVo.bigCatergory==TypeRole.BigCategory_Player)  ///人物  
							url=CharacterPointBasicManager.Instance.getShowURL(roleDyVo.career,roleDyVo.sex);
						else{	///宠物
							url=PetBasicManager.Instance.getHeadURL(roleDyVo.basicId);
						}
						choose_button.visible=true;
						break;
					case TypeRole.BigCategory_Monster:
						_mc.level.text=roleDyVo.level+"";
						_mc.player_name.text=roleDyVo.roleName;
//						_mc.hp_tf.text=int(100*roleDyVo.hp/roleDyVo.maxHp)+"%";
//						_mc.mp_tf.text="100%";
						_mc.hp_tf.text="";
						_mc.mp_tf.text="";
						url=MonsterBasicManager.Instance.getShowURL(roleDyVo.basicId);
						mp_progressBar.percent=1;
						hp_progressBar.percent=roleDyVo.hp/roleDyVo.maxHp;
						choose_button.visible=false;
						break;
					case TypeRole.BigCategory_NPC:
						_mc.level.text="N";
						_mc.player_name.text=roleDyVo.roleName;
						_mc.hp_tf.text="";
						_mc.mp_tf.text="";
						url=Npc_ConfigBasicManager.Instance.getSmallIcon(roleDyVo.basicId);
						mp_progressBar.percent=1;
						hp_progressBar.percent=1;
						choose_button.visible=false;
						break;
					case TypeRole.BigCategory_Gather:
						_mc.level.text="C";
						_mc.player_name.text=roleDyVo.roleName;
						_mc.hp_tf.text="";
						_mc.mp_tf.text="";
						mp_progressBar.percent=1;
						hp_progressBar.percent=1;
						choose_button.visible=false;
						url=Gather_ConfigBasicManager.Instance.getIconUrl(roleDyVo.basicId);
						break;
				}
				_imageIcon.clear();
				_imageIcon.url=url;
				if(roleDyVo.bigCatergory==TypeRole.BigCategory_Player){
					_imageIcon.x=-10;
					_imageIcon.y=0;
				}else{
					_imageIcon.x=3;
					_imageIcon.y=13;
				}
			}
		}
	}
}