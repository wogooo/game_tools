package com.YFFramework.game.core.module.pet.view
{
	import com.YFFramework.core.event.YFEvent;
	import com.YFFramework.core.event.YFEventCenter;
	import com.YFFramework.core.net.loader.image_swf.IconLoader;
	import com.YFFramework.core.utils.common.ClassInstance;
	import com.YFFramework.game.core.global.event.GlobalEvent;
	import com.YFFramework.game.core.global.manager.CharacterDyManager;
	import com.YFFramework.game.core.global.manager.ConstMapBasicManager;
	import com.YFFramework.game.core.global.manager.PetBasicManager;
	import com.YFFramework.game.core.global.manager.PropsBasicManager;
	import com.YFFramework.game.core.global.manager.PropsDyManager;
	import com.YFFramework.game.core.global.manager.SkillBasicManager;
	import com.YFFramework.game.core.global.model.PetBasicVo;
	import com.YFFramework.game.core.global.model.PropsBasicVo;
	import com.YFFramework.game.core.global.util.NoticeUtil;
	import com.YFFramework.game.core.global.util.TypeProps;
	import com.YFFramework.game.core.global.view.tips.PropsTip;
	import com.YFFramework.game.core.global.view.tips.SkillTip;
	import com.YFFramework.game.core.global.view.tips.TipUtil;
	import com.YFFramework.game.core.module.autoSetting.manager.AutoManager;
	import com.YFFramework.game.core.module.notMetion.data.NotMetionDataManager;
	import com.YFFramework.game.core.module.notMetion.view.NotMetionWindow;
	import com.YFFramework.game.core.module.notice.manager.NoticeManager;
	import com.YFFramework.game.core.module.pet.events.PetEvent;
	import com.YFFramework.game.core.module.pet.manager.PetDyManager;
	import com.YFFramework.game.core.module.pet.model.PetDyVo;
	import com.YFFramework.game.core.module.pet.view.collection.ItemsCollection;
	import com.YFFramework.game.core.module.pet.view.collection.PetsCollection;
	import com.YFFramework.game.core.module.pet.view.collection.SkillsCollection;
	import com.YFFramework.game.core.module.pet.view.grid.Item;
	import com.YFFramework.game.core.module.pet.view.grid.LearnSkillGrid;
	import com.YFFramework.game.core.module.pet.view.grid.PetItem;
	import com.YFFramework.game.core.module.shop.controller.ModuleShop;
	import com.YFFramework.game.core.module.shop.data.ShopBasicManager;
	import com.YFFramework.game.gameConfig.URLTool;
	import com.YFFramework.game.ui.layer.LayerManager;
	import com.dolo.ui.controls.Button;
	import com.dolo.ui.controls.VScrollBar;
	import com.dolo.ui.managers.UI;
	import com.dolo.ui.tools.AutoBuild;
	import com.dolo.ui.tools.Xdis;
	import com.dolo.ui.tools.Xtip;
	import com.msg.hero.CUseItem;
	import com.msg.pets.CPetLearnSkill;
	import com.msg.pets.CRefreshPetSkill;
	import com.msg.pets.CReplaceSkill;
	
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.events.MouseEvent;
	import flash.external.ExternalInterface;
	
	/**
	 * @version 1.0.0
	 * creation time：2013-3-8 下午2:57:07
	 * 宠物技能学习面板
	 */
	public class PetLearnPanel{
		private var _mc:MovieClip;
		
		private var petsCollection:PetsCollection;
		private var petScrollbar:VScrollBar;
		
		private var _learnSkills:Vector.<LearnSkillGrid>;
		private var _newSkills:Vector.<LearnSkillGrid>;
		
		private var refresh_button:Button;
		private var sub_button:Button;
		private var addBtn:SimpleButton;
		public static var Refreshed:Boolean=false;
		public static var HighestQuality:int=0;
		private static var MagicSoulItemType:int=31;
		
		public function PetLearnPanel(mc:MovieClip){
			_mc = mc;
			
			AutoBuild.replaceAll(_mc);
			
			refresh_button = Xdis.getChild(_mc,"refresh_button");
			refresh_button.addEventListener(MouseEvent.CLICK,onRefresh);
			
			sub_button = Xdis.getChild(_mc,"sub_button");
			sub_button.addEventListener(MouseEvent.CLICK,onSub);
			sub_button.enabled=false;
			
			petsCollection=new PetsCollection(0,30);
			petsCollection.init();
			_mc.addChild(petsCollection);
			
			petScrollbar = Xdis.getChild(_mc,"mainPet_vScrollBar");
			petScrollbar.setTarget(petsCollection,false,160,395);
			petScrollbar.updateSize(30*49+10);
			_mc.addChild(petScrollbar);
			
			_learnSkills = new Vector.<LearnSkillGrid>();
			_newSkills = new Vector.<LearnSkillGrid>();
			for(var i:int=0;i<8;i++){
				var learnSkill:LearnSkillGrid = new LearnSkillGrid(i,_mc["s"+i],true,false);//下面可操作部分
				learnSkill.getLockMc().mouseEnabled=false;
				learnSkill.getLockMc().mouseChildren=false;
				_learnSkills.push(learnSkill);
				
				var newSkill:LearnSkillGrid = new LearnSkillGrid(i,_mc["ss"+i],false,false);//上面刷新显示的
				newSkill.getAddBtn().visible=false;
				newSkill.getLockMc().visible=false;
				_newSkills.push(newSkill);
			}
			
			addBtn = _mc.addBtn;
			addBtn.addEventListener(MouseEvent.CLICK,onAdd);
			
			YFEventCenter.Instance.addEventListener(PetEvent.updateLock,updateSpendTxt);
		}
		/**增加魔元按钮点击
		 * @param e
		 */		
		private function onAdd(e:MouseEvent):void{
//			ExternalInterface.call(
			if(CharacterDyManager.Instance.magicSoul==10000){
				NoticeUtil.setOperatorNotice("魔元已满，无法添加");
			}else{
				var bvo:PropsBasicVo = PropsBasicManager.Instance.getAllBasicVoByType(MagicSoulItemType)[0];
				var pos:int = PropsDyManager.instance.getFirstPropsPos(bvo.template_id);
				if(pos<=0){
					AutoManager.autoUseTempId= bvo.template_id;
					ModuleShop.instance.buyItemDirect(TypeProps.ITEM_TYPE_PROPS,AutoManager.autoUseTempId,1);
				}else{
					var msg:CUseItem = new CUseItem();
					msg.itemPos = pos;
					YFEventCenter.Instance.dispatchEventWith(GlobalEvent.USE_ITEM,msg);
				}
			}
		}
		/**替换按钮点击
		 * @param e
		 */		
		private function onSub(e:MouseEvent):void{
			Refreshed = false;
			sub_button.enabled=false;
			var msg:CReplaceSkill = new CReplaceSkill();
			msg.petId = PetDyManager.crtPetId;
			YFEventCenter.Instance.dispatchEventWith(PetEvent.SubSkill,msg);
		}
		/**刷新按钮点击
		 * @param e
		 */		
		private function onRefresh(e:MouseEvent):void{
			if(_mc.spendTxt.textColor==TypeProps.COLOR_RED){
				NoticeUtil.setOperatorNotice("魔元不足，无法刷新");
			}else{
				if(NotMetionDataManager.petLearnSkill==false){
					refresh();
				}else{
					var arr:Array = PetDyManager.Instance.getCrtPetDyVo().skillAttrs;
					var len:int = arr.length;
					for(var i:int=0;i<len;i++){
						if(SkillBasicManager.Instance.getSkillBasicVo(arr[i].skillId,arr[i].skillLevel).quality>=TypeProps.QUALITY_PURPLE){
							
							NotMetionWindow.show("当前有高品质技能是否继续刷新",onConfirm);
							return;
						}
					}
				}
				refresh();
			}
		}
		/**刷新
		 */		
		private function refresh():void{
			Refreshed = true;
			sub_button.enabled=true;
			var msg:CRefreshPetSkill = new CRefreshPetSkill();
			msg.petId = PetDyManager.crtPetId;
			msg.lockSkills = new Array();
			var arr:Array = PetDyManager.Instance.getCrtPetDyVo().lockGridArray;
			var skillArr:Array = PetDyManager.Instance.getCrtPetDyVo().skillAttrs;
			var len:int = arr.length;
			for(var i:int=0;i<len;i++){
				if(arr[i]==true){
					msg.lockSkills.push(skillArr[i].skillId);
				}
			}
			YFEventCenter.Instance.dispatchEventWith(PetEvent.RefreshSkill,msg);
		}
		/**确认按钮点击
		 * @param data
		 */		
		private function onConfirm(data:Boolean):void{
			NotMetionDataManager.petLearnSkill=data;
			refresh();
		}
		/**切换界面更新
		 */		
		public function onTabUpdate():void{
			updatePetList();
			updateSkill();
		}
		/**选中宠物更新
		 * @param petItem
		 */		
		public function onSelectUpdate(petItem:PetItem):void{
			petsCollection.setFilter(petItem.getIndex());
			updateSkill();
		}
		/**更新宠物列表
		 */		
		public function updatePetList():void{
			_mc.petTxt.text="宠物列表("+PetDyManager.Instance.getPetListSize()+"/"+PetDyManager.petOpenSlots+")";
			petsCollection.openSlot();
			petsCollection.clearPetContent();
			petsCollection.loadContent();
		}
		/**更新技能
		 */		
		public function updateSkill():void{
			for(var i:int=0;i<8;i++){
				_learnSkills[i].iconImage.clear();
				_learnSkills[i].getAddBtn().visible=false;
				_learnSkills[i].getLockMc().visible=false;
				_learnSkills[i].getLockGridImg().visible=false;
				_newSkills[i].iconImage.clear();
				_mc["t"+i].text="";
			}
			
			if(PetDyManager.crtPetId!=-1){
				var vo:PetDyVo = PetDyManager.Instance.getCrtPetDyVo();
				var skillArr:Array = vo.skillAttrs;
				var lockArr:Array = vo.lockGridArray;
				var skillOpenSlots:int = vo.skillOpenSlots;
				var len:int=skillArr.length;
				var index:int=0;
				for(i=0;i<len;i++){
					if(skillArr[i].skillId != PetDyManager.Instance.getCrtPetDyVo().defaultSkillId){
						_learnSkills[index].iconImage.url = (SkillBasicManager.Instance.getURL(skillArr[i].skillId,skillArr[i].skillLevel));
						_learnSkills[index].setSkillInfo(skillArr[i].skillId,skillArr[i].skillLevel);
						_mc["t"+i].text = "lv "+skillArr[i].skillLevel;
						Xtip.registerLinkTip(_learnSkills[index].iconImage,SkillTip,TipUtil.skillTipInitFunc,skillArr[i].skillId,skillArr[i].skillLevel);
						_learnSkills[index].getLockMc().visible=true;
						UI.setEnable(_learnSkills[index].getLockMc(),!sub_button.enabled,false);
						if(skillArr[i].skillLevel<10){
							_learnSkills[index].getAddBtn().visible=true;
						}
						if(vo.lockGridArray[index]==true){
							var quality:int = SkillBasicManager.Instance.getSkillBasicVo(skillArr[i].skillId,skillArr[i].skillLevel).quality;
							if(quality>HighestQuality){
								HighestQuality = quality;
							}
						}
						index++;
					}
				}
				
				for(i=PetDyManager.Instance.getCrtPetDyVo().skillOpenSlots;i<8;i++){
					_learnSkills[i].getLockGridImg().visible=true;
				}
				
				var newSkillArr:Array = vo.newLearnSkills;
				index=0;
				len=newSkillArr.length;
				for(i=0;i<len;i++){
					if(newSkillArr[i].skillId != PetDyManager.Instance.getCrtPetDyVo().defaultSkillId){
						_newSkills[index].iconImage.url = (SkillBasicManager.Instance.getURL(newSkillArr[i].skillId,newSkillArr[i].skillLevel));
						_newSkills[index].setSkillInfo(newSkillArr[i].skillId,newSkillArr[i].skillLevel);
						Xtip.registerLinkTip(_newSkills[index].iconImage,SkillTip,TipUtil.skillTipInitFunc,newSkillArr[i].skillId,newSkillArr[i].skillLevel);
						index++;
					}
				}
				getSpendTxt();
				if(_mc.spendTxt.textColor == TypeProps.COLOR_RED){
					refresh_button.enabled=false;
				}else{
					refresh_button.enabled=true;
				}
				
			}else{
				_mc.spendTxt.text ="";
				refresh_button.enabled=false;
				sub_button.enabled=false;
			}
			_mc.soulTxt.text = "魔元："+CharacterDyManager.Instance.magicSoul;
		}
		/**更新魔元文本
		 */		
		public function updateMagicSoulTxt():void{
			_mc.soulTxt.text = "魔元："+CharacterDyManager.Instance.magicSoul;
			getSpendTxt();
			if(_mc.spendTxt.textColor == TypeProps.COLOR_RED){
				refresh_button.enabled=false;
			}else{
				refresh_button.enabled=true;
			}
		}
		/**更新消耗文本
		 * @param e
		 */		
		public function updateSpendTxt(e:YFEvent):void{
			var len:int = _learnSkills.length;
			HighestQuality=TypeProps.QUALITY_WHITE;
			for(var i:int=0;i<len;i++){
				if(_learnSkills[i].isLocked()==true){
					var quality:int = SkillBasicManager.Instance.getSkillBasicVo(_learnSkills[i]._skillId,_learnSkills[i]._skillLv).quality;
					if(quality>HighestQuality){
						HighestQuality=quality
					}
				}
			}
			
			getSpendTxt();
		}
		/**获取消耗魔元
		 */		
		private function getSpendTxt():void{
			var neededSoul:int;
			switch(HighestQuality){
				case TypeProps.QUALITY_GREEN:
					neededSoul = 400;
					_mc.spendTxt.text = "消耗魔元：400";
					break;
				case TypeProps.QUALITY_BLUE:
					neededSoul = 800;
					_mc.spendTxt.text = "消耗魔元：800";
					break;
				case TypeProps.QUALITY_PURPLE:
					neededSoul = 1600;
					_mc.spendTxt.text = "消耗魔元：1600";
					break;
				case TypeProps.QUALITY_ORANGE:
					neededSoul = 3200;
					_mc.spendTxt.text = "消耗魔元：3200";
					break;
				case TypeProps.QUALITY_RED:
					neededSoul = 6400;
					_mc.spendTxt.text = "消耗魔元：6400";
					break;
				default:
					neededSoul = 200;
					_mc.spendTxt.text = "消耗魔元：200";
					break;
			}
			if(neededSoul<=CharacterDyManager.Instance.magicSoul){
				_mc.spendTxt.textColor = TypeProps.C8CF213;
			}else{
				_mc.spendTxt.textColor = TypeProps.COLOR_RED;
			}
		}	
		/**重置
		 */		
		public function reset():void{
			Refreshed=false;
			sub_button.enabled=false;
			var arr:Array = PetDyManager.Instance.getPetIdArray();
			var len:int = arr.length;
			for(var i:int=0;i<len;i++){
				var vo:PetDyVo = PetDyManager.Instance.getPetDyVo(arr[i]);
				vo.newLearnSkills.splice(0);
				var skills:Array = vo.skillAttrs;
				var len2:int = skills.length;
				for(var j:int=0;j<len2;j++){
					vo.newLearnSkills.push(skills[j]);
				}
			}
		}
	}
} 