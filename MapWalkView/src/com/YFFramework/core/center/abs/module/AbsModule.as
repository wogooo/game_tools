package com.YFFramework.core.center.abs.module
{
	import com.YFFramework.core.center.face.IModule;
	import com.YFFramework.core.center.manager.ScenceManager;
	
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	/**
	 * author :夜枫 * 时间 ：2011-9-26 下午04:13:56
	 */
	public class AbsModule extends EventDispatcher implements IModule
	{
		/**该属性 在构造函数中饭需要进行赋值
		 */
		protected var _belongScence:String;
		public function AbsModule()
		{
			super(null);
			regModule();
		}
		
		public function regModule():void
		{
			ScenceManager.Instance.regModule(this);
		}
		
		
		
		
		/**
		 * 子类进行覆盖
		 */		
		public function delFromScence(scenceType:String):Boolean
		{
			if(_belongScence==scenceType)
			{
				dispose();
				return true;
			}
			return false;
		}
	
		
		/**@override  
		 * 子类进行覆盖  进行  ui的创建   该方法的调用时在场景管理器中进行调用
		 */	
		public function init():void
		{
		}
		/**override 
		 *  子类进行覆盖
		 */
		public function dispose():void
		{
			_belongScence="";
		}
	}
}