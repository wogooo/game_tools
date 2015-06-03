package com.YFFramework.game.core.module.character.view.simpleView
{
	import com.YFFramework.core.center.manager.ResizeManager;
	import com.YFFramework.core.center.manager.update.UpdateManager;
	import com.YFFramework.core.debug.print;
	import com.YFFramework.core.event.YFEvent;
	import com.YFFramework.core.proxy.StageProxy;
	import com.YFFramework.core.ui.abs.AbsView;
	import com.YFFramework.game.core.global.event.GlobalEvent;
	import com.YFFramework.game.ui.imageText.ImageTextManager;
	import com.YFFramework.game.ui.imageText.TypeImageText;
	import com.YFFramework.game.ui.layer.LayerManager;
	import com.dolo.ui.managers.UI;
	import com.greensock.TweenLite;
	import com.greensock.easing.Cubic;
	
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.utils.getTimer;

	/**
	 * 战斗力有任何改变，都显示在舞台的中下方
	 * @author jina;
	 * @version 1.0.0
	 * creation time：2013-10-14 下午2:36:07
	 */
	public class PowerNumView
	{
		//======================================================================
		//       public property
		//======================================================================
		
		//======================================================================
		//       private property
		//======================================================================
		private const STAND_BY:int=3;
		
		private static var _instance:PowerNumView;
		private var _startNum:int;
		private var _offsetNum:int;
		
		private var _powerSp:Sprite;
		private var _powerWord:Bitmap;
		private var _startTxt:AbsView;
		private var _offsetTxt:AbsView;
//		private var _startPlayer:TweenNumPlay;
//		private var _offsetPlayer:TweenNumPlay;
		private var _isPlay:Boolean=false;
		//======================================================================
		//        constructor
		//======================================================================
		
		public function PowerNumView()
		{
			_powerSp=new Sprite();
//			_startPlayer=new TweenNumPlay();
//			_startPlayer.addEventListener(YFEvent.Complete,onStartPlayerComplete);
			
//			_offsetPlayer=new TweenNumPlay();
//			_offsetPlayer.addEventListener(YFEvent.Complete,onOffsetPlayerComplete);
			
			_powerWord=ImageTextManager.Instance.createPowerTxt();
			ResizeManager.Instance.regFunc(initPos);
		}
		
		protected function initPos():void{
			_powerSp.x = (StageProxy.Instance.stage.stageWidth-_powerSp.width)/2;
			_powerSp.y = StageProxy.Instance.stage.stageHeight-250;
		}
		//======================================================================
		//        public function
		//======================================================================
		public function addPowerNum(startNum:int,offsetNum:int):void
		{
			_startNum=startNum;
			_offsetNum=offsetNum;
			showPowerNum();
		}
		//======================================================================
		//        private function
		//======================================================================
		private function showPowerNum():void
		{
			if(_isPlay == false)
			{
				if(_offsetNum == 0) return;
				
				_isPlay=true;
				
				_offsetTxt=ImageTextManager.Instance.createNumWithPre(_offsetNum,TypeImageText.Power_Green_Num,0,TypeImageText.Power_Plus);
				_startTxt=ImageTextManager.Instance.createNum(_startNum.toString(),TypeImageText.Power_Big_Num);			
				
				_powerSp.addChild(_powerWord);
				_powerWord.alpha=0;
				_powerWord.y=25;
				_powerWord.x=-15;
				
				_startTxt.x=_powerWord.width;
				_startTxt.y=25;
				_startTxt.alpha=0;
				_powerSp.addChild(_startTxt);
				
				var digit:int=(_startNum + _offsetNum).toString().length;
				if(digit == 2)
					_offsetTxt.x=_startTxt.x+_startTxt.width;
				else
					_offsetTxt.x=_startTxt.x+_startTxt.width+_startTxt.width/digit+5;
				_offsetTxt.y=25;
				_offsetTxt.alpha=0;
				_powerSp.addChild(_offsetTxt);
				
				initPos();
				LayerManager.TipsLayer.addChild(_powerSp);
				
				TweenLite.to(_powerWord,0.4,{alpha:1,y:0,ease:Cubic.easeOut});
				TweenLite.to(_startTxt,0.4,{alpha:1,y:4,ease:Cubic.easeOut});
				TweenLite.to(_offsetTxt,0.6,{alpha:1,y:0,ease:Cubic.easeOut,onComplete:fadeIn});
			}		
			else
			{
				clearPower();
				showPowerNum();
			}
		}
		
		/** 数字淡入效果结束 */		
		protected function fadeIn():void
		{
			//主数字开始滚动
			_startPlayer.setPlayFunc(startNumPlay);
			_startPlayer.stop();
			if(_offsetNum < 10)
			{
				_startPlayer.initData(_startNum,_startNum+_offsetNum,20);
			}
			else
			{
				_startPlayer.initData(_startNum,_startNum+_offsetNum,10);
			}

			//差值数字开始滚动
//			_offsetPlayer.setPlayFunc(offsetNumPlay);
//			if(_offsetNum < 10)
//				_offsetPlayer.initData(_offsetNum,0,20);
//			else
//				_offsetPlayer.initData(_offsetNum,0,10);
//			_offsetPlayer.start();
			//差值数字不滚动，显示2S后消失
			TweenLite.to(_powerWord,0.4,{alpha:0,delay:STAND_BY,y:-25});
			TweenLite.to(_startTxt,0.4,{alpha:0,delay:STAND_BY,y:-25,onComplete:clearPower});
			TweenLite.to(_offsetTxt,0.6,{alpha:0,delay:STAND_BY,y:-35});
			
		}
		
		/** 主数字开始播放 */		
<<<<<<< .mine
		private function startNumPlay(num:int):void
		{
			if(_startTxt.parent)_startTxt.parent.removeChild(_startTxt);
			_startTxt=ImageTextManager.Instance.createNum(num.toString(),TypeImageText.Power_Big_Num);
			_startTxt.x=_powerWord.width;
			_startTxt.y=4;
			_powerSp.addChild(_startTxt);	
			
			print(this,"显示数字",num);
			
		}
=======
//		private function startNumPlay(num:int):void
//		{
//			if(_startTxt.parent)_startTxt.parent.removeChild(_startTxt);
//			_startTxt=ImageTextManager.Instance.createNum(num.toString(),TypeImageText.Power_Big_Num);
//			_startTxt.x=_powerWord.width;
//			_startTxt.y=4;
//			_powerSp.addChild(_startTxt);	
//			
//		}
>>>>>>> .r7355
		
		/** 差值数字开始播放 */
//		private function offsetNumPlay(num:int):void
//		{
//			if(_offsetTxt.parent)_startTxt.parent.removeChild(_offsetTxt);
//			_offsetTxt=ImageTextManager.Instance.createNumWithPre(num,TypeImageText.Power_Green_Num,0,TypeImageText.Power_Plus);
//			var digit:int=(_startNum + _offsetNum).toString().length;
//			if(digit == 2)
//				_offsetTxt.x=_startTxt.x+_startTxt.width;
//			else
//				_offsetTxt.x=_startTxt.x+_startTxt.width+_startTxt.width/digit+5;
//			_offsetTxt.y=4;
//			_powerSp.addChild(_offsetTxt);
//		}
		
		/** 主数字滚动完成 */		
//		private function onStartPlayerComplete(e:YFEvent):void
//		{
//			TweenLite.to(_powerWord,0.4,{alpha:0,delay:STAND_BY,y:-25});
//			TweenLite.to(_startTxt,0.4,{alpha:0,delay:STAND_BY,y:-25,onComplete:clearPower});
//		}
		
		/** 差值数字滚动完成 */		
//		private function onOffsetPlayerComplete(e:YFEvent):void
//		{
//			TweenLite.to(_offsetTxt,0.4,{alpha:0,y:-15,onComplete:hideOffset});
//		}
		
//		private function hideOffset():void
//		{
//			if(_powerSp.contains(_offsetTxt))
//				_powerSp.removeChild(_offsetTxt);
//			UI.removeAllChilds(_offsetTxt);
//			TweenLite.killTweensOf(_offsetTxt);
//		}
		
		private function clearPower():void
		{		
			if(LayerManager.TipsLayer.contains(_powerSp))
				LayerManager.TipsLayer.removeChild(_powerSp);
			if(_powerSp.numChildren > 0)
				UI.removeAllChilds(_powerSp);
			if(_startTxt && _startTxt.numChildren > 0)
				UI.removeAllChilds(_startTxt);
			if( _offsetTxt && _powerSp.contains(_offsetTxt))
				_powerSp.removeChild(_offsetTxt);
			UI.removeAllChilds(_offsetTxt);
			
			TweenLite.killTweensOf(_offsetTxt);			
			TweenLite.killTweensOf(_powerWord);
			TweenLite.killTweensOf(_startTxt);			
			
//			_startPlayer.dispose();
			_isPlay=false;
		}
		//======================================================================
		//        event handler
		//======================================================================
		
		//======================================================================
		//        getter&setter
		//======================================================================
		
		public static function get instance():PowerNumView
		{
			if(_instance == null) _instance=new PowerNumView();
			return _instance;
		}

	}
} 