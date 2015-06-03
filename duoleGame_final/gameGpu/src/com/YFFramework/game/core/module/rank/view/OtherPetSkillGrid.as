package com.YFFramework.game.core.module.rank.view
{
	/**
	 * @version 1.0.0
	 * creation time：2013-6-25 下午3:41:01
	 * 
	 */
	import com.YFFramework.core.utils.common.ClassInstance;
	import com.YFFramework.game.core.global.manager.SkillBasicManager;
	import com.YFFramework.game.core.global.view.tips.SkillTip;
	import com.YFFramework.game.core.global.view.tips.TipUtil;
	import com.YFFramework.game.core.module.pet.model.PetSkillVo;
	import com.dolo.ui.controls.IconImage;
	import com.dolo.ui.tools.Xtip;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	
	public class OtherPetSkillGrid
	{
		//======================================================================
		//       public property
		//======================================================================
		
		//======================================================================
		//       private property
		//======================================================================
		private var _icon:IconImage;
		//======================================================================
		//        constructor
		//======================================================================
		
		public function OtherPetSkillGrid(skillIcon:IconImage)
		{
			_icon=skillIcon;			
		}
		
		//======================================================================
		//        public function
		//======================================================================
		public function updateSkill(data:PetSkillVo):void
		{
			_icon.url=SkillBasicManager.Instance.getURL(data.skillId,data.skillLevel);
			Xtip.registerLinkTip(_icon,SkillTip,TipUtil.skillTipInitFunc,data.skillId,data.skillLevel);

		}
		
		public function clearSkill():void
		{
			_icon.clear();
			Xtip.clearLinkTip(_icon);
		}
		//======================================================================
		//        private function
		//======================================================================
		
		//======================================================================
		//        event handler
		//======================================================================
		
		//======================================================================
		//        getter&setter
		//======================================================================
		
		
	}
} 