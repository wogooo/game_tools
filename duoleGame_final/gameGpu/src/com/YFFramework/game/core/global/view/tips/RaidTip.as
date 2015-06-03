package com.YFFramework.game.core.global.view.tips
{
	import com.YFFramework.game.core.global.TimeManager;
	import com.YFFramework.game.core.global.util.TypeProps;
	import com.YFFramework.game.core.module.raid.manager.RaidManager;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.text.TextField;

	/**
	 * @version 1.0.0
	 * creation time：2013-6-28 下午5:50:35
	 */
	public class RaidTip extends Sprite{
		
		private var _sp:Sprite;
		private var _text:TextField;
		
		public function RaidTip(){
			_sp=TipUtil.tipBackgrounPool.getObject();
			addChild(_sp);
			
			_text = new TextField();
			_text.x=10;
			_text.width=500;
			_text.textColor=TypeProps.COLOR_WHITE;
			this.addChild(_text);
		}
		
		public function setTip(raidArr:Array):void{
			_text.text = "";
			var len:int=raidArr.length;
			for(var i:int=0;i<len;i++){
				_text.appendText("["+RaidManager.Instance.getRaidVo(raidArr[i].raidId).raidName+"],"+TimeManager.getTimeStrFromSec(raidArr[i].raidTime)+"后关闭"+"\n");
			}
			_text.width=_text.textWidth+30;
			_sp.width = _text.width+40;
			_sp.height = _text.height+40;
		}
	}
} 