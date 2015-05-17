package com.YFFramework.game.core.global.view.tips
{
	/**
	 * @version 1.0.0
	 * creation time：2012-12-23 上午11:13:20
	 * 
	 */
	
	
	import com.YFFramework.core.net.loader.image_swf.IconLoader;
	import com.YFFramework.core.text.HTMLUtil;
	import com.YFFramework.core.utils.HashMap;
	import com.YFFramework.core.utils.common.ClassInstance;
	import com.YFFramework.core.world.model.type.TypeRole;
	import com.YFFramework.game.core.global.manager.CharacterDyManager;
	import com.YFFramework.game.core.global.manager.EquipBasicManager;
	import com.YFFramework.game.core.global.manager.EquipDyManager;
	import com.YFFramework.game.core.global.manager.EquipSuitBasicManager;
	import com.YFFramework.game.core.global.manager.PropsBasicManager;
	import com.YFFramework.game.core.global.manager.PropsDyManager;
	import com.YFFramework.game.core.global.model.EquipBasicVo;
	import com.YFFramework.game.core.global.model.EquipDyVo;
	import com.YFFramework.game.core.global.model.EquipSuitBasicVo;
	import com.YFFramework.game.core.global.model.PropsBasicVo;
	import com.YFFramework.game.core.global.model.PropsDyVo;
	import com.YFFramework.game.core.global.util.FilterConfig;
	import com.YFFramework.game.core.global.util.TypeProps;
	import com.YFFramework.game.core.module.ModuleManager;
	import com.msg.enumdef.BindingType;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	

	
	public class EquipTip extends Sprite
	{
		//======================================================================
		//        const variable
		//======================================================================
		private const GAP_X:int=10;
		private const PARA_OUT:int=2;
		private const TITLE_SIZE:int=15;
		private const FONT_SIZE:int=13;
		private const LEADING:int=2;
		private const TXT_WIDTH:int=212;
		private const INDENT:int=17;
		//======================================================================
		//        static variable
		//======================================================================
		
		//======================================================================
		//        variable
		//======================================================================
		private var _mc:Sprite;
		private var _template:EquipBasicVo;
		private var _equip:EquipDyVo;
		private var _inCharacter:Boolean=false;
		
		private var _title:TextField;
		private var _txt1:TextField;//绑定、类型
		private var _txt2:TextField;//职业限制、性别限制、需要等级、需要声望、耐久度
		private var _txt3:TextField;//物防、魔防、生命上限、一些附加属性
		private var _txt4:TextField;//要检查装备孔数是不是零
		private var _txt5:TextField;//套装
		private var _txt6:TextField;//装备简介、剩余时间、商店收购价、使用说明
		private var _slotsTxt:TextField;//凹槽
		
		private var _icon:Sprite;
		
		private var _starContaitner:Sprite;

		private var _holesContainer:Sprite;

		private var _gemContainer:Sprite;
		
		private var _lineBd:BitmapData;
		private var _line1:Bitmap;
		private var _line2:Bitmap;
		private var _line3:Bitmap;
		
		private var bgWidth:int=0;

		private var attrs:Array;
		private var gemsArr:Array;
		//======================================================================
		//        constructor
		//======================================================================
		
		public function EquipTip()
		{
			_mc=ClassInstance.getInstance("bagUI_tipBg") as Sprite;
			addChild(_mc);
			
			_icon=new Sprite();
			addChild(_icon);
			
			_lineBd=ClassInstance.getInstance("bagUI_line") as BitmapData;
			
			_line1=new Bitmap(_lineBd.clone());
			addChild(_line1);
			
			_line2=new Bitmap(_lineBd.clone());
			
			_line3=new Bitmap(_lineBd.clone());
			
			_starContaitner=new Sprite();
			_holesContainer=new Sprite();
			_gemContainer=new Sprite();
			
			_title=new TextField();
			_title.width=TXT_WIDTH;
			_title.multiline=false;
			_title.wordWrap=false;
			_title.filters=FilterConfig.Black_name_filter;
			_title.autoSize=TextFieldAutoSize.LEFT;
			addChild(_title);
			_title.x=GAP_X;
			_title.y=GAP_X;
			
			_txt1=new TextField();
			_txt1.width=TXT_WIDTH/2;
			_txt1.multiline=true;
			_txt1.wordWrap=true;
			_txt1.filters=FilterConfig.Black_name_filter;
			_txt1.autoSize=TextFieldAutoSize.CENTER;
			addChild(_txt1);
			
			_txt2=new TextField();
			_txt2.width=TXT_WIDTH;
			_txt2.multiline=true;
			_txt2.wordWrap=true;
			_txt2.filters=FilterConfig.Black_name_filter;
			_txt2.autoSize=TextFieldAutoSize.CENTER;
			addChild(_txt2);
			
			_txt3=new TextField();
			_txt3.width=TXT_WIDTH;
			_txt3.multiline=true;
			_txt3.wordWrap=true;
			_txt3.filters=FilterConfig.Black_name_filter;
			_txt3.autoSize=TextFieldAutoSize.CENTER;		
			
			_slotsTxt=new TextField();
			_slotsTxt.width=TXT_WIDTH;
			_slotsTxt.multiline=false;
			_slotsTxt.wordWrap=true;
			_slotsTxt.filters=FilterConfig.Black_name_filter;
			_slotsTxt.autoSize=TextFieldAutoSize.LEFT;
			
			_txt4=new TextField();
			_txt4.width=TXT_WIDTH;
			_txt4.multiline=true;
			_txt4.wordWrap=true;
			_txt4.filters=FilterConfig.Black_name_filter;
			_txt4.autoSize=TextFieldAutoSize.CENTER;
			
			_txt5=new TextField();
			_txt5.width=TXT_WIDTH;
			_txt5.multiline=true;
			_txt5.wordWrap=true;
			_txt5.filters=FilterConfig.Black_name_filter;
			_txt5.autoSize=TextFieldAutoSize.CENTER;
			
			_txt6=new TextField();
			_txt6.width=TXT_WIDTH;
			_txt6.multiline=true;
			_txt6.wordWrap=true;
			_txt6.filters=FilterConfig.Black_name_filter;
			_txt6.autoSize=TextFieldAutoSize.CENTER;
			addChild(_txt6);
				
			bgWidth=GAP_X*2+TXT_WIDTH;
			
		}	
		
		override public function get width():Number
		{
			return 228;
		}
		
		
		//======================================================================
		//        function
		//======================================================================
		/**
		 * args->[0]动态id,[1]模板id,[2]是否在角色面板
		 * @param args
		 * 
		 */		
		public function setTip(args:Array):void
		{
			disposeContent();
			
			if(args[0] != 0)
			{
				_equip=EquipDyManager.instance.getEquipInfo(args[0]);
			}
			else
				_equip=null;
			
			_template=EquipBasicManager.Instance.getEquipBasicVo(args[1]);

			_inCharacter=args[2];

			setTitle();//强化等级的星星也在这个函数里
			
			setIcon();
			
			setTxt1();//绑定、类型
			
			setTxt2();//职业限制、性别限制、需要等级、需要声望、耐久度
			
			_line1.x=(bgWidth-_line1.width)/2;
			_line1.y=_txt2.y+_txt2.textHeight+PARA_OUT;
			
			setTxt3();//处理装备的基本属性和附加属性
			
			if(_template.hole_number > 0)
				setTxt4();//凹槽和宝石
			
			if(_template.suit_id > 0)
				setTxt5();//套装信息
			
			setTxt6();//装备简介、剩余时间、商店收购价、使用说明
			
			_mc.width=bgWidth;
			_mc.height=_txt6.y + _txt6.height +GAP_X;
			
			this.scrollRect=new Rectangle(0,0,bgWidth,_mc.height);

		}
		//======================================================================
		//        private function
		//======================================================================
		private function setTitle():void
		{		
			var color:String=EquipBasicManager.getQualityColor(_template.quality);
			
			if(_template.can_enhance && _equip && _equip.enhance_level > 0)
			{
				_title.htmlText=createLineHtml(_template.name+"+"+_equip.enhance_level,color,TITLE_SIZE);
				
				for(var i:int=0;i<_equip.enhance_level;i++)
				{
					var star:Sprite=ClassInstance.getInstance("bagUI_star") as Sprite;
					_starContaitner.addChild(star);
					star.x=(star.width-2)*i;		
				}
				_starContaitner.x=GAP_X;
				_starContaitner.y=_title.y+_title.height+PARA_OUT;
				addChild(_starContaitner);
			}
			else
			{
				_title.htmlText=createLineHtml(_template.name,color,TITLE_SIZE);
			}
			
		}
		
		private function setIcon():void
		{
			IconLoader.initLoader(EquipBasicManager.Instance.getURL(_template.template_id),_icon);
			
			_icon.x=GAP_X;
			if(_template.can_enhance && _equip && _equip.enhance_level > 0)
			{				
				_icon.y=_starContaitner.y+_starContaitner.height+GAP_X;
			}
			else
			{
				_icon.y=_title.y+_title.height+PARA_OUT;
			}
			
		}
		
		//绑定、类型
		private function setTxt1():void
		{		
			var str:String='';
			var html:String='';
			
			switch(_template.binding_type)
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
			html=createLineHtml(str,'fed100')+'<br>';
			
			str="装备类型："+EquipBasicManager.getEquipType(_template.type);
			
			html +=createLineHtml(str,'fed100');
			
			_txt1.htmlText=createLeadingFormat(html,LEADING);
			
			_txt1.x=GAP_X*2+40;
			if(_template.can_enhance && _equip && _equip.enhance_level > 0)
			{				
				_txt1.y=_starContaitner.y+_starContaitner.height+GAP_X;
			}
			else
			{
				_txt1.y=_title.y+_title.height+PARA_OUT;
			}
			
		}
		
		/**
		 * 职业限制、性别限制、需要等级、需要声望、耐久度 
		 * 
		 */		
		private function setTxt2():void
		{
			var str:String='';
			var html:String='';
			
			str="职业限制："+TypeRole.getCareerName(_template.career);
			html = createLineHtml(str,'D6CC91')+"<br>";
			
			str="性别限制："+TypeRole.getSexName(_template.gender);;
			
			html += createLineHtml(str,'D6CC91')+"<br>";
			
			str="需要等级："+_template.level.toString();
			html += createLineHtml(str,'D6CC91')+"<br>";
			
			if(_template.prestige > 0)
			{
				str="需要声望："+_template.prestige.toString();
				html += createLineHtml(str,'D6CC91')+"<br>";
			}
			
			if(_equip)
			{
				str="耐久度："+int(_equip.cur_durability/100).toString()+"/"+int(_template.durability/100).toString();
				html += createLineHtml(str,'D6CC91');
			}
			
			_txt2.htmlText=createLeadingFormat(html,LEADING);
			_txt2.x=GAP_X;
			_txt2.y=_txt1.y+40+PARA_OUT;
			
		}
		
		/**
		 * 处理装备的基本属性和附加属性 
		 * 
		 */		
		private function setTxt3():void
		{
			var str:String='';
			var html:String='';
			attrs=[];
			
			if(_template.base_attr_t1 > 0)
			{
				str=PropsBasicManager.getAttrName(_template.base_attr_t1) + "："+int(_template.base_attr_v1).toString();
				html += createLineHtml(str,'D6CC91')+"<br>";
				attrs.push(_template.base_attr_t1);
			}
			else if(_template.base_attr_t2 > 0)
			{
				str=PropsBasicManager.getAttrName(_template.base_attr_t2) + "："+int(_template.base_attr_v2).toString();
				html += createLineHtml(str,'D6CC91')+"<br>";
				attrs.push(_template.base_attr_t2);
			}
			else if(_template.base_attr_t3 > 0)
			{
				str=PropsBasicManager.getAttrName(_template.base_attr_t3)+"："+int(_template.base_attr_v3).toString();
				html += createLineHtml(str,'D6CC91')+"<br>";
				attrs.push(_template.base_attr_t3);
			}
			else if(_template.app_attr_t1 > 0)
			{
				str=PropsBasicManager.getAttrName(_template.app_attr_t1)+"："+int(_template.app_attr_v1).toString();
				html += createLineHtml(str,'009cff')+"<br>";
				attrs.push(_template.app_attr_t1);
			}
			else if(_template.app_attr_t2 > 0)
			{
				str=PropsBasicManager.getAttrName(_template.app_attr_t2)+ "："+int(_template.app_attr_v2).toString();
				html += createLineHtml(str,'009cff')+"<br>";
				attrs.push(_template.app_attr_t2);
			}
			
			if(attrs.length > 0)
			{
				html = html.slice(0,html.length-4);
				_txt3.htmlText=createLeadingFormat(html,LEADING);
				
				_txt3.x=GAP_X;
				_txt3.y=_line1.y+_line1.height+PARA_OUT;
				addChild(_txt3);
			}			
			
		}
		
		/**
		 * 凹槽和宝石,宝石信息放在txt4里
		 * 
		 */		
		private function setTxt4():void
		{
			var html:String='';
			gemsArr=[];

			_slotsTxt.htmlText = createLineHtml("凹槽 "+_template.hole_number.toString(),'fed100',14);
			addChild(_slotsTxt);
			
			_slotsTxt.x=GAP_X;
			if(attrs.length > 0)
				_slotsTxt.y=_txt3.y+_txt3.height+PARA_OUT;
			else
				_slotsTxt.y=_line1.y+_line1.height+PARA_OUT;
			
			for(var i:int=0;i<_template.hole_number;i++)
			{
				var hole:Sprite=ClassInstance.getInstance("bagUI_hole");
				_holesContainer.addChild(hole);
				hole.x=hole.width*i;
			}
			_holesContainer.x=GAP_X;
			_holesContainer.y=_slotsTxt.y+_slotsTxt.height+PARA_OUT;
			addChild(_holesContainer);

			if(_equip)
			{
				if(_equip.gem_1_id > 0)
					gemsArr.push(_equip.gem_1_id);
				if(_equip.gem_2_id)
					gemsArr.push(_equip.gem_2_id);
				if(_equip.gem_3_id)
					gemsArr.push(_equip.gem_3_id);
				if(_equip.gem_4_id)
					gemsArr.push(_equip.gem_4_id);
				if(_equip.gem_5_id)
					gemsArr.push(_equip.gem_5_id);
				if(_equip.gem_6_id)
					gemsArr.push(_equip.gem_6_id);
				if(_equip.gem_7_id)
					gemsArr.push(_equip.gem_7_id);
				if(_equip.gem_8_id)
					gemsArr.push(_equip.gem_8_id);
			}		
			
			if(gemsArr.length > 0)
			{
				for(i=0;i<gemsArr.length;i++)
				{
					var pos:Object=new Object;
					pos.x=20*i;//位置以后调
					pos.y=0;
					
					var gemTemplate:PropsDyVo=PropsDyManager.instance.getPropsInfo(gemsArr[i]);
					IconLoader.initLoader(PropsBasicManager.Instance.getURL(gemTemplate.templateId),_gemContainer,null,pos);
				}
				
				_gemContainer.x=GAP_X;
				_gemContainer.y=_holesContainer.y+_holesContainer.height+PARA_OUT;//位置还要再调
				addChild(_gemContainer);		
				
				var name:String='';
				var attr:String='';
				var value:String='';
				for(i=0;i<gemsArr.length;i++)
				{
					var tmp:PropsBasicVo=PropsBasicManager.Instance.getPropsBasicVo(gemsArr[i]);
					if(tmp)
					{
						name = tmp.name;
						attr = PropsBasicManager.getAttrName(tmp.attr_type);
						value = tmp.attr_value.toString();
						html += createLineHtml(name+attr+value,'D6CC91')+"<br>";
					}
				}
				
				html = html.slice(0,html.length-4);
				_txt4.htmlText=createLeadingFormat(html,LEADING);
				_txt4.x=GAP_X;
				_txt4.y=_holesContainer.y+_holesContainer.height+PARA_OUT;
				addChild(_txt4);
			}
			
		}
		
		/**
		 * 套装信息 
		 * 
		 */		
		private function setTxt5():void
		{	
			if(gemsArr.length > 0)//有无宝石
			{
				_line2.y=_txt4.y+_txt4.textHeight+PARA_OUT;
				addChild(_line2);
			}
			else if(_template.hole_number > 0)//有无凹槽
			{
				_line2.y=_holesContainer.y+_holesContainer.height+PARA_OUT;
				addChild(_line2);
			}
			else if(attrs.length > 0)//有无附加属性
			{
				_line2.y=_txt3.y+_txt3.height+PARA_OUT;
				addChild(_line2);
			}
			
			var html:String='';
			var allEquipsArr:Array=EquipBasicManager.Instance.getSuitIdArr(_template.suit_id);//所有装备成员的信息:EquipBasicVo		
			var equipSuitsArr:Array=EquipSuitBasicManager.Instance.getEquipSuitArray(_template.suit_id);//所有套装信息,如哪几件有什么属性
			
			html += createLineHtml(equipSuitsArr[0].suits_name,'08df12')+"<br>";
			
			if(_inCharacter == false)
			{
				for(var i:int=0;i<allEquipsArr.length;i++)
				{
					var equipVo:EquipBasicVo=allEquipsArr[i];
					if(equipVo.template_id == _template.template_id)
					{
						html += createIndentFormat(createLineHtml(equipVo.name,'08df12'),INDENT)+"<br>";						
					}
					else
						html += createIndentFormat(createLineHtml(equipVo.name,'968664'),INDENT)+"<br>";
				}
				
				for(i=0; i<equipSuitsArr.length; i++)
				{
					var equipSuitVo:EquipSuitBasicVo=equipSuitsArr[i];
					html += createLineHtml("("+equipSuitVo.unit_num+") 套装",'968664'+":")+"<br>";
					if(equipSuitVo.app_attr_t1 > 0)
					{
						html += createIndentFormat(createLineHtml(equipSuitVo.app_attr_v1.toString(),'968664'),INDENT)+"<br>";
					}
					if(equipSuitVo.app_attr_t2 > 0)
					{
						html += createIndentFormat(createLineHtml(equipSuitVo.app_attr_v2.toString(),'968664'),INDENT)+"<br>";
					}
				}
				
			}
			else
			{
				var characterEquips:Array=CharacterDyManager.Instance.getEquipDict().values();//身上的dyVo
				var tmpEquips:HashMap=new HashMap();//当前在一个套装的挑出来
				
				//要将身上穿的所有包括在一个套装里的分出来放在tmpEquips里
				for(i=0;i<characterEquips.length;i++)//身上里找
				{
					var equipDyVo:EquipDyVo=characterEquips[i];
					for(var j:int=0;j<allEquipsArr.length;j++)
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
				for(i=0;i<allEquipsArr.length;i++)
				{
					if(tmpEquips.hasKey(allEquipsArr[i].template_id))
					{
						html += createIndentFormat(createLineHtml(allEquipsArr[i].name,'08df12'),INDENT)+"<br>";
					}
					else
						html += createIndentFormat(createLineHtml(allEquipsArr[i].name,'968664'),INDENT)+"<br>";
				}
				
				//把满足数量的高亮
				for(i=0; i<equipSuitsArr.length; i++)
				{
					equipSuitVo=equipSuitsArr[i];
					if(tmpEquips.values().length >= equipSuitVo.unit_num)
					{
						html += createLineHtml("("+equipSuitVo.unit_num+") 套装",'08df12'+":")+"<br>";
						if(equipSuitVo.app_attr_t1 > 0)
						{
							html += createIndentFormat(createLineHtml(equipSuitVo.app_attr_v1.toString(),'08df12'),INDENT)+"<br>";
						}
						if(equipSuitVo.app_attr_t2 > 0)
						{
							html += createIndentFormat(createLineHtml(equipSuitVo.app_attr_v2.toString(),'08df12'),INDENT)+"<br>";
						}
					}
					else
					{
						html += createLineHtml("("+equipSuitVo.unit_num+") 套装",'968664'+":")+"<br>";
						if(equipSuitVo.app_attr_t1 > 0)
						{
							html += createIndentFormat(createLineHtml(equipSuitVo.app_attr_v1.toString(),'968664'),INDENT)+"<br>";
						}
						if(equipSuitVo.app_attr_t2 > 0)
						{
							html += createIndentFormat(createLineHtml(equipSuitVo.app_attr_v2.toString(),'968664'),INDENT)+"<br>";
						}
					}
					
				}
				
			}
			
			html = html.slice(0,html.length-4);
			_txt5.htmlText=createLeadingFormat(html,LEADING);
			_txt5.x=GAP_X;
			addChild(_txt5);
			
			if(_line2.parent)
				_txt5.y=_line2.y+ _line2.height+PARA_OUT;
			else
				_txt5.y=_line1.y+ _line1.height+PARA_OUT;
			
		}
		
		/**
		 * 装备简介、剩余时间、商店收购价、使用说明
		 * 
		 */		
		private function setTxt6():void
		{
			var html:String='';
			html += createLineHtml(_template.introduction,'D6CC91')+"<br>";
			//又有个坑爹的剩余时间
			html += setTime();
			
			if(ModuleManager.moduleShop.isNPCShopOpened == false || _template.sell_price == -1)
				html += "";
			else
				html += createLineHtml("商店收购价："+_template.sell_price.toString(),'fe7e00')+"<br>";
			
			html += createLineHtml(_template.effect_desc,'D6CC91')+"<br>";
			
			_txt6.htmlText = createLeadingFormat(html,LEADING);
			
			if(_template.suit_id > 0)
			{
				_line3.x=GAP_X;
				_line3.y= _txt5.y+_txt5.height+PARA_OUT;
				addChild(_line3);
				
				_txt6.x=GAP_X;
				_txt6.y=_line3.y+_line3.height+PARA_OUT;
				
			}
			else if(_line2.parent)
			{
				_txt6.x=GAP_X;
				_txt6.y=_line2.y+_line2.height+PARA_OUT;
			}
			else
			{
				_txt6.x=GAP_X;
				_txt6.y=_line1.y+_line1.height+PARA_OUT;
			}
			
		}
		
		private function setTime():String
		{
			if(_template.remain_time > 0 && _equip && _equip.obtain_time)
			{
				var time:int=_template.remain_time-_equip.obtain_time;
				return createLineHtml("截止时间："+time.toString(),'08df12')+"<br>";
			}
			return '';
		}
		
		private function createLineHtml(str:String,color:String,size:int=FONT_SIZE):String
		{
			return HTMLUtil.createHtmlText(str,size,color);
		}
		
		private function createParagraph(str:String,align:String='left'):String
		{
			var html:String="<p align=\'" + align + "\'>"+str+"</p>";
			return html;
		}
		
		private function createLeadingFormat(str:String,leading:int):String
		{
			var html:String="<textformat leading=\'" + leading + "\'>"+str+"</textformat>";
			return html;
		}
		
		private function createIndentFormat(str:String,indent:int):String
		{
			var html:String="<textformat indent=\'" + indent + "\'>"+str+"</textformat>";
			return html;
		}
		
		
		
		
		
		private function disposeContent():void
		{
			if(_icon.numChildren > 0)
			{
				_icon.removeChildAt(0);
			}
			if(_starContaitner.numChildren > 0)
			{
				while(_starContaitner.numChildren > 0)
				{
					_starContaitner.removeChildAt(0);
				}
				removeChild(_starContaitner);
			}
			if(_slotsTxt.parent)
				removeChild(_slotsTxt);
			if(_holesContainer.numChildren > 0)
			{
				while(_holesContainer.numChildren > 0)
				{
					_holesContainer.removeChildAt(0);
				}
				removeChild(_holesContainer);
			}
			if(_gemContainer.numChildren > 0)
			{
				while(_gemContainer.numChildren > 0)
				{
					_gemContainer.removeChildAt(0);
				}
				removeChild(_gemContainer);
			}
			_txt4.text='';
			_txt5.text='';
			
			if(_line2.parent)
				removeChild(_line2);
			if(_line3.parent)
				removeChild(_line3);
			if(_txt3.parent)
				removeChild(_txt3);
			if(_txt4.parent)
				removeChild(_txt4);
			if(_txt5.parent)
				removeChild(_txt5);
			if(gemsArr && gemsArr.length == 0)
				gemsArr = [];
			if(attrs && attrs.length == 0)
				attrs = [];
			
		}
		//======================================================================
		//        event handler
		//======================================================================
		
		//======================================================================
		//        getter&setter
		//======================================================================
		
		
	}
} 