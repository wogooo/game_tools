package com.YFFramework.game.core.module.raid.view
{
	import com.YFFramework.core.center.manager.ResizeManager;
	import com.YFFramework.core.proxy.StageProxy;
	import com.YFFramework.core.utils.HashMap;
	import com.YFFramework.core.utils.common.ClassInstance;
	import com.YFFramework.game.core.global.TimeManager;
	import com.YFFramework.game.core.global.view.tips.RaidTip;
	import com.YFFramework.game.core.global.view.tips.TipUtil;
	import com.YFFramework.game.ui.layer.LayerManager;
	import com.dolo.ui.tools.Xtip;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.utils.clearInterval;
	import flash.utils.setInterval;

	/**
	 * @version 1.0.0
	 * creation time：2013-6-27 上午11:22:24
	 */
	public class CloseSprite extends Sprite{
		
		private var _mc:MovieClip;
		private var _raidsArr:Array=new Array();
		private var _timeId:int=-1;
		
		public function CloseSprite(){
			super();
			this.y = 120;
			LayerManager.UILayer.addChild(this);
			ResizeManager.Instance.regFunc(resize);
			resize();
			Xtip.registerLinkTip(this,RaidTip,TipUtil.raidTipInitFunc,_raidsArr);
		}
		
		public function addClose():void{
			if(_mc==null){
				_mc = ClassInstance.getInstance("CloseRaid");
				this.addChild(_mc);
				Xtip.registerLinkTip(this,RaidTip,TipUtil.raidTipInitFunc,_raidsArr);
			}
		}
		
		public function addEntry(raidId:int,raidTime:int):void{
			if(containsRaid(raidId)){
				var len:int = _raidsArr.length;
				for(var i:int=0;i<len;i++){
					if(_raidsArr[i].raidId==raidId){
						_raidsArr[i].raidTime=raidTime;
						break;
					}
				}
			}else{
				var obj:Object = new Object();
				obj.raidId = raidId;
				obj.raidTime = raidTime;
				_raidsArr.push(obj);
			}
			if(_timeId==-1)	_timeId = setInterval(countDown,1000);
		}
		
		private function containsRaid(raidId:int):Boolean{
			var len:int = _raidsArr.length;
			for(var i:int=0;i<len;i++){
				if(_raidsArr[i].raidId==raidId)	return true;
			}
			return false;
		}
		
		public function removeEntry(raidId:int):void{
			for(var i:int=0;i<_raidsArr.length;i++){
				if(_raidsArr[i].raidId==raidId){
					_raidsArr.splice(i,1);
					break;
				}
			}
			if(_raidsArr.length==0){
				Xtip.clearLinkTip(this,TipUtil.raidTipInitFunc);
				if(_mc && this.contains(_mc))	this.removeChild(_mc);
				_mc=null;
				clearInterval(_timeId);
				_timeId=-1;
			}
		}
		
		private function countDown():void{
			var len:int=_raidsArr.length;
			for(var i:int=0;i<len;i++){
				if(_raidsArr[i]){
					_raidsArr[i].raidTime--;
					if(_raidsArr[i].raidTime==0){
						_raidsArr.splice(i,1);
						i--;
					}
				}
			}
		}
		
		/**窗口大小改变
		 */		
		private function resize():void{
			this.x = StageProxy.Instance.viewRect.width -400;
			this.y=120;
		}
	}
} 