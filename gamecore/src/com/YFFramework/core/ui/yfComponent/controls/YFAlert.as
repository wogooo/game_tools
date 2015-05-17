package com.YFFramework.core.ui.yfComponent.controls
{
	/**@author yefeng
	 *2012-5-18上午12:22:19
	 */
	import com.YFFramework.core.proxy.StageProxy;
	import com.YFFramework.core.ui.layer.PopUpManager;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	public class YFAlert extends YFPane
	{
		
		private static const MaxWidth:int=280;
		
		private static const MinWidth:int=180	
		
		private static const MaxHeight:int=250;
		private static const MinHeight:int=150;
		
		private var _okFunc:Function;
		private var _cancelFunc:Function;
		private var _okFuncParam:Object;
		private var _cancelFuncParam:Object
		protected var _btnOK:YFButton;
		protected var _btnCancel:YFButton;
		/** 标志值   1 表示 只显示一个按钮 2 表示显示两个
		 */		
		private var _flags:int;
		private var _tittle:String;
		private var _msg:String;
		private var _msgLabel:YFLabel;
		private var _tittleLabel:YFLabel;
		public function YFAlert(message:String="",tittle:String="提示",flags:int=1,okFunc:Function=null,cancelFunc:Function=null,okFuncParam:Object=null,cancelFuncparam:Object=null)
		{
			_msg=message;
			_tittle=tittle;
			_flags=flags;
			_okFunc=okFunc;
			_cancelFunc=cancelFunc;
			_okFuncParam=okFuncParam;
			_cancelFuncParam=cancelFuncparam;
			super(200,200,true);
		}
		
		override protected function initSize(width:Number,height:Number):void
		{
			
		}
		

		override protected function initUI():void
		{
			super.initUI();
			_tittleLabel=new YFLabel(_tittle,1,12,0xFF0000);
			addChild(_tittleLabel);
			_tittleLabel.mouseChildren=_tittleLabel.mouseEnabled=false;
			_tittleLabel.x=5;
			_tittleLabel.y=5;
			_msgLabel=new YFLabel(_msg);
			_msgLabel.width=MinWidth;
			_msgLabel.exactWidth();
			_msgLabel.mouseChildren=_msgLabel.mouseEnabled=false;
			addChild(_msgLabel);
			_msgLabel.y=40;	
			var vSpace:int=20;
			if(_flags==0)	
			{
				_btnOK=new YFButton("确定",2);	
				_btnOK.y=_msgLabel.y+_msgLabel.height+vSpace;
			}
			else if(_flags==1)
			{
				_btnOK=new YFButton("确定",2);	
				addChild(_btnOK);
				_btnOK.y=_msgLabel.y+_msgLabel.height+vSpace;
			}
			else  if(_flags==2)
			{
				_btnOK=new YFButton("确定",2);	
				_btnCancel=new YFButton("取消",2);
				addChild(_btnOK);
				addChild(_btnCancel);
				_btnCancel.y=_btnOK.y=_msgLabel.y+_msgLabel.height+vSpace;
			}
			var space:int=20;
			var myWidth:Number=_msgLabel.width+space<MinWidth?MinWidth:_msgLabel.width+space;
			var myHeight:Number=_btnOK.y+_btnOK.height<MinHeight?MinHeight:_msgLabel.y+_msgLabel.height;
			_msgLabel.x=(myWidth-_msgLabel.textWidth)*0.5;
			if(_flags==1)
			{
				_btnOK.x=(myWidth-_btnOK.width)*0.5;
			}
			else if(_flags==2)
			{
				var btnSpace:int=20;
				_btnOK.x=(myWidth-_btnOK.width-_btnCancel.width-btnSpace)*0.5;
				_btnCancel.x=_btnOK.x+_btnOK.width+btnSpace;
			}
			
			_bgBody.width=myWidth;
			_bgBody.height=_btnOK.y+_btnOK.height+20;
		}
		
		override protected function addEvents():void
		{
			super.addEvents();
			_btnOK.addEventListener(MouseEvent.CLICK,onBtnMouseEvent);
			if(_btnCancel)_btnCancel.addEventListener(MouseEvent.CLICK,onBtnMouseEvent);
		}
		
		override protected function removeEvents():void
		{
			super.removeEvents();
			_btnOK.removeEventListener(MouseEvent.CLICK,onBtnMouseEvent);
			if(_btnCancel)_btnCancel.removeEventListener(MouseEvent.CLICK,onBtnMouseEvent);
		}
		private function onBtnMouseEvent(e:MouseEvent):void
		{
			switch(e.currentTarget)
			{
				case _btnOK:
					if(_okFunc!=null)_okFunc(_okFuncParam);
					PopUpManager.removePopUp(this);
					break;
				case _btnCancel:
					if(_cancelFunc!=null)_cancelFunc(_cancelFuncParam);
					PopUpManager.removePopUp(this);
					break;
			}
		}
		
		public static function show(message:String="",tittle:String="提示",flags:int=1,okFunc:Function=null,cancelFunc:Function=null,okFuncParam:Object=null,cancelFuncParam:Object=null):void
		{
			var alert:YFAlert=new YFAlert(message,tittle,flags,okFunc,cancelFunc,okFuncParam,cancelFuncParam);
			var tx:int=(StageProxy.Instance.stage.stageWidth-alert.width)*0.5;
			var ty:int=(StageProxy.Instance.stage.stageHeight-alert.height)*0.5;
			PopUpManager.addPopUp(alert,null,tx,ty,0x336699);
		}
		
		override public function dispose(e:Event=null):void
		{
			super.dispose();
			 _okFunc=null;
			_cancelFunc=null;
			_btnOK=null;
			_btnCancel=null;
			_tittle="";
			_msg="";
			_msgLabel=null;
		}
		
	}
}