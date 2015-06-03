package com.YFFramework.game.core.module.rank.data
{
	import com.YFFramework.core.center.manager.update.UpdateManager;
	import com.YFFramework.game.core.global.manager.PetBasicManager;
	import com.YFFramework.game.core.global.manager.StrRatioManager;
	import com.YFFramework.game.core.global.model.EquipDyVo;
	import com.YFFramework.game.core.global.model.PetBasicVo;
	import com.YFFramework.game.core.global.model.StrRatioVo;
	import com.YFFramework.game.core.global.util.TypeProps;
	import com.YFFramework.game.core.module.bag.data.BagTimerManager;
	import com.YFFramework.game.core.module.mapScence.world.model.type.TypeRole;
	import com.YFFramework.game.core.module.pet.model.PetDyVo;
	import com.YFFramework.game.core.module.pet.model.PetSkillVo;
	import com.msg.common.AttrInfo;
	import com.msg.hero.SOtherHeroInfo;
	import com.msg.item.CharacterEquip;
	import com.msg.rank_pro.EquipInfo;
	import com.msg.rank_pro.PetSkill;
	import com.msg.rank_pro.SRankPlayOrPetInfo;
	
	import flash.utils.Dictionary;

	/**
	 * 查询其他玩家、宠物信息储存
	 * @version 1.0.0
	 * creation time：2013-6-24 下午3:02:21
	 * 
	 */
	public class OtherHeroPetDyManager
	{
		//======================================================================
		//       public property
		//======================================================================
		public static const SHOW_CHARACTER:int=1;
		public static const SHOW_PET:int=2;
		//======================================================================
		//       private property
		//======================================================================
		private static var _instance:OtherHeroPetDyManager;
		
		private var _petDict:Dictionary;
		private var _characterDict:Dictionary;
		//======================================================================
		//        constructor
		//======================================================================
		
		public function OtherHeroPetDyManager()
		{
			_petDict=new Dictionary();
			_characterDict=new Dictionary();
		}
		
		//======================================================================
		//        public function
		//======================================================================
		/** 除了排行榜的其他角色信息查询 */
		public function setOtherHeroInfo(hero:SOtherHeroInfo):void
		{
			var otherHero:OtherHeroDyVo=new OtherHeroDyVo();
			otherHero.playerId=hero.dyId;
			otherHero.power=hero.power;
			otherHero.sex=hero.sex;
			otherHero.name=hero.name;
//			otherHero.exp=hero.exp;
			otherHero.career=hero.career;
			otherHero.level=hero.level;
			otherHero.guildName=hero.sociaty;
//			otherHero.energy=hero.energy;
//			otherHero.pk_value=hero.pkValue;
//			otherHero.see_value=hero.seeValue;
//			otherHero.potential=hero.potential;
//			otherHero.honor=hero.honour;
			otherHero.title_id=hero.titleId;
			
//			otherHero.attrs=[];
//			for each(var attr:AttrInfo in hero.attrArr)
//			{
//				otherHero.attrs[attr.attrId]=attr.attrValue;
//			}
			initEquips(otherHero,hero.equips);
			_characterDict[hero.dyId]=otherHero;
		}
		
		/** 排行榜人物角色查询专用 */
		public function rankOtherRole(msg:SRankPlayOrPetInfo):void
		{
			var otherHero:OtherHeroDyVo=new OtherHeroDyVo();
			var rankDyVo:RankDyVo=RankDyManager.instance.getHeroRankInfo(msg.characterId);
			otherHero.playerId=msg.characterId;
			otherHero.name=rankDyVo.playerName;
			otherHero.career=rankDyVo.playerCareer;
			otherHero.title_id=rankDyVo.titleId;
			otherHero.level=rankDyVo.level;
			otherHero.guildName=rankDyVo.guildName;
			otherHero.power=rankDyVo.rankValue;
			
			initEquips(otherHero,msg.equipInfo);
			_characterDict[msg.characterId]=otherHero;
		}
		
		private function initEquips(otherHero:OtherHeroDyVo,equips:Array):void
		{
			otherHero.equips=[];
			for each(var equip:* in equips)
			{
				var otherEquip:EquipDyVo=new EquipDyVo();
				otherEquip.template_id=equip.templateId;
				otherEquip.equip_id=equip.equipId;
				otherEquip.binding_type=equip.bindingAttr;
				otherEquip.cur_durability=equip.curDurability;
				otherEquip.enhance_level=equip.enhanceLevel;
				if(equip.hasGem_1Id)
					otherEquip.gem_1_id=equip.gem_1Id;
				if(equip.hasGem_2Id)
					otherEquip.gem_2_id=equip.gem_2Id;
				if(equip.hasGem_3Id)
					otherEquip.gem_3_id=equip.gem_3Id;
				if(equip.hasGem_4Id)
					otherEquip.gem_4_id=equip.gem_4Id;
				if(equip.hasGem_5Id)
					otherEquip.gem_5_id=equip.gem_5Id;
				if(equip.hasGem_6Id)
					otherEquip.gem_6_id=equip.gem_6Id;
				if(equip.hasGem_7Id)
					otherEquip.gem_7_id=equip.gem_7Id;
				if(equip.hasGem_8Id)
					otherEquip.gem_8_id=equip.gem_8Id;
				BagTimerManager.instance.deleteOtherTimer(TypeProps.ITEM_TYPE_EQUIP,equip.equipId);
				
				if(equip.hasAppAttrT1)
					otherEquip.app_attr_t1=equip.appAttrT1;
				if(equip.hasAppAttrT2)
					otherEquip.app_attr_t2=equip.appAttrT2;
				if(equip.hasAppAttrT3)
					otherEquip.app_attr_t3=equip.appAttrT3;
				if(equip.hasAppAttrT4)
					otherEquip.app_attr_t4=equip.appAttrT4;
				
				if(equip.hasAppAttrV1)
					otherEquip.app_attr_v1=equip.appAttrV1;
				if(equip.hasAppAttrV2)
					otherEquip.app_attr_v2=equip.appAttrV2;
				if(equip.hasAppAttrV3)
					otherEquip.app_attr_v3=equip.appAttrV3;
				if(equip.hasAppAttrV4)
					otherEquip.app_attr_v4=equip.appAttrV4;
				
				if(equip.hasAppAttrC1)
					otherEquip.app_attr_color1=equip.appAttrC1;
				if(equip.hasAppAttrC2)
					otherEquip.app_attr_color2=equip.appAttrC2;
				if(equip.hasAppAttrC3)
					otherEquip.app_attr_color3=equip.appAttrC3;
				if(equip.hasAppAttrC4)
					otherEquip.app_attr_color4=equip.appAttrC4;
				if(equip.hasObtainTime)
				{
					otherEquip.obtain_time=equip.obtainTime;
					BagTimerManager.instance.addOtherEquipTimer(otherEquip);
				}
				otherHero.equips.push(otherEquip);
			}
		}
		
		public function setOtherPetInfo(msg:SRankPlayOrPetInfo):void
		{
			var pet:PetDyVo=new PetDyVo();
			pet.basicId=msg.petInfo.petConfigId;
			pet.dyId=msg.petInfo.petId;
			pet.level=RankDyManager.instance.getPetRankInfo(pet.dyId).petLevel;
			pet.fightAttrs=[];
			pet.fightAttrs[TypeProps.BA_STRENGTH]=msg.petInfo.basicStrengthApt;
			pet.fightAttrs[TypeProps.BA_AGILE]=msg.petInfo.basicAgileApt;
			pet.fightAttrs[TypeProps.BA_INTELLIGENCE]=msg.petInfo.basicIntelligenceApt;
			pet.fightAttrs[TypeProps.BA_PHYSIQUE]=msg.petInfo.basicPyhsiqueApt;
			pet.fightAttrs[TypeProps.BA_SPIRIT]=msg.petInfo.basicSpiritApt;
			
			pet.skillAttrs=[];
			var len:int=msg.petInfo.petSkill.length;
			var skill:PetSkill;
			var petSkillVo:PetSkillVo;
			for(var i:int=0;i<len;i++)
			{
				skill=msg.petInfo.petSkill[i];
				petSkillVo = new PetSkillVo();
				petSkillVo.skillId = skill.skillId;
				petSkillVo.skillLevel = skill.skillLevel;
				pet.skillAttrs[skill.skillIndex] = petSkillVo;
			}
			
			_petDict[pet.dyId]=pet;
			calStat(pet.dyId);
			
		}
		
		public function getOtherCharacter(playerId:int):OtherHeroDyVo
		{
			return _characterDict[playerId];
		}
		
		public function getPet(petId:int):PetDyVo
		{
			return _petDict[petId];
		}
		//======================================================================
		//        private function
		//======================================================================
		/**计算宠物属性值
		 */	
		public function calStat(petId:int):void
		{
			var pet:PetDyVo = _petDict[petId];
			var petStrRatio:StrRatioVo = StrRatioManager.Instance.getStrRatioVo(pet.enhanceLv);
			var petBsVo:PetBasicVo=PetBasicManager.Instance.getPetConfigVo(pet.basicId);
			pet.fightAttrs[TypeProps.BA_PHY_QLT_LIM]=Math.round(petBsVo.physique_apt*1.2*petStrRatio.ratio);
			pet.fightAttrs[TypeProps.BA_STR_QLT_LIM]=Math.round(petBsVo.strength_apt*1.2*petStrRatio.ratio);
			pet.fightAttrs[TypeProps.BA_AGI_QLT_LIM]=Math.round(petBsVo.agile_apt*1.2*petStrRatio.ratio);
			pet.fightAttrs[TypeProps.BA_INT_QLT_LIM]=Math.round(petBsVo.intelligence_apt*1.2*petStrRatio.ratio);
			pet.fightAttrs[TypeProps.BA_SPI_QLT_LIM]=Math.round(petBsVo.spirit_apt*1.2*petStrRatio.ratio);			
		}
		//======================================================================
		//        event handler
		//======================================================================
		
		//======================================================================
		//        getter&setter
		//======================================================================
		public static function get instance():OtherHeroPetDyManager
		{
			if(_instance == null)
				_instance=new OtherHeroPetDyManager();
			return _instance;
		}

	}
} 