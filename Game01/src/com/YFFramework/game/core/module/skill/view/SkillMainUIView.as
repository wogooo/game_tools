package com.YFFramework.game.core.module.skill.view
{
	import com.YFFramework.core.debug.print;
	import com.YFFramework.core.event.YFEvent;
	import com.YFFramework.core.event.YFEventCenter;
	import com.YFFramework.core.proxy.StageProxy;
	import com.YFFramework.game.core.global.event.GlobalEvent;
	import com.YFFramework.game.core.global.util.DragManager;
	import com.YFFramework.game.core.module.skill.events.SkillEvent;
	import com.YFFramework.game.core.module.skill.mamanger.SkillDyManager;
	import com.YFFramework.game.core.module.skill.model.SkillDyVo;
	import com.YFFramework.game.core.module.skill.model.proto.DeleteSKillShortCutVo;
	import com.YFFramework.game.core.module.skill.model.proto.SkillShortCutVo;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.utils.Dictionary;

	/**主界面的 技能ui区域
	 * @author yefeng
	 *2012-11-3下午3:00:58
	 */
	public class SkillMainUIView
	{
		/**鼠标按下
		 */		
		private var _isMouseDown:Boolean;
		/**从主面板拖动的技能
		 */	
		private var _dragFromMainUI:Boolean;
		
		private var _skillCDViewDict:Dictionary;
		/**技能图标的存放容器
		 */		
		private var __skillIconContainer:Sprite;
		public function SkillMainUIView()
		{
			
			initUI();
			addEvents();
		}
		
		private function initUI():void
		{
			_isMouseDown=false;
			_skillCDViewDict=new Dictionary();
		}
		
		private function addEvents():void
		{
			YFEventCenter.Instance.addEventListener(GlobalEvent.SkillPaneMouseUp,onSkillMouseUp);
			StageProxy.Instance.mouseUp.regFunc(stageMouseUp);
		}
		private function onMouseEvent(e:MouseEvent):void
		{
			var skillCDView:SKillCDView=e.currentTarget as SKillCDView;
			if(skillCDView)
			{
				switch(e.type)
				{
					case MouseEvent.MOUSE_DOWN:
						_isMouseDown=true;				
						break;
					case MouseEvent.MOUSE_MOVE:
						if(_isMouseDown&&DragManager.Instance.dragVo==null) 
						{
							DragManager.Instance.startDragSkill(skillCDView);
							_dragFromMainUI=true;
						}
						break;
				}	
			}
		}
		private function stageMouseUp():void
		{
			var skillDyVo:SkillDyVo=DragManager.Instance.dragVo as SkillDyVo;
			if(skillDyVo&&_dragFromMainUI)  ///删除技能
			{
				noticeDeleteSKillShortCut(skillDyVo.skillId);
			}
			_isMouseDown=false;
			_dragFromMainUI=false;
		}
		private function onSkillMouseUp(e:YFEvent):void
		{
			_dragFromMainUI=false;
			var obj:Object=e.param;
			var skillDyVo:SkillDyVo;
			if(DragManager.Instance.dragVo)
			{
				skillDyVo=DragManager.Instance.dragVo as SkillDyVo;
				if(skillDyVo)
				{
					print(this,"拉出技能图标 ");	
					__skillIconContainer=obj.container
					///图标大小 为  主界面 为40区域大小  而  技能图标大小为 32*32 
					///跟据 x坐标定位     格子数是从  1 开始
					var gridNum:int=int(obj.x/40)+1 ;
					noticeSetSkillShortCut(skillDyVo.skillId,gridNum);
					
				
				}
			}
		}

		/**设置技能快捷方式
		 * skillId 技能 id 
		 */		
		private function noticeSetSkillShortCut(skillId:int,grid:int):void
		{
			var skillShortCutVo:SkillShortCutVo=new SkillShortCutVo();
			skillShortCutVo.grid=grid;
			skillShortCutVo.id=skillId;
			YFEventCenter.Instance.dispatchEventWith(SkillEvent.C_SetSkillShortCut,skillShortCutVo);
		}
		
		/**提示 删除技能技能快捷方式
		 */		
		private function noticeDeleteSKillShortCut(skillId:int):void
		{
			var deleteSkill:DeleteSKillShortCutVo=new DeleteSKillShortCutVo();
			deleteSkill.id=skillId;
			YFEventCenter.Instance.dispatchEventWith(SkillEvent.C_DeleteSkillShortCut,deleteSkill);
		}
		
		/**更新技能的快捷方式 
		 */		
		public function updateSkillShortCut(skillSortCutVo:SkillShortCutVo):void
		{
			var gridNum:int=skillSortCutVo.grid;
			var skillDyVo:SkillDyVo=SkillDyManager.Instance.getSkillDyVo(skillSortCutVo.id);
			var mX:Number=(gridNum-1)*40+(40-32)/2;
			var my:Number=(40-32)/2;
			var skillCDView:SKillCDView;
			if(_skillCDViewDict[skillDyVo.skillId]) ///存在技能  
			{
				skillCDView=_skillCDViewDict[skillDyVo.skillId];
			}
			else  //不存在
			{
				skillCDView=new SKillCDView();
				skillCDView.initSkillId(skillDyVo.skillId);
				__skillIconContainer.addChild(skillCDView);
				///事件侦听
				skillCDView.addEventListener(MouseEvent.MOUSE_MOVE,onMouseEvent);
				skillCDView.addEventListener(MouseEvent.MOUSE_DOWN,onMouseEvent);
				_skillCDViewDict[skillDyVo.skillId]=skillCDView;
			}
			////定位
			skillCDView.x=mX;
			skillCDView.y=my;
		}
		
		
		/**删除技能快捷方式
		 */		
		public function updateDeleteSKillShortCut(skillId:int):void
		{
			var skillCDView:SKillCDView=_skillCDViewDict[skillId];
			delete _skillCDViewDict[skillId];
			skillCDView.removeEventListener(MouseEvent.MOUSE_MOVE,onMouseEvent);
			skillCDView.removeEventListener(MouseEvent.MOUSE_DOWN,onMouseEvent);
			skillCDView.parent.removeChild(skillCDView);
			skillCDView.dispose();

		}

		/**更新播放技能動畫
		 */ 
		public function updatePlayCD(skillId:int):void
		{
			var skillCDView:SKillCDView=_skillCDViewDict[skillId];
			if(skillCDView!=null)///技能如果存在 
			{
				skillCDView.playCD();
			}
				
				
		}

		
		
	}
}
