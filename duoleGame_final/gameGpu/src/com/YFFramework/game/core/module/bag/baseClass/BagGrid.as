package com.YFFramework.game.core.module.bag.baseClass
{
	/**
	 * @version 1.0.0
	 * creation time：2012-11-29 下午03:40:51
	 * 
	 */
	
	import com.YFFramework.core.ui.abs.AbsView;
	import com.YFFramework.core.ui.yfComponent.controls.YFCD;
	import com.YFFramework.core.utils.common.ClassInstance;
	import com.YFFramework.game.core.global.DataCenter;
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
	import com.YFFramework.game.core.global.view.tips.EquipTipMix;
	import com.YFFramework.game.core.global.view.tips.OpenCellTip;
	import com.YFFramework.game.core.global.view.tips.PropsTip;
	import com.YFFramework.game.core.global.view.tips.TipUtil;
	import com.YFFramework.game.core.module.bag.backPack.OpenBagGridManager;
	import com.YFFramework.game.core.module.bag.data.BagStoreManager;
	import com.YFFramework.game.core.module.market.source.MarketSource;
	import com.YFFramework.game.core.module.trade.manager.TradeDyManager;
	import com.dolo.ui.controls.BitmapControl;
	import com.dolo.ui.controls.IconImage;
	import com.dolo.ui.managers.UI;
	import com.dolo.ui.skin.Skins;
	import com.dolo.ui.tools.Xtip;
	
	import flash.display.Bitmap;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	
	public class BagGrid extends AbsView
	{
		//======================================================================
		//        const variable
		//======================================================================
		private const ICON_SIZE:int=42;
		//======================================================================
		//        static variable
		//======================================================================
		
		//======================================================================
		//        variable
		//======================================================================
		private var _bg:BitmapControl;
		private var _cover:MovieClip;//关闭
		
		private var _info:ItemDyVo;
		
		protected var _propsInfo:PropsDyVo;
		protected var _equipInfo:EquipDyVo;
		
		private var _bound:Sprite;
//		private var _nonTrade:Boolean=false;
//		private var _locked:Boolean=false;
		
		private var _boxType:int;
		private var _tf:TextField;
		
		private var _actualPos:int=0;
		private var _selected:Boolean=false;
		
		private var _iconImage:IconImage;
		private var _cd:YFCD;
		private var _closeCd:YFCD;
		
		private var _equipMask:Sprite;
		
		private var _nonTradeMask:Bitmap;//不可交易\寄售的蒙版
		private var _lockMask:Sprite;//锁定蒙版
		//======================================================================
		//        constructor
		//======================================================================
		
		public function BagGrid()
		{
		}
		

		
		//======================================================================
		//        function
		//======================================================================
		public function setContent(info:ItemDyVo):void
		{
			initGrid();
			
			_info=info;
			actualPos=info.pos;//灵活使用
			
			_bg = new BitmapControl(Skins.bagGridSkin,_info.pos);
			_bg.setXYOffset(-4,-4);
			addChildAt(_bg,0);
			
			if(_info.type == TypeProps.ITEM_TYPE_PROPS)
			{
				_propsInfo=PropsDyManager.instance.getPropsInfo(info.id);//服务器发来的
				if(_propsInfo)
				{
					_iconImage.url = PropsBasicManager.Instance.getURL(_propsInfo.templateId);				
					if(_propsInfo.binding_type == TypeProps.BIND_TYPE_YES)
						_bound.visible=true;
					else
						_bound.visible=false;
					
					if(_propsInfo.quantity >1)
					{
						_tf.text=_propsInfo.quantity.toString();					
						_tf.visible=true;
						_tf.x=ICON_SIZE-_tf.width;
						_tf.y=ICON_SIZE-_tf.height;
					}
					else
						_tf.visible=false;
					
					addChild(_cd);
					
					Xtip.registerLinkTip(this,PropsTip,TipUtil.propsTipInitFunc,_propsInfo.propsId,_propsInfo.templateId);
				}
					
			}
			else
			{
				_tf.visible=false;
				
				_equipInfo=EquipDyManager.instance.getEquipInfo(_info.id);
				if(_equipInfo)
				{
					if(_equipInfo.binding_type == TypeProps.BIND_TYPE_YES)
					{
						_bound.visible=true;
					}
					else
					{
						_bound.visible=false;
					}
					_iconImage.url = EquipBasicManager.Instance.getURL(_equipInfo.template_id);
					
					if(DataCenter.Instance.roleSelfVo.roleDyVo.career != EquipBasicManager.Instance.getEquipBasicVo(_equipInfo.template_id).career)
					{
						if(TradeDyManager.isTrading == false && MarketSource.ConsignmentStatus == false)
							changeEquipStatus(true);
					}
					
					Xtip.registerLinkTip(this,EquipTipMix,TipUtil.equipTipInitFunc,_equipInfo.equip_id,_equipInfo.template_id);
				}
			}
			
			_bg.followTargetMouse(_iconImage);
			
			if(TradeDyManager.isTrading || MarketSource.ConsignmentStatus)
			{
				setBoundStatus();
			}
		}
		
		/**
		 * 专门为回购列表初始格子的方法 ,和setContent方法互斥
		 * @param info
		 * 
		 */		
		public function setBackGridContent(obj:Object):void
		{
			initGrid();
			
			_bg = new BitmapControl(Skins.bagGridSkin,0,false);
			_bg.setXYOffset(-4,-4);
			addChildAt(_bg,0);
			
			
			if(obj.type == TypeProps.ITEM_TYPE_PROPS)
			{
				_propsInfo=obj.info as PropsDyVo;
				
				_info=new ItemDyVo(0,TypeProps.ITEM_TYPE_PROPS,_propsInfo.propsId);
				
				_iconImage.url = PropsBasicManager.Instance.getURL(_propsInfo.templateId);
				if(_propsInfo.binding_type == TypeProps.BIND_TYPE_YES)
				{
					_bound.visible=true;
				}
				else
				{
					_bound.visible=false;
				}
				
				if(_propsInfo.quantity >1)
				{
					_tf.text=_propsInfo.quantity.toString();					
					_tf.visible=true;
					_tf.x=ICON_SIZE-_tf.width;
					_tf.y=ICON_SIZE-_tf.height;
				}
				else
					_tf.visible=false;
				
				Xtip.registerLinkTip(this,PropsTip,TipUtil.propsTipInitFunc,0,_propsInfo.templateId,_propsInfo);
			}
			else
			{
				_tf.visible=false;
//				_bound.visible=false;
				
				_equipInfo=obj.info as EquipDyVo;
				_info=new ItemDyVo(0,TypeProps.ITEM_TYPE_EQUIP,_equipInfo.equip_id);
//				if(_equipInfo)
//				{
					if(_equipInfo.binding_type == TypeProps.BIND_TYPE_YES)
					{
						_bound.visible=true;
					}
					else
					{
						_bound.visible=false;
					}
					_iconImage.url = EquipBasicManager.Instance.getURL(_equipInfo.template_id);
					
					Xtip.registerLinkTip(this,EquipTipMix,TipUtil.equipTipInitFunc,0,_equipInfo.template_id,false,_equipInfo);
//				}
					
			}
			_bg.followTargetMouse(_iconImage);	
		}
		
		public function openGrid():void
		{
			_bg = new BitmapControl(Skins.bagGridSkin,0,false);
			_bg.setXYOffset(-4,-4);
			addChild(_bg);
			
			clearCover();
			
			addEvent();
//			removeEventListener(MouseEvent.MOUSE_DOWN,onMouseDownHandler);
		}
		
		/** 看清楚了，对于关闭的格子，没有信息，只是显示在哪而已 */
		public function closeGrid():void
		{
			_cover=ClassInstance.getInstance("bagUI_bagCover") as MovieClip;
			TextField(_cover.txt).selectable=false;
			addChild(_cover);
			clearBg();
		}
		
		/************************************使用道具cd处理方法***********************************/
		
		/** 开始道具cd */
		public function playCd():void
		{
			var template:PropsBasicVo=PropsBasicManager.Instance.getPropsBasicVo(_propsInfo.templateId);
			_cd.play(template.cd_time,0);
			_cd.start();
			BagStoreManager.instantce.addCd(template.cd_type,_cd);
		}
		
		/** 重置道具cd */
		public function resetCd(cd:YFCD=null):void
		{
			if(_cd) 
			{
				if(_cd.parent) _cd.parent.removeChild(_cd);
				_cd.dispose();
			}
			_cd=cd;
			addChild(_cd);
		}
		
		/************************************时间开启格子cd处理方法（类似使用道具cd）********************************/		
		/** 按照时间开启关闭的格子 */
		public function playCloseCd():void
		{ 
			clearCloseCd();
			_closeCd=OpenBagGridManager.instance.cd.clone();
			addChild(_closeCd);
			Xtip.registerLinkTip(this,OpenCellTip,TipUtil.openCellInitFunc);
		}	

		/** 清除开启格子cd */
		public function clearCloseCd():void
		{
			if(_closeCd && _closeCd.parent)
				_closeCd.parent.removeChild(_closeCd);
		}
		/****************************************************************************/
		
		public function changePropsNum():void
		{
			if(_propsInfo && _propsInfo.quantity > 1)//不知道这里为什么会报空
			{
				_tf.visible=true;
				_tf.text=_propsInfo.quantity.toString();
				_tf.x=ICON_SIZE-_tf.width;
				_tf.y=ICON_SIZE-_tf.height;
			}
			else
				_tf.visible=false;
			
		}
		
		public function setExtendGridTxt(txt:String):void
		{
			if(_cover)
			{
				_cover.txt.text=txt;
			}
		}
		
		public function clearTxt():void
		{
			_cover.txt.text="";
		}
		
		/**
		 * 查看格子是否关闭，true就是关闭
		 * @return 
		 * 
		 */		
		public function getCoverStatus():Boolean
		{
			if(_cover)
				return true;
			else
				return false;
		}
		
		/**********************************************************************/
		
		/**
		 * 这个物品是否是锁定的 
		 * @return true:不锁定
		 * 
		 */		
		public function getLock():Boolean
		{
			if(info)
			{
				if(_lockMask != null)//不锁定
					return true;
				else
					return false;
			}
			return false;
		}
		
		public function getBound():Boolean
		{
			if(info)
			{
				if(_bound.visible)
					return true;
				else
					return false;
			}
			return false;
		}
		
		/**
		 * 锁定绑定物品格子，针对：寄售、交易
		 * @param nonTrade 
		 * 
		 */		
		public function setBoundStatus():void
		{		
			clearBoundStatus();

			if(_bound.visible && _nonTradeMask == null)
			{
				_nonTradeMask=new Bitmap(ClassInstance.getInstance("nonTrade"));
				_nonTradeMask.x=1;
				_nonTradeMask.y=1;
				addChild(_nonTradeMask);
			}
			
		}
		
		/** 
		 * 清除绑定物品模式，针对：寄售、交易
		 */		
		public function clearBoundStatus():void
		{
			if(_nonTradeMask)
			{
				if(_nonTradeMask.parent)
					_nonTradeMask.parent.removeChild(_nonTradeMask);
				_nonTradeMask=null;
			}
		}
		
		/*********************************************************************************/
		
		/** 
		 * 锁定某格子的效果
		 */		
		public function setLockGrid():void
		{
			if(_equipMask == null || _equipMask.parent == null)
			{
				_lockMask=ClassInstance.getInstance("bagUI_mask") as Sprite;//暂时用这个素材
				_lockMask.x=1;
				_lockMask.y=1;
				addChild(_lockMask);
			}		

		}
		
		public function unLockGrid():void
		{
			if(_lockMask)
			{
				if(_lockMask.parent)
				{
					_lockMask.parent.removeChild(_lockMask);
				}
				_lockMask=null;
			}
		}
		
		/**
		 * 是否显示职业不符装备的红色蒙版
		 * true-显示
		 * false-不显示
		 * @param clear
		 * 
		 */				
		public function changeEquipStatus(show:Boolean):void
		{
			clearEquipMask();
			if(show)
			{			
				if(DataCenter.Instance.roleSelfVo.roleDyVo.career != EquipBasicManager.Instance.getEquipBasicVo(_equipInfo.template_id).career)
				{
					_equipMask=ClassInstance.getInstance("bagUI_mask") as Sprite;
					_equipMask.x=1;
					_equipMask.y=1;
					_equipMask.mouseEnabled=false;
					addChild(_equipMask);
				}
			}
				
		}
		
		/** 改变道具装备绑定性
		 * @param type
		 */		
		public function changePropsEquipBound(type:int):void
		{
			if(type == TypeProps.ITEM_TYPE_EQUIP)
			{
				if(_equipInfo.binding_type == TypeProps.BIND_TYPE_YES)
					_bound.visible=true;
				else
					_bound.visible=false;
			}
			else
			{
				if(_propsInfo.binding_type == TypeProps.BIND_TYPE_YES)
					_bound.visible=true;
				else
					_bound.visible=false;
			}
		}
		
		public function disposeContent():void
		{
			//必须把所有的都清除，因为回购那边需要
			_info=null;
			
			Xtip.clearLinkTip(this);
			
			if(_iconImage)
			{
				_iconImage.clear();
				_bg.clearFollowTargetMouse(_iconImage);
				_bg.visible=false;
			}
			
			if(_bound)
			{
				if(_bound.parent)
				{
					_bound.parent.removeChild(_bound);
				}
				_bound=null;
			}
			if(_tf)
			{
				if(_tf.parent)
				{
					_tf.parent.removeChild(_tf);
				}
				_tf=null;
			}
			if(_cd)
			{
				if(_cd.parent)
					_cd.parent.removeChild(_cd);
			}
			if(_closeCd && _closeCd.parent)
			{
				_closeCd.parent.removeChild(_closeCd);
				_closeCd=null;
			}
			if(_equipMask)
			{
				if(_equipMask.parent)
					_equipMask.parent.removeChild(_equipMask);
				_equipMask=null;
			}

			clearBoundStatus();
			unLockGrid();
			
		}	

		override public function dispose(e:Event=null):void
		{
			disposeContent();
			_iconImage=null;
//			removeEventListener(MouseEvent.MOUSE_DOWN,onMouseDownHandler);
			_cd.dispose();
			UI.removeAllChilds(this);
		}
		//======================================================================
		//        private function
		//======================================================================
		private function initGrid():void
		{	
			_iconImage= new IconImage();
			_iconImage.x=2;
			_iconImage.y=2;
			addChild(_iconImage);
			
			//绑定和数字记得要重新显示
			_bound=ClassInstance.getInstance("lock") as Sprite;
			addChild(_bound);
			_bound.x=1;
			_bound.y=1;
			_bound.visible=false;
			
			_tf=new TextField();
			_tf.mouseEnabled=false;
			_tf.filters=FilterConfig.Black_name_filter;
			_tf.textColor=0xFFFF00;
			_tf.autoSize=TextFieldAutoSize.RIGHT;
			_tf.multiline=false;
			addChild(_tf);
//			_tf.x=ICON_SIZE*0.83;
//			_tf.y=ICON_SIZE*0.65;
			_tf.visible=false;
			
			_cd=new YFCD(ICON_SIZE,ICON_SIZE);
			_cd.mouseChildren=false;
			_cd.mouseEnabled=false;
			
//			addEvent();

		}
		
		private function addEvent():void
		{
//			addEventListener(MouseEvent.MOUSE_DOWN,onMouseDownHandler);
		}
		
		private function clearCover():void
		{
			if(_cover)
			{
				if(_cover.parent)
					_cover.parent.removeChild(_cover);
				_cover=null;
			}
		}
		
		private function clearBg():void
		{
			if(_bg)
			{
				_bg.dispose();
				_bg=null;
			}
		}
		
		private function clearEquipMask():void
		{
			if(_equipMask)
			{
				if(_equipMask.parent)
				{
					_equipMask.parent.removeChild(_equipMask);
				}
				_equipMask=null;
			}
		}
		//======================================================================
		//        event handler
		//======================================================================
//		protected function onMouseDownHandler(e:MouseEvent):void
//		{
//			if(_info != null)
//			{
//				if(boxType == TypeProps.STORAGE_TYPE_PACK)
//					YFEventCenter.Instance.dispatchEventWith(BagEvent.HIGH_LIGHT,info.pos);
//			}
//		}

		//======================================================================
		//        getter&setter
		//======================================================================			
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
			if(_selected == false)
				_bg.select=false;
		}

		public function get iconImage():IconImage
		{
			return _iconImage;
		}
		

	}
} 