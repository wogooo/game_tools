package com.YFFramework.game.core.module.pet.view.collection
{
	import com.YFFramework.core.utils.HashMap;
	import com.YFFramework.game.core.global.util.FilterConfig;
	import com.YFFramework.game.core.module.pet.manager.PetDyManager;
	import com.YFFramework.game.core.module.pet.view.grid.SkillGrid;
	
	import flash.display.MovieClip;
	import flash.events.MouseEvent;

	/**
	 * @version 1.0.0
	 * creation time：2013-3-21 上午11:49:02
	 * 
	 */
	public class SkillsCollection{
		
		private var _skills:Vector.<SkillGrid>;
		
		public function SkillsCollection(){
			_skills = new Vector.<SkillGrid>();
		}
		
		/**
		 * 把宠物技能全部加载到容器里面
		 * infoPanel=true,信息面板的技能显示
		 **/
		public function loadContent(infoPanel:Boolean,mc:MovieClip):void{
			if(PetDyManager.crtPetId!=-1){
				var skillArr:Array = PetDyManager.Instance.getCrtPetDyVo().skillAttrs;
				var skillOpenSlots:int = PetDyManager.Instance.getCrtPetDyVo().skillOpenSlots;
				var index:int=0;
				for(var i:int=0;i<skillArr.length;i++){
					if(skillArr[i].skillId != PetDyManager.Instance.getCrtPetDyVo().defaultSkillId){
						var skill:SkillGrid = new SkillGrid(index,false,infoPanel,mc["i"+index],skillArr[i].skillId,skillArr[i].skillLevel);
						_skills.push(skill);
						index++;
					}
				}
				for(i=skillOpenSlots;i<8;i++){
					skill = new SkillGrid(i,true,infoPanel,mc["i"+i],0,0);
					_skills.push(skill);
				}
			}
		}

		/**
		 * 指定对象进行filter.如果index=-1,清空全部filter
		 **/
		public function setFilter(index:int):void{
			for(var i:int=0;i<_skills.length;i++){
				_skills[i].getMC().filters = null;
			}
			if(index!=-1)
				_skills[index].getMC().filters = FilterConfig.white_glow_filter;
		}
		
		/**
		 * 把全部内容清除
		 **/
		public function clearSkillGrid():void{
			for(var i:int=0;i<_skills.length;i++){
				if(_skills[i].getMC().numChildren>0)
					_skills[i].getMC().removeChildAt(0);
					_skills[i].removeListener();
			}
			_skills = new Vector.<SkillGrid>();
		}
	}
} 