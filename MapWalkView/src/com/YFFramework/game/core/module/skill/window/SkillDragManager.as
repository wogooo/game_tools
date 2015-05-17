package com.YFFramework.game.core.module.skill.window
{
	import com.YFFramework.game.core.global.manager.SkillBasicManager;
	import com.YFFramework.game.core.global.model.SkillBasicVo;
	import com.YFFramework.game.core.global.model.TypeSkill;
	import com.YFFramework.game.core.global.util.DragManager;
	import com.YFFramework.game.core.global.util.NoticeUtil;
	import com.YFFramework.game.core.module.skill.model.SkillDyVo;
	import com.dolo.lang.LangBasic;
	import com.dolo.ui.controls.IconImage;
	import com.dolo.ui.managers.UI;
	
	import flash.display.InteractiveObject;
	import flash.display.Sprite;
	import flash.events.MouseEvent;

	/**
	 * 技能拖动管理 
	 * @author flashk
	 * 
	 */
	public class SkillDragManager
	{
		private var _uis:Array = [];
		private var _tabUIC:SkillTabUIC;
		
		public function SkillDragManager(uic:SkillTabUIC)
		{
			_tabUIC = uic;
		}
		
		public function add(view:Sprite):void
		{
			 _uis.push(view);
			 view.addEventListener(MouseEvent.MOUSE_DOWN,checkDrag);
		}
		
		protected function checkDrag(event:MouseEvent):void
		{
			var view:Sprite = event.currentTarget  as Sprite;
			if(UI.isEnable(view)==true){
				var vo:SkillDyVo = _tabUIC.findDyVO(view);
				if(vo){
					var bvo:SkillBasicVo = SkillBasicManager.Instance.getSkillBasicVo(vo.skillId,vo.skillLevel);
					//被动技能不能被拖动到技能栏
					if(bvo && bvo.use_type == TypeSkill.UseType_Passive) return;
					DragManager.Instance.startDrag(view.getChildByName("icon_iconImage") as Sprite,vo);
				}
			}
		}
		
	}
}