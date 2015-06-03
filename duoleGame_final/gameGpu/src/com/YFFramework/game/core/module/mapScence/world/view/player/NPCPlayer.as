package com.YFFramework.game.core.module.mapScence.world.view.player
{
	import com.YFFramework.core.center.manager.update.UpdateManager;
	import com.YFFramework.game.core.global.MouseManager;
	import com.YFFramework.game.core.global.MouseStyle;
	import com.YFFramework.game.core.global.manager.CommonEffectURLManager;
	import com.YFFramework.game.core.global.util.TypeProps;
	import com.YFFramework.game.core.module.mapScence.world.model.RoleDyVo;
	import com.YFFramework.game.core.module.task.enum.TaskState;
	import com.YFFramework.game.ui.yf2d.view.avatar.EffectURL2DView;
	
	/**NPC  播放器
	 * 2012-10-22 下午7:57:29
	 *@author yefeng
	 */
	public class NPCPlayer extends PlayerView
	{
		/**数据是否已经初始化 
		 *   场景模块   npc皮肤初始化时候需要   动画数据是否已经创建
		 */		
		public var dataInit:Boolean;
		/** npc 特效显示
		 */		
		private var _npcStateView:EffectURL2DView;
		public function NPCPlayer(roleDyVo:RoleDyVo=null)
		{
			super(roleDyVo);
			dataInit=false;
			roleDyVo.hp=100;
		}
		override protected function initUI():void
		{
			super.initUI();
			initEffectView();
		}
		/**创建   状态 光效容器
		 */		
		protected function initEffectView():void
		{
			_npcStateView=new EffectURL2DView(this);
			addChild(_npcStateView);
//			_npcStateView.y=_nameLayer.y-30;
//			_npcStateView.y=_nameItem1.y-30;
			_npcStateView.setY(_nameLayer.y-30);
		}
		
		override protected function initBloodLayer():void
		{
			
		}
		override public function updateHp():void
		{
			
		}
		
		override protected  function reLocateBloodName():void
		{
			var obj:Object=_cloth.actionDataStandWalk.getBlood();
//			_nameItem1.setY(obj.y-10);
			_nameLayer.y=obj.y-10
		}
		/**设置字体颜色
		 */
		override public function updateName():void
		{
			_nameItem1.setText(roleDyVo.roleName,0xFFFF00);
			reLocateNamePosition();
		}
		/**初始化手势
		 */		
		override protected function initMouseCursor(select:Boolean):void
		{
			if(select)
			{
				MouseManager.changeMouse(MouseStyle.NPCMouse);
			}
			else 
			{
				MouseManager.resetToDefaultMouse();
			}
		}
		
		public function setPath(arr:Array):void
		{
			setMapXY(arr[0].x,arr[0].y);
			sMoveTo(arr,150/UpdateManager.UpdateRate,complete,arr);
		}
		private function complete(arr:Array):void
		{
			sMoveTo(arr,150/UpdateManager.UpdateRate,complete,arr);
		}
		
		/**
		 * 任务state状态  
		 * 任务 quality品质
		 * tagType   为 任务 目标类型   TaskTargetType_    TaskTargetType_
		 */		
		public function setState(state:int,quality:int=1,npcTalk:int=0):void
		{
			_npcStateView.deleteAll();
			switch(state)//接受任务
			{
				case TaskState.ACCEPT:
					_npcStateView.addEffect(CommonEffectURLManager.Task_Yellow_keJie);
					break;
				case TaskState.FINISH:
					_npcStateView.addEffect(CommonEffectURLManager.Task_Yellow_keWanCheng);
					break;
				case TaskState.PROGRESS:
					if(npcTalk!=TypeProps.TaskTargetType_NPCDialog)	_npcStateView.addEffect(CommonEffectURLManager.Task_JingXingZhong);
					else _npcStateView.addEffect(CommonEffectURLManager.Task_Yellow_keWanCheng); //对话任务的 进行中状态变成可以完成
					break;
				case TaskState.NONE:
					_npcStateView.deleteAll();
					break;

			}
		}
		
		override public function dispose(childrenDispose:Boolean=true):void
		{
			super.dispose(childrenDispose);
			_npcStateView=null;
		}
		
		
		
		
	}
}