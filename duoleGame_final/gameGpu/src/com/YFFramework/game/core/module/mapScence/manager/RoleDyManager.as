package com.YFFramework.game.core.module.mapScence.manager
{
	import com.YFFramework.core.event.YFDispather;
	import com.YFFramework.core.utils.math.YFMath;
	import com.YFFramework.game.core.global.DataCenter;
	import com.YFFramework.game.core.global.model.TypeSkill;
	import com.YFFramework.game.core.module.guild.manager.GuildInfoManager;
	import com.YFFramework.game.core.module.mapScence.world.model.RoleDyVo;
	import com.YFFramework.game.core.module.mapScence.world.model.type.TypeRole;
	import com.YFFramework.game.core.module.team.manager.TeamDyManager;
	
	import flash.utils.Dictionary;

	/** 角色动态数据管理器     管理其他角色的 vo  当前玩家的信息roleDyvo也保存在里面
	 *  场景角色管理器
	 * 小地图  通过该类 拿数据
	 * @author yefeng
	 *2012-4-22上午11:00:25
	 */
	public class RoleDyManager extends YFDispather
	{
		
		private static const Path:String="com.YFFramework.game.core.module.mapScence.manager.";
		/**添加角色
		 */		
		public static const AddRole:String=Path+"AddRole";
		/**删除角色
		 */		
		public static const DeleteRole:String=Path+"DeleteRole";
		
		private var roleDict:Dictionary;
		private static var _instance:RoleDyManager;
		public function RoleDyManager()
		{
			roleDict=new Dictionary();
		}
		public static function get Instance():RoleDyManager
		{
			if(_instance==null) _instance=new RoleDyManager();
			return _instance;
		}
		public function addRole(roleDyVo:RoleDyVo):void
		{
			roleDict[roleDyVo.dyId]=roleDyVo;
			///只对 怪物    npc   以及队友 进行通知
			if(canNoitce(roleDyVo))dispatchEventWith(AddRole,roleDyVo);
//			if(roleDyVo.bigCatergory==TypeRole.BigCategory_Player)  //存储名称
//			{
//				GlobalIDChache.setName(roleDyVo.roleName,roleDyVo.dyId);
//			}
		}
		public function updateLevel(id:int,level:int):void
		{
			var roledyVo:RoleDyVo=getRole(id) as RoleDyVo;
			if(roledyVo)
			{
				roledyVo.level=level;
			}
		}
		
		public function updateHp(id:int,hp:int):void
		{
			var roledyVo:RoleDyVo=getRole(id) as RoleDyVo;
			if(roledyVo)
			{
				roledyVo.hp=hp;
			}
		}
		/**更新魔法值
		 */		
		public function updateMp(id:int,mp:int):void
		{
			var roledyVo:RoleDyVo=getRole(id) as RoleDyVo;
			if(roledyVo)
			{
				roledyVo.mp=mp;
			}
		}
		/**更新玩家职业
		 */		
		public function updateCareer(id:int,career:int):void
		{
			var roledyVo:RoleDyVo=getRole(id) as RoleDyVo;
			if(roledyVo)
			{
				roledyVo.career=career;
			}
		}
		/** 是否进行通知   只对 怪物    npc   以及队友 进行通知
		 * @param roleDyVo
		 * @return 
		 */		
		private function canNoitce(roleDyVo:RoleDyVo):Boolean
		{
			var canFire:Boolean=false
//			if(roleDyVo.bigCatergory==TypeRole.BigCategory_NPC||roleDyVo.bigCatergory==TypeRole.BigCategory_Monster)
//			{
				canFire=true;
//			}
			return canFire;
		}
		
		public function delRole(dyId:uint):void
		{
			var roleDyVo:RoleDyVo=roleDict[dyId];
			if(roleDyVo)
			{
				delete roleDict[dyId];
				///只对 怪物    npc   以及队友 进行通知
				if(canNoitce(roleDyVo))	dispatchEventWith(DeleteRole,dyId);
			}
		}
		public function getRole(dyId:uint):RoleDyVo
		{
			return roleDict[dyId];
		}
		public function getRoleDict():Dictionary
		{
			return roleDict;
		}
		
		
		/**  根据服务端的返回数据角色列表  注意 当前玩家不在该列表中  当前玩家的创建使用  createHero
		 */
		public function createRoleList(roleList:Array):void
		{
			for each (var roleDyvo:RoleDyVo in roleList)
			{
			//	roleDict[roleDyvo.dyId]=roleDyvo;
				addRole(roleDyvo);
			}
		}
		
		/**切换场景  更新人物管理角色
		 */ 
		public function updateDifMapChange():void
		{
			roleDict=new Dictionary(); ///更新的原因是为了删除npc 
			roleDict[DataCenter.Instance.roleSelfVo.roleDyVo.dyId]=DataCenter.Instance.roleSelfVo.roleDyVo;
		}
		/**同场景切换
		 */		
		public function updateSameMapChange():void
		{
			for each (var roleDyVo:RoleDyVo in roleDict)
			{
				if(roleDyVo.dyId!=DataCenter.Instance.roleSelfVo.roleDyVo.dyId)
				{
					if(roleDyVo.bigCatergory!=TypeRole.BigCategory_NPC)
					{
						delRole(roleDyVo.dyId);
					}
				}
			}
		}

		
		/**更新玩家是否红名
		 */		
		public function updateRoleNameColor(dyId:int,nameColor:int):void
		{
			var roleDyVo:RoleDyVo=getRole(dyId);
			if(roleDyVo)roleDyVo.nameColor=nameColor;
		}
		
		public   function canFight(roleDyVo:RoleDyVo,pkMode:int=1,affect_group:int=1):Boolean
		{
			
			var canFire:Boolean=checkSkillAffectGroupCanFire(roleDyVo,affect_group);
			if(canFire)
			{
				if(affect_group!=TypeSkill.AffectGroup_All&&affect_group!=TypeSkill.AffectGroup_Self)
				{
					return canFightIt(roleDyVo,pkMode,affect_group);
				}
				else return true;
			}
			return false;
		}

		
		/**   设置 PK模式
		 * roleDyVo 能否进行攻击
		 */ 
		private   function canFightIt(roleDyVo:RoleDyVo,pkMode:int,affect_group:int):Boolean
		{
			
			//切磋状态
			if(DataCenter.Instance.roleSelfVo.roleDyVo.competeId==roleDyVo.dyId&&DataCenter.Instance.roleSelfVo.roleDyVo.competeId!=-1)
			{
				return true;
			}
			/// 不能攻击相同阵营或者 中立阵营的玩家
			if(DataCenter.Instance.roleSelfVo.roleDyVo.camp>0&&(DataCenter.Instance.roleSelfVo.roleDyVo.camp==roleDyVo.camp||DataCenter.Instance.roleSelfVo.roleDyVo.camp==TypeRole.Camp_Middle))
			{
				return false;
			}
			/// pk状态
			var ownPlayer:RoleDyVo;
			//当对象为 怪物   玩家 或者宠物时  可以进行攻击
			if(roleDyVo.bigCatergory==TypeRole.BigCategory_Player||roleDyVo.bigCatergory==TypeRole.BigCategory_Monster||roleDyVo.bigCatergory==TypeRole.BigCategory_Pet)
			{
				if(pkMode==TypeRole.PKMode_Peace) ///和平攻击
				{
					if(roleDyVo.bigCatergory==TypeRole.BigCategory_Monster)return true;
					else if(roleDyVo.bigCatergory==TypeRole.BigCategory_Player)
					{
						if(affect_group==TypeSkill.AffectGroup_FreindRole||affect_group==TypeSkill.AffectGroup_Freind) return true;
					}
				}
				else if(pkMode==TypeRole.PKMode_JusticeEvil)  ///善恶攻击 
				{
					if(roleDyVo.bigCatergory==TypeRole.BigCategory_Monster)return true;
					else if(roleDyVo.bigCatergory==TypeRole.BigCategory_Player)
					{
						if(roleDyVo.nameColor==TypeRole.NameColor_Red||roleDyVo.nameColor==TypeRole.NameColor_Gray)	
						{
							if(!isTeamer(roleDyVo))		return true;  //不为队友
						}
					}
					else if(roleDyVo.bigCatergory==TypeRole.BigCategory_Pet)  
					{
						ownPlayer= getRole(roleDyVo.ownId) as RoleDyVo;
						if(ownPlayer) 
						{
							if(ownPlayer.nameColor==TypeRole.NameColor_Red||ownPlayer.nameColor==TypeRole.NameColor_Gray) 
							{
								if(!isTeamer(ownPlayer))	return true;
							}
						}
						else return true; ///如果不存在   则交给服务端进行判断
					}
				}
				else if(pkMode==TypeRole.PKMode_All)  ///全体攻击
				{
					if(!isTeamer(roleDyVo))	return true;
				}
//				else if(pkMode==TypeRole.PKMode_Team)  ///组队攻击
//				{
//					if(roleDyVo.bigCatergory==TypeRole.BigCategory_Monster)return true;
//					else if(roleDyVo.bigCatergory==TypeRole.BigCategory_Player)
//					{
//						if(!TeamDyManager.Instance.containsMember(roleDyVo.dyId))
//						{
//							return true;
//						}
//					}
//					else if(roleDyVo.bigCatergory==TypeRole.BigCategory_Pet)  
//					{
//						ownPlayer= getRole(roleDyVo.ownId) as RoleDyVo;
//						if(ownPlayer) 
//						{
//							if(!TeamDyManager.Instance.containsMember(roleDyVo.dyId))
//							{
//								return true;
//							}
//						}
//						else return true; ///如果不存在   则交给服务端进行判断
//					}
//
//				}
				else if(pkMode==TypeRole.PKMode_Sociaty)  //公会模式
				{
					if(roleDyVo.bigCatergory==TypeRole.BigCategory_Monster)return true;
					else if(roleDyVo.bigCatergory==TypeRole.BigCategory_Player)
					{
						if(!GuildInfoManager.Instence.isGuildMate(roleDyVo.dyId))  //不为 工会成员
						{
							if(!isTeamer(roleDyVo))		return true;  //不为队友
						}
					}
					else if(roleDyVo.bigCatergory==TypeRole.BigCategory_Pet)  
					{
						ownPlayer= getRole(roleDyVo.ownId) as RoleDyVo;
						if(ownPlayer) 
						{
							if(!GuildInfoManager.Instence.isGuildMate(ownPlayer.dyId))  //不为 工会成员
							{
								if(!isTeamer(ownPlayer))		return true;  //不为队友
							}
						}
						else return true; ///如果不存在   则交给服务端进行判断
					}
				}
			}
			return false;
		}
		/**是否是队友
		 */		
		public function isTeamer(roleDyVo:RoleDyVo):Boolean
		{
			var ownPlayer:RoleDyVo;
			if(roleDyVo.bigCatergory==TypeRole.BigCategory_Player)
			{
				if(TeamDyManager.Instance.containsMember(roleDyVo.dyId))
				{
					return true;
				}
			}
			else if(roleDyVo.bigCatergory==TypeRole.BigCategory_Pet)  
			{
				ownPlayer= getRole(roleDyVo.ownId) as RoleDyVo;
				if(ownPlayer) 
				{
					if(TeamDyManager.Instance.containsMember(roleDyVo.dyId))
					{
						return true;
					}
				}
			}
			return false;
		}
		
		
		/**是否是友方
		 */
		public function isFriendCamp(roleDyVo:RoleDyVo):Boolean
		{
			var freindCamp:Boolean=false;
			freindCamp=isTeamer(roleDyVo);
			if(!freindCamp)
			{
				if(roleDyVo.dyId==DataCenter.Instance.roleSelfVo.roleDyVo.dyId)
				{
					freindCamp=true;//自己   自己属于友方 
				}
			} 
			return freindCamp;
		}
		
		
		
		/**检测  targetPlayer在 技能SKillBasicVo. affectGroup参数为   affectGroup 的情况下能否选择 该player目标
		 * affectGroup 的值在TypeSkill.AffectGroup_
		 */
		public function checkSkillAffectGroupCanFire(targetDyVo:RoleDyVo,affectGroup:int):Boolean
		{
			if(isFightPlayer(targetDyVo))
			{
				switch(affectGroup)
				{
					case TypeSkill.AffectGroup_Enemy:
						if(targetDyVo.bigCatergory!=TypeRole.BigCategory_Gather)
							if(!RoleDyManager.Instance.isFriendCamp(targetDyVo)) return true;
						break;
					case TypeSkill.AffectGroup_EnemyRole:
						if(targetDyVo.bigCatergory==TypeRole.BigCategory_Player)
						{
							if(!RoleDyManager.Instance.isFriendCamp(targetDyVo)) return true;
						}
						break;
					case TypeSkill.AffectGroup_EnemyPet:
						if(targetDyVo.bigCatergory==TypeRole.BigCategory_Pet)
						{
							if(!RoleDyManager.Instance.isFriendCamp(targetDyVo)) return true;
						}
						break;
					case TypeSkill.AffectGroup_EnemyMonster:
						if(targetDyVo.bigCatergory==TypeRole.BigCategory_Monster)
						{
							return true;
						}
						break;
					case TypeSkill.AffectGroup_Freind:
						if(RoleDyManager.Instance.isFriendCamp(targetDyVo)) return true;
						break;
					case TypeSkill.AffectGroup_FreindRole:
						if(targetDyVo.bigCatergory==TypeRole.BigCategory_Player)
						{
							if(RoleDyManager.Instance.isFriendCamp(targetDyVo)) return true;
						}
						break;
					case TypeSkill.AffectGroup_FreindPet:
						if(targetDyVo.bigCatergory==TypeRole.BigCategory_Pet)
						{
							if(RoleDyManager.Instance.isFriendCamp(targetDyVo)) return true;
						}
						break;
					case TypeSkill.AffectGroup_FreindDeadRole:
						if(targetDyVo.bigCatergory==TypeRole.BigCategory_Player)
						{
							if(targetDyVo.hp==0)return true;
						}
						break;
					case TypeSkill.AffectGroup_Self:
						if(targetDyVo.bigCatergory==TypeRole.BigCategory_Player)
						{
							if(targetDyVo.dyId==DataCenter.Instance.roleSelfVo.roleDyVo.dyId) return true;
						}
						break;
					case TypeSkill.AffectGroup_All:
						return true;
						break;
				}
			}
			return false;
		}
		
		
		/**更新玩家切磋状态
		 */
		public function updateRoleCompete(id:int,competeId:int):void
		{
			var roleDyVo:RoleDyVo=getRole(id) as RoleDyVo;
			if(roleDyVo)
			{
				roleDyVo.competeId=competeId;
			}
		}
		/** 比较主角 和玩家之间的距离
		 */		
		public function distanceToPlayer(roleDyVo:RoleDyVo):Number
		{
			return YFMath.distance(DataCenter.Instance.roleSelfVo.roleDyVo.mapX,DataCenter.Instance.roleSelfVo.roleDyVo.mapY,roleDyVo.mapX,roleDyVo.mapY);
		}
		
		
		/** 是否是可以战斗的对象  可以 战斗的对象 就只有 怪物 人物 以及宠物
		 * @param targetPlayer
		 */		
		public function isFightPlayer(roleDyVo:RoleDyVo):Boolean
		{
			if(roleDyVo.bigCatergory==TypeRole.BigCategory_Monster||roleDyVo.bigCatergory==TypeRole.BigCategory_Pet||roleDyVo.bigCatergory==TypeRole.BigCategory_Player)
			{
				return true
			}
			return false;
		}

		
	}
}