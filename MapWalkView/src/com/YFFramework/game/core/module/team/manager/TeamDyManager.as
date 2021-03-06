package com.YFFramework.game.core.module.team.manager
{
	import com.YFFramework.core.map.rectMap.findPath.TypeRoad;
	import com.YFFramework.core.utils.HashMap;
	import com.YFFramework.core.world.model.type.TypeRole;
	import com.YFFramework.game.core.global.DataCenter;
	import com.YFFramework.game.core.global.manager.CharacterDyManager;
	import com.YFFramework.game.core.global.model.RoleSelfVo;
	import com.YFFramework.game.core.global.util.TypeProps;
	import com.YFFramework.game.core.module.mapScence.manager.RoleDyManager;
	import com.YFFramework.game.core.module.team.model.InviteDyVo;
	import com.YFFramework.game.core.module.team.model.MemberDyVo;
	import com.msg.team_pro.MemberInfo;

	/**
	 * @version 1.0.0
	 * creation time：2013-3-29 上午10:51:10
	 * 
	 */
	public class TeamDyManager{
		
		private static var instance:TeamDyManager;
		private var _inviteList:Array;
		private var _memberList:Array;
		private var _reqList:Array;
		public static var LeaderId:int; //0代表没有队伍
		public static var isAutoJoin:Boolean=false;
		
		public function TeamDyManager(){	
			_inviteList = new Array();
			_reqList = new Array();
			_memberList = new Array();
		}
		
		/**添加队员 
		 * @param m 队员信息
		 */		
		public function addMember(m:MemberInfo):void{
			var member:MemberDyVo = new MemberDyVo();
			member.dyId = m.dyId;
			member.name = m.name;
			member.power = m.power;
			member.lv = m.level;
			member.profession = m.profession;
			member.sex = m.sex;
			member.clothId = m.equipInfo.clothId;
			member.wingId = m.equipInfo.wingId;
			member.weaponId = m.equipInfo.weaponId;
			member.isOnline = m.isOnline;
			member.hpPercent = m.hpPercent/10000;
			member.mpPercent = m.mpPercent/10000;
			
			_memberList[_memberList.length]=member;
		}
		
		/**清空队伍列表 
		 */		
		public function emptyMembers():void{
			_memberList = new Array();
		}
		
		/**移除队员
		 * @param dyId 移除队员的dyId
		 */		
		public function removeMember(dyId:int):void{
			for(var i:int=0;i<_memberList.length;i++){
				if(_memberList[i].dyId==dyId){
					_memberList.splice(i,1);
					break;
				}
			}
			if(_memberList.length==1)	LeaderId=0;
		}
		
		/**添加自己进去队伍列表 
		 */		
		public function addSelf():void{
			var self:MemberDyVo = new MemberDyVo();
			self.dyId = DataCenter.Instance.roleSelfVo.roleDyVo.dyId;
			self.lv = DataCenter.Instance.roleSelfVo.roleDyVo.level;
			self.name = DataCenter.Instance.roleSelfVo.roleDyVo.roleName;
			self.power = DataCenter.Instance.roleSelfVo.roleDyVo.power;
			self.profession = DataCenter.Instance.roleSelfVo.roleDyVo.career;
			self.sex = DataCenter.Instance.roleSelfVo.roleDyVo.sex;
			self.clothId = CharacterDyManager.Instance.getEquipTempId(TypeProps.EQUIP_TYPE_CLOTHES);
			self.wingId = CharacterDyManager.Instance.getEquipTempId(TypeProps.EQUIP_TYPE_WINGS);
			self.weaponId = CharacterDyManager.Instance.getEquipTempId(TypeProps.EQUIP_TYPE_WEAPON);
			self.isOnline = true;
			
			_memberList[_memberList.length]=self;
		}
		
		/**获取队伍列表 
		 * @return 成员列表Array
		 */		
		public function getMembers():Array{
			return _memberList;
		}
		
		/**获取成员信息
		 * @param dyId
		 * @return MemberDyVo 对应的队员信息
		 */		
		public function getMemberDyVo(dyId:int):MemberDyVo{
			for(var i:int=0;i<_memberList.length;i++){
				if(_memberList[i].dyId==dyId){
					return _memberList[i];
				}
			}
			return null;
		}
		
		/**换队长 
		 * @param newLeaderId
		 */		
		public function switchLeader(newLeaderId:int):void{
			var temp:MemberDyVo;
			for(var i:int=0;i<_memberList.length;i++){
				if(_memberList[i].dyId==newLeaderId){
					temp = _memberList[i];
					_memberList.splice(i,1);
					break;
				}
			}
			_memberList.unshift(temp);
			LeaderId = temp.dyId;
		}
		
		/**队员是否在队伍里面 
		 * @param dyId
		 * @return Boolean
		 */		
		public function containsMember(dyId:int):Boolean{
			for(var i:int=0;i<_memberList.length;i++){
				if(_memberList[i].dyId==dyId){
					return true;
				}
			}
			return false;
		}
		
		/**添加到申请列表 
		 * @param dyId	队员的dyId
		 * @param power 队员的战斗力
		 */		
		public function addToReq(dyId:int,power:int):void{
			delFromReq(dyId);
			if(_reqList.length==20){
				_reqList.shift();
			}
			var invite:InviteDyVo = new InviteDyVo();
			invite.dyId = dyId;
			invite.power = power;
			invite.name = RoleDyManager.Instance.getRole(dyId).roleName;
			invite.lv = RoleDyManager.Instance.getRole(dyId).level;
			_reqList[_reqList.length] = invite;
		}
		
		/**从申请列表删除队员
		 * @param dyId 删除队员的dyId
		 */		
		public function delFromReq(dyId:int):void{
			for(var i:int=0;i<_reqList.length;i++){
				if(_reqList[i].dyId==dyId){
					_reqList.splice(i,1);
					break;
				}
			}
		}
		
		/**获得申请列表 
		 * @return 申请列表Array
		 */		
		public function getReqList():Array{
			return _reqList;
		}
		
		/**添加到邀请列表 
		 * @param dyId	添加的玩家dyId
		 * @param power	添加的玩家的战斗力
		 */		
		public function addToInvite(dyId:int,power:int):void{
			if(RoleDyManager.Instance.getRole(dyId)!=null){
				delFromInvite(dyId);
				if(_inviteList.length==20)	_inviteList.shift();
				var invite:InviteDyVo = new InviteDyVo();
				invite.dyId = dyId;
				invite.power = power;
				invite.name = RoleDyManager.Instance.getRole(dyId).roleName;
				invite.lv = RoleDyManager.Instance.getRole(dyId).level;
				_inviteList.push(invite);
			}
		}
		
		/**从邀请列表删除对应的玩家
		 * @param dyId 玩家的dyId
		 */		
		public function delFromInvite(dyId:int):void{
			for(var i:int=0;i<_inviteList.length;i++){
				if(_inviteList[i].dyId==dyId){
					_inviteList.splice(i,1);
					break;
				}
			}
		}
		
		/**获得邀请列表 
		 * @return 邀请列表Array
		 */		
		public function getInviteList():Array{
			return _inviteList;
		}
		
		/**清空邀请列表 
		 */		
		public function emptyInviteList():void{
			_inviteList.splice(0);
		}
		
		public static function get Instance():TeamDyManager{
			return instance ||= new TeamDyManager();
		}

	}
} 