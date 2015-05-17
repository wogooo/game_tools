package com.YFFramework.game.core.module.pet.view.grid
{
	import com.YFFramework.core.event.YFEventCenter;
	import com.YFFramework.core.net.loader.image_swf.IconLoader;
	import com.YFFramework.core.utils.common.ClassInstance;
	import com.YFFramework.game.core.global.event.GlobalEvent;
	import com.YFFramework.game.core.global.manager.SkillBasicManager;
	import com.YFFramework.game.core.module.pet.events.PetEvent;
	
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.sampler.getMasterString;

	/**
	 * @version 1.0.0
	 * creation time：2013-3-21 上午11:28:49
	 * 
	 */
	public class SkillGrid{
		
		private var _skillId:int;
		private var _mc:MovieClip;
		private var _index:int;
		private var _lock:Boolean;
		
		public function SkillGrid(index:int,lock:Boolean,infoPanel:Boolean,mc:MovieClip,skillID:int=0,skillLv:int=0){
			_mc = mc;
			_index = index;
			_lock = lock;
			if(lock==true){
				var lockImg:MovieClip = ClassInstance.getInstance("petSkillGrid");
				_mc.addChild(lockImg);
			}else{
				IconLoader.initLoader(SkillBasicManager.Instance.getURL(skillID,skillLv),mc);
				_skillId = skillID;
			}
			if(infoPanel==true)
				_mc.addEventListener(MouseEvent.CLICK,onClick);
		}
		
		public function getMC():MovieClip{
			return _mc;
		}
		
		public function getIndex():int{
			return _index;
		}
		
		public function getSkillId():int{
			return _skillId;
		}
		
		public function removeListener():void{
			if(_mc.hasEventListener(MouseEvent.CLICK))
				_mc.removeEventListener(MouseEvent.CLICK,onClick);
		}
		
		private function onClick(e:MouseEvent):void{
			if(_lock==true)
				YFEventCenter.Instance.dispatchEventWith(GlobalEvent.OPEN_PET_PANEL,3);
			else
				YFEventCenter.Instance.dispatchEventWith(PetEvent.Select_Skill,this);
		}
	}
} 