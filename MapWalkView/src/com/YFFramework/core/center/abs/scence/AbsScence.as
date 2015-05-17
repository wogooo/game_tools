package com.YFFramework.core.center.abs.scence
{
	import com.YFFramework.core.center.face.IScence;
	import com.YFFramework.core.center.manager.ScenceManager;
	import com.YFFramework.core.event.ScenceEvent;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	/**
	 * author :夜枫 * 时间 ：2011-9-25 下午06:54:36
	 */
	public class AbsScence implements IScence
	{
		protected var _scenceType:String;
		private var dispatcher:EventDispatcher;
		public function AbsScence(_scenceType:String)
		{
			dispatcher=new EventDispatcher();
			this._scenceType=_scenceType;
			regScence()
		}
		
		public function get scenceType():String
		{
			return _scenceType;
		}
		
		public function set scenceType(_scenceType:String):void
		{
			this._scenceType=_scenceType;
		}
		
		/**@override 
		 * 初始化场景相关联的模块   Imodule.show();     需要在子类覆盖@override 
		 */
		public function enterScence():void
		{
			//override ---------------
		}
		/**
		 * 将场景相关的模块进行移出去这里只是进行移除去 模块这里不需要进行内存释放 因为模块内存释放时在场景管理器中完成的       
		 */		
		public function removeScence():void
		{
			removeScenceUI();
			this.dispatchEvent(new ScenceEvent(ScenceEvent.RemoveScenceComplete));
		}
		/** @override  需要在子类覆盖@override 
		 *  子类 覆盖该方法
		 */		
		protected function  removeScenceUI():void
		{
			//override ---------------
			
		}
		
		public function regScence():void
		{
			ScenceManager.Instance.regScence(this);
		//	trace("注册场景类型::",scenceType);
		}
		public function delScence():void
		{
			ScenceManager.Instance.delScence(this);
		}
		
		public function addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false):void
		{
			dispatcher.addEventListener(type, listener, useCapture, priority);
		}
		
		public function dispatchEvent(evt:Event):Boolean
		{
			return dispatcher.dispatchEvent(evt);
		}
		public function hasEventListener(type:String):Boolean
		{
			return dispatcher.hasEventListener(type);
		}
		
		public function removeEventListener(type:String, listener:Function, useCapture:Boolean = false):void
		{
			dispatcher.removeEventListener(type, listener, useCapture);
		}
		
		public function willTrigger(type:String):Boolean
		{
			return dispatcher.willTrigger(type);
		}

	}
}