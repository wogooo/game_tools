package com.YFFramework.game.core.global.view.tips
{
	/**
	 * @author zhoujun
	 * @E-mail: 214501728@qq.com
	 * @version 1.0.0
	 * creation time：2012-12-4 下午07:45:53
	 * 
	 */
	
	import com.YFFramework.core.net.loader.image_swf.IconLoader;
	import com.YFFramework.core.text.HTMLUtil;
	import com.YFFramework.game.core.global.manager.SkillBasicManager;
	import com.YFFramework.game.core.global.model.SkillBasicVo;
	import com.YFFramework.game.core.global.model.TypeSkill;
	import com.YFFramework.game.core.global.util.FilterConfig;
	import com.YFFramework.game.core.global.util.TypeProps;
	import com.dolo.common.GlobalPools;
	import com.dolo.ui.managers.UI;
	
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	public class SkillTip extends Sprite
	{
		//======================================================================
		//        property
		//======================================================================
		private const TEXTFORMAT:TextFormat=new TextFormat('_san',12);
		private const GAP_X:int=10;
		private const PARA_OUT:int=2;
		private const TITLE_SIZE:int=15;
		private const FONT_SIZE:int=12;
		private const LEADING:int=2;
		private const TXT_WIDTH:int=212;
		
		private var _mc:Sprite;
		private var _curSkillInfo:SkillBasicVo;
		private var _nextSkillInfo:SkillBasicVo;
		private var _title:TextField;
		private var _txt1:TextField;//技能等级，技能类型
		private var _txt2:TextField;//攻击距离，消耗魔法，冷却时间，效果说明
		private var _txt3:TextField;//下一等级：攻击距离，消耗魔法，冷却时间，效果说明
		private var _icon:Sprite;
		private var _line1:Bitmap;
		private var _line2:Bitmap;
		private var bgWidth:int=0;
		private var skillId:int;
		private var skillLevel:int;
		private var isSimple:Boolean=false;
		private var _isDispose:Boolean = false;
		
		public function dispose(event:Event=null):void
		{
			if(_isDispose == true) return;
			_isDispose = true;
			UI.removeAllChilds(this);
			TipUtil.tipBackgrounPool.returnObject(_mc);
			GlobalPools.textFieldPool.returnObject(_title);
			GlobalPools.textFieldPool.returnObject(_txt1);
			GlobalPools.textFieldPool.returnObject(_txt2);
			GlobalPools.textFieldPool.returnObject(_txt3);
			GlobalPools.bitmapPool.returnObject(_line1);
			GlobalPools.bitmapPool.returnObject(_line2);
			GlobalPools.spritePool.returnObject(_icon);
			_mc = null;
			_curSkillInfo = null;
			_nextSkillInfo = null;
			_title = null;
			_txt1 = null;
			_txt2 = null;
			_txt3 = null;
			_icon = null;
			_line1 = null;
			_line2 = null;
		}
		
		public function SkillTip()
		{
			_mc=TipUtil.tipBackgrounPool.getObject();
			addChild(_mc);
			
			_line1 = GlobalPools.bitmapPool.getObject();
			_line1.bitmapData = LineBD.bitmapData;
			
			_line2 = GlobalPools.bitmapPool.getObject();
			_line2.bitmapData =  LineBD.bitmapData;
			
			_title=GlobalPools.textFieldPool.getObject();
			_title.width=TXT_WIDTH;
			_title.multiline=false;
			_title.wordWrap=false;
			_title.filters=FilterConfig.Black_name_filter;
			_title.autoSize=TextFieldAutoSize.CENTER;
			addChild(_title);
			_title.x=GAP_X;
			_title.y=GAP_X;
			
			_icon= GlobalPools.spritePool.getObject();
			addChild(_icon);
			
			_txt1=GlobalPools.textFieldPool.getObject();
			_txt1.width=200;
			_txt1.multiline=true;
			_txt1.wordWrap=true;
			_txt1.filters=FilterConfig.Black_name_filter;
			_txt1.autoSize=TextFieldAutoSize.CENTER;
			_txt1.defaultTextFormat=TEXTFORMAT;
			addChild(_txt1);
			
			_txt2=GlobalPools.textFieldPool.getObject();
			_txt2.width=TXT_WIDTH;
			_txt2.multiline=true;
			_txt2.wordWrap=true;
			_txt2.filters=FilterConfig.Black_name_filter;
			_txt2.autoSize=TextFieldAutoSize.CENTER;
			_txt2.defaultTextFormat=TEXTFORMAT;
			addChild(_txt2);
			
			_txt3=GlobalPools.textFieldPool.getObject();
			_txt3.width=TXT_WIDTH;
			_txt3.multiline=true;
			_txt3.wordWrap=true;
			_txt3.filters=FilterConfig.Black_name_filter;
			_txt3.autoSize=TextFieldAutoSize.CENTER;
			_txt3.defaultTextFormat=TEXTFORMAT;
			
			bgWidth=GAP_X*2+TXT_WIDTH;
			this.addEventListener(Event.REMOVED_FROM_STAGE,dispose);
		}	
		
		//======================================================================
		//        public function
		//======================================================================
		/**
		 * [0]id,[1]等级,[2]是否是简略tip 
		 * @param args
		 * 
		 */		
		public function setTip(args:Array):void
		{
			disposeContent();
			
			skillId=args[0];
			skillLevel=args[1];
			
			_curSkillInfo=SkillBasicManager.Instance.getSkillBasicVo(skillId,skillLevel)
			isSimple=args[2];
			
			setTitle();//标题
			
			setIcon();
			
			setTxt1();//技能等级，技能类型
			
			_line1.x=(bgWidth-_line1.width)/2;
			_line1.y=_txt1.y+_txt1.height+GAP_X;
			addChild(_line1);
			
			setTxt2();//攻击距离，消耗魔法，冷却时间，效果说明
			
			_nextSkillInfo=SkillBasicManager.Instance.getSkillBasicVo(skillId,skillLevel+1);
			if(isSimple == false && _nextSkillInfo)
			{
				_line2.x=(bgWidth-_line2.width)/2;
				_line2.y=_txt2.y+_txt2.height+PARA_OUT;
				addChild(_line2);
				
				setTxt3();//下一等级：攻击距离，消耗魔法，冷却时间，效果说明
				
				_mc.height=_txt3.y + _txt3.height +GAP_X;
			}
			else
				_mc.height=_txt2.y + _txt2.height +GAP_X;
			
			_mc.width=bgWidth;
			
		}
		
		//======================================================================
		//        private function
		//======================================================================
		private function setTitle():void
		{
			if(_curSkillInfo.skill_big_category == TypeSkill.BigCategory_Pet)
			{
				var color:String=TypeProps.getQualityColor(_curSkillInfo.quality);
				_title.htmlText=createLineHtml(_curSkillInfo.name,color,TITLE_SIZE);
			}
			else
				_title.htmlText=createLineHtml(_curSkillInfo.name,'f0ff00',TITLE_SIZE);
			_title.x=GAP_X;
			_title.y=GAP_X;
			
		}
	
		private function setIcon():void
		{		
			IconLoader.initLoader(SkillBasicManager.Instance.getURL(skillId,skillLevel),_icon);
			
			_icon.x=GAP_X;
			_icon.y=_title.y+_title.height+PARA_OUT;
			addChild(_icon);
			
		}
		
		/**
		 * 技能等级，技能类型
		 * 
		 */		
		private function setTxt1():void
		{
			var html:String='';
			
			if(_curSkillInfo)
				html = createLineHtml("技能等级："+_curSkillInfo.skill_level,'d6cd93')+"<br>";
			else
				html = createLineHtml("技能等级：0",'d6cd93')+"<br>";
			
			html += createLineHtml("技能类型："+getSkillUseType(_curSkillInfo.use_type),'d6cd93');
			
			_txt1.htmlText=HTMLUtil.createLeadingFormat(html,LEADING);
			_txt1.x=_icon.x+40+PARA_OUT;
			_txt1.y=_icon.y-3;
			
		}
		
		private function setTxt2():void
		{
			var html:String='';
			
			if(_curSkillInfo)
			{
				html = createLineHtml("攻击距离："+_curSkillInfo.use_distance,'01ca1b')+"<br>";
				
				var str:String='';
				if(_curSkillInfo.consume_type == 2)//消耗魔法
				{
					html += createLineHtml("消耗魔法："+_curSkillInfo.consume_value.toString(),'01ca1b')+"<br>";
				}
				
				html += createLineHtml("冷却时间："+(_curSkillInfo.cooldown_time)/1000+"秒",'01ca1b')+"<br>";
				
				html += createLineHtml(_curSkillInfo.effect_desc,'d6cd93');//效果说明
			}
			else
				html += createLineHtml("尚未学习",'01ca1b');//尚未学习
			
			_txt2.htmlText=createParagraphHtml(html,LEADING);
			_txt2.x= GAP_X;
			_txt2.y=_line1.y + _line1.height + PARA_OUT;
		}
		
		/**
		 * 下一等级：攻击距离，消耗魔法，冷却时间，效果说明
		 * 
		 */		
		private function setTxt3():void
		{
			var html:String=createLineHtml("下一等级：",'f0ff00')+"<br>";
			
			html += createLineHtml("攻击距离："+_nextSkillInfo.use_distance,'01ca1b')+"<br>";
			
			var str:String='';
			if(_curSkillInfo.consume_type == 2)//消耗魔法
			{
				html += createLineHtml("消耗魔法："+_nextSkillInfo.consume_value.toString(),'01ca1b')+"<br>";
			}		
			
			html += createLineHtml("冷却时间："+(_nextSkillInfo.cooldown_time)/1000+"秒",'01ca1b')+"<br>";
			
			html += createLineHtml(_nextSkillInfo.effect_desc,'d6cd93');
			
			_txt3.htmlText=createParagraphHtml(html,LEADING);
			_txt3.x= GAP_X;
			_txt3.y=_line2.y + _line2.height + PARA_OUT;
			addChild(_txt3);
		}
		
		private function createLineHtml(str:String,color:String,size:int=FONT_SIZE):String
		{
			return HTMLUtil.createHtmlText(str,size,color);
		}
		
		private function disposeContent():void
		{
			if(_icon.numChildren)
			{
				_icon.removeChildAt(0);
			}
			if(_line1.parent)
				removeChild(_line1);
			if(_line2.parent)
				removeChild(_line2);
			if(_txt3.parent)
				removeChild(_txt3);
		}
		
		private function getSkillUseType(useType:int):String
		{
			var str:String='';
			if(useType != 4)
				str="主动技能";
			else 
				str="被动技能";
			return str;
		}
		
		private function createParagraphHtml(str:String,leading:int):String
		{
			var html:String="<textformat leading=\'" + leading + "\'><p indent='10' align='left'>"+str+"</p></textformat>";
			return html;
		}
		//======================================================================
		//        event handler
		//======================================================================
		
		//======================================================================
		//        getter&setter
		//======================================================================
		
		
	}
} 