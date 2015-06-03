package com.YFFramework.game.core.module.task.manager
{
	import com.YFFramework.game.core.global.DataCenter;
	import com.YFFramework.game.core.global.manager.EquipBasicManager;

	/**
	 * @version 1.0.0
	 * creation time：2013-8-26 上午9:58:33
	 */
	public class EquipIDManager{
		
		public function EquipIDManager()
		{
		}
		
		/**根据职业显示对应的任务奖励道具
		 * @param equipTempId	任务奖励道具的静态id
		 * @return int	根据职业的任务奖励道具的静态id
		 */		
		public static function getCareerEquipID(equipTempId:int):int{
			//if(EquipBasicManager.Instance.getEquipBasicVo(equipTempId).type
			return int(String(equipTempId).substr(0,4)+DataCenter.Instance.roleSelfVo.roleDyVo.career+String(equipTempId).substr(5,2));
		}
	}
} 