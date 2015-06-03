package com.YFFramework.game.core.module.notice.view
{
	import com.YFFramework.core.center.manager.ResizeManager;
	import com.YFFramework.core.proxy.StageProxy;
	import com.YFFramework.core.utils.common.ClassInstance;
	import com.YFFramework.game.ui.layer.LayerManager;
	import com.dolo.ui.tools.Xdis;
	import com.greensock.TweenLite;
	import com.greensock.easing.Linear;
	
	import flash.display.Sprite;
	import flash.text.TextField;

	/**
	 * @author jina;
	 * @version 1.0.0
	 * creation time：2013-8-20 下午5:01:25
	 */
	public class BulletinBoardManager
	{
		//======================================================================
		//       public property
		//======================================================================
		
		//======================================================================
		//       private property
		//======================================================================
		private const SPEED:int=50;
		
		private var _ui:Sprite;
		private var _txt:TextField;
		private var _mask:Sprite;
		
		private var _msgAry:Array;
		private var _isPlay:Boolean=false;
		//======================================================================
		//        constructor
		//======================================================================
		
		public function BulletinBoardManager()
		{
			_ui=ClassInstance.getInstance('bullitinBoard');
			_mask = Xdis.getChild(_ui,'mask_mc');
			_ui.cacheAsBitmap=true;
			_ui.mouseChildren=false;
			_ui.mouseEnabled=false;
			
			_txt = Xdis.getChild(_ui,'str');
			_txt.selectable=false;
			_txt.mouseEnabled=false;
			_txt.mask = _mask;
			
			_msgAry=[];
			
			ResizeManager.Instance.regFunc(initPos);
			initPos();
		}
		
		//======================================================================
		//        public function
		//======================================================================
		public function setOperatiorNotice(msg:String):void
		{
			_msgAry.push(msg);
			LayerManager.NoticeLayer.addChild(_ui);
			showMsg();
		}
		//======================================================================
		//        private function
		//======================================================================
		protected function initPos():void{
			_ui.x = (StageProxy.Instance.stage.stageWidth-_mask.width)/2;
			_ui.y = StageProxy.Instance.stage.stageHeight*0.18;
		}
		
		private function showMsg():void
		{
			var len:int=_msgAry.length;
			if(len == 0)
			{
				if(LayerManager.NoticeLayer.contains(_ui))LayerManager.NoticeLayer.removeChild(_ui);
				_txt.x=0;
				_txt.width=_mask.width;
				return;
			}
			else
			{
				if(_isPlay == false)
				{
					_isPlay=true;
					_txt.htmlText=_msgAry.pop();
					_txt.x=_mask.width;
					_txt.width=_txt.textWidth+10;
					TweenLite.to(_txt, (_mask.width + _txt.width) / SPEED , {x:-_txt.width,onComplete:completeHandler,ease:Linear.easeNone});
				}
				
			}
		}
		//======================================================================
		//        event handler
		//======================================================================
		private function completeHandler():void 
		{
			_isPlay=false;
			TweenLite.killTweensOf(_txt);
			showMsg();
		}
		//======================================================================
		//        getter&setter
		//======================================================================

	}
} 