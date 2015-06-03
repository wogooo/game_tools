package com.YFFramework.game.core.module.pet.events
{
	public class PetEvent{
		
		private static const Path:String="com.YFFramework.game.core.module.pet.events.";
		
		public static const Select_Pet:String = Path + "Select_Pet";
		public static const Select_Item:String = Path + "Select_Item";
		public static const Select_Skill:String = Path + "Select_Skill";
		public static const Select_Inherit_Skill:String = Path + "Select_Inherit_Skill";
		public static const CDOver:String = Path + "CDOver";
		
		public static const OpenSlotReq:String = Path + "OpenSlotReq";
		public static const RenameReq:String = Path + "RenameReq";
		public static const CombineReq:String = Path + "CombineReq";
		public static const InheritReq:String = Path + "InheritReq";
		public static const FightPetReq:String = Path + "FightPetReq";
		public static const TakeBackReq:String = Path + "TakeBackReq";
		public static const ReleaseReq:String = Path + "ReleaseReq";
		public static const QuickBuyReq:String = Path + "QuickBuyReq";
		public static const ComprehendReq:String = Path + "ComprehendReq";
		public static const LearnReq:String = Path + "LearnReq";
		public static const ForgetSkillReq:String = Path + "ForgetSkillReq";
		public static const SuccReq:String = Path + "SuccReq";
		public static const SuccConfirmReq:String = Path + "SuccConfirmReq";
		public static const AddPointReq:String = Path + "AddPointReq";
		public static const ResetReq:String = Path + "ResetReq";
		public static const EnhanceReq:String = Path + "EnhanceReq";
		public static const AiModeReq:String = Path + "AiModeReq";
		
		public static const RefreshSkill:String = Path + "RefreshSkill";
		public static const SubSkill:String = Path + "SubSkill";
		public static const updateLock:String = Path + "updateLock";
		public static const SkillLvUp:String = Path + "SkillLvUp";
		
		public function PetEvent(){
		}
	}
}