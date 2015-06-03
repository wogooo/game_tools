package com.YFFramework.game.core.module.smallMap.view
{
	import com.YFFramework.core.ui.abs.AbsView;
	import com.YFFramework.core.ui.yfComponent.controls.YFLabel;
	import com.YFFramework.game.core.module.mapScence.manager.RoleDyManager;
	import com.YFFramework.game.core.module.mapScence.world.model.RoleDyVo;
	import com.YFFramework.game.core.module.mapScence.world.model.type.TypeRole;
	import com.YFFramework.game.core.module.npc.manager.NPCIocnQualityUtil;
	import com.YFFramework.game.core.module.npc.manager.Npc_PositionBasicManager;
	import com.YFFramework.game.core.module.npc.model.Npc_PositionBasicVo;
	import com.YFFramework.game.core.module.smallMap.model.SmallMapRoleVo;
	import com.YFFramework.game.core.module.task.enum.TaskState;
	
	import flash.display.MovieClip;
	
	/**2012-11-6 下午3:09:51
	 *@author yefeng
	 */
	public class SmallMapPlayer extends YFSmallMapIcon
	{
		private var _nameLabel:YFLabel;
		private var _roleDyVo:SmallMapRoleVo;
		/** 任务 状态 容器      里面放置的是  问号     感叹号 等图标  表示任务状态
		 */		
		private var _flagContainer:AbsView;
		
		private var _myRole:RoleDyVo;
		public function SmallMapPlayer(roleDyVo:SmallMapRoleVo)
		{
			_roleDyVo=roleDyVo;
			if(roleDyVo.bigCatergory==TypeRole.BigCategory_Monster||roleDyVo.bigCatergory==TypeRole.BigCategory_Player||roleDyVo.bigCatergory==TypeRole.BigCategory_Pet)
			{
				_myRole=RoleDyManager.Instance.getRole(_roleDyVo.dyId);
			}
			var skinId:int=0;
			var npcSKinId:int;
			switch(roleDyVo.bigCatergory)
			{
				case TypeRole.BigCategory_NPC:  // npc 
					skinId=1;
					buttonMode=true;
					var npc_postionVo:Npc_PositionBasicVo=Npc_PositionBasicManager.Instance.getNpc_PositionBasicVo(roleDyVo.dyId);
//					npcSKinId=npc_postionVo.styleId;
					skinId=npc_postionVo.styleId;
					break;
				case TypeRole.BigCategory_Monster:  // 怪物
					skinId=2;
					break;
				case TypeRole.BigCategory_Transfer: ///传送点
					skinId=3;
					break;
				case TypeRole.BigCategory_Player:  //如果为队友 则显示队友的图标
					skinId=4;
					break;
				case TypeRole.BigCategory_MonsterZone: ///怪物区域 图标
					skinId=5;
					break;
			}
			super(skinId);
			mouseChildren=false;
		}
		
		override protected function initUI():void
		{
			super.initUI();
			tooltip=_roleDyVo.roleName;
			if(_roleDyVo.bigCatergory==TypeRole.BigCategory_NPC||_roleDyVo.bigCatergory==TypeRole.BigCategory_Transfer||_roleDyVo.bigCatergory==TypeRole.BigCategory_MonsterZone)
			{
				_nameLabel=new YFLabel();
				addChild(_nameLabel);
				text=_roleDyVo.roleName;
				_nameLabel.setColor(0xFFFF99);
			}
			_flagContainer=new AbsView(false);
			addChild(_flagContainer);
			_flagContainer.y=-50
			_flagContainer.x=-12;
				
		}
		/**更新世界坐标
		 * @param ratio 缩放因子
		 */		
		public function updateMapPosition(ratio:Number):void
		{
			if(_myRole)
			{
				x=_myRole.mapX*ratio;
				y=_myRole.mapY*ratio;
			}
			else
			{
				x=_roleDyVo.mapX*ratio;
				y=_roleDyVo.mapY*ratio;
			}
			
		}
		
		private function set text(value:String):void
		{
			_nameLabel.text=value;
			_nameLabel.exactWidth();
			_nameLabel.y=_bitmap.y-_nameLabel.textHeight;
			_nameLabel.x=-_nameLabel.textWidth*0.5
		}
		
		public function get smallMapRoleVo():SmallMapRoleVo
		{
			return _roleDyVo;
		}
		
		override public function dispose():void
		{
			super.dispose();
			_nameLabel=null;
			_roleDyVo=null;
			_myRole=null;
		}
		
		/**
		 * 任务state状态  
		 * 任务 quality品质
		 * npcTalk   为 任务 目标类型   TaskTargetType_    TaskTargetType_
		 */		
		public function setState(state:int,quality:int=1,npcTalkType:int=0):void
		{
			_flagContainer.removeAllContent(true);
			var mc:MovieClip=NPCIocnQualityUtil.getTaskItemMC(state,quality,npcTalkType);
			if(mc)_flagContainer.addChild(mc);
		}
		 
		
	}
}