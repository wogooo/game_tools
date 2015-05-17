package com.YFFramework.game.core.module.bag.baseClass
{
	/**
	 * @version 1.0.0
	 * creation time：2012-11-29 下午03:40:51
	 * 
	 */
	
	import com.YFFramework.core.debug.print;
	import com.YFFramework.core.net.loader.image_swf.UILoader;
	import com.YFFramework.core.ui.yfComponent.controls.YFCD;
	import com.YFFramework.core.utils.common.ClassInstance;
	import com.YFFramework.game.core.global.MouseManager;
	import com.YFFramework.game.core.global.MouseStyle;
	import com.YFFramework.game.core.global.manager.EquipBasicManager;
	import com.YFFramework.game.core.global.manager.EquipDyManager;
	import com.YFFramework.game.core.global.manager.PropsBasicManager;
	import com.YFFramework.game.core.global.manager.PropsDyManager;
	import com.YFFramework.game.core.global.model.EquipDyVo;
	import com.YFFramework.game.core.global.model.ItemDyVo;
	import com.YFFramework.game.core.global.model.PropsBasicVo;
	import com.YFFramework.game.core.global.model.PropsDyVo;
	import com.YFFramework.game.core.global.util.FilterConfig;
	import com.YFFramework.game.core.global.util.TypeProps;
	import com.YFFramework.game.core.global.view.tips.EquipTip;
	import com.YFFramework.game.core.global.view.tips.PropsTip;
	import com.YFFramework.game.core.global.view.tips.TipUtil;
	import com.YFFramework.game.core.module.bag.event.BagEvent;
	import com.YFFramework.game.core.module.bag.source.PackSource;
	import com.dolo.ui.controls.IconImage;
	import com.dolo.ui.managers.UI;
	import com.dolo.ui.tools.MovieClipButton;
	import com.dolo.ui.tools.Xtip;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	
	public class BagGrid extends Sprite
	{
		//======================================================================
		//        const variable
		//======================================================================
		private const ICON_SIZE:int=40;
		//======================================================================
		//        static variable
		//======================================================================
		
		//======================================================================
		//        variable
		//======================================================================
		private var _bg:MovieClip;
		private var _cover:MovieClip;//关闭
		
		protected var _info:ItemDyVo;
		
		private var _propsInfo:PropsDyVo;
		private var _equipInfo:EquipDyVo;
		
		private var _bound:Bitmap;
		
		private var _boxType:int;
		private var tf:TextField;
		
		private var _actualPos:int=0;
		private var _selected:Boolean=false;
		
		private var _iconImage:IconImage;
		private var _cd:YFCD;
		
		//======================================================================
		//        constructor
		//======================================================================
		public function BagGrid()
		{
			this.scrollRect=new Rectangle(0,0,42,42);
			
			_bg=ClassInstance.getInstance("bagUI_bg2") as MovieClip;
			addChild(_bg);
			
			_iconImage= new IconImage();
			_iconImage.x=1;
			_iconImage.y=1;
			addChild(_iconImage);
			
			_cover=ClassInstance.getInstance("bagUI_bagCover") as MovieClip;	
			
			tf=new TextField();
			tf.mouseEnabled=false;
			tf.filters=FilterConfig.Black_name_filter;
			tf.textColor=0xFFFF00;
			tf.autoSize=TextFieldAutoSize.RIGHT;
			tf.multiline=false;
			
			_cd=new YFCD(ICON_SIZE,ICON_SIZE);
			_cd.mouseChildren=false;
			_cd.mouseEnabled=false;
			
			addEventListener(MouseEvent.MOUSE_DOWN,onMouseDownHandler);
			addEventListener(MouseEvent.ROLL_OVER,rollOverHandler);
			addEventListener(MouseEvent.ROLL_OUT,rollOutHandler);
			
			this.mouseChildren=false;

		}
		
		//======================================================================
		//        function
		//======================================================================
		public function setContent(info:ItemDyVo):void
		{
			_info=info;
			actualPos=info.pos;//灵活使用
			
			var iconLoader:UILoader=new UILoader();
			if(_info.type == TypeProps.ITEM_TYPE_PROPS)
			{
				_propsInfo=PropsDyManager.instance.getPropsInfo(info.id);//服务器发来的
				if(_propsInfo)
				{
					_iconImage.url = PropsBasicManager.Instance.getURL(_propsInfo.templateId);				
					if(PropsBasicManager.Instance.getPropsBasicVo(_propsInfo.templateId).binding_type == TypeProps.BIND_TYPE_YES)
					{
						_bound=new Bitmap(ClassInstance.getInstance("bagUI_lock") as BitmapData);
						addChild(_bound);
						_bound.x=1;
						_bound.y=1;
					}									
					
					if(_propsInfo.quantity >1)
					{
						tf.text=_propsInfo.quantity.toString();					
						tf.x=ICON_SIZE*0.65;
						tf.y=ICON_SIZE*0.65;
						addChild(tf);
					}		

					addChild(_cd);
//					this.addEventListener(MouseEvent.ROLL_OUT,onMeRollOut);
					Xtip.registerLinkTip(this,PropsTip,TipUtil.propsTipInitFunc,_propsInfo.propsId,_propsInfo.templateId);
				}
					
			}
			else if(_info.type == TypeProps.ITEM_TYPE_EQUIP)
			{
				_equipInfo=EquipDyManager.instance.getEquipInfo(_info.id);
				if(_equipInfo)
				{
					_iconImage.url = EquipBasicManager.Instance.getURL(_equipInfo.template_id);
					Xtip.registerLinkTip(this,EquipTip,TipUtil.equipTipInitFunc,_equipInfo.equip_id,_equipInfo.template_id);
				}
			}
			
		}
		
		public function openGrid():void
		{
			if(cover.parent)
				cover.parent.removeChild(cover);
		}
		
		public function closeGrid():void
		{
			addChild(_cover);
		}

		public function highLight():void
		{
			_iconImage.filters=FilterConfig.white_glow_filter;
		}
		
		public function clearFilter():void
		{
			_iconImage.filters=null;
		}
		
		public function playCd():void
		{
			var template:PropsBasicVo=PropsBasicManager.Instance.getPropsBasicVo(_propsInfo.templateId);
			_cd.play(template.cd_time);
			_cd.start();
		}
		
		public function changePropsNum(num:int):void
		{
			tf.text=num.toString();
		}
		
		public function setExtendGridTxt(txt:String):void
		{
			if(cover.visible)
			{
				cover.txt.text=txt;
			}
		}
		
		public function clearTxt():void
		{
			cover.txt.text="";
		}
		
		public function disposeContent():void
		{		
			if(tf)
			{
				tf.text="";
				if(tf.parent)
					tf.parent.removeChild(tf);
			}
			_iconImage.clear();
			if(_bound)
			{
				if(_bound.parent)
					_bound.parent.removeChild(_bound);
				_bound=null;
			}
			_info=null;
			//求千万别清除id
			Xtip.clearLinkTip(this);
			clearFilter();
		}	

		public function dispose():void
		{
			disposeContent();
			removeEventListener(MouseEvent.MOUSE_DOWN,onMouseDownHandler);
			removeEventListener(MouseEvent.ROLL_OVER,rollOverHandler);
			removeEventListener(MouseEvent.ROLL_OUT,rollOutHandler);
			_cd.dispose();
			if(_cd.parent)
				removeChild(_cd);
		}
		//======================================================================
		//        private function
		//======================================================================
		private function bgHighLight():void
		{
			_bg.filters=FilterConfig.white_glow_filter;
		}
		
		private function bgClearFilter():void
		{
			_bg.filters=[];
		}
		
		private function getCoverVisible():Boolean
		{
			if(_cover.parent)
				return true;
			else
				return false;
		}
		//======================================================================
		//        event handler
		//======================================================================
		protected function onMouseDownHandler(e:MouseEvent):void
		{
			if(_info != null)
			{
				dispatchEvent(new BagEvent(BagEvent.HIGH_LIGHT,info.pos,true));
			}
		}
		protected function rollOverHandler(e:MouseEvent):void
		{
			if(getCoverVisible() == false)
			{
				if(info)
					highLight();
				else
					bgHighLight();
				
				if(info)
				{
					if(PackSource.shopSell)
					{
						MouseManager.changeMouse(MouseStyle.SELL);
					}
					else if(PackSource.shopMend && info.type == TypeProps.ITEM_TYPE_EQUIP)
					{
						MouseManager.changeMouse(MouseStyle.FIX);
					}
				}
			}	

		}
		protected function rollOutHandler(e:MouseEvent):void
		{
			if(selected == false)
			{
				if(info)
					clearFilter();
				else
					bgClearFilter();
				MouseManager.resetToDefaultMouse();
			}
			
		}

		//======================================================================
		//        getter&setter
		//======================================================================		
		public function get cover():MovieClip
		{
			return _cover;
		}
		
		public function get info():ItemDyVo
		{
			return _info;
		}

		public function set boxType(boxType:int):void
		{
			this._boxType=boxType;
		}
		
		public function get boxType():int
		{
			return _boxType;
		}

		public function get actualPos():int
		{
			return _actualPos;
		}

		public function set actualPos(value:int):void
		{
			_actualPos = value;
		}
		
		public function get selected():Boolean
		{
			return _selected;
		}

		public function set selected(value:Boolean):void
		{
			_selected = value;
		}
		

	}
} 