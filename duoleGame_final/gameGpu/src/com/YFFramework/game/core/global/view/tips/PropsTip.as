package com.YFFramework.game.core.global.view.tips
{
	/**
	 * @version 1.0.0
	 * creation time：2012-12-13 上午11:04:32
	 * 
	 */
	
	import com.YFFramework.core.center.manager.ResizeManager;
	import com.YFFramework.core.net.loader.image_swf.IconLoader;
	import com.YFFramework.core.proxy.StageProxy;
	import com.YFFramework.core.text.HTMLUtil;
	import com.YFFramework.core.utils.common.ClassInstance;
	import com.YFFramework.game.core.global.DataCenter;
	import com.YFFramework.game.core.global.TimeManager;
	import com.YFFramework.game.core.global.manager.PropsBasicManager;
	import com.YFFramework.game.core.global.manager.PropsDyManager;
	import com.YFFramework.game.core.global.model.PropsBasicVo;
	import com.YFFramework.game.core.global.model.PropsDyVo;
	import com.YFFramework.game.core.global.util.FilterConfig;
	import com.YFFramework.game.core.global.util.TypeProps;
	import com.YFFramework.game.core.module.ModuleManager;
	import com.YFFramework.game.core.module.bag.data.BagTimerManager;
	import com.dolo.common.GlobalPools;
	import com.dolo.common.ObjectPool;
	import com.dolo.ui.controls.IconImage;
	import com.dolo.ui.managers.UI;
	import com.dolo.ui.sets.Linkage;
	import com.dolo.ui.tools.LibraryCreat;
	import com.msg.enumdef.BindingType;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	public class PropsTip extends Sprite
	{
		//======================================================================
		//        const variable
		//======================================================================
		/** 文本区块和区块间的距离 */
		private const GAP_X:int=10;
		/** 一个文本区块内的行间距 */
		private const PARA_IN:int=2;
		private const TITLE_SIZE:int=14;
		/** 正文字大小 */
		private const FONT_SIZE:int=12;
		/** 行距 */
		private const LEADING:int=2;
		/** 文本框最宽宽度 */
		private const TXT_WIDTH:int=212;
		/** 正文文本格式 */
		private const FORMAT:TextFormat=new TextFormat('宋体',FONT_SIZE);
		/** tip总体宽度 */
		private const BG_WIDTH:int=GAP_X*2+TXT_WIDTH;
		/** iconBg的长宽尺寸 */		
		private const ICON_BG:int=53;
		
		private const COLOR_DARK_YELLOW:String='D6CC91';//暗黄色
		private const COLOR_RED:String='ff0000';//是大红色
		private const COLOR_LIGHT_YELLOW:String='fed100';//亮黄色
		private const COLOR_ORANGE:String='fe7e00';//橘色
		private const COLOR_GREEN:String='08df12';//绿色
		private const COLOR_BROWN:String='968664';//介于褐色和灰色之间
		private const COLOR_BLUE:String='009cff';//蓝色
		//======================================================================
		//        static variable
		//======================================================================
		
		//======================================================================
		//        variable
		//======================================================================
		/** 背景九宫格 */
		private var _bgMc:Sprite;
		/** 所有文本框的数组 */		
		private var _txtsAry:Array;
		/** 白线数组 */		
		private var _linesAry:Array;
		/** 道具图标 */
		private var _icon:IconImage;
		/** 背景下的边框 */
		private var _iconBg:Sprite;
//		private var _title:TextField;//名称
//		private var _txt1:TextField;//物品绑定、道具类型
//		private var _levelTxt:TextField;//等级
//		private var _txt2:TextField;//效果描述
//		private var _txt3:TextField;//道具简介、剩余时间、商店收购价、使用说明

		private var _template:PropsBasicVo;
		private var _props:PropsDyVo;
		
//		private var _line1:Bitmap;
//		private var _line2:Bitmap;
		
//		private var bgWidth:int=0;
//		private var _isDispose:Boolean = false;
		/** 聊天查询时，需要关闭按钮 */
		private var _closeBtn:SimpleButton;
		/** 商店绑定性（其独立于道具表） */
		private var _shopBind:int=0;
		
		private var args:Array;
		private static var _instance:PropsTip;
		//======================================================================
		//        constructor
		//======================================================================
		public function PropsTip()
		{	
		}
		
		private function initTip():void
		{
			_bgMc= TipUtil.tipBackgrounPool.getObject();
			_bgMc.width=BG_WIDTH;
			addChild(_bgMc);
			
			_icon=new IconImage();
			_txtsAry=[];
			_linesAry=[];
			
			this.addEventListener(Event.REMOVED_FROM_STAGE,dispose);
		}
		
		private function getTxt():TextField
		{
			var txt:TextField=GlobalPools.textFieldPool.getObject();
			txt.width=TXT_WIDTH;
			txt.multiline=true;
			txt.wordWrap=true;
			txt.filters=FilterConfig.Black_name_filter;
			txt.autoSize=TextFieldAutoSize.LEFT;
			txt.selectable=false;
			txt.mouseEnabled=false;
			txt.defaultTextFormat=FORMAT;
			_txtsAry.push(txt);
			return txt;
		}
		
		private function getLine():Bitmap
		{
			var line:Bitmap = GlobalPools.bitmapPool.getObject();
			line.bitmapData = LineBD.bitmapData;
			_linesAry.push(line);
			return line;
		}
		
		/** 排列一个文本和文本下的白横线，用于两个文本块之间需要视觉划分 */
		private function setTxtLineFormat(html:String,leading:int=LEADING):void
		{
			var txt:TextField=getTxt();
			var beforeLine:Bitmap=_linesAry[_linesAry.length-1];
			txt.htmlText=HTMLUtil.createLeadingFormat(html,leading);
			txt.x=GAP_X;
			txt.y=beforeLine.y+beforeLine.height+PARA_IN;
			addChild(txt);
			
			var afterLine:Bitmap=getLine();
			afterLine.x=(_bgMc.width-afterLine.width)/2;
			afterLine.y=txt.y+txt.height+PARA_IN;
			addChild(afterLine);
		}
		//======================================================================
		//        function
		//======================================================================
		private function onStageRender(e:Event):void
		{
			UI.stage.removeEventListener( Event.RENDER, onStageRender );
		}
		
		/**
		 * [0]：动态id;[1]:模板id;[2]指定propsDyVo;[3]是不是有关闭按钮,Boolean;[4]商店表里的绑定性
		 * 注意：【0】(【1】可以填也可以不填)和【2】是冲突的
		 * @param args 
		 * 
		 */		
		public function setTip(args:Array):void
		{	
			this.args=args;
			dispose();
			UI.stage.addEventListener( Event.RENDER, onStageRender);
			UI.stage.invalidate();
			initTip();
			
			var propsId:int=args[0];
			if(propsId > 0)
				_props=PropsDyManager.instance.getPropsInfo(propsId);
			
			var tempId:int=args[1];
			if(tempId > 0)
				_template=PropsBasicManager.Instance.getPropsBasicVo(tempId);
			
//			if(propsId != 0)
//				_obtainTime=PropsDyManager.instance.getPropsInfo(propsId).obtain_time;
			if(args[2] != null)
			{
				tempId = PropsDyVo(args[2]).templateId;
				_template=PropsBasicManager.Instance.getPropsBasicVo(tempId);
//				_obtainTime=(args[2] as PropsDyVo).obtain_time;
			}
			
			//专为发送到聊天准备，如果窗口变化，tip也要改变位置
			if(args[3])
			{
				_closeBtn = LibraryCreat.getDisplay(Linkage.windowCloseButton) as SimpleButton;
				_closeBtn.addEventListener(MouseEvent.CLICK,close);
				_closeBtn.useHandCursor = false;
				_closeBtn.scaleX=_closeBtn.scaleY=0.8
				_closeBtn.x = BG_WIDTH-_closeBtn.width;
				_closeBtn.y = 3;
				addChild(_closeBtn);
				ResizeManager.Instance.regFunc(resize);
				resize();
//				this.removeEventListener(Event.REMOVED_FROM_STAGE,dispose);
			}
//			else
//				this.addEventListener(Event.REMOVED_FROM_STAGE,dispose);
				
			_shopBind=args[4];
			
			setTitle();//名称			
			setIcon();//道具图标	
			setBindType();//绑定,类型
			setLevel();//使用等级
			
//			_line1.x=(BG_WIDTH-_line1.width)/2;
//			_line1.y=_levelTxt.y+_levelTxt.height+PARA_OUT;
			
			setDesc();//效果描述
			
//			_line2.x=(BG_WIDTH-_line2.width)/2;
//			if(_txt2.parent)
//			{	
//				_line2.y=_txt2.y+_txt2.height+PARA_OUT;
//			}
//			else
//			{
//				_line2.y=_levelTxt.y+_levelTxt.height+PARA_OUT;
//			}
			
			setOtherTxt();//道具简介，剩余时间，商店收购价，使用说明
			
//			_bgMc.height=_txt3.y + _txt3.height + GAP_X;
//			_bgMc.width=BG_WIDTH;
			if(_linesAry.length > 0)
				_linesAry.pop();
			_bgMc.height = _txtsAry[_txtsAry.length-1].y+_txtsAry[_txtsAry.length-1].height+GAP_X;
			_bgMc.height += 4;
		}
		
		public function resize():void{
			this.x = 200;
			this.y = StageProxy.Instance.viewRect.height-this.width;
		}
		
		public function dispose(event:Event = null):void
		{
//			if(_isDispose == true) return;
//			_isDispose = true;
			this.removeEventListener(Event.REMOVED_FROM_STAGE,dispose);
			
			_template = null;
			_props = null;
			
			for each(var line:Bitmap in _linesAry)
			{
				if(line.parent)
					line.parent.removeChild(line);
				GlobalPools.bitmapPool.returnObject(line);
				line=null;
			}
			for each(var txt:TextField in _txtsAry)
			{
				if(txt.parent)
					txt.parent.removeChild(txt);
				GlobalPools.textFieldPool.returnObject(txt);
				txt=null;
			}
//			UI.removeAllChilds(this);
//			textFieldPool.returnObject(_title);
//			textFieldPool.returnObject(_txt1);
//			textFieldPool.returnObject(_txt2);
//			textFieldPool.returnObject(_txt3);
//			textFieldPool.returnObject(_levelTxt);
//			TipUtil.tipBackgrounPool.returnObject(_bgMc);
			if(_bgMc && _bgMc.parent)
			{
				_bgMc.parent.removeChild(_bgMc);
				TipUtil.tipBackgrounPool.returnObject(_bgMc);
				_bgMc = null;
			}
//			GlobalPools.spritePool.returnObject(_icon);
//			GlobalPools.bitmapPool.returnObject(_line1);
//			GlobalPools.bitmapPool.returnObject(_line2);
//			_bgMc = null;
			if(_iconBg)
			{
				GlobalPools.spritePool.returnObject(_iconBg);
				_iconBg=null;
			}
			
			if(_icon && _icon.parent)
				_icon.parent.removeChild(_icon);
			if(_icon && _icon.hasOwnProperty("dispose"))
				_icon.dispose();
			_icon=null;
//			_title = null;
//			_txt1 = null;
//			_levelTxt = null;
//			_txt2 = null;
//			_txt3 = null;
//			_template = null;
//			_line1 = null;
//			_line2 = null;
			
			if(_closeBtn)
			{
//				_closeBtn.removeEventListener(MouseEvent.CLICK,close);
//				_closeBtn=null;
//				ResizeManager.Instance.delFunc(resize);
				if(_closeBtn.parent)
					_closeBtn.parent.removeChild(_closeBtn);
				_closeBtn.removeEventListener(MouseEvent.CLICK,close);
				_closeBtn=null;
				ResizeManager.Instance.delFunc(resize);
			}		

		}
		
//		private function get textFieldPool():ObjectPool
//		{
//			return GlobalPools.textFieldPool;
//		}
		//======================================================================
		//        private function
		//======================================================================
//		private function disposeContent():void
//		{
//			_template=null;
//			_levelTxt.text='';
//			_txt1.text='';
//			_txt2.text='';
//			_txt3.text='';
//		}
		
		private function setTitle():void
		{
			var color:String=TypeProps.getQualityColor(_template.quality);
			var html:String=createLineHtml(_template.name,color,TITLE_SIZE);
			var txt:TextField=getTxt();
			txt.htmlText=html;
			txt.x=GAP_X;
			txt.y=GAP_X;
			addChild(txt);
//			_title.htmlText=createLineHtml(_template.name,color,TITLE_SIZE);
			
//			_title.x=GAP_X;
//			_title.y=GAP_X;
			
		}
		
		private function setIcon():void
		{
			var txt:TextField=_txtsAry[_txtsAry.length-1];
			_iconBg=ClassInstance.getInstance('bagIconBg');
			_iconBg.x=GAP_X*1.5;
			_iconBg.y=txt.y+txt.height+7;
			addChild(_iconBg);
			
			_icon.url=PropsBasicManager.Instance.getURL(_template.template_id);
			_icon.x=GAP_X*1.5+4;//千万不要用_iconBg.x来加，因为很可能图片还没加载出来			
			_icon.y=_iconBg.y+4;
			addChild(_icon);
//			_icon.y=_title.y+_title.height+PARA_OUT;
		}
		
		/** 绑定,类型 */
		private function setBindType():void
		{
			var str:String="";
			var html:String='';
			var bind:int=0;
			
			if(_shopBind > 0)
				bind = _shopBind;
			else
			{
				if(_props)
					bind=_props.binding_type;
				else
					bind = _template.binding_type;
			}	
			
			if(bind == TypeProps.BIND_TYPE_NO)
				str = str = "物品未绑定";
			else
				str = "物品已绑定";
			
			html += createLineHtml(str,COLOR_LIGHT_YELLOW)+"<br>";

			html += createLineHtml("道具类型："+_template.show_type,COLOR_LIGHT_YELLOW);
			
			var txt:TextField=getTxt();
			txt.htmlText=createParagraphHtml(html,5);
			txt.x=ICON_BG+20;
			txt.y=_iconBg.y+5;
			addChild(txt);
			
//			_txt1.htmlText=createParagraphHtml(html,LEADING);
//			_txt1.x=GAP_X+43;//不能用icon来定位，因为加载慢的话位置就错了
//			_txt1.y=_title.y+_title.height+PARA_OUT;
			
		}
		
		/** 使用等级 */
		private function setLevel():void
		{	
			var html:String="";
			
			if(DataCenter.Instance.roleSelfVo.roleDyVo.level >= _template.level)
				html += createLineHtml("使用等级："+_template.level.toString(),COLOR_DARK_YELLOW);
			else
				html += createLineHtml("使用等级："+_template.level.toString(),COLOR_RED);
			
			var txt:TextField=getTxt();
			txt.htmlText=html;
			txt.x=GAP_X;
			txt.y=_txtsAry[_txtsAry.length-2].y+_txtsAry[_txtsAry.length-2].height+GAP_X+3;
			addChild(txt);
			
			var line:Bitmap=getLine();
			line.x=(BG_WIDTH-line.width)/2;
			line.y=txt.y+txt.height+PARA_IN;
			addChild(line);
//			setTxtLineFormat(html);
//			_levelTxt.htmlText=createParagraphHtml(str,LEADING);
			
//			_levelTxt.x=GAP_X;
//			_levelTxt.y=_txt1.y+_txt1.height+PARA_OUT+2;
		}
		
		/** 效果说明 */
		private function setDesc():void
		{
			if(_template.effect_desc != '')
			{
				var html:String=createLineHtml(_template.effect_desc,COLOR_BLUE);
				setTxtLineFormat(html);
			}
		}
		
		//道具简介，剩余时间，商店收购价，使用说明
		private function setOtherTxt():void
		{
			var html:String='';
			
			if(_template.describe != '')//道具简介不为空，有时候sb策划啥都不配
				html += createLineHtml(_template.describe,COLOR_DARK_YELLOW)+"<br>";
			
			html += setTime();
			
			//还要做商店界面是否打开的判断
			if(ModuleManager.moduleShop.isNPCShopOpened == false || _template.sell_price == -1)
				html += "";
			else
				html += createLineHtml("商店收购价："+_template.sell_price.toString()+"银锭",COLOR_ORANGE)+"<br>";	
			
			if(_template.use_desc != '')
				html += createLineHtml(_template.use_desc,COLOR_DARK_YELLOW)+"<br>";
			
			html = html.slice(0,html.length-4);
			setTxtLineFormat(html);
			
//			_txt3.htmlText=createParagraphHtml(html,LEADING);
			
//			_txt3.x=GAP_X;
//			_txt3.y=_line2.y+_line2.height+PARA_OUT;
			
		}
		
		private function setTime():String
		{
			if(_template.remain_time > 0 && _props && _props.obtain_time > 0){
				var time:Number=BagTimerManager.instance.getPassTime(TypeProps.ITEM_TYPE_PROPS,_props.propsId);
				var str:String=TimeManager.getTimeFormat2(time);
				return createLineHtml("剩余时间："+str,COLOR_GREEN)+"<br>";
			}
				return "";
		}
		
		private function createLineHtml(str:String,color:String,size:int=FONT_SIZE):String
		{
			return HTMLUtil.createHtmlText(str,size,color,'宋体');
		}
		private function createParagraphHtml(str:String,leading:int):String
		{
			var html:String=HTMLUtil.createLeadingFormat(str,leading);
			return html;
		}
		
		//======================================================================
		//        event handler
		//======================================================================
		private function close(e:MouseEvent):void
		{
//			disposeContent();
//			this.parent.removeChild(this);
			dispose();
		}

		public static function get instance():PropsTip
		{
			if(_instance == null)
				_instance=new PropsTip();
			return _instance;
		}

		//======================================================================
		//        getter&setter
		//======================================================================
		
		
	}
} 