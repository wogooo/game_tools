package com.YFFramework.game.core.global.view.tips
{
	/**
	 * @version 1.0.0
	 * creation time：2012-12-23 上午11:13:20
	 * 没想到六个月后又来大改T_T
	 */
	import com.YFFramework.core.center.manager.ResizeManager;
	import com.YFFramework.core.proxy.StageProxy;
	import com.YFFramework.core.text.HTMLUtil;
	import com.YFFramework.core.utils.HashMap;
	import com.YFFramework.core.utils.common.ClassInstance;
	import com.YFFramework.game.core.global.DataCenter;
	import com.YFFramework.game.core.global.TimeManager;
	import com.YFFramework.game.core.global.manager.CharacterDyManager;
	import com.YFFramework.game.core.global.manager.EquipBasicManager;
	import com.YFFramework.game.core.global.manager.EquipDyManager;
	import com.YFFramework.game.core.global.manager.EquipSuitBasicManager;
	import com.YFFramework.game.core.global.manager.PropsBasicManager;
	import com.YFFramework.game.core.global.manager.StrRatioManager;
	import com.YFFramework.game.core.global.model.EquipBasicVo;
	import com.YFFramework.game.core.global.model.EquipDyVo;
	import com.YFFramework.game.core.global.model.EquipSuitBasicVo;
	import com.YFFramework.game.core.global.model.PropsBasicVo;
	import com.YFFramework.game.core.global.util.FilterConfig;
	import com.YFFramework.game.core.global.util.TypeProps;
	import com.YFFramework.game.core.module.ModuleManager;
	import com.YFFramework.game.core.module.bag.data.BagTimerManager;
	import com.YFFramework.game.core.module.forge.data.ForgeSource;
	import com.YFFramework.game.core.module.mapScence.world.model.type.TypeRole;
	import com.YFFramework.game.gameConfig.URLTool;
	import com.dolo.common.GlobalPools;
	import com.dolo.ui.controls.IconImage;
	import com.dolo.ui.managers.UI;
	import com.dolo.ui.sets.Linkage;
	import com.dolo.ui.tools.LibraryCreat;
	
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;

	public class EquipTip extends Sprite
	{		
		/** 文本区块和区块间的距离 */		
		private const GAP_X:int=10;
		/** 一个文本区块内的行间距 */		
		private const PARA_IN:int=2;
		/** 标题字大小 */
		private const TITLE_SIZE:int=14;
		/** 正文字大小 */
		private const FONT_SIZE:int=12;
		/** 行距 */		
		private const LEADING:int=2;
		/** 文本框最宽宽度 */
		private const TXT_WIDTH:int=212;
		/** 缩进 */		
		private const INDENT:int=15;
		/** 防御宝石缩进 */
		private const GEM_INDENT:int=30;
		/** 宝石图标间距 */
		private const GEM_ICON_WIDTH:int=22;
		/** tip总体宽度 */
		private const BG_WIDTH:int=GAP_X*2+TXT_WIDTH;
		/** 正文文本格式 */
		private const FORMAT:TextFormat=new TextFormat('宋体',FONT_SIZE);
		
		/** 装备评分 */		
		private const COLOR_POINT:String='fcc51f';//金色
		/** “基础属性”“附加属性”“装备镶嵌”三个题目 */		
		private const COLOR_TITLE:String='ec8c38';
		/** 装备基本属性 */		
		private const COLOR_BASE_ATTRS:String='f3fbfa';
		private const COLOR_RED:String='ff0000';//是大红色
//		private const COLOR_LIGHT_YELLOW:String='fed100';//亮黄色
//		private const COLOR_ORANGE:String='fe7e00';
//		private const COLOR_GREEN:String='08df12';
//		private const COLOR_BROWN:String='968664';
		private const COLOR_APP_ATTRS:String='8cf213';
		private const COLOR_DEFAULT:String='fff0b6';
		
		/** 背景九宫格 */		
		private var _bgMc:Sprite;
		private var _template:EquipBasicVo;
		private var _equip:EquipDyVo;
		private var _inCharacter:Boolean=false;
		private var _holesContainer:Sprite;
		/** 背景下的边框 */
		private var _iconBg:Sprite;
		/** 所有文本框的数组 */		
		private var _txtsAry:Array;
		/** 所有图标的数组 */		
		private var _iconsAry:Array;
		/** "已装备"的文字 */		
		private var _equipedSp:Sprite;
		/** 白线数组 */		
		private var _linesAry:Array;
		
		private var _attrs:Array;
		private var _gemsArr:Array;
		/** 商店绑定性（其独立于装备表） */
		private var _shopBind:int=0;
		/** 聊天查询时，需要关闭按钮 */
		private var _closeBtn:SimpleButton;
		
		private static var _instance:EquipTip;
		
		private var args:Array;
		public function EquipTip()
		{
		}

		public function dispose(e:Event=null):void
		{			
			this.removeEventListener(Event.REMOVED_FROM_STAGE,dispose);
			
			_template = null;
			_equip = null;
			
			for each(var icon:IconImage in _iconsAry)
			{
				if(icon.parent)
					icon.parent.removeChild(icon);
				if(icon.hasOwnProperty("dispose"))
					icon.dispose();
				icon=null;
			}
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
			_txtsAry=null;
			_iconsAry=null;
			_linesAry=null;
			
			if(_holesContainer)
			{
				while(_holesContainer.numChildren >0)
				{
					var child:DisplayObject=_holesContainer.removeChildAt(0);
					GlobalPools.spritePool.returnObject(child);
					child=null;
				}
				GlobalPools.spritePool.returnObject(_holesContainer);
				_holesContainer=null;
			}			
			
			if(_iconBg)
			{
				GlobalPools.spritePool.returnObject(_iconBg);
				_iconBg=null;
			}		
			
			if(_equipedSp)
			{
				TipUtil.hasOnPool.returnObject(_equipedSp);
				_equipedSp = null;
			}	
			
			_attrs = null;
			_gemsArr = null;		
			
			if(_closeBtn)
			{
				if(_closeBtn.parent)
					_closeBtn.parent.removeChild(_closeBtn);
				_closeBtn.removeEventListener(MouseEvent.CLICK,close);
				_closeBtn=null;
				ResizeManager.Instance.delFunc(resize);	
			}
			
			if(_bgMc && _bgMc.parent)
			{
				_bgMc.parent.removeChild(_bgMc);
				TipUtil.tipBackgrounPool.returnObject(_bgMc);
				_bgMc = null;
			}
		}
		
		private function initTip():void
		{
			_bgMc= TipUtil.tipBackgrounPool.getObject();
			_bgMc.width=BG_WIDTH;
			addChild(_bgMc);

			_equipedSp= TipUtil.hasOnPool.getObject();
			_txtsAry=[];
			_iconsAry=[];
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
		
		private function getIcon():IconImage
		{
			var icon:IconImage=new IconImage();
			_iconsAry.push(icon);
			return icon;
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
		
		private function onStageRender(e:Event):void
		{
			UI.stage.removeEventListener( Event.RENDER, onStageRender );
		}
		
		/**
		 * args->[0]动态id,[1]模板id,[2]是否在角色面板,[3]是否显示已装备文字,[4]不在显示列表的equipDyVo,[5]有没有关闭按钮（Boolean）,
		 * 		[6]商店表的绑定性
		 * 注意注意：【0】(【1】可以填也可以不填)和【4】是冲突的
		 * @param args
		 * 
		 */		
		public function setTip(args:Array):void
		{
			this.args=args;
			dispose();
			UI.stage.addEventListener( Event.RENDER, onStageRender );
			UI.stage.invalidate();
			initTip();
			
			if(args[0] != 0)
				_equip=EquipDyManager.instance.getEquipInfo(args[0]);
			else if(args[4] != null)
				_equip=args[4] as EquipDyVo;
			else
				_equip = null;
			
			if(args[1] > 0)
				_template=EquipBasicManager.Instance.getEquipBasicVo(args[1]);
			else
				_template=EquipBasicManager.Instance.getEquipBasicVo(_equip.template_id);
			
			_inCharacter=args[2];
			
			if(args[3])
			{
				addChild(_equipedSp);
				_equipedSp.x=155;
				_equipedSp.y=GAP_X;
			}
			
			//专为发送到聊天准备，如果窗口变化，tip也要改变位置
			if(args[5] != null && args[5] == true)
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
			}
			
			_shopBind=args[6];
			
			setTitle();//标题、装备评分
			setEquipLimited();//装备类型、等级要求、职业、绑定
			setIcon();
			setAttrs();//处理装备的基本属性和附加属性
			setInlayGems();//凹槽和宝石
			setOtherInfo();//装备简介、剩余时间、商店收购价、使用说明
			//			if(_template.suit_id > 0)
			//				setEquipSuitInfo();//套装信息
			
			var line:Bitmap=_linesAry.pop();
			if(line.parent)
				line.parent.removeChild(line);
			GlobalPools.bitmapPool.returnObject(line);
			line=null;
			
			var txt:TextField=_txtsAry[_txtsAry.length-1];
			if(_template.type != TypeProps.EQUIP_TYPE_WINGS)
			{
				if(_template.quality > TypeProps.QUALITY_WHITE)//品质大于白色是一定有孔的，所有一定就有至少五个文本框,最多7个
				{
					if(_txtsAry.length > 5)//不管有没有宝石属性以及其他信息
						_bgMc.height=txt.y+txt.height+GAP_X;
					else
					{
						if(_holesContainer && ModuleManager.moduleShop.isNPCShopOpened == false)
						{
							if(_equip && _template.remain_time > 0)//居然tm的还有个剩余时间，吼吼~
								_bgMc.height=txt.y+txt.height+GAP_X;
							else
								_bgMc.height=_holesContainer.y+_holesContainer.height+GAP_X;
						}
						else
							_bgMc.height=txt.y+txt.height+GAP_X;
					}
				}
				else
				{
					_bgMc.height=txt.y+txt.height+GAP_X;
				}
			}
			else
			{
				if(_gemsArr.length > 0 || _txtsAry.length > 5)
					_bgMc.height=txt.y+txt.height+GAP_X;
				else
					_bgMc.height=_holesContainer.y+_holesContainer.height+GAP_X;
			}
			_bgMc.height += 4;
		}
		
		public function resize():void{
			this.x = 250;
			this.y = StageProxy.Instance.viewRect.height-500;
		}
		
		private function close(e:MouseEvent):void
		{
			dispose();
		}
		
		private function setTitle():void
		{	
			var html:String='';
			var color:String=TypeProps.getQualityColor(_template.quality);
			
			/*********************************装备名称********************************/
			if(_template.type != TypeProps.EQUIP_TYPE_WINGS && _equip && _equip.enhance_level > 0){
				html+=createLineHtml(_template.name+" +"+_equip.enhance_level,color,TITLE_SIZE);
			}else{
				html=createLineHtml(_template.name,color,TITLE_SIZE);
			}
			
			var txt:TextField=getTxt();
			txt.htmlText=html;
			txt.x=txt.y=GAP_X;
			addChild(txt);
			
			var line:Bitmap=getLine();
			line.x=(_bgMc.width-line.width)/2;
			line.y=txt.y+txt.height+PARA_IN;
			addChild(line);
			/*********************************装备评分********************************/
			var point:int=calculatePower();
			html = createLineHtml("装备评分："+point.toString(),COLOR_POINT,TITLE_SIZE);
			
			setTxtLineFormat(html);
		}
		
		private function setIcon():void
		{
			var txt:TextField=_txtsAry[_txtsAry.length-1];
			_iconBg=ClassInstance.getInstance('bagIconBg');
			_iconBg.x=GAP_X*3-2;
			_iconBg.y=txt.y+10;
			addChild(_iconBg);
			
			var icon:IconImage=getIcon();
			icon.url=EquipBasicManager.Instance.getURL(_template.template_id);
			icon.x=GAP_X*3+4.2;			
			icon.y=txt.y+16.1;
			addChild(icon);
		}
		
		/** 装备类型、等级要求、职业、绑定 */		
		private function setEquipLimited():void
		{
			var LIMIT_INDENT:int=80;
			var str:String='';
			var html:String='';
			
			str="装备类型："+EquipBasicManager.getEquipType(_template.type);
			html +=HTMLUtil.createIndentFormat(createLineHtml(str,COLOR_DEFAULT),LIMIT_INDENT)+"<br>";
			
			str="等级要求："+_template.level.toString();
			if(DataCenter.Instance.roleSelfVo.roleDyVo.level < _template.level)
				html += HTMLUtil.createIndentFormat(createLineHtml(str,COLOR_RED),LIMIT_INDENT)+"<br>";
			else	
				html += HTMLUtil.createIndentFormat(createLineHtml(str,COLOR_DEFAULT),LIMIT_INDENT)+"<br>";
			
			str="职业限制："+TypeRole.getCareerName(_template.career);
			if(DataCenter.Instance.roleSelfVo.roleDyVo.career != _template.career)
				html += HTMLUtil.createIndentFormat(createLineHtml(str,COLOR_RED),LIMIT_INDENT)+"<br>";//不是这个职业就变红色
			else
				html += HTMLUtil.createIndentFormat(createLineHtml(str,COLOR_DEFAULT),LIMIT_INDENT)+"<br>";
			
			var binding:int=0;			
			if(_shopBind > 0)
				binding = _shopBind;
			else
			{
				if(_equip)
					binding=_equip.binding_type;
				else
					binding=_template.binding_type;
			}
			
			switch(binding)
			{
				case TypeProps.BIND_TYPE_EQUIP:
					str="穿戴后绑定";
					break;
				case TypeProps.BIND_TYPE_NO:
					str="不绑定";
					break;
				case TypeProps.BIND_TYPE_YES:
					str="绑定";
					break;
			}
			html += HTMLUtil.createIndentFormat(createLineHtml(str,COLOR_DEFAULT),LIMIT_INDENT)+'<br>';
			
			setTxtLineFormat(html);
		}
		
		/** 处理装备的基本属性和附加属性  */		
		private function setAttrs():void
		{
			var str:String='';
			var html:String='';
			var value:Number=0;
			
			_attrs=[];
			if(_template.base_attr_t1 > 0){
				html += '<b>'+createLineHtml("基础属性",COLOR_TITLE)+'</b><br>';
				if(_template.type == TypeProps.EQUIP_TYPE_WINGS)
					str=TypeProps.getAttrName(_template.base_attr_t1)+"："+_template.base_attr_v1+"%";
				else
				{
					if(_template.base_attr_v1>=1)
						str=getAttrsInfo(_template.base_attr_t1,_template.base_attr_v1);
					else
						str=getAttrsInfo(_template.base_attr_t1,_template.base_attr_v1*10000);
				}
				html += HTMLUtil.createIndentFormat(createLineHtml(str,COLOR_BASE_ATTRS),INDENT)+"<br>";
				_attrs.push(_template.base_attr_t1);
				
				if(_template.base_attr_t2 > 0){
					if(_template.type == TypeProps.EQUIP_TYPE_WINGS)
						str=TypeProps.getAttrName(_template.base_attr_t2)+"："+_template.base_attr_v2+"%";
					else
					{
						if(_template.base_attr_v2>=1)
							str=getAttrsInfo(_template.base_attr_t2,_template.base_attr_v2);
						else
							str=getAttrsInfo(_template.base_attr_t2,_template.base_attr_v2*10000);
					}
					html += HTMLUtil.createIndentFormat(createLineHtml(str,COLOR_BASE_ATTRS),INDENT)+"<br>";
					_attrs.push(_template.base_attr_t2);
				}
				if(_template.base_attr_t3 > 0){
					if(_template.type == TypeProps.EQUIP_TYPE_WINGS)
						str=TypeProps.getAttrName(_template.base_attr_t3)+"："+_template.base_attr_v3+"%";
					else
					{
						if(_template.base_attr_v3>=1)
							str=getAttrsInfo(_template.base_attr_t3,_template.base_attr_v3);
						else
							str=getAttrsInfo(_template.base_attr_t3,_template.base_attr_v3*10000);
					}
					html += HTMLUtil.createIndentFormat(createLineHtml(str,COLOR_BASE_ATTRS),INDENT)+"<br>";
					_attrs.push(_template.base_attr_t3);
				}
			}
			else
				html += '<b>'+createLineHtml("基础属性（无）",COLOR_TITLE)+'</b><br>';
			
			/***********************************附加属性***********************************/
			
			if(_template.app_attr_t1 > 0){
				html += '<b>'+createLineHtml("附加属性",COLOR_TITLE)+'</b><br>';
				if(_template.type == TypeProps.EQUIP_TYPE_WINGS)
					str=TypeProps.getAttrName(_template.app_attr_t1)+"："+_template.base_attr_v1+"%";
				else
				{
					if(_template.app_attr_v1>=1)
						str=getAttrsInfo(_template.app_attr_t1,_template.app_attr_v1);
					else
						str=getAttrsInfo(_template.app_attr_t1,_template.app_attr_v1*10000);
				}
				html += HTMLUtil.createIndentFormat(createLineHtml(str,COLOR_APP_ATTRS),INDENT)+"<br>";
				_attrs.push(_template.app_attr_t1);
				
				if(_template.app_attr_t2 > 0){
					if(_template.type == TypeProps.EQUIP_TYPE_WINGS)
						str=TypeProps.getAttrName(_template.app_attr_t2)+"："+_template.base_attr_v2+"%";
					else
					{
						if(_template.app_attr_v2>=1)
							str=getAttrsInfo(_template.app_attr_t2,_template.app_attr_v2);
						else
							str=getAttrsInfo(_template.app_attr_t2,_template.app_attr_v2*10000);
					}
					html += HTMLUtil.createIndentFormat(createLineHtml(str,COLOR_APP_ATTRS),INDENT)+"<br>";
					_attrs.push(_template.app_attr_t2);
				}
			}
			else
				html += '<b>'+createLineHtml("附加属性（无）",COLOR_TITLE)+'</b><br>';
			
			if(_attrs.length > 0){
				if(_equip && _equip.app_attr_t1 != 0)
				{
					html += '<b>'+createLineHtml("洗练属性",COLOR_TITLE)+'</b><br>';
					str=TypeProps.getAttrName(_equip.app_attr_t1)+'：'+_equip.app_attr_v1;
					html += createLineHtml(str,_equip.app_attr_color1.toString(16))+"<br>";
					str=TypeProps.getAttrName(_equip.app_attr_t2)+'：'+_equip.app_attr_v2;
					html += createLineHtml(str,_equip.app_attr_color2.toString(16))+"<br>";
					str=TypeProps.getAttrName(_equip.app_attr_t3)+'：'+_equip.app_attr_v3;
					html += createLineHtml(str,_equip.app_attr_color3.toString(16))+"<br>";
					str=TypeProps.getAttrName(_equip.app_attr_t4)+'：'+_equip.app_attr_v4;
					html += createLineHtml(str,_equip.app_attr_color4.toString(16))+"<br>";
				}
				html = html.slice(0,html.length-4);
				setTxtLineFormat(html);
			}		
		}
		
		/** 凹槽和宝石,宝石信息 */		
		private function setInlayGems():void
		{
			if(_template.hole_number == 0) return;
			
			_gemsArr=[];
			
			var title:TextField=getTxt();
			title.htmlText = '<b>'+createLineHtml("装备镶嵌",COLOR_TITLE)+'</b><br>';	
			var line:Bitmap=_linesAry[_linesAry.length-1];
			title.x=GAP_X;
			title.y=line.y+line.height+PARA_IN;
			addChild(title);
			
			_holesContainer=new Sprite();
			for(var i:int=0;i<_template.hole_number;i++)
			{
				var hole:Sprite=ClassInstance.getInstance("bagUI_hole");
				_holesContainer.addChild(hole);
				hole.x=(hole.width+3)*i;
			}
			_holesContainer.x=GAP_X;
			_holesContainer.y=title.y+title.height+PARA_IN;
			addChild(_holesContainer);
			
			if(_equip)
			{
				if(_equip.gem_1_id >0) _gemsArr.push(_equip.gem_1_id);				
				if(_equip.gem_2_id >0) _gemsArr.push(_equip.gem_2_id);					
				if(_equip.gem_3_id >0) _gemsArr.push(_equip.gem_3_id);				
				if(_equip.gem_4_id >0) _gemsArr.push(_equip.gem_4_id);				
				if(_equip.gem_5_id >0) _gemsArr.push(_equip.gem_5_id);				
				if(_equip.gem_6_id >0) _gemsArr.push(_equip.gem_6_id);			
				if(_equip.gem_7_id >0) _gemsArr.push(_equip.gem_7_id);			
				if(_equip.gem_8_id >0) _gemsArr.push(_equip.gem_8_id);			
			}
			var html:String='';
			if(_gemsArr.length > 0)
			{
				var gemName:String='';
				var attr:String='';
				var value:String='';
				var gemsNum:int=_gemsArr.length;
				var icon:IconImage;
				var propsTmpVo:PropsBasicVo;
				for(i=0;i<gemsNum;i++)
				{
					propsTmpVo=PropsBasicManager.Instance.getPropsBasicVo(_gemsArr[i]);//宝石的id全都是模板Id
					icon=getIcon();
					icon.url=URLTool.getInlayIcon(propsTmpVo.icon_id);
					addChild(icon);
					icon.x=GAP_X+6+(GEM_ICON_WIDTH+15)*i;
					icon.y=_holesContainer.y+PARA_IN*3;			
					//显示宝石信息
					icon=getIcon();
					icon.url=URLTool.getInlayIcon(propsTmpVo.icon_id);
					icon.x=GAP_X+6;
					if(propsTmpVo.gem_type != ForgeSource.GEM_TYPE_DEFEND)
						icon.y=_holesContainer.y+_holesContainer.height+PARA_IN+(GEM_ICON_WIDTH)*i;
					else
						icon.y=_holesContainer.y+_holesContainer.height+PARA_IN+(GEM_ICON_WIDTH+12)*i;
					addChild(icon);
					if(propsTmpVo.gem_type != ForgeSource.GEM_TYPE_DEFEND)
					{
						gemName = createLineHtml(propsTmpVo.name+"：",TypeProps.getQualityColor(propsTmpVo.quality));
						html += HTMLUtil.createIndentFormat(gemName+createLineHtml(TypeProps.getAttrName(propsTmpVo.attr_type)+
							" +"+propsTmpVo.attr_value.toString(),COLOR_DEFAULT),GEM_INDENT)+'<br>';
					}
					else
					{
						html += HTMLUtil.createIndentFormat('<b>'+createLineHtml(propsTmpVo.name+"：",
							TypeProps.getQualityColor(propsTmpVo.quality))+'</b>'+createLineHtml("物理防御 +"
								+propsTmpVo.attr_value.toString(),COLOR_DEFAULT),30);
						html += HTMLUtil.createIndentFormat(createLineHtml("<br>魔法防御 +"+propsTmpVo.attr_value.toString(),COLOR_DEFAULT),GEM_INDENT*3+24)+'<br>';
//						html += HTMLUtil.createIndentFormat(createLineHtml(,COLOR_DEFAULT),GEM_INDENT)+'<br>';
					}
				}

				html = html.slice(0,html.length-4);
				var txt:TextField=getTxt();
				if(propsTmpVo.gem_type != ForgeSource.GEM_TYPE_DEFEND)
					txt.htmlText=HTMLUtil.createLeadingFormat(html,7);
				else
					txt.htmlText=HTMLUtil.createLeadingFormat(html,LEADING);
				txt.x=GAP_X;
				txt.y=_holesContainer.y+_holesContainer.height+PARA_IN;
				addChild(txt);
				
				line=getLine();
				line.x=(_bgMc.width-line.width)/2;
				line.y=txt.y+txt.height+PARA_IN;
				addChild(line);
			}
			else
			{
				line=getLine();
				line.x=(_bgMc.width-line.width)/2;
				line.y=_holesContainer.y+_holesContainer.height+PARA_IN;
				addChild(line);
			}		
			
		}
		
		/** 套装信息  */		
		private function setEquipSuitInfo():void
		{			
			var html:String='';
			var allEquipsArr:Array=EquipBasicManager.Instance.getSuitIdArr(_template.suit_id);//所有装备成员的信息:EquipBasicVo		
			var equipSuitsArr:Array=EquipSuitBasicManager.Instance.getEquipSuitArray(_template.suit_id);//所有套装信息,如哪几件有什么属性
			
			var len:int=0;//每个数组的长度
			
			html += createLineHtml(equipSuitsArr[0].suits_name,COLOR_DEFAULT)+"<br>";
			
			if(_inCharacter == false)
			{
				len=allEquipsArr.length;
				for(var i:int=0;i<len;i++)
				{
					var equipVo:EquipBasicVo=allEquipsArr[i];
					if(equipVo.template_id == _template.template_id)
					{
						html += HTMLUtil.createIndentFormat(createLineHtml(equipVo.name,COLOR_DEFAULT),INDENT)+"<br>";						
					}
					else
						html += HTMLUtil.createIndentFormat(createLineHtml(equipVo.name,COLOR_DEFAULT),INDENT)+"<br>";
				}
				
				len=equipSuitsArr.length;
				for(i=0; i<len; i++)
				{
					var equipSuitVo:EquipSuitBasicVo=equipSuitsArr[i];
					html += createLineHtml("("+equipSuitVo.unit_num+") 套装",COLOR_DEFAULT+"：")+"<br>";
					var attrName:String='';
					if(equipSuitVo.app_attr_t1 > 0)
					{
						attrName=TypeProps.getAttrName(equipSuitVo.app_attr_t1);
						html += HTMLUtil.createIndentFormat(createLineHtml(attrName+"：+"+equipSuitVo.app_attr_v1.toString(),COLOR_DEFAULT),INDENT)+"<br>";
					}
					if(equipSuitVo.app_attr_t2 > 0)
					{
						attrName=TypeProps.getAttrName(equipSuitVo.app_attr_t2);
						html += HTMLUtil.createIndentFormat(createLineHtml(attrName+"：+"+equipSuitVo.app_attr_v2.toString(),COLOR_DEFAULT),INDENT)+"<br>";
					}
				}
				
			}
			else
			{
				var characterEquips:Array=CharacterDyManager.Instance.getEquipDict().values();//身上的dyVo
				var tmpEquips:HashMap=new HashMap();//当前在一个套装的挑出来
				
				//要将身上穿的所有包括在一个套装里的分出来放在tmpEquips里
				len=characterEquips.length;
				var len1:int=allEquipsArr.length;
				for(i=0;i<len;i++)//身上里找
				{
					var equipDyVo:EquipDyVo=characterEquips[i];
					for(var j:int=0;j<len1;j++)
					{
						var equipBsVo:EquipBasicVo=allEquipsArr[j];
						if(EquipDyManager.instance.getEquipInfo(equipDyVo.equip_id) && 
							equipDyVo.template_id == equipBsVo.template_id)
						{
							tmpEquips.put(equipBsVo.template_id,equipBsVo);
							break;
						}
					}
				}
				
				//高亮所有在此套装内身上的装备
				len=allEquipsArr.length;
				for(i=0;i<allEquipsArr.length;i++)
				{
					if(tmpEquips.hasKey(allEquipsArr[i].template_id))
					{
						html += HTMLUtil.createIndentFormat(createLineHtml(allEquipsArr[i].name,COLOR_DEFAULT),INDENT)+"<br>";
					}
					else
						html += HTMLUtil.createIndentFormat(createLineHtml(allEquipsArr[i].name,COLOR_DEFAULT),INDENT)+"<br>";
				}
				
				//把满足数量的高亮
				len=equipSuitsArr.length;
				for(i=0; i<len; i++)
				{
					equipSuitVo=equipSuitsArr[i];
//					var attrName:String='';
					if(tmpEquips.values().length >= equipSuitVo.unit_num)
					{
						html += createLineHtml("("+equipSuitVo.unit_num+") 套装",COLOR_DEFAULT+"：")+"<br>";
						if(equipSuitVo.app_attr_t1 > 0)
						{
							attrName=TypeProps.getAttrName(equipSuitVo.app_attr_t1);
							html += HTMLUtil.createIndentFormat(createLineHtml(attrName+"：+"+equipSuitVo.app_attr_v1.toString(),COLOR_DEFAULT),INDENT)+"<br>";
						}
						if(equipSuitVo.app_attr_t2 > 0)
						{
							attrName=TypeProps.getAttrName(equipSuitVo.app_attr_t2);
							html += HTMLUtil.createIndentFormat(createLineHtml(attrName+"：+"+equipSuitVo.app_attr_v2.toString(),COLOR_DEFAULT),INDENT)+"<br>";
						}
					}
					else
					{
						html += createLineHtml("("+equipSuitVo.unit_num+") 套装",COLOR_DEFAULT+"：")+"<br>";
						if(equipSuitVo.app_attr_t1 > 0)
						{
							attrName=TypeProps.getAttrName(equipSuitVo.app_attr_t1);
							html += HTMLUtil.createIndentFormat(createLineHtml(attrName+"：+"+equipSuitVo.app_attr_v1.toString(),COLOR_DEFAULT),INDENT)+"<br>";
						}
						if(equipSuitVo.app_attr_t2 > 0)
						{
							attrName=TypeProps.getAttrName(equipSuitVo.app_attr_t2);
							html += HTMLUtil.createIndentFormat(createLineHtml(attrName+"：+"+equipSuitVo.app_attr_v2.toString(),COLOR_DEFAULT),INDENT)+"<br>";
						}
					}					
				}				
			}
			
			html = html.slice(0,html.length-4);
			setTxtLineFormat(html);
		}
		
		/**
		 * (装备简介)剩余时间、商店收购价、使用说明
		 */		
		private function setOtherInfo():void
		{
			var html:String='';
			if(_template.introduction != '')
				html += createLineHtml(_template.introduction,COLOR_DEFAULT)+"<br>";
			
			//又有个坑爹的剩余时间
			html += setTime();
			
			if(ModuleManager.moduleShop.isNPCShopOpened == false || _template.sell_price == -1)
				html += "";
			else
			{
				html += createLineHtml("商店收购价："+_template.sell_price.toString()+"银锭",COLOR_DEFAULT)+"<br>";
			}
			if(_template.effect_desc != '')
				html += createLineHtml(_template.effect_desc,COLOR_DEFAULT)+"<br>";
			
			if(html != '')
			{
				html = html.slice(0,html.length-4);			
				//装备和翅膀一定会有镶嵌空，就是要看有没有镶嵌宝石
				var line:Bitmap=getLine();
				line.x=(_bgMc.width-line.width)/2;
				addChild(line);
				var lastTxt:TextField=_txtsAry[_txtsAry.length-1];
				if(_gemsArr && _gemsArr.length > 0)//有镶嵌
				{
					//从上一个文本框开始定位置					
					line.y=lastTxt.y+lastTxt.height+PARA_IN;					
				}
				else//没有镶嵌
				{
					if(_holesContainer)
						line.y=_holesContainer.y+_holesContainer.height+PARA_IN;
					else
						line.y=lastTxt.y+lastTxt.height+PARA_IN;
				}
				var txt:TextField=getTxt();
				txt.htmlText=HTMLUtil.createLeadingFormat(html,LEADING);
				txt.x=GAP_X;
				txt.y=line.y+line.height+PARA_IN;
				addChild(txt);
			}
		}
		
		private function setTime():String
		{
			//现在只做剩余时间
			if(_template.remain_time > 0 && _equip){
				var time:Number=BagTimerManager.instance.getPassTime(TypeProps.ITEM_TYPE_EQUIP,_equip.equip_id);
				var str:String=TimeManager.getTimeFormat2(time);
				return createLineHtml("剩余时间："+str,COLOR_DEFAULT)+"<br>";
			}
			return '';
		}
		
		private function createLineHtml(str:String,color:String,size:int=FONT_SIZE):String
		{
			return HTMLUtil.createHtmlText(str,size,color,'宋体');
		}	

		private function calculatePower():int
		{
			var power:int=0;
			var hp:Number=getAttrValue(TypeProps.EA_HEALTH_LIMIT);//生命上限			
			if(hp < 1 && hp > 0)
				hp=CharacterDyManager.Instance.propArr[TypeProps.BA_PHYSIQUE]*15;
			var mp:Number=getAttrValue(TypeProps.EA_MANA_LIMIT);//魔法上限
			if(mp < 1 && mp > 0)
				mp=CharacterDyManager.Instance.propArr[TypeProps.BA_INTELLIGENCE]*15;
			
			var pd:Number=getAttrValue(TypeProps.EA_PHYSIC_DEFENSE);//物防
			if(pd < 1 && pd > 0)
			{
				if(_template.career == TypeRole.CAREER_PRIEST)
					pd=0.25*CharacterDyManager.Instance.propArr[TypeProps.BA_SPIRIT]+0.6*CharacterDyManager.Instance.propArr[TypeProps.BA_STRENGTH];
				else
					pd=0.6*CharacterDyManager.Instance.propArr[TypeProps.BA_STRENGTH];
			}
			
			var md:Number=getAttrValue(TypeProps.EA_MAGIC_DEFENSE);//法防
			if(md < 1 && md > 0)
				md=CharacterDyManager.Instance.propArr[TypeProps.BA_SPIRIT]*0.6;
			var pa:Number=getAttrValue(TypeProps.EA_PHYSIC_ATK);//物攻
			if(pa < 1 && pa > 0)
			{
				if(_template.career == TypeRole.CAREER_NEWHAND || _template.career == TypeRole.CAREER_WARRIOR)
					pa=CharacterDyManager.Instance.propArr[TypeProps.BA_STRENGTH]*0.5;
				else if(_template.career == TypeRole.CAREER_HUNTER)
					pa=CharacterDyManager.Instance.propArr[TypeProps.BA_AGILE]*0.5;
				else if(_template.career == TypeRole.CAREER_BRAVO)
					pa=CharacterDyManager.Instance.propArr[TypeProps.BA_AGILE]*0.55;
				else
					pa=0;
			}
			var ma:Number=getAttrValue(TypeProps.EA_MAGIC_ATK);//法攻
			if(ma < 1 && ma > 0)
			{
				if(_template.career == TypeRole.CAREER_NEWHAND || _template.career == TypeRole.CAREER_WARRIOR
					|| _template.career == TypeRole.CAREER_BRAVO)
					ma=0;
				else if(_template.career == TypeRole.CAREER_HUNTER)
					ma=CharacterDyManager.Instance.propArr[TypeProps.BA_INTELLIGENCE]*0.5;
				else if(_template.career == TypeRole.CAREER_PRIEST)
					ma=CharacterDyManager.Instance.propArr[TypeProps.BA_INTELLIGENCE]*0.5+CharacterDyManager.Instance.propArr[TypeProps.BA_SPIRIT]*0.2;
				else
					ma=CharacterDyManager.Instance.propArr[TypeProps.BA_INTELLIGENCE]*0.6;
			}
			var miss:Number=getAttrValue(TypeProps.EA_MISSRATE);//闪避
			var crit:Number=getAttrValue(TypeProps.EA_CRITRATE);//暴击
			var hit:Number=getAttrValue(TypeProps.EA_HITRATE);//命中
			var tough:int=getAttrValue(TypeProps.EA_TOUGHRATE);//韧性
			power=Math.ceil((hp+mp/10+(pd+md)*25+(pa+ma)*30)*(1+(miss+crit+hit+tough)/(114*115))/10);
			return power;
		}
		
		private function getAttrValue(attrType:int):Number
		{
			if(_template.base_attr_t1 == attrType)
				return _template.base_attr_v1;
			else if(_template.base_attr_t2 == attrType)
				return _template.base_attr_v2;
			else if(_template.base_attr_t3 == attrType)
				return _template.base_attr_v3;
			else if(_template.app_attr_t1 == attrType)
				return _template.app_attr_v1;
			else if(_template.app_attr_t2 == attrType)
				return _template.app_attr_v2;
			else return 0.0;
		}
		
		/** 组装成属性 ：  XX（+yy）”，XX为强化后的属性值，yy为强化增加的属性值
		 * @param type
		 * @param value
		 * @return 
		 */		
		private function getAttrsInfo(type:int,value:Number):String
		{
			var sign:String='';
			switch(type)
			{
				case TypeProps.EA_HEALTH:
				case TypeProps.EA_MANA:
				case TypeProps.EA_HITRATE://"命中"
				case TypeProps.EA_MISSRATE://"闪避"
				case TypeProps.EA_CRITRATE://暴击
				case TypeProps.EA_TOUGHRATE://坚韧
				case TypeProps.EA_MOVESPEED://移动速度
					sign='';
					break;
				case TypeProps.EA_HEALTH_LIMIT://生命上限
				case TypeProps.EA_MANA_LIMIT://魔法上限
				case TypeProps.EA_PHYSIC_ATK://物理攻击
				case TypeProps.EA_MAGIC_ATK://魔法攻击
				case TypeProps.EA_PHYSIC_DEFENSE://物理防御
				case TypeProps.EA_MAGIC_DEFENSE://魔法防御
					if(value < 1)
						sign='%';
					else
					{
						value=Math.ceil(value);
						sign='';
					}
					break;
				case TypeProps.EA_PREDUCE://物理减伤
				case TypeProps.EA_MREDUCE://魔法减伤
				case TypeProps.EA_BLOODRESIST://减速抗性
				case TypeProps.EA_TOUGHRATE://定身抗性					
				case TypeProps.EA_SWIMRESIST://晕眩抗性
				case TypeProps.EA_FROZENRESIST://沉默抗性
					sign='%';
					break;
			}
			var offset:int;
			var str:String='';
			if(_equip && _equip.enhance_level > 0){
				offset=Math.ceil(value*EquipDyManager.instance.getEquipStrengthenIncrement(_equip.enhance_level)-value);
				if(sign != '%')
					str=TypeProps.getAttrName(type)+'：'+value.toString()+sign+'（+'+offset.toString()+sign+'）';
				else
					str=TypeProps.getAttrName(type)+'：'+(value*10000).toString()+sign+'（+'+(offset*10000).toString()+sign+'）';
			}
			else
				str=TypeProps.getAttrName(type)+'：'+value.toString()+sign;
			return str;
		}
		
		public static function get instance():EquipTip
		{
			if(_instance == null)
				_instance=new EquipTip();
			return _instance;
		}
	
	}
} 