package com.YFFramework.game.core.module.notice.view
{
	import com.YFFramework.core.center.manager.ResizeManager;
	import com.YFFramework.core.proxy.StageProxy;
	import com.YFFramework.core.ui.yfComponent.PopUpManager;
	import com.YFFramework.game.ui.layer.LayerManager;
	import com.dolo.ui.tools.Align;
	import com.dolo.ui.tools.EnterFrameMove;
	import com.greensock.TweenLite;
	import com.greensock.easing.Cubic;
	
	import flash.display.Sprite;
	import flash.filters.GlowFilter;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.utils.setTimeout;

	/**
	 * @version 1.0.0
	 * creation time：2013-8-17 下午2:12:46
	 */
	public class PopupNoticeManager{
		
		protected var _spArea:Sprite = new Sprite();
		protected var showTime:Number = 1.2;
		protected var displayCount:int=3;
		private static const OperatorFilter:GlowFilter=new GlowFilter(0x000000,1,2,2,5,1);
		protected var _pool:Vector.<TextField>=new Vector.<TextField>();
		protected var _index:int=0;
		
		public function PopupNoticeManager(){
			_pool.push(createNewText());
			_pool.push(createNewText());
			_pool.push(createNewText());
			_pool.push(createNewText());
			_spArea.mouseChildren=false;
			_spArea.mouseEnabled=false;
			LayerManager.NoticeLayer.addChild(_spArea);
			
			ResizeManager.Instance.regFunc(initPos);
			initPos();
		}
		
		public function createNewText():TextField{
			var txt:TextField = new TextField();
			var tf:TextFormat = new TextFormat();
			tf.bold = true;
			txt.defaultTextFormat=tf;
			txt.mouseEnabled=false;
			txt.selectable=false;
			txt.filters=[OperatorFilter];
			return txt;
		}
		
		protected function initPos():void{
			_spArea.x = (StageProxy.Instance.stage.stageWidth/2);
			_spArea.y = StageProxy.Instance.stage.stageHeight/2+100;
		}
		
		public function setOperatiorNotice(str:String):void{
			var txt:TextField;
			txt = _pool[_index];
			_index = (_index+1)%4;
				
			txt.htmlText = str;
			txt.width = 500;
			txt.width = txt.textWidth+5;
			txt.y=0;
			txt.x = -(txt.textWidth/2);

			
			var sp:Sprite =new Sprite();
			sp.addChild(txt);
			sp.mouseChildren=false;
			sp.mouseEnabled=false;
			
			_spArea.addChild(sp);
			if(_spArea.numChildren>displayCount)	_spArea.removeChildAt(0);
			sp.y = 0 + 20*_spArea.numChildren;
			
			var len:int=_spArea.numChildren;
			for(var i:int=0;i<len;i++){
				new EnterFrameMove(_spArea.getChildAt(i),-1.5,30);
			}
			
			txt.alpha = 0.5;
			TweenLite.to(txt,0.45,{alpha:1,y:txt.y-25,ease:Cubic.easeOut,onComplete:completeOperator,onCompleteParams:[txt]});
		}
		
		private function completeOperator(txt:TextField):void{
			setTimeout(moveOut,showTime*1000,txt);
		}
		
		private function moveOut(txt:TextField):void{
			TweenLite.to(txt,0.7,{alpha:0,y:txt.y-30,onComplete:completeTween,onCompleteParams:[txt],ease:Cubic.easeOut,delay:0.5});
		}
		
		private function completeTween(txt:TextField):void{
			var sp:Sprite = txt.parent as Sprite;
			if(sp&&sp.parent)  sp.parent.removeChild(sp);
			//if(_spArea.contains(txt))	_spArea.removeChild(txt);
		}
	}
} 