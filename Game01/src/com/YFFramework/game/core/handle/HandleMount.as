package com.YFFramework.game.core.handle
{
	import com.YFFramework.core.center.abs.handle.AbsHandle;
	import com.YFFramework.core.event.YFEventCenter;
	import com.YFFramework.game.core.module.mount.events.MountEvent;
	import com.YFFramework.game.core.module.mount.model.CMDMount;
	import com.YFFramework.game.core.module.mount.model.MountListVo;
	
	/**坐骑模块 700-799
	 * 2012-10-26 下午2:49:24
	 *@author yefeng
	 */
	public class HandleMount extends AbsHandle
	{
		public function HandleMount()
		{
			super();
			_maxCMD=799;
			_minCMD=700;
		}
		override public function socketHandle(data:Object):Boolean
		{
			var info:Object=data.info;
			var obj:Object;
			switch(data.cmd)
			{
				case CMDMount.S_RequestMountList:
					var mountListVo:MountListVo=new MountListVo();
					mountListVo.mountArr=info.mountArr;
					YFEventCenter.Instance.dispatchEventWith(MountEvent.S_RequestMountList,mountListVo);
					return true;
					break;
			}
			return false;
		}
		
	}
}