package com.dolo.ui.controls
{
	import com.YFFramework.core.center.manager.update.UpdateManager;
	import com.YFFramework.core.utils.common.ClassInstance;
	import com.dolo.ui.managers.UI;
	import com.greensock.TweenLite;
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;

	/**皮肤百分比进度条
	 */
	public class ProgressBar extends UIComponent{
		
		protected var _speed:Number = 4;
		protected var _ui:DisplayObject;
		/** 一个progressBar的最大宽度 */		
		protected var _initW:Number;
		protected var _percent:Number;
//		protected var _toWidth:Number;
//		protected var _to100:Number;
//		protected var _isTo100:Boolean;
//		protected var _cannelIsTo100:Boolean = true;
		
		override public function dispose():void{
			super.dispose();
			_ui = null;
		}
		
		public function ProgressBar(){	
		}

//		public function get speed():Number{
//			return _speed;
//		}

		/**缓动的速度，默认4 公式 a += (b-a)/speed 
		 * @param value
		 */
//		public function set speed(value:Number):void{
//			_speed = value;
//		}

		public function get percent():Number{
			return _percent;
		}
		
		/**设置百分比 
		 * @param value 0-1之间的浮点数字
		 */
		public function set percent(value:Number):void{
//			if(_cannelIsTo100 == true)	_isTo100 = false;
//			if(_percent < 0 )	_percent = 0;
//			if(_percent > 1 ) 	_percent = 1;
//			_toWidth = int(_initW*_percent);
//			UpdateManager.Instance.framePer.regFunc(onEnterFrame);
			
			//升级后，新的小数小于旧的小数，旧的小数要先变成1，再变成新的小数；
			//当然可能会出现一种特殊情况，新的小数虽然大于旧的小数，但其实升级了，这个时候就可以找策划算账了，因为数值没配好！
//			if(value < _percent)
//				TweenLite.to(_ui,0.25,{width:_initW*1,onComplete:completeScale,onCompleteParams:[value]});
//			else if(value > _percent)
			TweenLite.to(_ui,0.25,{width:_initW*value,onComplete:completeTween});
			_percent = value;
		}
		
		/** 设置百分比 
		 * 血条 从 大到下一个等级的小 percent   是先percent升到 100% 然后 从 0 升到 value 
		 */
		public function set percentUpTo(value:Number):void{
			//			if(_cannelIsTo100 == true)	_isTo100 = false;
			//			if(_percent < 0 )	_percent = 0;
			//			if(_percent > 1 ) 	_percent = 1;
			//			_toWidth = int(_initW*_percent);
			//			UpdateManager.Instance.framePer.regFunc(onEnterFrame);
			
			//升级后，新的小数小于旧的小数，旧的小数要先变成1，再变成新的小数；
			//当然可能会出现一种特殊情况，新的小数虽然大于旧的小数，但其实升级了，这个时候就可以找策划算账了，因为数值没配好！
			if(value < _percent)
				TweenLite.to(_ui,0.25,{width:_initW*1,onComplete:completeScale,onCompleteParams:[value]});
			else if(value > _percent)
				TweenLite.to(_ui,0.25,{width:_initW*value,onComplete:completeTween});
			_percent = value;
		}

		
		
		
		private function completeScale(percent:Number):void
		{
			_ui.scaleX=0;
			TweenLite.to(_ui,0.25,{width:_initW*percent,onComplete:completeTween});
		}
		
		private function completeTween():void
		{
			TweenLite.killTweensOf(_ui);
		}
		
//		public function update100ToPercent(value:Number):void{
//			_isTo100 = true;
//			_to100 = value;
//			_cannelIsTo100 = false;
//			percent = 1;
//		}
		
//		protected function onEnterFrame(event:Event=null):void{
//			var less:Number = _toWidth-_ui.width;
//			_ui.width += less/_speed;
//			if(Math.abs(less)<1.1){
//				_ui.width = _toWidth;
//				UpdateManager.Instance.framePer.delFunc(onEnterFrame);
//				onEnd();
//			}
//		}
		
//		protected function onEnd():void{
//			if(_isTo100 == true)	percent = _to100;
//			_isTo100 = false;
//			_cannelIsTo100 = true;
//		}
		
		override public function targetSkin(skin:DisplayObject):void{
			_ui = skin;
			this.x = int(_ui.x);
			this.y = int(_ui.y);
			_ui.x = 0;
			_ui.y = 0;
			_initW = _ui.width;
			_percent = 0;
			_ui.width = 0;
			this.addChild(_ui);
		}
	}
}