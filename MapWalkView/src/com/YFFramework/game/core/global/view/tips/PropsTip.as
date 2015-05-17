package com.YFFramework.game.core.global.view.tips
{
	/**
	 * @version 1.0.0
	 * creation time：2012-12-13 上午11:04:32
	 * 
	 */
	
	import com.YFFramework.core.net.loader.image_swf.IconLoader;
	import com.YFFramework.core.text.HTMLUtil;
	import com.YFFramework.core.utils.common.ClassInstance;
	import com.YFFramework.game.core.global.manager.PropsBasicManager;
	import com.YFFramework.game.core.global.manager.PropsDyManager;
	import com.YFFramework.game.core.global.model.PropsBasicVo;
	import com.YFFramework.game.core.global.util.FilterConfig;
	import com.YFFramework.game.core.global.util.TypeProps;
	import com.YFFramework.game.core.module.ModuleManager;
	import com.msg.enumdef.BindingType;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	
	public class PropsTip extends Sprite
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
		//======================================================================
		//        static variable
		//======================================================================
		
		//======================================================================
		//        variable
		//======================================================================
		private var _mc:Sprite;
		private var _icon:Sprite;
		private var _title:TextField;//名称
		private var _txt1:TextField;//物品绑定、道具类型
		private var _levelTxt:TextField;//等级
		private var _txt2:TextField;//效果描述
		private var _txt3:TextField;//道具简介、剩余时间、商店收购价、使用说明

		private var _template:PropsBasicVo;
		private var _obtainTime:int=0;
		
		private var _lineBd:BitmapData;
		private var _line1:Bitmap;
		private var _line2:Bitmap;
		
		private var bgWidth:int=0;
		//======================================================================
		//        constructor
		//======================================================================
		/**
		* 0：id(模板唯一Id)，1：名字，2：绑定，3：类型，4：等级，5：效果描述，
		* 6：道具简介，7：剩余时间（除了不限制是不显示,其他都显示）， 8：商店收购价，9：使用说明
		*/
		
		public function PropsTip()
		{		
			_mc=ClassInstance.getInstance("bagUI_tipBg") as Sprite;
			addChild(_mc);
			
			_lineBd=ClassInstance.getInstance("bagUI_line");
			
			_title=new TextField();
			_title.width=TXT_WIDTH;
			_title.multiline=false;
			_title.wordWrap=false;
			_title.filters=FilterConfig.Black_name_filter;
			_title.autoSize=TextFieldAutoSize.LEFT;
			addChild(_title);
			
			_txt1=new TextField();	
			_txt1.width=180;
			_txt1.wordWrap=true;
			_txt1.autoSize=TextFieldAutoSize.LEFT;
			_txt1.filters=FilterConfig.Black_name_filter;
			_txt1.multiline=true;
			addChild(_txt1);
			
			_levelTxt=new TextField();	
			_levelTxt.width=TXT_WIDTH;
			_levelTxt.wordWrap=true;
			_levelTxt.autoSize=TextFieldAutoSize.LEFT;
			_levelTxt.filters=FilterConfig.Black_name_filter;
			_levelTxt.multiline=true;
			addChild(_levelTxt);
			
			_line1=new Bitmap(_lineBd.clone());
			addChild(_line1);
			
			_txt2=new TextField();
			_txt2.width=TXT_WIDTH;
			_txt2.wordWrap=true;
			_txt2.autoSize=TextFieldAutoSize.LEFT;
			_txt2.filters=FilterConfig.Black_name_filter;
			_txt2.multiline=true;
			addChild(_txt2);
			
			_line2=new Bitmap(_lineBd.clone());
			addChild(_line2);
			
			_txt3=new TextField();
			_txt3.width=TXT_WIDTH;
			_txt3.wordWrap=true;
			_txt3.autoSize=TextFieldAutoSize.LEFT;
			_txt3.filters=FilterConfig.Black_name_filter;
			_txt3.multiline=true;
			addChild(_txt3);
			
			bgWidth=GAP_X*2+TXT_WIDTH;
			
			_icon=new Sprite();
			addChild(_icon);
			
		}
		/**
		 * 0：动态id;1:模板id
		 * @param args 
		 * 
		 */		
		public function setTip(args:Array):void
		{
			disposeContent();
			
			var propsId:int=args[0];
			var tempId:int=args[1];
			
			_template=PropsBasicManager.Instance.getPropsBasicVo(tempId);
			
			if(propsId != 0)
				_obtainTime=PropsDyManager.instance.getPropsInfo(propsId).obtain_time;
			
			setTitle();
			
			setIcon();		
			
			setTxt1();//绑定,类型
			
			setLevel();//使用等级
			
			_line1.x=(bgWidth-_line1.width)/2;
			_line1.y=_levelTxt.y+_levelTxt.height+PARA_OUT;
			
			setTxt2();//效果描述
			
			_line2.x=(bgWidth-_line2.width)/2;
			_line2.y=_txt2.y+_txt2.height+PARA_OUT;
			
			setTxt3();//道具简介，剩余时间，商店收购价，使用说明
			
			_mc.height=_txt3.y + _txt3.height + GAP_X;
			_mc.width=bgWidth;		
			
			
		}
		
		
		
		//======================================================================
		//        function
		//======================================================================
		
		//======================================================================
		//        private function
		//======================================================================
		private function setTitle():void
		{
			var color:String=PropsDyManager.getQualityColor(_template.quality);
			_title.htmlText=createLineHtml(_template.name,color,TITLE_SIZE);
			
			_title.x=GAP_X;
			_title.y=GAP_X;
			
		}
		
		private function setIcon():void
		{		
			IconLoader.initLoader(PropsBasicManager.Instance.getURL(_template.template_id),_icon);
			_icon.x=GAP_X;
			_icon.y=_title.y+_title.height+PARA_OUT;
		}
		
		private function setTxt1():void
		{
			var str:String="";
			var html:String='';
			
			if(_template.binding_type == TypeProps.BIND_TYPE_NO)
				str = "物品未绑定";
			else if(_template.binding_type == TypeProps.BIND_TYPE_YES)
				str = "物品已绑定";
			html += createLineHtml(str,'fed100')+"<br>";

			html += createLineHtml("道具类型："+_template.show_type,'fed100');
			
			_txt1.htmlText=createParagraphHtml(html,LEADING);
			_txt1.x=GAP_X+43;//不能用icon来定位，因为加载慢的话位置就错了
			_txt1.y=_title.y+_title.height+PARA_OUT;
			
		}
		
		private function setLevel():void
		{	
			var str:String="";
			
			str += createLineHtml("使用等级："+_template.level.toString(),'D6CC91');
			_levelTxt.htmlText=createParagraphHtml(str,LEADING);
			
			_levelTxt.x=GAP_X;
			_levelTxt.y=_txt1.y+_txt1.height+PARA_OUT+2;
		}
		
		//效果说明
		private function setTxt2():void
		{
			_txt2.htmlText=createParagraphHtml(createLineHtml(_template.effect_desc,'009cff'),LEADING);
			_txt2.x=GAP_X;
			_txt2.y=_line1.y+_line1.height+PARA_OUT;
		}
		
		//道具简介，剩余时间，商店收购价，使用说明
		private function setTxt3():void
		{
			var html:String='';
			
			html += createLineHtml(_template.describe,'D6CC91')+"<br>";
			
			html += setTime();
			
			//还要做商店界面是否打开的判断
			if(ModuleManager.moduleShop.isNPCShopOpened == false || _template.sell_price == -1)
				html += "";
			else
				html += createLineHtml("商店收购价："+_template.sell_price.toString(),'fe7e00')+"<br>";
			
			html += createLineHtml(_template.use_desc,'D6CC91');
			
			_txt3.htmlText=createParagraphHtml(html,LEADING);
			
			_txt3.x=GAP_X;
			_txt3.y=_line2.y+_line2.height+PARA_OUT;
			
		}
		
		private function setTime():String
		{
			//这个地方以后要做个算具体时间的定时器时间格式：剩余时间：*天*时*分*秒
			//截止日期：*年*月*日00:00:00
			if(_template.deadline != 0)
			{
				return createLineHtml("截止时间："+_template.deadline.toString(),'08df12')+"<br>";			
			}
			else if(_template.remain_time != 0 && _obtainTime != 0)
			{
				var time:int=_template.remain_time-_obtainTime;
				return createLineHtml("剩余时间："+time.toString(),'08df12')+"<br>";
			}
			else
				return "";
			
		}
		
		private function createLineHtml(str:String,color:String,size:int=FONT_SIZE):String
		{
			return HTMLUtil.createHtmlText(str,size,color);
		}
		private function createParagraphHtml(str:String,leading:int):String
		{
			var html:String="<textformat leading=\'" + leading + "\'><p indent='10' align='left'>"+str+"</p></textformat>";
			return html;
		}
		
		private function disposeContent():void
		{
			if(_icon.numChildren >0)
				_icon.removeChildAt(0);
		}
		//======================================================================
		//        event handler
		//======================================================================
		
		//======================================================================
		//        getter&setter
		//======================================================================
		
		
	}
} 