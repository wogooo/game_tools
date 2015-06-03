package com.YFFramework.game.core.module.mapScence.manager
{
	import com.YFFramework.game.core.module.mapScence.model.BuffDyVo;
	
	import flash.utils.Dictionary;
	import flash.utils.getTimer;

	/** 
	 * @author yefeng
	 * 2013 2013-12-31 下午2:15:40 
	 */
	public class BuffDyManager
	{
		/** buff字典
		 */
		private var _dict:Dictionary;
		public function BuffDyManager()
		{
			_dict=new Dictionary();
		}
		/**添加buff 
		 */
		public function addBuff(buff_id:int,skillId:int,skillLevel:int=1):void
		{
			var buffDyVo:BuffDyVo=_dict[buff_id];
			if(!buffDyVo)
			{
				buffDyVo=new BuffDyVo();
				buffDyVo.buff_id=buff_id;
			}
			buffDyVo.skill_id=skillId;
			buffDyVo.skill_level=skillLevel;
			buffDyVo.time=getTimer();
			_dict[buff_id]=buffDyVo;
		}
		/**移除buff 
		 */
		public function removeBuff(buff_id:int):void
		{
			_dict[buff_id]=null;
			delete _dict[buff_id];
		}
		/**获取buff动态vo 
		 */
		public function getBuffDyVo(buff_id:int):BuffDyVo
		{
			return _dict[buff_id];
		}
	}
}