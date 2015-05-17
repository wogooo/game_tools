package com.YFFramework.game.core.module.mapScence.manager
{
	import com.YFFramework.core.event.YFDispather;
	import com.YFFramework.core.world.model.MonsterDyVo;
	import com.YFFramework.core.world.model.RoleDyVo;
	import com.YFFramework.core.world.model.type.TypeRole;
	import com.YFFramework.game.core.global.DataCenter;
	
	import flash.utils.Dictionary;

	/** 角色动态数据管理器     管理其他角色的 vo  当前玩家的信息并没有保存在这里面 而是保存在 RoleSelfVo 里面 通过数据中心可以拿到
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
		public function addRole(roleDyVo:MonsterDyVo):void
		{
			roleDict[roleDyVo.dyId]=roleDyVo;
			///只对 怪物    npc   以及队友 进行通知
			if(canNoitce(roleDyVo))dispatchEventWith(AddRole,roleDyVo);
		}
		/** 是否进行通知   只对 怪物    npc   以及队友 进行通知
		 * @param roleDyVo
		 * @return 
		 */		
		private function canNoitce(roleDyVo:MonsterDyVo):Boolean
		{
			var canFire:Boolean=false
			if(roleDyVo.bigCatergory==TypeRole.BigCategory_Player)
			{
				//判断是否在 队友列表内
				canFire=DataCenter.Instance.roleSelfVo.teamPlayers.hasKey(roleDyVo.dyId); //如果为队友 则显示队友的图标
			}
			else if(roleDyVo.bigCatergory==TypeRole.BigCategory_NPC||roleDyVo.bigCatergory==TypeRole.BigCategory_Monster)
			{
				canFire=true;
			}
			return canFire;
		}
		
		public function delRole(dyId:String):void
		{
			var roleDyVo:MonsterDyVo=roleDict[dyId];
			if(roleDyVo)
			{
				delete roleDict[dyId];
				///只对 怪物    npc   以及队友 进行通知
				if(canNoitce(roleDyVo))	dispatchEventWith(DeleteRole,dyId);
			}
		}
		public function getRole(dyId:String):MonsterDyVo
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
		public function updateMapChange():void
		{
			roleDict=new Dictionary(); ///更新的原因是为了删除npc 
			roleDict[DataCenter.Instance.roleSelfVo.roleDyVo.dyId]=DataCenter.Instance.roleSelfVo.roleDyVo;
		}
		
	}
}