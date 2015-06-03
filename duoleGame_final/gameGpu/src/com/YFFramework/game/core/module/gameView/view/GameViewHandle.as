package com.YFFramework.game.core.module.gameView.view
{
	import com.YFFramework.core.event.YFEventCenter;
	import com.YFFramework.core.utils.common.ClassInstance;
	import com.YFFramework.game.core.global.DataCenter;
	import com.YFFramework.game.core.global.event.GlobalEvent;
	import com.YFFramework.game.core.global.manager.CharLevelExperienceBasicManager;
	import com.YFFramework.game.core.global.util.TypeProps;
	import com.YFFramework.game.core.module.im.model.PrivateTalkPlayerVo;
	import com.YFFramework.game.core.module.mapScence.world.model.RoleDyVo;
	import com.YFFramework.game.core.module.mapScence.world.model.type.TypeRole;
	import com.YFFramework.game.core.module.pet.manager.PetDyManager;
	import com.YFFramework.game.core.module.pet.model.PetDyVo;
	import com.YFFramework.game.core.module.team.manager.TeamDyManager;
	import com.YFFramework.game.ui.layer.LayerManager;
	import com.dolo.ui.tools.Xtip;
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;

	/**  处理UI的更新
	 * 
	 * @author yefeng
	 * 2013 2013-3-25 上午10:02:36 
	 */
	public class GameViewHandle
	{
		
		private var _mainUI:MovieClip;

//		/**主角的宠物 主界面UI
//		 */		
//		private var _petView:PetIconView;
		
		/**弹出按钮管理UI
		 */
		private var _ejectBtnView:EjectBtnView;
		/**队员场景组件UI管理
		 */
		private var _teamMemViews:Array;
		
		/**其他角色UI
		 */		
		private var _otherRoleView:OtherRoleStatusView;
		/**主角UI 
		 */		
		private var _heroIconView:HeroIconView;
		
		/**buff 图标显示容器
		 */		
		private var _buffContainer:BuffIconView;
		/**经验条
		 */		
		private var _expProgressBar:ExpProgressBar;
		public function GameViewHandle(view:MovieClip)
		{
			_mainUI=view;
			initUI();
		}
		/**初始化UI
		 */		
		private function initUI():void
		{
			var otherRoleMC:MovieClip=ClassInstance.getInstance("target_status") as MovieClip;
			_otherRoleView=new OtherRoleStatusView(otherRoleMC);
			
//			_petView = new PetIconView();
//			_petView.x=205;
//			_petView.y=90;
//			if(DataCenter.Instance.roleSelfVo.roleDyVo.level<10){
//				addToPopLayer(_petView);
//			}else{
//				addToLayer(_petView);
//			}
			
			_ejectBtnView = new EjectBtnView(_mainUI.UI_buttom.ejectBtns);
//			addToLayer(_ejectBtnView);
			
			_heroIconView=new HeroIconView(_mainUI.UI_people);
			
			_buffContainer=new BuffIconView();
			addToLayer(_buffContainer);
			_otherRoleView.x=400;
			_otherRoleView.y=10;
			_buffContainer.x=122;
			_buffContainer.y=85;
			///经验条
			_expProgressBar=new ExpProgressBar(_mainUI);
			
			
			_teamMemViews = new Array();
		}
		/** 更新主角经验 
		 */		
		public function updateHeroExp():void
		{
			_expProgressBar.setPercent(DataCenter.Instance.roleSelfVo.exp/CharLevelExperienceBasicManager.Instance.getExp(DataCenter.Instance.roleSelfVo.roleDyVo.level));
			Xtip.registerTip(_mainUI.UI_buttom.pb_disPlay_num,DataCenter.Instance.roleSelfVo.exp+" / "+CharLevelExperienceBasicManager.Instance.getExp(DataCenter.Instance.roleSelfVo.roleDyVo.level));
		}
		
		public function updateAddBuff(buffId:int):void
		{
			_buffContainer.addBuffIcon(buffId,BuffIconView.TypeHero);
		}
		
		public function updateDeleteBuff(buffId:int):void
		{
			_buffContainer.deleteBuffIcon(buffId);
		}
		
		private function addToLayer(display:DisplayObject):void
		{
			if(!LayerManager.UILayer.contains(display))LayerManager.UILayer.addChild(display);
		}
		
		private function addToPopLayer(display:DisplayObject):void{
			if(!LayerManager.PopLayer.contains(display))LayerManager.PopLayer.addChild(display);
		}
		
		private function removeFromPopLayer(display:DisplayObject):void{
			if(LayerManager.PopLayer.contains(display))LayerManager.PopLayer.removeChild(display);
		}
		
		private function removeFromLayer(display:DisplayObject):void
		{
			if(LayerManager.UILayer.contains(display))LayerManager.UILayer.removeChild(display);
		}
		private function containsView(display:DisplayObject):Boolean
		{
			return LayerManager.UILayer.contains(display);
		}
		
		
		/** 更新角色信息
		 */		
		public function updateRoleInfo(roleDyVo:RoleDyVo):void
		{
			switch(roleDyVo.bigCatergory)
			{
				///玩家类型
				case TypeRole.BigCategory_Player: 
					if(roleDyVo.dyId==DataCenter.Instance.roleSelfVo.roleDyVo.dyId)  ///当为玩家自己
					{
						_heroIconView.updateInfo();
					}
					else  ///为其他玩家
					{
						if(containsView(_otherRoleView))
						{
							if(_otherRoleView.roleDyVo.dyId==roleDyVo.dyId)  ///当前显示的对象是该对象
							{
								_otherRoleView.updateInfo();
							}
						}
					}
				break;
				//怪物类型 信息
				case TypeRole.BigCategory_Monster: 
					if(containsView(_otherRoleView))
					{
						if(_otherRoleView.roleDyVo.dyId==roleDyVo.dyId)  ///当前显示的对象是该对象
						{
							_otherRoleView.updateInfo();
						}
					}
				break;
				///宠物类型
				case TypeRole.BigCategory_Pet:
					if(PetDyManager.Instance.hasPet(roleDyVo.dyId))  ///自己的宠物
					{
						if(PetDyManager.fightPetId>0)
						{
							PetDyManager.Instance.getFightPetDyVo().fightAttrs[TypeProps.EA_HEALTH] = roleDyVo.hp;
							YFEventCenter.Instance.dispatchEventWith(GlobalEvent.PetHpChg);
						}
					}
					else   ///其他宠物
					{
						_otherRoleView.updateInfo();
					}
				break;
				case TypeRole.BigCategory_NPC:  // npc 
					if(containsView(_otherRoleView))
					{
						if(_otherRoleView.roleDyVo.dyId==roleDyVo.dyId)  ///当前显示的对象是该对象
						{
							_otherRoleView.updateInfo();
						}
					}
				break;
				case TypeRole.BigCategory_Gather:
					_otherRoleView.updateInfo();
					break;
			}
		}
		/**更新 主角 突袭nag
		 */		
		public function updateHeroImage():void
		{
			_heroIconView.updateIconImg();
		}
		/**初始化主角icon
		 */
		public function initHeroView():void
		{
			_heroIconView.initView();
		}

		/**删除界面    当其他玩家 比如怪物死亡后 ，需要删除显示界面
		 */		
		public function deleteOtherRoleInfo(dyId:int):void
		{ 
			if(_otherRoleView.roleDyVo==null)removeFromLayer(_otherRoleView);
			else if(_otherRoleView.roleDyVo.dyId==dyId)  ///当前显示的对象是该对象
			{
				removeFromLayer(_otherRoleView);
			}
		}
		
		/**取消选中 
		 */
		public function deleteOtherRoleInfo2():void
		{
			removeFromLayer(_otherRoleView);
		}

		/**切换场景 需要 删除  _otherRoleView
		 */		
		public function updateMapChange():void
		{
			removeFromLayer(_otherRoleView);
		}
		/**删除 _otherRoleView id 动态id 
		 */		
		public function updateDeleRoleStatus(id:int):void
		{
			if(_otherRoleView.roleDyVo)
			{
				if(_otherRoleView.roleDyVo.dyId==id)
				{
					removeFromLayer(_otherRoleView);
				}
			}
		}
		
		/**显示其他角色的信息    当单击玩家时 显示
		 */		
		public function showOtherRoleInfo(roleDyVo:RoleDyVo):void
		{
			addToLayer(_otherRoleView);
			_otherRoleView.roleDyVo=roleDyVo;
			updateRoleInfo(roleDyVo);
		}
		/** 更新血量  
		 */		
		public function updateHeroHp():void
		{
			_heroIconView.updateHp();
		}
		/**更新魔法值
		 */		
		public function updateHeroMp(mp:int,maxHp:int):void
		{
			_heroIconView.updateMp();
		}
		/**  更新等级
		 */		
		public function updateHeroLevel():void
		{
			_heroIconView.updateLevel();
		}
		/**更新模式 
		 */		
		public function updateHeroMode():void
		{
			_heroIconView.updatePKMode();
		}
		
		/**  更新 怪物血量百分比
		 */		
		public function updateMonsterHpPercent(hpPercent:Number):void
		{
			
		}
		/**更新怪物名称
		 */		
		public function updateMonsterName(name:String):void
		{
			
		}
		
//		/**添加宠物场景组件 
//		 */		
//		public function addPetIconView():void{
//			_petView.visible=true;
//		}
//		
//		/**移除宠物场景组件 
//		 */		
//		public function removePetIconView():void{
//			_petView.visible=false;
//		}
//		
//		/**更新宠物
//		 */	
//		public function updatePet(type:String):void{
//			var pet:PetDyVo;
//			if(PetDyManager.fightPetId==0)	pet = PetDyManager.Instance.getCrtPetDyVo();
//			else	pet = PetDyManager.Instance.getFightPetDyVo();
//			_petView.updateInfo(type,pet);
//		}
//		
//		/**宠物出战更新 
//		 */		
//		public function updateFightPet():void{
//			_petView.updateFightPet();
//		}
//		
//		/**宠物收回更新 
//		 */		
//		public function updateTakeBackPet():void{
//			_petView.updateTakeBack();
//		}
//		
//		/**宠物Buff更新
//		 */		
//		public function updatePetBuff():void{
//			_petView.updateBuffView();
//		}
		
		/**初始化组队场景组件列表 
		 */
		public function initTeamMembers():void{
			var teamArr:Array = TeamDyManager.Instance.getMembers();
			if(teamArr.length>1){
				var index:int = 0;
				for(var i:int=0;i<teamArr.length;i++){
					if(teamArr[i].dyId!=DataCenter.Instance.roleSelfVo.roleDyVo.dyId){
						_teamMemViews[index] = new TeamMemberView(teamArr[i].dyId,index);
						_teamMemViews[index].updateMemberView();
						addToLayer(_teamMemViews[index]);
						index++;
					}
				}
			}
		}
		
		/**添加一个队员组件 
		 * @param dyId 添加队员的dyId
		 */		
		public function addTeamMembers(dyId:int):void{
			_teamMemViews.push(new TeamMemberView(dyId,_teamMemViews.length));
			_teamMemViews[_teamMemViews.length-1].updateMemberView();
			addToLayer(_teamMemViews[_teamMemViews.length-1]);
		}
		
		/**删除全部队员组件 
		 */		
		public function removeAllTeamMembers():void{
			for(var i:int=0;i<_teamMemViews.length;i++){
				removeFromLayer(_teamMemViews[i]);
			}
			_teamMemViews.splice(0);
		}
		
		/**删除一个队员组件 
		 * @param dyId 删除队员的dyId
		 */		
		public function removeTeamMember(dyId:int):void{
			for(var i:int=0;i<_teamMemViews.length;i++){
				if(dyId==_teamMemViews[i].getDyId()){
					removeFromLayer(_teamMemViews[i]);
					_teamMemViews[i].dispose();
					_teamMemViews.splice(i,1);
					for(var j:int=i;j<_teamMemViews.length;j++){
						_teamMemViews[j].shiftUp();
						_teamMemViews[j].updateMemberView();
					}
					break;
				}
			}
		}
		
		/**更改队员组件位置
		 */		
		public function switchTeamMembers():void{
			var teamArr:Array = TeamDyManager.Instance.getMembers();
			var index:int=0;
			var myId:int = DataCenter.Instance.roleSelfVo.roleDyVo.dyId;
			for(var i:int=0;i<teamArr.length;i++){//正确的位置
				if(teamArr[i].dyId!=DataCenter.Instance.roleSelfVo.roleDyVo.dyId){
					for(var j:int=0;j<_teamMemViews.length;j++){
						var targetId:int = _teamMemViews[j].getDyId();
						if(teamArr[i].dyId==_teamMemViews[j].getDyId()){
							_teamMemViews[j].shiftTo(index);
							_teamMemViews[j].updateMemberView();
							index++;
							break;
						}
					}
				}
			}
			var tempArr:Array = new Array();
			for(i=0;i<_teamMemViews.length;i++){
				for(j=0;j<_teamMemViews.length;j++){
					if(_teamMemViews[j].getIndex()==i){
						tempArr.push(_teamMemViews[j]);
						break;
					}
				}
			}
			_teamMemViews = tempArr;
		}
		
		/**更新队员等级 
		 * @param dyId 更新队员的dyId
		 */		
		public function updateMemberLv(dyId:int,lv:int):void{
			for(var i:int=0;i<_teamMemViews.length;i++){
				if(dyId==_teamMemViews[i].getDyId()){
					_teamMemViews[i].updateLv(lv);
					break;
				}
			}
		}
		
		/**更新队员Hp,Mp 
		 * @param dyId 更新队员的dyId
		 */		
		public function updateMemberHpMp(dyId:int):void{
			for(var i:int=0;i<_teamMemViews.length;i++){
				if(dyId==_teamMemViews[i].getDyId()){
					_teamMemViews[i].updateHpMp();
					break;
				}
			}
		}
		
		/**更新下线成员图标
		 * @param dyId 	下线成员dyId
		 */		
		public function offlineMemberIcon(dyId:int):void{
			for(var i:int=0;i<_teamMemViews.length;i++){
				if(dyId==_teamMemViews[i].getDyId()){
					_teamMemViews[i].offlineIconImg();
					break;
				}
			}
		}
		
		/**更新上线成员图标
		 * @param dyId 	上线成员dyId
		 */		
		public function onlineMemberIcon(dyId:int):void{
			for(var i:int=0;i<_teamMemViews.length;i++){
				if(dyId==_teamMemViews[i].getDyId()){
					_teamMemViews[i].onlineIconImg();
					break;
				}
			}
		}
		
		/**如果自己是队长，更新队长旗子 
		 */		
		public function updateLeaderFlag():void{
			_heroIconView.updateLeaderFlag();
		}
		
		/**添加按钮
		 */	
		public function updateBtn(type:String,privateTalkRequestVo:PrivateTalkPlayerVo=null):void{
			if(!_ejectBtnView.hasBtn(type))	_ejectBtnView.addBtn(type,privateTalkRequestVo);
			_ejectBtnView.updateBtnView();
		}
		
		/**删除按钮
		 */
		public function removeBtn(type:String,privateTalkRequestVo:PrivateTalkPlayerVo=null):void{
			_ejectBtnView.removeBtn(type,privateTalkRequestVo);
			_ejectBtnView.updateBtnView();
		}
	}
}