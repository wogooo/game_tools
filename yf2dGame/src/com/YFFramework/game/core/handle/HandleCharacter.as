package com.YFFramework.game.core.handle
{
	import com.YFFramework.core.center.abs.handle.AbsHandle;
	import com.YFFramework.core.event.YFEventCenter;
	import com.YFFramework.game.core.module.character.events.CharacterEvent;
	import com.YFFramework.game.core.module.character.model.CMDCharacter;
	
	//	人物面板模块 300--399

	/**2012-8-23 下午4:04:30
	 *@author yefeng
	 */
	public class HandleCharacter extends AbsHandle
	{
		public function HandleCharacter()
		{
			super();
			_minCMD=300;
			_maxCMD=399;
		}
		
		override public function socketHandle(data:Object):Boolean
		{
			var info:Object=data.info;
			switch(data.cnd)
			{
				case CMDCharacter.S_PutOffEquip:
					///服务端返回 请求脱下装备
					var dyId:String=String(info);
					YFEventCenter.Instance.dispatchEventWith(CharacterEvent.S_PutOffEquip,dyId);
					return true;
					break;
			}
			return false;
		}
		
		
	}
}