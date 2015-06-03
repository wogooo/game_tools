package com.dolo.ui.tools
{
	import com.YFFramework.core.center.manager.update.UpdateManager;
	import com.dolo.ui.managers.UI;
	
	import flash.display.DisplayObject;
	import flash.events.Event;

	public class EnterFrameMove
	{
		private static var all:Array = [];
		
		private var _dis:DisplayObject;
		private var _speed:Number;
		private var _max:Number;
		private var _now:Number= 0 ;
		private var _isY:Boolean;
		
		public function EnterFrameMove(target:DisplayObject,moveSpeed:Number,max:Number,isY:Boolean = true)
		{
			all.push(this);
			_dis = target;
			_speed = moveSpeed;
			_max =Math.abs(max);
			_isY = isY;
			UpdateManager.Instance.framePer.regFunc(onEnterFrame);
		}
		
		protected function onEnterFrame(event:Event=null):void
		{
			_now += Math.abs(_speed);
			var less:Number = 0;
			if(_isY){
				_dis.y += _speed-less;
			}else{
				_dis.x += _speed-less;
			}
			if(_now >= _max){
				less = _now-_max;
				if(_speed < 0){
					less = -less;
				}
				clear();
			}
		}
		
		private function clear():void
		{
			UpdateManager.Instance.framePer.delFunc(onEnterFrame);
			_dis = null;
			var index:int=all.indexOf(this);
			if(index!=-1)all.splice(index,1);
		}
	}
}