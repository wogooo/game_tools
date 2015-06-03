package com.YFFramework.game.core.global.view.tips
{
	/**
	 * @author jina;
	 * @version 1.0.0
	 * creation time：2013-12-31 下午3:48:19
	 */
	import com.YFFramework.core.text.HTMLUtil;
	import com.YFFramework.game.core.global.DataCenter;
	import com.YFFramework.game.core.global.TimeManager;
	import com.YFFramework.game.core.global.manager.SkillBasicManager;
	import com.YFFramework.game.core.global.model.BuffBasicVo;
	import com.YFFramework.game.core.global.model.SkillBasicVo;
	import com.YFFramework.game.core.global.util.FilterConfig;
	import com.YFFramework.game.core.module.mapScence.model.BuffDyVo;
	import com.dolo.common.GlobalPools;
	import com.dolo.ui.managers.UI;
	import com.netease.protobuf.TextFormat;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.utils.getTimer;
	
	public class BuffTip extends Sprite
	{
		//======================================================================
		//       public property
		//======================================================================
		
		//======================================================================
		//       private property
		//======================================================================
		/** 正文文本格式 */
//		private const FORMAT:TextFormat=new TextFormat('宋体',FONT_SIZE);
		/** 文本框最宽宽度 */
		private const TXT_WIDTH:int=160;
		/** tip总体宽度 */
		private const BG_WIDTH:int=TXT_WIDTH+GAP_X*2;
		/** buff名称字大小 */
		private const TITLE_SIZE:int=15;
		/** 正文字大小 */
		private const FONT_SIZE:int=13;
		/** 文本区块和区块间的距离 */
		private const GAP_X:int=8;
		/** buff名称文字颜色 */
		private const TITLE_COLOR:String='f0ff00';
		/** buff等级文字颜色 */
//		private const LEVEL_COLOR:String='01ca1b';
		/** buff效果说明颜色 */
		private const DESC_COLOR:String='d6cd93';
		/** buff剩余时间颜色 */
		private const TIME_COLOR:String='01ca1b';
		
		/** 背景九宫格 */
		private var _bgMc:Sprite;
		private var _txt:TextField;
		
		private var _buffBsVo:BuffBasicVo;
		private var _buffDyVo:BuffDyVo;
		private var _skillBsVo:SkillBasicVo;
		//======================================================================
		//        constructor
		//======================================================================
		
		public function BuffTip()
		{
		}
		
		//======================================================================
		//        public function
		//======================================================================
		/**
		 * 初始化buffTip
		 * @param buffBsVo
		 * @param buffDyVo 内含buff的开始时间
		 * 
		 */		
		public function setTip(buffBsVo:BuffBasicVo,buffDyVo:BuffDyVo):void
		{
			_buffBsVo=buffBsVo;
			_buffDyVo=buffDyVo;
			_skillBsVo=SkillBasicManager.Instance.getSkillBasicVo(_buffDyVo.skill_id,_buffDyVo.skill_level);
			
			dispose();
			UI.stage.addEventListener( Event.RENDER, onStageRender);
			UI.stage.invalidate();
			initTip();
			
			getTxt();
			setBuffTxt();
			
			_bgMc.height = _txt.height+GAP_X*2;
		}
		
		public function dispose(event:Event = null):void
		{
			this.removeEventListener(Event.REMOVED_FROM_STAGE,dispose);
			
			if(_txt)
			{
				GlobalPools.textFieldPool.returnObject(_txt);
				_txt=null;
			}
			
			if(_bgMc && _bgMc.parent)
			{
				_bgMc.parent.removeChild(_bgMc);
				TipUtil.tipBackgrounPool.returnObject(_bgMc);
				_bgMc = null;
			}
		}
		//======================================================================
		//        private function
		//======================================================================
		private function getTxt():void
		{
			_txt=GlobalPools.textFieldPool.getObject();
			_txt.width=TXT_WIDTH;
			_txt.multiline=true;
			_txt.wordWrap=true;
			_txt.filters=FilterConfig.Black_name_filter;
			_txt.autoSize=TextFieldAutoSize.LEFT;
			_txt.selectable=false;
			_txt.mouseEnabled=false;
//			txt.defaultTextFormat=FORMAT;
			addChild(_txt);
		}
		
		private function initTip():void
		{
			_bgMc= TipUtil.tipBackgrounPool.getObject();
			_bgMc.width=BG_WIDTH;
			addChild(_bgMc);
			
			this.addEventListener(Event.REMOVED_FROM_STAGE,dispose);
		}
		
		private function setBuffTxt():void
		{
			var html:String='';
			//名称			
			html=HTMLUtil.createHtmlText(_buffBsVo.name,TITLE_SIZE,TITLE_COLOR)+"<br>";			
			//效果描述
			html += HTMLUtil.createHtmlText(_buffBsVo.description,FONT_SIZE,DESC_COLOR)+"<br>";		
			//剩余时间
			var startTime:Number=_buffDyVo.time;//buff开始时间
			var keepTime:Number=_skillBsVo.buff_time;//buff持续时间
			var nowTime:Number=getTimer();//现在的时间
			var remainTime:Number=(startTime+keepTime)-nowTime;
			if(remainTime > 0)
			{
				html += getTime(remainTime);
			}
			html=HTMLUtil.createLeadingFormat(html,2);
			_txt.x=GAP_X;
			_txt.y=GAP_X;
			_txt.htmlText=html;
		}
		
		private function getTime(time:Number):String
		{
			var str:String=TimeManager.getTimeFormat2(time,false);
			var html:String=HTMLUtil.createHtmlText("剩余时间："+str,FONT_SIZE,TIME_COLOR)+"<br>";
			return html;
		}
		//======================================================================
		//        event handler
		//======================================================================
		private function onStageRender(e:Event):void
		{
			UI.stage.removeEventListener( Event.RENDER, onStageRender );
		}
		//======================================================================
		//        getter&setter
		//======================================================================
		
		
	}
} 