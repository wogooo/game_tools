package com.YFFramework.game.core.module.notice.view
{
	import com.YFFramework.core.center.manager.ResizeManager;
	import com.YFFramework.core.center.manager.update.UpdateManager;
	import com.YFFramework.core.proxy.StageProxy;
	import com.YFFramework.core.utils.common.ClassInstance;
	import com.YFFramework.game.ui.layer.LayerManager;
	import com.dolo.ui.controls.VScrollBar;
	import com.dolo.ui.tools.AutoBuild;
	import com.dolo.ui.tools.Xdis;
	import com.greensock.TweenLite;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;

	/**
	 * @author jina;
	 * @version 1.0.0
	 * creation time：2013-8-22 上午9:27:05
	 */
	public class NormalNoticeManager
	{
		
		public static const Glow:GlowFilter=new GlowFilter(0x000000,1,2,2,2);

		//======================================================================
		//       public property
		//======================================================================
		
		//======================================================================
		//       private property
		//======================================================================
		private var _ui:Sprite;
		private var _bigAndSmall:MovieClip;
		private var _bg:Sprite;
		private var _scrollBar:VScrollBar;
		
		private var _isDown:Boolean=false;
		private var _txt:TextField;
		private var _notices:Vector.<String>;
		
		
		/**msg数据
		 *  用来错帧处理
		 */
//		private var _msgArr:Vector.<String>;
//		/** msg数据长度
//		 */
//		private var _msgSize:int;

		//======================================================================
		//        constructor
		//======================================================================
		public function NormalNoticeManager()
		{
			_ui=ClassInstance.getInstance('nomalNotice');
			AutoBuild.replaceAll(_ui);
			_bg=Xdis.getChild(_ui,"bg");
			_scrollBar=Xdis.getChild(_ui,"list_vScrollBar");
			_txt=Xdis.getChild(_ui,"rich_txt");
			_txt.mouseWheelEnabled=false;
			_txt.autoSize=TextFieldAutoSize.LEFT;
			_bg.alpha=.7;
			
			_scrollBar.setTarget(_txt,false,_txt.width+10,_scrollBar.compoHeight-5,0,0);
			_scrollBar.arrowClickMove=21;
			
			_bigAndSmall=ClassInstance.getInstance("plusAndMinus");
			_bigAndSmall.gotoAndStop(2);
			_bigAndSmall.addEventListener(MouseEvent.CLICK,onClick);
			_ui.addChild(_bigAndSmall);
			_bigAndSmall.y=-_bigAndSmall.height;
			_bigAndSmall.visible=false;
			
			ResizeManager.Instance.regFunc(initPos);
			initPos();
			
			LayerManager.UILayer.addChild(_ui);
			
			_ui.addEventListener(MouseEvent.ROLL_OUT,onRollOut);
			_ui.addEventListener(MouseEvent.ROLL_OVER,onRollOver);
			
			_scrollBar.alpha=0;
			_bg.visible=false;
			
			_notices=new Vector.<String>(20,false);
			
//			_msgArr=new Vector.<String>();
//			_msgSize=0;

			_txt.filters=[Glow];
//			UpdateManager.Instance.frame8.regFunc(handleMsg);

		}
		
		//======================================================================
		//        public function
		//======================================================================
		public function setOperatiorNotice(msg:String):void
		{
//			_msgArr.unshift(msg);
//			_msgSize++;
			handleNotice(msg);
		}
		
		/**处理消息
		 */
//		private function handleMsg():void
//		{
//			if(_msgSize>0)
//			{
//				_msgSize--;
//				var msg:String=_msgArr.pop();
//				handleNotice(msg);
//			}
//		}

		private function handleNotice(msg:String):void
		{
			addNotice(msg);
			var i:int;
			var str:String="";
			var hasFirstLine:Boolean=false;
			for(i=0;i<20;i++)
			{
				if(_notices[i])
				{
					if(!hasFirstLine)
					{
						str=_notices[i];
						hasFirstLine=true;
					}
					else
						str+="<br>"+_notices[i];
				}
			}
			_txt.htmlText=str;
			_scrollBar.updateSize(_txt.textHeight+5);
			_scrollBar.scrollToEnd();
		}
		
		private function addNotice(no:String):void
		{
//			var i:int;
//			for(i=0;i<19;i++)
//			{
//				_notices[i]=_notices[i+1];
//			}
//			_notices[19]=no;
			
			_notices.shift()
			_notices[19]=no;
		}
		
		protected function initPos():void
		{
			if(_bigAndSmall.currentFrame==2)
				_ui.x = StageProxy.Instance.stage.stageWidth-_bg.width-_scrollBar.width;
			else if(_bigAndSmall.currentFrame==1)
				_ui.x= StageProxy.Instance.getWidth()-_bigAndSmall.width;
			_ui.y = StageProxy.Instance.stage.stageHeight*0.65;
		}
		//======================================================================
		//        private function
		//======================================================================
		
		//======================================================================
		//        event handler
		//======================================================================
		private function onRollOut(e:MouseEvent=null):void
		{
			_bg.visible=false;
			_scrollBar.alpha=0;
			_bigAndSmall.visible=false;
		}
		private function onRollOver(e:MouseEvent):void
		{
			_bg.visible=true;
			_scrollBar.alpha=1;
			_bigAndSmall.visible=true;
		}
		
		protected function onClick(event:MouseEvent):void
		{
			var current:int=_bigAndSmall.currentFrame;
			if(current==1)
			{//还原
				_bigAndSmall.gotoAndStop(2);
				_bg.visible=true;
				_txt.visible=true;
				
				TweenLite.to(_ui,.5,{x:StageProxy.Instance.stage.stageWidth-_ui.width,onComplete:function():void{
					_ui.addEventListener(MouseEvent.ROLL_OVER,onRollOver);
					_ui.addEventListener(MouseEvent.ROLL_OUT,onRollOut);
					onRollOut();
				}});
			}
			else if(current==2)
			{//最小化
				_bigAndSmall.gotoAndStop(1);
				_ui.removeEventListener(MouseEvent.ROLL_OVER,onRollOver);
				_ui.removeEventListener(MouseEvent.ROLL_OUT,onRollOut);
				TweenLite.to(_ui,.5,{x:StageProxy.Instance.getWidth()-_bigAndSmall.width,onComplete:function():void{
					_bg.visible=false;
					_txt.visible=false;
				}});
			}
			event.stopPropagation();
		}
		//======================================================================
		//        getter&setter
		//======================================================================
	}
} 