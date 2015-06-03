package com.YFFramework.game.core.module.pet.model
{
	import com.YFFramework.game.core.module.mapScence.world.model.MonsterDyVo;

	/**
	 * @version 1.0.0
	 * creation time：2013-3-11 下午2:56:27
	 * 
	 */
	public class PetDyVo extends MonsterDyVo{
		
		public var potential:int;
		public var power:int;
		public var happy:int;
		public var skillOpenSlots:int;
		public var exp:int;
		/**魔法  最大魔法 血量 最大血量 成长率 体质-精神 体质资质-精神资质 速度 攻击力 魔法攻击力 防御力 魔法防御力
		 */		
		public var fightAttrs:Array;
		public var skillAttrs:Array;
		public var enhanceLv:int;
		public var defaultSkillId:int;
		public var succTempAttrs:Array;
		public var buffIdArray:Array;
		public var newLearnSkills:Array;
		public var lockGridArray:Array;
		public var quality:int;

		public function PetDyVo(){
			fightAttrs = new Array();
			skillAttrs = new Array();
			succTempAttrs = new Array();
			buffIdArray = new Array();
			newLearnSkills = new Array();
			lockGridArray = new Array();
			for(var i:int=0;i<8;i++){
				lockGridArray.push(false);
			}
		}
		
		public function containsBuffId(buffId:int):Boolean{
			for(var i:int=0;i<buffIdArray.length;i++){
				if(buffIdArray[i]==buffId){
					return true;
				}
			}
			return false;
		}
		
		public function removeBuffId(buffId:int):void{
			for(var i:int=0;i<buffIdArray.length;i++){
				if(buffIdArray[i]==buffId){
					buffIdArray.splice(i,1);
					break;
				}
			}
		}
	}
} 