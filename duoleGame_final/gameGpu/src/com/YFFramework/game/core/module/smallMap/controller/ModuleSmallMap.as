package com.YFFramework.game.core.module.smallMap.controller
{
	import com.YFFramework.core.center.abs.module.AbsModule;
	import com.YFFramework.core.debug.print;
	import com.YFFramework.core.event.YFEvent;
	import com.YFFramework.core.event.YFEventCenter;
	import com.YFFramework.game.core.module.mapScence.world.model.RoleDyVo;
	import com.YFFramework.game.core.global.event.GlobalEvent;
	import com.YFFramework.game.core.module.gameView.view.GameView;
	import com.YFFramework.game.core.module.mapScence.manager.RoleDyManager;
	import com.YFFramework.game.core.module.smallMap.model.SmallMapRoleVo;
	import com.YFFramework.game.core.module.smallMap.view.SmallMapScrollView;
	import com.YFFramework.game.core.module.smallMap.view.SmallMapWindow;
	import com.YFFramework.game.core.scence.TypeScence;
	
	/**2012-7-20 下午1:47:27
	 *@author yefeng
	 */
	
	public class ModuleSmallMap extends AbsModule
	{
		/**小地图
		 */
		private var _smallMapWindow:SmallMapWindow;
		/**具有滚屏
		 */		
		private var _smallScrollMap:SmallMapScrollView;
		public function ModuleSmallMap()
		{
			super();
			_belongScence=TypeScence.ScenceGameOn;
			_smallScrollMap=new SmallMapScrollView();
			_smallMapWindow=new SmallMapWindow();

		}
		override public function init():void
		{
			GameView._mapUI.smallMap.addChild(_smallScrollMap);
			addEvents();
		}
		/**
		 */		
		private function addEvents():void
		{
			///切换场景  事件的发送来自场景模块  服务端返回切换场景时触发
			YFEventCenter.Instance.addEventListener(GlobalEvent.EnterDifferentMap,onYFEvent);
			//切换场景时 配置文件加载完成时触发
//			YFEventCenter.Instance.addEventListener(GlobalEvent.MapConfigLoadComplete,onYFEvent);

			///弹出小场景地图
			YFEventCenter.Instance.addEventListener(GlobalEvent.SmallMapUIClick,onYFEvent);

			///添加角色
			RoleDyManager.Instance.addEventListener(RoleDyManager.AddRole,onRoleDyEvent);
			///删除角色
			RoleDyManager.Instance.addEventListener(RoleDyManager.DeleteRole,onRoleDyEvent);
			/// team改变
			YFEventCenter.Instance.addEventListener(GlobalEvent.TeamAddMember,onteamChange);
			YFEventCenter.Instance.addEventListener(GlobalEvent.TeamRemoveMember,onteamChange);
		}
		/**  创建小地图数据模型vo 
		 */		
		private function createSmallMapRoleVo(roleDyVo:RoleDyVo):SmallMapRoleVo
		{
			var smallMapRoleVo:SmallMapRoleVo=new SmallMapRoleVo();
			smallMapRoleVo.roleName=roleDyVo.roleName;
			smallMapRoleVo.dyId=roleDyVo.dyId;
			smallMapRoleVo.bigCatergory=roleDyVo.bigCatergory;
			smallMapRoleVo.mapX=roleDyVo.mapX;
			smallMapRoleVo.mapY=roleDyVo.mapY;
			return smallMapRoleVo;
		}
		/**队友发生改变
		 */		
		private function onteamChange(e:YFEvent):void
		{
			var arr:Array=e.param as Array;
			var roleDyVo:RoleDyVo;
			var dyId:int;
			var smallMapRoleVo:SmallMapRoleVo;
			switch(e.type)
			{
				case GlobalEvent.TeamAddMember: //添加队友
					for each(dyId in arr)
					{
						roleDyVo=RoleDyManager.Instance.getRole(dyId);
						if(roleDyVo)
						{
							smallMapRoleVo=createSmallMapRoleVo(roleDyVo);
							_smallMapWindow._currentSmallMapView.addNewTeamPlayer(smallMapRoleVo);
							_smallScrollMap.addNewTeamPlayer(smallMapRoleVo);
						}
					}
					break;
				case GlobalEvent.TeamRemoveMember: //删除队友
					for each(dyId in arr)
					{
						roleDyVo=RoleDyManager.Instance.getRole(dyId);
						if(roleDyVo)
						{
							_smallMapWindow._currentSmallMapView.delRole(roleDyVo.dyId);
							_smallScrollMap.delRole(roleDyVo.dyId);
						}
					}
					break;
			}
		}
		/** 角色的添加与删除
		 */		
		private function onRoleDyEvent(e:YFEvent):void
		{
			var smallMapRoleVo:SmallMapRoleVo;
			switch(e.type)
			{
				case RoleDyManager.AddRole:
					var monsterVo:RoleDyVo=e.param as RoleDyVo;
					smallMapRoleVo=createSmallMapRoleVo(monsterVo);
					_smallMapWindow._currentSmallMapView.addRole(smallMapRoleVo);
					_smallScrollMap.addRole(smallMapRoleVo);
					break;
				case RoleDyManager.DeleteRole:
					var dyId:int=int(e.param);
					_smallMapWindow._currentSmallMapView.delRole(dyId);
					_smallScrollMap.delRole(dyId);
					break;
			}
		}
		
		private function onYFEvent(e:YFEvent):void
		{
			switch(e.type)
			{
				case GlobalEvent.MapConfigLoadComplete:
					//切换场景时 配置文件加载完成时触发
//					var xxobj:Object=e.param;
//					_smallMapWindow.updateConfigUI(xxobj);
					print(this,"这里代码侦听待去掉......");
					break;
				case GlobalEvent.EnterDifferentMap:
					///切换场景
					_smallMapWindow.updateMapChange()
					_smallScrollMap.updateMapChange();
					break;
				case GlobalEvent.SmallMapUIClick:
					_smallMapWindow.switchOpenClose()
					break;
				
			}
		}
		
	}
}