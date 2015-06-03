package com.YFFramework.game.core.module.gameView.view
{
	import com.YFFramework.core.net.loader.image_swf.IconLoader;
	import com.YFFramework.core.ui.abs.AbsView;
	import com.YFFramework.game.core.global.TimeManager;
	import com.YFFramework.game.core.global.manager.BuffBasicManager;
	import com.YFFramework.game.core.global.manager.SkillBasicManager;
	import com.YFFramework.game.core.global.model.BuffBasicVo;
	import com.YFFramework.game.core.global.model.SkillBasicVo;
	import com.YFFramework.game.core.global.util.TypeProps;
	import com.YFFramework.game.core.global.view.tips.BuffTip;
	import com.YFFramework.game.core.global.view.tips.TipUtil;
	import com.YFFramework.game.core.module.mapScence.model.BuffDyVo;
	import com.dolo.ui.tools.Xtip;
	
	import flash.events.Event;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;

	/**
	 * @version 1.0.0
	 * creation time：2013-5-10 下午1:40:53
	 * 
	 */
	public class BuffIcon extends AbsView{
		
		private var _text:TextField;
		private var _time:Number;
		
		public function BuffIcon(buffId:int,vo:BuffBasicVo,dyVo:BuffDyVo){
			super(true);
			IconLoader.initLoader(BuffBasicManager.Instance.getBuffIconURL(buffId),this);
			var skillVo:SkillBasicVo=SkillBasicManager.Instance.getSkillBasicVo(dyVo.skill_id,dyVo.skill_level);
			_time = skillVo.buff_time+dyVo.time;
			_text = new TextField();
			_text.selectable=false;
			_text.mouseEnabled=false;
			_text.y=20;
			_text.textColor=TypeProps.Cffef95;
			_text.autoSize=TextFieldAutoSize.LEFT;
			this.addChild(_text);
			Xtip.registerLinkTip(this,BuffTip,TipUtil.buffTipInitFunc,vo,dyVo);
		}
		
		/**
		 * 重新设置buff的持续时间
		 * @param vo
		 * 
		 */		
		public function resetTime(vo:BuffDyVo):void
		{
			var skill:SkillBasicVo=SkillBasicManager.Instance.getSkillBasicVo(vo.skill_id,vo.skill_level);
			_time=skill.buff_time+vo.time;
		}
		
		/**
		 * 刷新buff显示的时间
		 * @param t
		 * 
		 */		
		public function updateTime(t:Number):void{
			_text.text = TimeManager.getTimeFormat4(_time-t);
		}
		
		override public function dispose(e:Event=null):void{
			while(this.numChildren>0)	this.removeChildAt(0);
			_text = null;
			Xtip.clearLinkTip(this,TipUtil.buffTipInitFunc);
		}
	}
} 