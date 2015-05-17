package com.YFFramework.game.core.module.gameView.view
{
	import com.YFFramework.core.event.YFEventCenter;
	import com.YFFramework.core.ui.abs.AbsView;
	import com.YFFramework.core.utils.common.ClassInstance;
	import com.YFFramework.game.core.global.event.GlobalEvent;
	
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.utils.Dictionary;

	/**
	 * 弹出按钮统一管理器
	 * @version 1.0.0
	 * creation time：2013-4-2 下午4:07:20
	 * 
	 */
	public class EjectBtnView extends AbsView{
		
		private var _mc:MovieClip;
		/**
		 *是否有对应的按钮，Boolean值 
		 */		
		private var _btnDict:Dictionary;
		private var _btnArray:Array;
		
		public function EjectBtnView(mc:MovieClip){
			_mc = mc;
			super(false);
			_btnDict = new Dictionary();
			_btnArray = new Array();
		}
		
		/**添加弹出按钮 
		 * @param type	按钮类型
		 */		
		public function addBtn(type:String):void{
			var btn:MovieClip;
			switch(type){
				case "team":
					btn = ClassInstance.getInstance("teamBtn") as MovieClip;
					btn.addEventListener(MouseEvent.CLICK,onClick);
					_btnDict["team"] = true;
					_btnArray.push(btn);
					break;
			}
			btn.name = type;
		}
		
		/**更新弹出按钮View 
		 */		
		public function updateBtnView():void{
			removeAllBtn();
			for(var i:int=0;i<_btnArray.length;i++){
				_btnArray[i].x = i*40;
				_mc.addChild(_btnArray[i]);
			}
		}
		
		/**移除全部弹出的按钮
		 */		
		public function removeAllBtn():void{
			while(_mc.numChildren!=0)
				_mc.removeChildAt(0);
		}
		
		/**移除指定按钮 
		 * @param type	按钮类型
		 */		
		public function removeBtn(type:String):void{
			if(hasBtn(type)){
				_btnDict[type]=false;
				for(var i:int=0;i<_btnArray.length;i++){
					if(_btnArray[i].name==type){
						_btnArray.splice(i,1);
						break;
					}
				}
			}
		}
		
		/**是否已经有该弹出按钮 
		 * @param type	按钮类型
		 * @return Boolean值
		 */		
		public function hasBtn(type:String):Boolean{
			if(_btnDict[type])	return true;
			return false;
		}
		
		private function onClick(e:MouseEvent):void{
			switch(e.currentTarget.name){
				case "team":
					YFEventCenter.Instance.dispatchEventWith(GlobalEvent.InviteUIClick);
					break;
			}
		}
	}
} 