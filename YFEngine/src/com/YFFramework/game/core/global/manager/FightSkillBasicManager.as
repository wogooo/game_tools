package com.YFFramework.game.core.global.manager
{
	import com.YFFramework.game.core.global.model.FightSkillBasicVo;
	
	import flash.utils.Dictionary;

	/**
	 * 缓存fightSkill 表   包含技能  id 与 特效播放id 以及 技能cd 的时间
	 * 2012-9-4 上午9:54:00
	 *@author yefeng
	 */
	public class FightSkillBasicManager
	{
		private static var _instance:FightSkillBasicManager;
		private var _dict:Dictionary;
		public function FightSkillBasicManager()
		{
			_dict=new Dictionary();
		}
		public static function get Instance():FightSkillBasicManager
		{
			if(_instance==null) _instance=new FightSkillBasicManager();
			return _instance;
		}
		
		
		public function cacheData(jsonData:Object):void
		{
			var fightSkillBasicVo:FightSkillBasicVo;
			for(var id:String   in jsonData)
			{
				fightSkillBasicVo=new FightSkillBasicVo();
				fightSkillBasicVo.fightSkillId=int(id);
				fightSkillBasicVo.fightEffectId=jsonData[id].fightEffectId;
				fightSkillBasicVo.atkType=jsonData[id].atkType;
				fightSkillBasicVo.range=jsonData[id].range;
				fightSkillBasicVo.CDTime=jsonData[id].CDTime;
				fightSkillBasicVo.speed=jsonData[id].speed;
				fightSkillBasicVo.effectType=jsonData[id].effectType;
				fightSkillBasicVo.effectLen=jsonData[id].effectLen;
				_dict[fightSkillBasicVo.fightSkillId]=fightSkillBasicVo;
			}
		}
		
		
		public function getFightSkillBasicVo(fightId:int):FightSkillBasicVo
		{
			return _dict[fightId];
		}
	}
}