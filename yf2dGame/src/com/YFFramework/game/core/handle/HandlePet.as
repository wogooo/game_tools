package com.YFFramework.game.core.handle
{
	import com.YFFramework.core.center.abs.handle.AbsHandle;
	import com.YFFramework.core.event.YFEventCenter;
	import com.YFFramework.game.core.module.pet.events.PetEvent;
	import com.YFFramework.game.core.module.pet.model.CMDPet;
	import com.YFFramework.game.core.module.pet.model.PetPlayResultVo;
	
	/** 600-699
	 * 2012-9-18 下午4:21:45
	 *@author yefeng
	 */
	public class HandlePet extends AbsHandle
	{
		public function HandlePet()
		{
			super();
			_minCMD=600;
			_maxCMD=699;
		}
		override public function socketHandle(data:Object):Boolean
		{
			var info:Object=data.info;
			switch(data.cmd)
			{
				case CMDPet.S_RequestPetList:
					///服务端返回宠物列表
					var petArr:Array=info as Array;
					YFEventCenter.Instance.dispatchEventWith(PetEvent.S_RequestPetList,petArr);
					return true;
					break;
				case CMDPet.S_PetPlay:
					///服务端返回 宠物出战
					var petPlayResultVo:PetPlayResultVo=new PetPlayResultVo();
					petPlayResultVo.dyId=info.dyId;
					YFEventCenter.Instance.dispatchEventWith(PetEvent.S_PetPlay,petPlayResultVo);
					return true;
					break;
				case CMDPet.S_PetCallBack:
					var callBackPetDyId:String=String(info);
					YFEventCenter.Instance.dispatchEventWith(PetEvent.S_PetCallBack,callBackPetDyId);
					return true;	
					break;
			}
			return false
		}
	}
}