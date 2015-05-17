package com.YFFramework.core.center.manager
{
	import com.YFFramework.core.center.face.IModule;
	import com.YFFramework.core.center.face.IScence;
	import com.YFFramework.core.event.ScenceEvent;
	import com.YFFramework.core.utils.common.ArrayUtil;
	
	import flash.utils.Dictionary;
	/**
	 * author :夜枫 * 时间 ：Sep 21, 2011 1:08:00 PM
	 */
	public final class ScenceManager
	{
		private static var _instance:ScenceManager;
		
		private var _dict:Dictionary=new Dictionary();
		private var  moduleList:Dictionary=new Dictionary();
		private var currentScence:IScence=null;
		private var nextScence:IScence=null;
		public function ScenceManager()
		{
			if(_instance) throw new Error("请使用Instance属性");
		}
		public static function  get Instance():ScenceManager
		{
			if(!_instance) _instance=new ScenceManager();
			return _instance;
		}
		
		public function   regModule(module:IModule):void
		{
		//	ArrayUtil.addElement(moduleList,module);
			moduleList[module]=module;
		}
		public function delModule(module:IModule):void
		{
		//	ArrayUtil.removeElement(moduleList,module);
			delete moduleList[module]

		}
		
		public function  regScence(scence:IScence):void
		{
			
			if(_dict[scence.scenceType])  throw new Error("该场景已经注册了");
			_dict[scence.scenceType]=scence;
		}
		public function delScence(scence:IScence):void
		{
			delete _dict[scence.scenceType];
		}
		/**以前的场景模块将会被销毁
		 */		
		public function enterScence(scence:IScence):void
		{
			//trace("进入场景:",scence.scenceType)
			nextScence=_dict[scence.scenceType];
			if(!nextScence) throw new Error("请先注册该场景"); 
			if(!removeCurrentScence()) enterNextScence();
		}
		private function  removeCurrentScence():Boolean
		{
			if(!currentScence) return false;
			destroyCurrentScenceModule();
			delete _dict[currentScence.scenceType];  ////
			currentScence.addEventListener(ScenceEvent.RemoveScenceComplete,onRemoveScenceComplete);///移除场景时触发
			currentScence.removeScence();
			return true;
		}
		private function onRemoveScenceComplete(e:ScenceEvent):void
		{
		//	trace("删除当前场景--",currentScence.scenceType);
			currentScence.removeEventListener(ScenceEvent.RemoveScenceComplete,onRemoveScenceComplete);
			enterNextScence();
		}
		/** 销毁当前场景所附带的模块
		 */		
		private function destroyCurrentScenceModule():void
		{
//			var len:int=moduleList.length;
//			var module:IModule;
//			for(var i:int=0;i!=len;++i)
//			{
//				module=moduleList[i];
//				if(module.delFromScence(currentScence.scenceType))
//				{
//					moduleList.splice(i,1);
//					i--;
//				}
//			}
			
			var module:IModule;
			for  (var moduleStr:Object in moduleList)
			{
				module=moduleList[moduleStr];
				if(module.delFromScence(currentScence.scenceType))
				{
					delete moduleList[moduleStr];
				}
			}
		}
		
		private function  enterNextScence():void
		{
			nextScence.enterScence();
			currentScence=nextScence;
			nextScence=null;
		}
	}
}