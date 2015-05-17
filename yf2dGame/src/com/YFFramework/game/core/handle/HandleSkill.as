package com.YFFramework.game.core.handle
{
	import com.YFFramework.core.center.abs.handle.AbsHandle;
	import com.YFFramework.core.event.YFEventCenter;
	import com.YFFramework.game.core.module.skill.events.SkillEvent;
	import com.YFFramework.game.core.module.skill.model.CMDSkill;
	import com.YFFramework.game.core.module.skill.model.proto.RequestSkillListResultVo;
	import com.YFFramework.game.core.module.skill.model.proto.SkillShortCutVo;
	
	/**技能  400-499
	 * 2012-9-4 下午5:55:03
	 *@author yefeng
	 */
	public class HandleSkill extends AbsHandle
	{
		public function HandleSkill()
		{
			super();
			_maxCMD=499;
			_minCMD=400;
		}
		
		override public function socketHandle(data:Object):Boolean
		{
			var info:Object=data.info;
			switch(data.cmd)
			{
				case CMDSkill.S_RequestSkillList:
					//服务器返回技能列表
					var requestSKillListResultVo:RequestSkillListResultVo=new RequestSkillListResultVo();
					requestSKillListResultVo.skillList=info.skillList;
					requestSKillListResultVo.defaultSkillId=info.defaultSkillId;
					YFEventCenter.Instance.dispatchEventWith(SkillEvent.S_RequestSkillList,requestSKillListResultVo);
					return true;
					break;
				case CMDSkill.S_SetSkillShortCut:
					//設置技能快捷方式
					var skillShortCutVo:SkillShortCutVo=new SkillShortCutVo();
					skillShortCutVo.grid=info.grid;
					skillShortCutVo.id=info.id;
					YFEventCenter.Instance.dispatchEventWith(SkillEvent.S_SetSkillShortCut,skillShortCutVo);
					return true;
					break;
				case CMDSkill.S_DeleteSkillShortCut:
					//刪除技能快捷方式
					var skillId:int=int(info);
					YFEventCenter.Instance.dispatchEventWith(SkillEvent.S_DeleteSkillShortCut,skillId);
					return true;
					break;

			}
			return false;
		}
	}
}