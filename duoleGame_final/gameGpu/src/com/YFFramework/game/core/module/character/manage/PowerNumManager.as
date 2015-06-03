package com.YFFramework.game.core.module.character.manage
{
	import com.YFFramework.core.center.manager.ResizeManager;
	import com.YFFramework.core.proxy.StageProxy;
	import com.YFFramework.core.ui.abs.AbsView;
	import com.YFFramework.game.ui.imageText.ImageTextManager;
	import com.YFFramework.game.ui.imageText.TypeImageText;
	import com.YFFramework.game.ui.layer.LayerManager;
	import com.dolo.ui.managers.UI;
	import com.greensock.TweenLite;
	import com.greensock.easing.Cubic;
	
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.utils.Dictionary;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;

	/**
	 * 战斗力有任何改变，都显示在舞台的中下方
	 * @author jina;
	 * @version 1.0.0
	 * creation time：2013-10-14 下午2:36:07
	 */
	public class PowerNumManager
	{
		//======================================================================
		//       public property
		//======================================================================
		
		//======================================================================
		//       private property
		//======================================================================
		private static var _instance:PowerNumManager;
		private var _numAry:Array;
		private var _powerSp:Sprite;
		private var _isPlay:Boolean=false;
		private var _powerWord:Bitmap;
		private var _resultTxt:AbsView;
		private var _offsetTxt:AbsView;
//		private var _timerOutDict:Dictionary;
		private var _timerIndex:uint;
		//======================================================================
		//        constructor
		//======================================================================
		
		public function PowerNumManager()
		{
			_numAry=[];
			_powerSp=new Sprite();
			ResizeManager.Instance.regFunc(initPos);
//			initPos();
			_powerWord=ImageTextManager.Instance.createPowerTxt();
//			_timerOutDict=new Dictionary();
		}
		
		protected function initPos():void{
			_powerSp.x = (StageProxy.Instance.stage.stageWidth-_powerSp.width)/2;
			_powerSp.y = StageProxy.Instance.stage.stageHeight-250;
		}
		//======================================================================
		//        public function
		//======================================================================
		public function addPowerNum(resultNum:int,offsetNum:int):void
		{
			_numAry.push({result:resultNum,offset:offsetNum});
			showPowerNum();
		}
		//======================================================================
		//        private function
		//======================================================================
		private function showPowerNum():void
		{
			var len:int=_numAry.length;
			if(len == 0)
			{
				if(LayerManager.TipsLayer.contains(_powerSp)){
					LayerManager.TipsLayer.removeChild(_powerSp);
					UI.removeAllChilds(_powerSp);
				}
			}
			else
			{
				if(_isPlay == false)
				{
					_isPlay=true;
					
					var obj:Object=_numAry.pop();
					
					_resultTxt=ImageTextManager.Instance.createNum(obj.result,TypeImageText.Power_Big_Num);
					if(obj.offset < 0)
					{
						_offsetTxt=ImageTextManager.Instance.createNumWithPre(obj.offset,TypeImageText.Power_Red_Num,
							TypeImageText.Power_Minus,TypeImageText.Power_Plus);
					}
					else
					{
						_offsetTxt=ImageTextManager.Instance.createNumWithPre(obj.offset,TypeImageText.Power_Green_Num,
							TypeImageText.Power_Minus,TypeImageText.Power_Plus);
					}
					_powerSp.addChild(_powerWord);
					_powerWord.alpha=0;
					_powerWord.y=25;
					_powerWord.x=-15;
					
					_resultTxt.x=_powerWord.width;
					_resultTxt.y=25;
					_resultTxt.alpha=0;
					_powerSp.addChild(_resultTxt);
					
					_offsetTxt.x=_resultTxt.x+_resultTxt.width+5;
					_offsetTxt.y=25;
					_offsetTxt.alpha=0;
					_powerSp.addChild(_offsetTxt);
					
					initPos();
					LayerManager.TipsLayer.addChild(_powerSp);
					
					TweenLite.to(_powerWord,0.4,{alpha:1,y:0,ease:Cubic.easeOut});
					TweenLite.to(_resultTxt,0.4,{alpha:1,y:4,ease:Cubic.easeOut});
					TweenLite.to(_offsetTxt,0.6,{alpha:1,y:0,ease:Cubic.easeOut,onComplete:showPower});
				}
				else
				{
					hidePower();
				}
			}
		}
		
		protected function showPower():void
		{
//			_timerIndex=setTimeout(hidePower,1300);
//			_timerOutDict[{r:result,o:offset}]=index;
			TweenLite.to(_powerWord,0.4,{alpha:0,delay:1.2,y:-25});
			TweenLite.to(_resultTxt,0.4,{alpha:0,delay:1.2,y:-25});
			TweenLite.to(_offsetTxt,0.6,{alpha:0,delay:1.2,y:-35,onComplete:hidePower});
		}
		
		private function hidePower():void
		{
			if(LayerManager.TipsLayer.contains(_powerSp))
				LayerManager.TipsLayer.removeChild(_powerSp);
			if(_powerSp.numChildren > 0)
				UI.removeAllChilds(_powerSp);
			if(_resultTxt.numChildren > 0)
			{
				UI.removeAllChilds(_resultTxt);
//				_resultTxt=null;
			}
			if(_offsetTxt.numChildren > 0)
			{
				UI.removeAllChilds(_offsetTxt);
//				_offsetTxt=null;
			}
			TweenLite.killTweensOf(_powerWord);
			TweenLite.killTweensOf(_resultTxt);
			TweenLite.killTweensOf(_offsetTxt);
			
			_isPlay=false;
			showPowerNum();
		}
		//======================================================================
		//        event handler
		//======================================================================
		
		//======================================================================
		//        getter&setter
		//======================================================================
		
		public static function get instance():PowerNumManager
		{
			if(_instance == null) _instance=new PowerNumManager();
			return _instance;
		}

	}
} 