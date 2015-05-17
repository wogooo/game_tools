package com.YFFramework.game.core.module.smallMap.controller
{
	import com.YFFramework.core.center.abs.module.AbsModule;
	import com.YFFramework.core.event.YFEvent;
	import com.YFFramework.core.event.YFEventCenter;
	import com.YFFramework.core.ui.layer.LayerManager;
	import com.YFFramework.core.world.model.MonsterDyVo;
	import com.YFFramework.game.core.global.event.GlobalEvent;
	import com.YFFramework.game.core.module.gameView.view.GameView;
	import com.YFFramework.game.core.module.mapScence.manager.RoleDyManager;
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
		}
		override public function init():void
		{
			_smallMapWindow=new SmallMapWindow();
			_smallScrollMap=new SmallMapScrollView();
//			LayerManager.UILayer.addChild(_smallScrollMap);
//			_smallScrollMap.x=300;
			GameView.smallMap.addChild(_smallScrollMap);

			addEvents();
		}
		/**
		 */		
		private function addEvents():void
		{
			///切换场景  事件的发送来自场景模块  服务端返回切换场景时触发
			YFEventCenter.Instance.addEventListener(GlobalEvent.MapChange,onYFEvent);
			//切换场景时 配置文件加载完成时触发
			YFEventCenter.Instance.addEventListener(GlobalEvent.MapConfigLoadComplete,onYFEvent);

			///弹出小场景地图
			YFEventCenter.Instance.addEventListener(GlobalEvent.SmallMapUIClick,onYFEvent);

			///添加角色
			RoleDyManager.Instance.addEventListener(RoleDyManager.AddRole,onRoleDyEvent);
			///删除角色
			RoleDyManager.Instance.addEventListener(RoleDyManager.DeleteRole,onRoleDyEvent);
		}
		/** 角色的添加与删除
		 */		
		private function onRoleDyEvent(e:YFEvent):void
		{
			switch(e.type)
			{
				case RoleDyManager.AddRole:
					var monsterVo:MonsterDyVo=e.param as MonsterDyVo;
					_smallMapWindow._smallMapView.addRole(monsterVo);
					_smallScrollMap.addRole(monsterVo);
					break;
				case RoleDyManager.DeleteRole:
					var dyId:String=String(e.param);
					_smallMapWindow._smallMapView.delRole(dyId);
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
					var xxobj:Object=e.param;
					_smallMapWindow.updateConfigUI(xxobj);
					
					break;
				case GlobalEvent.MapChange:
					///切换场景
					_smallMapWindow._smallMapView.updateMapChange()
					_smallScrollMap.updateMapChange();
					break;
				case GlobalEvent.SmallMapUIClick:
					_smallMapWindow.toggle();
					break;
				
			}
		}
		
	}
}