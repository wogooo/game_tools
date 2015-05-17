package com.YFFramework.game.core.module.pet.manager
{
	import com.YFFramework.core.center.manager.update.TimeOut;
	import com.YFFramework.core.center.manager.update.UpdateManager;
	import com.YFFramework.core.utils.HashMap;
	import com.YFFramework.game.core.global.manager.PetBasicManager;
	import com.YFFramework.game.core.global.util.TypeProps;
	import com.YFFramework.game.core.module.pet.model.PetDyVo;
	import com.YFFramework.game.core.module.pet.model.PetSkillVo;
	import com.YFFramework.game.core.global.model.StrRatioVo;
	import com.msg.common.SkillInfo;
	
	import flash.utils.Dictionary;
	import com.YFFramework.game.core.global.manager.StrRatioManager;
	
	public class PetDyManager{

		private static var instance:PetDyManager;
		private var _petsList:HashMap;
		private var _petIdArray:Array;
		private var _petOpenSlots:int;
		private var _fightPetId:int;		//0代表没有
		public static var crtPetId:int;		//当前选中宠物id;-1代表没有
		public static var cdPool:TimeOut;
		private var _aiMode:int;			//1主动；2被动；3跟随
		
		public function PetDyManager(){
			_petsList = new HashMap();
			_petIdArray = new Array();
		}
		
		public static function get Instance():PetDyManager{
			return instance ||= new PetDyManager();
		}

		/**  缓存服务端发来的宠物列表   {basicId  dyId level }   服务端的  RequestPetVo 类
		 */
		public function cachePetList(arr:Array):void{
			for each(var obj:Object in arr){
				addPetDyVo(obj);
			}
		}
		
		public function addPetDyVo(obj:Object,petId:int=0):void{
			var pet:PetDyVo;
			if(petId==0){
				pet = new PetDyVo();
				_petIdArray[_petIdArray.length] = obj.petId;
				_petsList.put(obj.petId,pet);
			}
			else{
				pet = _petsList.get(petId);
			}
			pet.dyId = obj.petId;
			pet.basicId = obj.configId;
			pet.potential = obj.potential;
			pet.exp = obj.exp;
			pet.level=obj.lv;
			pet.happy = obj.happy;
			pet.skillOpenSlots=obj.skillOpenSlots;
			if(obj.petNickname=="")
				pet.roleName = PetBasicManager.Instance.getPetConfigVo(pet.basicId).pet_type;
			else
				pet.roleName = obj.petNickname;
			pet.power = obj.petAttr.power;
			for(var i:int=0;i<obj.petAttr.petAttrs.length;i++){
				pet.fightAttrs[obj.petAttr.petAttrs[i].attrId] = obj.petAttr.petAttrs[i].attrValue;
			}
			for(i=0;i<obj.petSkills.length;i++){
				var petSkillVo:PetSkillVo = new PetSkillVo();
				petSkillVo.skillId = obj.petSkills[i].skillId;
				petSkillVo.skillLevel = obj.petSkills[i].skillLevel;
				pet.skillAttrs[i] = petSkillVo;
			}
			pet.enhanceLv = obj.enhanceLv;
			pet.speed = pet.fightAttrs[TypeProps.SPEED]/UpdateManager.IntervalRate;
			pet.defaultSkillId = obj.defaultSkillId;
			
			calStat(pet.dyId);
		}
		
		/**
		 * 计算宠物属性值
		 */	
		public function calStat(petId:int):void{
			var pet:PetDyVo = _petsList.get(petId);
			var petStrRatio:StrRatioVo = StrRatioManager.Instance.getStrRatioVo(pet.enhanceLv);
			pet.fightAttrs[TypeProps.BASIC_PHY_QLT_LIM]=Math.round(PetBasicManager.Instance.getPetConfigVo(pet.basicId).physique_apt*1.2*petStrRatio.ratio);
			pet.fightAttrs[TypeProps.BASIC_STR_QLT_LIM]=Math.round(PetBasicManager.Instance.getPetConfigVo(pet.basicId).strength_apt*1.2*petStrRatio.ratio);
			pet.fightAttrs[TypeProps.BASIC_AGI_QLT_LIM]=Math.round(PetBasicManager.Instance.getPetConfigVo(pet.basicId).agile_apt*1.2*petStrRatio.ratio);
			pet.fightAttrs[TypeProps.BASIC_INT_QLT_LIM]=Math.round(PetBasicManager.Instance.getPetConfigVo(pet.basicId).intelligence_apt*1.2*petStrRatio.ratio);
			pet.fightAttrs[TypeProps.BASIC_SPI_QLT_LIM]=Math.round(PetBasicManager.Instance.getPetConfigVo(pet.basicId).spirit_apt*1.2*petStrRatio.ratio);

			
			//petDyVo.fightAttrs[TypeProps.HEALTH_LIMIT] = Math.round(petDyVo.fightAttrs[TypeProps.BASIC_PHY]*petDyVo.fightAttrs[TypeProps.BASIC_PHY_QLT]*petDyVo.fightAttrs[TypeProps.GROWTH]/50);
			//petDyVo.fightAttrs[TypeProps.MANA_LIMIT] = Math.round(petDyVo.fightAttrs[TypeProps.BASIC_INTELL]*petDyVo.fightAttrs[TypeProps.BASIC_INTELL_QLT]*3*petDyVo.fightAttrs[TypeProps.GROWTH]/1000+petDyVo.fightAttrs[TypeProps.BASIC_SPIRIT]*petDyVo.fightAttrs[TypeProps.BASIC_SPIRIT_QLT]*petDyVo.fightAttrs[TypeProps.GROWTH]*6/1000);
			//宠物魔法上限是神马
			//petDyVo.fightAttrs[TypeProps.PHYSIC_ATK] = Math.round(petDyVo.fightAttrs[TypeProps.BASIC_STRENGTH]*petDyVo.fightAttrs[TypeProps.BASIC_STR_QLT]*petDyVo.fightAttrs[TypeProps.GROWTH]*3/1000+petDyVo.fightAttrs[TypeProps.BASIC_AGI]*petDyVo.fightAttrs[TypeProps.BASIC_AGI_QLT]*petDyVo.fightAttrs[TypeProps.GROWTH]*0.5/1000);
			//petDyVo.fightAttrs[TypeProps.PHYSIC_DEF] = Math.round(petDyVo.fightAttrs[TypeProps.BASIC_STRENGTH]*petDyVo.fightAttrs[TypeProps.BASIC_STR_QLT]*petDyVo.fightAttrs[TypeProps.GROWTH]*0.5/1000+petDyVo.fightAttrs[TypeProps.BASIC_AGI]*petDyVo.fightAttrs[TypeProps.BASIC_AGI_QLT]*petDyVo.fightAttrs[TypeProps.GROWTH]*3/1000);
			//petDyVo.fightAttrs[TypeProps.MAGIC_ATK] = Math.round(petDyVo.fightAttrs[TypeProps.BASIC_INTELL]*petDyVo.fightAttrs[TypeProps.BASIC_INTELL_QLT]*petDyVo.fightAttrs[TypeProps.GROWTH]*3/1000+petDyVo.fightAttrs[TypeProps.BASIC_SPIRIT]*petDyVo.fightAttrs[TypeProps.BASIC_SPIRIT_QLT]*petDyVo.fightAttrs[TypeProps.GROWTH]*0.5/1000);
			//petDyVo.fightAttrs[TypeProps.MAGIC_DEF] = Math.round(petDyVo.fightAttrs[TypeProps.BASIC_INTELL]*petDyVo.fightAttrs[TypeProps.BASIC_INTELL_QLT]*petDyVo.fightAttrs[TypeProps.GROWTH]*0.5/1000+petDyVo.fightAttrs[TypeProps.BASIC_SPIRIT]*petDyVo.fightAttrs[TypeProps.BASIC_SPIRIT_QLT]*petDyVo.fightAttrs[TypeProps.GROWTH]*3/1000);
		}

		/**获取宠物
		 * @param dyId
		 */	
		public function getPetDyVo(petId:int):PetDyVo{
			return _petsList.get(petId);
		}
		
		/**
		 * 获取宠物数量
		 */
		public function getPetListSize():int{
			return _petsList.size();
		}
		
		/**
		 * 获取宠物排列顺序
		 */
		public function getPetIdArray():Array{
			return _petIdArray;
		}
		
		/**
		 * 返回宠物战斗模式
		 */
		public function getAiMode():int{
			return _aiMode;
		}
		
		/**
		 * 获取出战宠物ID
		 */
		public function getFightPetId():int{
			return _fightPetId;
		}
		
		
		/**是否具有宠物  场景模块需要
		 * @param dyId
		 */		
		public function hasPet(dyId:uint):Boolean{
			if(getPetDyVo(dyId)==null) return false;
			return true;
		}
		
		/**获取当前选中宠物
		 * @return PetDyVo
		 */
		public function getCrtPetDyVo():PetDyVo{
			return _petsList.get(crtPetId);
		}
		
		/**获取当前出战宠物
		 * @return PetDyVo
		 */
		public function getFightPetDyVo():PetDyVo{
			return _petsList.get(_fightPetId);
		}
		
		/**
		 * 遗忘宠物技能
		 **/
		public function dropSkill(petId:int,skillId:int):void{
			var pet:PetDyVo = _petsList.get(petId);
			for(var i:int=0;i<pet.skillAttrs.length;i++){
				if(pet.skillAttrs[i].skillId==skillId){
					pet.skillAttrs.splice(i,1);
					break;
				}
			}
		}
		
		/**
		 * 清除宠物洗练点
		 **/
		public function clearTempAttrs(petId:int):void{
			(_petsList.get(petId) as PetDyVo).succTempAttrs = new Array();
		}
		
		/**
		 * 更新宠物战斗模式
		 **/
		public function setAiMode(ai:int):void{
			_aiMode = ai;
		}
		
		/**
		 * 更新宠物洗练点
		 **/
		public function setTempAttrs(petId:int,tempAttr:Array):void{
			var pet:PetDyVo = _petsList.get(petId);
			for(var i:int=0;i<tempAttr.length;i++){
				pet.succTempAttrs[tempAttr[i].attrId] = int(tempAttr[i].attrValue);
			}
		}
		
		/**
		 * 更新宠物技能
		 **/
		public function setSkill(petId:int,skillInfo:SkillInfo):void{
			var petDyVo:PetDyVo = _petsList.get(petId);
			var newSkill:Boolean = true;
			for(var i:int=0;i<petDyVo.skillAttrs.length;i++){
				if(petDyVo.skillAttrs[i].skillId==skillInfo.skillId){
					petDyVo.skillAttrs[i].skillLevel=skillInfo.skillLevel;
					newSkill = false;
					break;
				}
			}
			if(newSkill==true)
				petDyVo.skillAttrs.push(skillInfo);
		}
		
		/**
		 * 把出战宠物id放在第一位
		 **/
		public function topFightPetId(fightPetId:int):void{
			for(var i:int=0;i<_petIdArray.length;i++){
				if(_petIdArray[i]==fightPetId){
					_petIdArray.splice(i,1);
					_petIdArray.unshift(fightPetId);
					break;
				}
			}
		}
		
		/**
		 * 获取宠物品质
		 **/
		public function getGrowQuality(petId:int):int{
			var grow:Number = (_petsList.get(petId) as PetDyVo).fightAttrs[TypeProps.GROWTH];
			if(grow >=0 && grow <= 1.04)
				return 1;
			else if(grow >= 1.05 && grow <= 1.34)
				return 2;
			else if(grow >= 1.35 && grow <= 1.64)
				return 3;
			else if(grow >= 1.65 && grow <= 2.04)
				return 4;
			else
				return 5;
		}
		
		/**
		 * 获取宠物栏数量
		 **/
		public function getPetOpenSlots():int{
			return _petOpenSlots;
		}
		
		/**
		 * 更新宠物栏数量
		 **/
		public function setPetOpenSlots(openSlots:int):void{
			_petOpenSlots = openSlots;
		}
		
		/**
		 * 初始化选中宠物id
		 **/
		public function initCrtPetId():void{
			if(_petsList.size()>0)
				crtPetId = _petIdArray[0];
			else
				crtPetId = -1;
		}
		
		/**
		 * 更新出战宠物ID
		 **/
		public function setFightPetId(petId:int):void{
			_fightPetId = petId;
		}
		
		/**
		 * 更新宠物战斗属性
		 **/
		public function setFightAttr(petId:int,attr:Array):void{
			var pet:PetDyVo = _petsList.get(petId);
			for(var i:int=0;i<attr.length;i++){
				pet.fightAttrs[attr[i].attrId] = attr[i].attrValue;
			}
		}
		
		/**
		 * 放生宠物，更新当前选中宠物ID和出战宠物ID
		 **/
		public function dropPet(petId:int):void{
			_petsList.remove(petId);
			for(var i:int=0;i<_petIdArray.length;i++){
				if(_petIdArray[i]==petId){
					_petIdArray.splice(i,1);
					break;
				}
			}
			if(_petsList.size()>0)
				crtPetId = _petIdArray[0];
			else
				crtPetId = -1;
			if(petId == _fightPetId)
				_fightPetId=0;
		}
	}
}