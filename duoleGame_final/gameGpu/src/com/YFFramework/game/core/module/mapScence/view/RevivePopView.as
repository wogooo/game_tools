package com.YFFramework.game.core.module.mapScence.view
{
	/**人物 复活面板
	 * @author yefeng
	 * 2013 2013-8-23 下午5:40:10 
	 */
	import com.YFFramework.core.ui.yfComponent.PopUpManager;
	import com.YFFramework.core.ui.yfComponent.controls.YFLabel;
	import com.YFFramework.game.core.module.raid.manager.RaidManager;
	import com.YFFramework.game.core.module.raid.model.RaidVo;
	import com.YFFramework.game.core.module.raid.view.RaidAlert;
	import com.dolo.ui.controls.Button;
	import com.dolo.ui.controls.Window;
	
	import flash.events.MouseEvent;
	
	public class RevivePopView extends Window//Alert
	{
		public static const YuanDi:int=0;
		
		public static const HuiCheng:int=1;
		
		private var _label:YFLabel;
		public var yuanDiBtn:Button;
		public var huichenBtn:Button;
		private var _closeFunc:Function;
		public function RevivePopView()
		{
			super(MinWindowBg2); 
			setSize(300,150);
			initUI();
			addEvents();
			_closeButton.visible=false;
		}
		/**初始化UI 
		 */
		private function initUI():void
		{
			yuanDiBtn=Button.creatNewButton("原地复活");  //原地复活
			huichenBtn=Button.creatNewButton("回程复活");  //回程复活
			addChild(yuanDiBtn);
			addChild(huichenBtn);
			yuanDiBtn.x=50;
			huichenBtn.x=165;
			yuanDiBtn.y=huichenBtn.y=_compoHeight-50;
			_label=new YFLabel();
			addChild(_label);
			_label.y=yuanDiBtn.y-45;
		}
		private function addEvents():void
		{
			yuanDiBtn.addEventListener(MouseEvent.CLICK,onClick);
			huichenBtn.addEventListener(MouseEvent.CLICK,onClick);
		}
		
		private function removeEvents():void
		{
			yuanDiBtn.removeEventListener(MouseEvent.CLICK,onClick);
			huichenBtn.removeEventListener(MouseEvent.CLICK,onClick);
		}

		private function onClick(e:MouseEvent):void
		{
			if(_closeFunc!=null)
			{
				switch(e.currentTarget)
				{
					case yuanDiBtn:
						_closeFunc(YuanDi);
						break;
					case huichenBtn:
						_closeFunc(HuiCheng);
						break;
				}
			}
		}
		private function initText(txt:String):void
		{
			_label.text=txt;
			_label.width=200;
			_label.exactWidth();
			_label.x=(_compoWidth-_label.textWidth)*0.5;
		}
		
		public static function show(text:String ,title:String = "提示",closeFunction:Function = null ):RevivePopView{
			var alert:RevivePopView = new RevivePopView();
			if(RaidManager.raidId!=-1){
				var raidVo:RaidVo = RaidManager.Instance.getRaidVo(RaidManager.raidId);
				raidVo.deadNum++;
				if(raidVo.deadNum>=raidVo.deadTimes){
					return null;					
				}
				alert.yuanDiBtn.label = "继续副本";
				alert.huichenBtn.label = "离开副本";
			}else{
				alert.yuanDiBtn.label = "原地复活";
				alert.huichenBtn.label = "回程复活";
			}
			alert.initText(text);
			alert._closeFunc=closeFunction;
			//				alert.eventData = data;
			//				alert.init( text, title, closeFunction, buttonLabels, isUnableMouse, icon, alertWidth, alertHeight );
			//				alert._closeButton.visible=false;
			//				return alert;
			PopUpManager.addPopUp(alert,null,0,0,0xFFFFFF,0.01);
			PopUpManager.centerPopUp(alert);
			return alert;
		}
  
//		override protected function onBtnClick(event:MouseEvent):void
//		{
//			_needSendEvent = false;
//			 
//			var btn:Button = event.currentTarget as Button;
//			var index:int= 0 ;
//			for( var i:int=0; i<_btns.length; i++ ){
//				if( btn == _btns [ i ] ){
//					index = i;
//					break;
//				}
//			}
//			if( _closeFunction != null ){
//				var ae:AlertCloseEvent = new AlertCloseEvent( AlertCloseEvent.CLOSE, index+1, btn.label );
//				ae.data = _eventData;
//				_closeFunction ( ae );
//			}
//		}
		public function updateClose():void
		{
			PopUpManager.removePopUp(this);
			removeEvents();
			while(numChildren)
			{
				removeChildAt(0);
			}
			yuanDiBtn=null;
			huichenBtn=null;
			_closeFunc=null;
			dispose();
			
		}
		
		

	}
}