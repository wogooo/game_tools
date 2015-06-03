package com.dolo.lang
{
	import com.YFFramework.game.core.global.util.TypeProps;
	import com.YFFramework.game.core.module.pet.model.PetConfig;
	import com.YFFramework.game.core.module.task.enum.RewardTypes;

	/**
	 * 基础语音包 
	 * @author flashk
	 * 
	 */
	public class LangBasic
	{
		public static var level:String = "等级：";
		public static var beforeSkill:String = "前置技能：";
		public static var excludeSkill:String = "排斥技能：";
		public static var playerLevel:String = "人物等级：";
		public static var seeConsume:String = "消耗阅历：";
		public static var noteConsume:String = "消耗银锭：";
		public static var skillUpSuccess:String = "技能升级成功！";
		public static var skillLearnSuccess:String = "技能学习成功！";
		public static var skillLearnFaild:String = "技能学习失败。";
		public static var skillUpFaild:String = "技能升级失败。";
		public static var skill:String = "技能";
		public static var skillCDing:String = "正在冷却中";
		public static var skillDragSuccess1:String = "放入快捷栏成功！";
		public static var skillDragSuccess2:String = "移动成功！";
		public static var skillDragSuccess3:String = "已从快捷栏移除！";
		public static var itemRepairOK:String = "装备全部修理成功。";
		public static var itemRepairFaild:String = "装备全部修理失败！";
		public static var itemRepairMoneyNotEnough:String = "全部修理身上金钱不足。";
		public static var itemNoNeedRepair:String = "身上没有装备需要修理。";
		public static var fix:String = "修理";
		public static var equipUpdate:String = "锻造";
		public static var equipStrengthenBindUnable:String = "只有绑定装备，才能强化。";
		public static var equipShiftPutFromBindUnable:String = "只有绑定装备，才能放入源格。";
		public static var equipShiftPutToBindUnable:String = "只有绑定装备，才能放入目标格。";
		public static var equipStrengthenOK:String = "装备强化成功！";
		public static var equipStrengthenFaild:String = "装备强化失败！";
		public static var noteUse:String = "消耗银锭  ";
		public static var equipInlayBindUnable:String = "只有绑定装备，才能镶嵌宝石。";
		public static var equipGemNoHole:String = "装备没有可镶嵌的空孔";
		public static var inlayGemOK:String = "宝石镶嵌完成。";
		public static var inlayGemFaild:String = "宝石镶嵌失败。";
		public static var noEquip:String = "请先放入装备。";
		public static var noGem:String = "请放入宝石。";
		public static var gemHasNone:String = "宝石已用完。";
		public static var skillLevelFull:String = "技能已经满级";
		public static var passiveSkillCantDrag:String = "被动技能不能拖动";
		public static var shiftOK:String = "强化转移完成。";
		public static var shiftFaild:String = "强化转移失败！";
		public static var removeOK:String = "宝石摘除完成，已放入背包。";
		public static var removeFaild:String = "宝石摘除失败！";
		public static var cantPutInBag:String = "背包空间不足，无法购买此物品！";
		public static var cantPutInBagTask:String = "背包空间不足，无法完成任务！";
		public static var cantPutGemInBag:String = "背包空间不足，无法摘除此物品宝石！";
		public static var taskFinishFaild:String = "距离太远,完成任务失败！";
		public static var shop:String = "商店";
		public static var exp:String = "经验";
		public static var coupon:String = "礼券";
		public static var silver:String = "银币";
		public static var note:String = "银锭";
		public static var dotSpace:String = "：";
		public static var chatNotConnnect:String = "和聊天服务器尚未成功建立连接，请稍后再试";
		public static var speakerNum:String = "传音符剩余数量：{$1}个";
		public static var speakerPrice:String = "单价:{$1}";
		public static var speakerNone:String = "当前已经没有传音符，请在商店/商城购买";
		
		/**货币名称常量（临时）**/
		public static var contribution:String="贡献";
		public static var title:String="称号";
		
		/**天命神脉*/
		public static const divine_pulse_level:String="等级限制：";
		public static function get divine_pulse_see():String {return RewardTypes.getTypeStr(RewardTypes.SEE)+"：";}
		public static function get divine_pulse_note():String {return RewardTypes.getTypeStr(RewardTypes.NOTE)+"：";}
		public static function get divine_pulse_diamond():String {return RewardTypes.getTypeStr(RewardTypes.DIAMOND)+"：";}
		public static const divine_pulse_max_level:String="满级";
		public static const divine_pulse_learn:String="学习";
		public static function get divine_pulse_physics_attack():String {return TypeProps.getAttrName(TypeProps.EA_PHYSIC_ATK)+"：";}
		public static function get divine_pulse_physics_defance():String {return TypeProps.getAttrName(TypeProps.EA_PHYSIC_DEFENSE)+"：";}
		public static function get divine_pulse_magic_attack():String {return TypeProps.getAttrName(TypeProps.EA_MAGIC_ATK)+"：";}
		public static function get divine_pulse_magic_defance():String {return TypeProps.getAttrName(TypeProps.EA_MAGIC_DEFENSE)+"：";}
		public static function get divine_pulse_hp():String {return TypeProps.getAttrName(TypeProps.EA_HEALTH)+"：";}
		public static function get divine_pulse_mp():String {return TypeProps.getAttrName(TypeProps.EA_MANA)+"：";}
		public static function get divine_pulse_crit():String {return TypeProps.getAttrName(TypeProps.EA_CRITRATE)+"：";}
		public static function get divine_pulse_avoid():String {return TypeProps.getAttrName(TypeProps.EA_MISSRATE)+"：";}
		public static function get divine_pulse_hit():String {return TypeProps.getAttrName(TypeProps.EA_HITRATE)+"：";}
		public static function get divine_pulse_tenacity():String {return TypeProps.getAttrName(TypeProps.EA_TOUGHRATE)+"：";}
		public static function get divine_pulse_physics_pierce():String {return TypeProps.getAttrName(TypeProps.EA_PSTRIKE)+"：";}
		public static function get divine_pulse_magic_pierce():String {return TypeProps.getAttrName(TypeProps.EA_MSTRIKE)+"：";}
		
		/**属性加点提示*/
		public static const Help_Add_Point:String="当前有剩余的属性点可分配哦";
		public static const Help_Go_Now:String="立即前往";
		
		/**天书提示*/
		public static const Help_GrowTask:String="你完成了一个成就，请打开天书查看";
		
		/**小地图*/
		public static const SmallMap_Teleporter:String="传送点"; 
		public static const SmallMap_NPC:String="NPC";
		public static const SmallMap_Monster:String="怪物";
		
		/**宠物*/
//		public static const Pet_Open_SkillGrid:String="扩展一个宠物技能格需要"+PetConfig.pet_skill_slot_cost+"魔钻，是否继续？";
		public static const Pet_SkillGrid_Title:String="宠物技能格扩展";
		public static const Pet_SkillGrid_BtnLabels:Array=["确认","取消"];
		
		/**扩展宠物 格子
		 */
		public static function getPet_Open_SkillGridStr():String
		{
			return "扩展一个宠物技能格需要"+PetConfig.pet_skill_slot_cost+"魔钻，是否继续？";
		}
		
		/**血池、蓝池*/
		public static const Pool_HP:String="生命";
		public static const Pool_MP:String="魔力";
		public static const Pool_Pet:String="宠物生命";
		
		/**翅膀*/
		public static const Wing_cast:String="花费&&魔钻使所需材料减半";
		public static const Wind_next_look:String="再进阶&&次后外观将发生改变";
		
		/**礼包*新手引导*/
		public static const Bag_Gift:String="背包中有可使用的礼包，请打开背包使用。";
		public static const Bag_Open_label:String="打开背包";
	}
}