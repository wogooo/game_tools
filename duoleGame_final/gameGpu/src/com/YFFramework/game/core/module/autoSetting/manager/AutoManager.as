package com.YFFramework.game.core.module.autoSetting.manager
{
	import com.YFFramework.core.event.YFEventCenter;
	import com.YFFramework.game.core.global.manager.EquipBasicManager;
	import com.YFFramework.game.core.global.manager.PropsBasicManager;
	import com.YFFramework.game.core.global.manager.SkillBasicManager;
	import com.YFFramework.game.core.global.model.SkillBasicVo;
	import com.YFFramework.game.core.global.model.TypeSkill;
	import com.YFFramework.game.core.global.util.TypeProps;
	import com.YFFramework.game.core.module.autoSetting.event.AutoEvent;
	import com.YFFramework.game.core.module.autoSetting.source.AutoSource;
	import com.YFFramework.game.core.module.skill.mamanger.SkillDyManager;
	import com.YFFramework.game.core.module.skill.model.SkillDyVo;
	
	import flash.utils.Dictionary;
	import flash.utils.getTimer;

	/** 挂机模块管理器
	 * @version 1.0.0
	 * creation time：2013-7-20 下午4:38:30
	 */
	public class AutoManager{
		
		private static var instance:AutoManager;
		private var monsterIdArr:Array = new Array();
		private var monsterIdDict:Dictionary;
		public var _equipPickable:Boolean;
		public var _propsPickable:Boolean;
		public var _equipVec:Vector.<Boolean> = new Vector.<Boolean>(6);
		public var _propsVec:Vector.<Boolean> = new Vector.<Boolean>(5);
		public var _skillArr:Array = new Array(10);
		public var hpPercent:int;
		public var mpPercent:int;
		public var petHpPercent:int;
		/**自动使用物品的静态id
		 */		
		public static var autoUseTempId:int=-1;
		//public static var autoUseTempIdArr:Array=new Array();
		
		
		/**选择技能的 index 
		 */
		private var _availableIndex:int=0;
		public function AutoManager(){
		}
		
//		public static function containsAutoUseId(id:int):Boolean{
//			var len:int = autoUseTempIdArr.length;
//			for(var i:int=0;i<len;i++){
//				if(autoUseTempIdArr[i]==id){
//					return true;
//				}
//			}
//			return false;
//		}
		
		
		/**加载配置
		 * @param boolArr
		 * @param intArr
		 */		
		public function loadConfig(boolArr:Array,intArr:Array):void{
			if(boolArr!=null){
				_equipPickable = boolArr[AutoSource.CT_EQUIPS-1].configValue;
				_equipVec[0] = boolArr[AutoSource.CT_EQUIPS0-1].configValue;
				_equipVec[1] = boolArr[AutoSource.CT_EQUIPS1-1].configValue;
				_equipVec[2] = boolArr[AutoSource.CT_EQUIPS2-1].configValue;
				_equipVec[3] = boolArr[AutoSource.CT_EQUIPS3-1].configValue;
				_equipVec[4] = boolArr[AutoSource.CT_EQUIPS4-1].configValue;
				_equipVec[5] = boolArr[AutoSource.CT_EQUIPS5-1].configValue;
				
				_propsPickable = boolArr[AutoSource.CT_PROPS-1].configValue;
				_propsVec[0] = boolArr[AutoSource.CT_PROPS0-1].configValue;
				_propsVec[1] = boolArr[AutoSource.CT_PROPS1-1].configValue;
				_propsVec[2] = boolArr[AutoSource.CT_PROPS2-1].configValue;
				_propsVec[3] = boolArr[AutoSource.CT_PROPS3-1].configValue;
				_propsVec[4] = boolArr[AutoSource.CT_PROPS4-1].configValue;
			}
			if(intArr!=null){
				hpPercent = intArr[AutoSource.CT_HP_PERCENT-1].configValue;
				mpPercent = intArr[AutoSource.CT_MP_PERCENT-1].configValue;
				petHpPercent = intArr[AutoSource.CT_PET_HP_PERCENT-1].configValue;
				var len:int=_skillArr.length;
				for(var i:int=0;i<len;i++){
					_skillArr[i] = intArr[AutoSource.CT_SKILL_ARR[i]-1].configValue;
				}
			}
			_availableIndex=0;
			YFEventCenter.Instance.dispatchEventWith(AutoEvent.LOAD_COMPLETE);
		}
		
		/**设置挂机怪物静态id 的dictionary    
		 * @param dict
		 */
		public function setMonsterIdArr(dict:Dictionary):void{
			monsterIdDict = dict;
		}
		
		/**获取挂机怪物静态id的dictionary
		 * @return 
		 */		
		public function getMonsterIdDict():Dictionary{
			return monsterIdDict;
		}
		
		/**获取指定物品能否捡取
		 * @param templateId	静态id
		 * @param itemType		物品类型
		 * @return 
		 */
		public function isPickable(templateId:int,itemType:int):Boolean{
			if(itemType==TypeProps.ITEM_TYPE_EQUIP){
				return _equipVec[EquipBasicManager.Instance.getEquipBasicVo(templateId).quality];
			}else{
				return _propsVec[PropsBasicManager.Instance.getPropsBasicVo(templateId).quality];
			}
		}
		
//		private var _guajiTime:Number=0;
		
		/**获取第一个可用的技能ID,没有的话返回-1
		 * @return 
		 */		
		public function getAvailableSkill():int{
			
//			trace("挂机时间差",getTimer()-_guajiTime);
			var len:int=_skillArr.length;
//			for(var i:int=0;i<len;i++){
//				if(_skillArr[i]!=-1){
//					var vo:SkillDyVo = SkillDyManager.Instance.getSkillDyVo(_skillArr[i]);
//					if(SkillBasicManager.Instance.getSkillBasicVo(vo.skillId,vo.skillLevel).skillCanfire()){
//						return vo.skillId;
//					}
//				}
//			}
			  //此处待判断魔法值是否满足
			var skillDyVo:SkillDyVo;
			var beginIdex:int=_availableIndex;
			var skillBasicVo:SkillBasicVo;
			var fightType:int;
			
			while(_availableIndex<len)
			{
				if(_skillArr[_availableIndex]>0)
				{
					skillDyVo=SkillDyManager.Instance.getSkillDyVo(_skillArr[_availableIndex]);
					if(skillDyVo)
					{
						skillBasicVo=SkillBasicManager.Instance.getSkillBasicVo(skillDyVo.skillId,skillDyVo.skillLevel);
						
						fightType=TypeSkill.getFightType(skillBasicVo.use_type);
						if(skillBasicVo.skillCanfire())
						{
							if(SkillDyManager.Instance.canTriggerSkillByConsume(skillBasicVo,false))
							{
								if(fightType!=TypeSkill.FightType_Switch)
								{
									if(skillBasicVo.special_effect==TypeSkill.SpecialEffetType_None)
									{
										++_availableIndex;
										return skillDyVo.skillId;
									}
								}
								//						if(skillBasicVo.special_effect!=TypeSkill.SpecialEffetType_Revive)  //挂机的时候不能使用复活技能 
								//						{
								//							++_availableIndex;
								//							return skillDyVo.skillId;
								//						}
							}
						}
					}
				}
				++_availableIndex;
			}
			
			if(_availableIndex>=len)_availableIndex=_availableIndex%len;
			while(_availableIndex<beginIdex)
			{
				if(_skillArr[_availableIndex]>0)
				{
					skillDyVo=SkillDyManager.Instance.getSkillDyVo(_skillArr[_availableIndex]);
					if(skillDyVo)
					{
						skillBasicVo=SkillBasicManager.Instance.getSkillBasicVo(skillDyVo.skillId,skillDyVo.skillLevel);
						fightType=TypeSkill.getFightType(skillBasicVo.use_type);
						if(skillBasicVo.skillCanfire())
						{
							if(SkillDyManager.Instance.canTriggerSkillByConsume(skillBasicVo,false))
							{
								if(fightType!=TypeSkill.FightType_Switch)
								{
									if(skillBasicVo.special_effect==TypeSkill.SpecialEffetType_None)
									{
										++_availableIndex;
										return skillDyVo.skillId;
									}
								}
							}
						}

					}
				}
				++_availableIndex;
			}
			return -1;
		}
		
		public static function get Instance():AutoManager{
			return instance ||= new AutoManager();
		}
	}
} 