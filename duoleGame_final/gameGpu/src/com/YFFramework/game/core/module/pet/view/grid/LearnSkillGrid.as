package com.YFFramework.game.core.module.pet.view.grid
{
	import com.YFFramework.core.event.YFEventCenter;
	import com.YFFramework.game.core.global.DataCenter;
	import com.YFFramework.game.core.global.manager.CharacterDyManager;
	import com.YFFramework.game.core.global.manager.PropsBasicManager;
	import com.YFFramework.game.core.global.manager.PropsDyManager;
	import com.YFFramework.game.core.global.manager.SkillBasicManager;
	import com.YFFramework.game.core.global.model.PropsBasicVo;
	import com.YFFramework.game.core.global.model.SkillBasicVo;
	import com.YFFramework.game.core.global.util.NoticeUtil;
	import com.YFFramework.game.core.global.util.TypeProps;
	import com.YFFramework.game.core.module.bag.data.BagStoreManager;
	import com.YFFramework.game.core.module.notice.manager.NoticeManager;
	import com.YFFramework.game.core.module.notice.model.NoticeType;
	import com.YFFramework.game.core.module.pet.events.PetEvent;
	import com.YFFramework.game.core.module.pet.manager.PetDyManager;
	import com.YFFramework.game.core.module.pet.model.PetConfig;
	import com.YFFramework.game.core.module.pet.view.PetLearnPanel;
	import com.dolo.lang.LangBasic;
	import com.dolo.ui.controls.Alert;
	import com.dolo.ui.controls.IconImage;
	import com.dolo.ui.events.AlertCloseEvent;
	import com.dolo.ui.tools.AutoBuild;
	import com.dolo.ui.tools.Xdis;
	import com.msg.pets.CAddSkillSlot;
	import com.msg.pets.CUpgradePetSkill;
	
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	/**
	 * @version 1.0.0
	 * creation time：2013-11-11 下午7:47:36
	 */
	public class LearnSkillGrid{
		
		public var _skillId:int;
		public var _skillLv:int;
		private var _index:int;
		private var _clickable:Boolean;
		private var _mc:MovieClip;
		private var _icon:IconImage;
		private var _lockMc:MovieClip;
		private var _lock:Boolean;
		private var _addBtn:SimpleButton;
		private var _lockGridImg:MovieClip;
		
		public function LearnSkillGrid(index:int,mc:MovieClip,clickable:Boolean,locked:Boolean){
			_mc = mc;
			_index = index;
			_clickable = clickable;
			
			AutoBuild.replaceAll(_mc);
			_icon = Xdis.getChild(_mc,"skill_iconImage");
			_lockGridImg = Xdis.getChild(_mc,"lockImg");
			_lockGridImg.visible=false;
			_lockGridImg.addEventListener(MouseEvent.CLICK,onLockGridClick);
			if(_clickable)	_icon.addEventListener(MouseEvent.CLICK,onClick);
			_lockMc = _mc.lockMc;
			_addBtn = _mc.upBtn;
			_addBtn.addEventListener(MouseEvent.CLICK,onAddClick);
			if(locked){
				_lockMc.gotoAndStop(2);
				_lock = locked;
			}else{
				_lockMc.gotoAndStop(1);
				_lock = locked;
			}
		}
		
		/**获得锁定图片 
		 * @return 
		 */		
		public function getLockGridImg():MovieClip{
			return _lockGridImg;
		}
		
		/**获得锁图片
		 * @return 
		 */		
		public function getLockMc():MovieClip{
			return _lockMc;
		}
		
		/**设置技能内容
		 * @param skillId
		 * @param skillLevel
		 */		
		public function setSkillInfo(skillId:int,skillLevel:int):void{
			_skillId = skillId;
			_skillLv = skillLevel;
		}
		
		/**获得技能升级按钮
		 * @return 
		 */		
		public function getAddBtn():SimpleButton{
			return _addBtn;
		}
		
		/**查看技能是否锁定
		 * @return 
		 */		
		public function isLocked():Boolean{
			return _lock;
		}
		
		/** 获得技能的iconiamge
		 * @return 
		 */		
		public function get iconImage():IconImage{
			return _icon;
		}
		
		/**扩展技能栏点击
		 * @param e
		 */		
		private function onLockGridClick(e:MouseEvent):void{
			//提示扩展宠物技能格子需要的魔钻
			Alert.show(LangBasic.getPet_Open_SkillGridStr(),LangBasic.Pet_SkillGrid_Title,GridOpenAlertCallback,LangBasic.Pet_SkillGrid_BtnLabels);
		}
		
		private function GridOpenAlertCallback(e:AlertCloseEvent):void
		{//用户点击 确认 时发送消息，否则什么都不做
			if(e.clickButtonIndex==1)
			{
				if(DataCenter.Instance.roleSelfVo.diamond>=PetConfig.pet_skill_slot_cost)
				{
					var msg:CAddSkillSlot = new CAddSkillSlot();
					msg.petId = PetDyManager.crtPetId;
					var vo:PropsBasicVo = PropsBasicManager.Instance.getAllBasicVoByType(TypeProps.PROPS_TYPE_PET_COMPRE)[0];
					var pos:int = PropsDyManager.instance.getFirstPropsPos(vo.template_id);
					if(pos>0){
						msg.itemPos = pos;
					}
					YFEventCenter.Instance.dispatchEventWith(PetEvent.ComprehendReq,msg);
				}
				else
				{
					NoticeManager.setNotice(NoticeType.Notice_id_319);//提示魔钻不足
				}
			}
		}
		
		/**技能升级点击
		 * @param e
		 */		
		private function onAddClick(e:MouseEvent):void{
			var vo:SkillBasicVo = SkillBasicManager.Instance.getSkillBasicVo(_skillId,_skillLv);
			if(CharacterDyManager.Instance.magicSoul<getQuality(vo.quality)){
				NoticeUtil.setOperatorNotice("魔元不够，无法升级");
			}else{
				var msg:CUpgradePetSkill = new CUpgradePetSkill();
				msg.petId = PetDyManager.crtPetId;
				msg.skillId = _skillId;
				YFEventCenter.Instance.dispatchEventWith(PetEvent.SkillLvUp,msg);
			}
		}
		
		/**根据quality获得所需要消耗的魔元
		 * @param quality
		 * @return 
		 */		
		private function getQuality(quality:int):int{
			switch(quality){
				case TypeProps.QUALITY_WHITE:return 200;
				case TypeProps.QUALITY_GREEN:return 400;
				case TypeProps.QUALITY_BLUE:return 800;
				case TypeProps.QUALITY_PURPLE:return 1600;
				case TypeProps.QUALITY_ORANGE:return 3200;
				case TypeProps.QUALITY_RED:return 6400;
			}
			return 0;
		}
		
		/**锁定、解锁技能
		 * @param e
		 */		
		private function onClick(e:MouseEvent):void{
			if(PetLearnPanel.Refreshed==true)	return;
			
			if(_lock){
				_lock = false;
				_lockMc.gotoAndStop(1);
				PetDyManager.Instance.getCrtPetDyVo().lockGridArray[_index]=false;
				YFEventCenter.Instance.dispatchEventWith(PetEvent.updateLock);
			}else{
				_lock = true;
				_lockMc.gotoAndStop(2);
				PetDyManager.Instance.getCrtPetDyVo().lockGridArray[_index]=true;
				YFEventCenter.Instance.dispatchEventWith(PetEvent.updateLock);
			}
		}
	}
} 