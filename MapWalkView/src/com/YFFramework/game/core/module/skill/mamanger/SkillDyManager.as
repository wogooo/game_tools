package com.YFFramework.game.core.module.skill.mamanger
{
	import com.CMD.GameCmd;
	import com.YFFramework.core.event.YFEventCenter;
	import com.YFFramework.game.core.global.event.GlobalEvent;
	import com.YFFramework.game.core.global.manager.FightEffectBasicManager;
	import com.YFFramework.game.core.global.manager.SkillBasicManager;
	import com.YFFramework.game.core.global.model.FightEffectBasicVo;
	import com.YFFramework.game.core.global.model.SkillBasicVo;
	import com.YFFramework.game.core.module.skill.model.SkillDyVo;
	import com.msg.enumdef.RspMsg;
	import com.msg.skill_pro.SLearnSkill;
	import com.net.MsgPool;
	
	import flash.utils.Dictionary;

	/** 缓存 SkillDyVo   服务器发过来的 技能数据
	 *   角色当前 具有的技能列表
	 *   技能动态id  
	 * 2012-9-4 上午11:09:21
	 *@author yefeng
	 */
	public class SkillDyManager
	{
		
		private static var _instance:SkillDyManager;
		/**缓存数据 id--SkillDyVo
		 */		
		private var _dict:Dictionary;
		
		/**緩存 已經設置格子的技能
		 */ 
		private var _gridDict:Dictionary;
		/**默认的普通攻击  技能
		 */ 
		private var _defaultSkillId:int;
		
		public function SkillDyManager()
		{
			_dict=new Dictionary();
			_gridDict=new Dictionary();
			MsgPool.addCallBack(GameCmd.SLearnSkill,SLearnSkill,onServerSLearnSkill);
		}
		
		private function onServerSLearnSkill(data:SLearnSkill):void
		{
			if(data.code != RspMsg.RSPMSG_SUCCESS){
				return;
			}
			var skillVO:SkillDyVo;
			skillVO = _dict[data.skillId];
			if(skillVO){
				skillVO.skillLevel = data.skillLevel;
			}else{
				var skillDyVo:SkillDyVo = new SkillDyVo();
				skillDyVo.skillId = data.skillId;
				skillDyVo.skillLevel = data.skillLevel;
				_dict[skillDyVo.skillId]=skillDyVo;
			}
			YFEventCenter.Instance.dispatchEventWith(GlobalEvent.SKILL_TREE_UPDATE,[data.skillId,data.skillLevel]);
		}
		
		/**技能
		 */ 
		public static function get Instance():SkillDyManager
		{
			if(_instance==null)_instance=new SkillDyManager();
			return _instance;
		}
			
		
		/**添加技能
		 */		
		public function addSkill(skillDyVo:SkillDyVo):void
		{
			_dict[skillDyVo.skillId]=skillDyVo;
			if(skillDyVo.grid>0) _gridDict[skillDyVo.grid]=skillDyVo;
		}
		
		public function getAllSkill():Vector.<SkillDyVo>
		{
			var vct:Vector.<SkillDyVo> = new Vector.<SkillDyVo>();
			for(var obj:Object in _dict)
			{
				vct.push(_dict[obj]);
			}
			return vct;
		}
		 
		/**删除技能
		 */		
		public function delSkill(skillId:int):void
		{
			var skillDyVo:SkillDyVo=_dict[skillId];
			if(skillDyVo)
			{
				delete _gridDict[skillDyVo.grid];
				_dict[skillId]=null;
				delete _dict[skillId];	
			}
		}
		
		/**获取 技能动态vo 
		 * 
		 */		
		public function getSkillDyVo(skillId:int):SkillDyVo
		{
			return _dict[skillId];
		}
		
		/**更新技能的格子書
		 */		
		public function updateSKillGrid(skillId:int,newGrid:int):void
		{
			 var skillDyVo:SkillDyVo=_dict[skillId];
			 var oldGrid:int=skillDyVo.grid;
			 delete _gridDict[oldGrid];
			 skillDyVo.grid=newGrid;
			 _gridDict[skillDyVo.grid]=skillDyVo;
		}
		
		/**刪除技能格子
		 */		
		public function deleteSkillGrid(skillId:int):void
		{
			var skillDyVo:SkillDyVo=_dict[skillId];
			var oldGrid:int=skillDyVo.grid;
			delete _gridDict[oldGrid];
			skillDyVo.grid=0;
		}
		
		/**通過格子數取得技能id 
		 * @param grid
		 * @return
		 */		
		public function getSKillDyVoByGrid(grid:int):SkillDyVo
		{
			return _gridDict[grid];
		}
		
		/**获取技能id 
		 */		
		public function getDefaultSkill():int
		{
			return _defaultSkillId;
		}
		
		/**设置默认技能
		 */
		public function setDefaultSkill(defalutSkillId:int):void
		{
			_defaultSkillId=defalutSkillId;
		}
		
		/**获取技能播放数据 level 是从   1 开始
		 */		
		public function getFightEffectBasicVo(skillId:int,level:int):FightEffectBasicVo
		{
			var skillBasicVo:SkillBasicVo=SkillBasicManager.Instance.getSkillBasicVo(skillId,level);
			var fightEffectVo:FightEffectBasicVo=FightEffectBasicManager.Instance.getFightEffectBasicVo( skillBasicVo.effect_id);
			return fightEffectVo;
		}
		
	}
}