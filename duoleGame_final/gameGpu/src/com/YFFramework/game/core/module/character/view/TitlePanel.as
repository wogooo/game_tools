package com.YFFramework.game.core.module.character.view
{
	import com.YFFramework.core.event.YFEventCenter;
	import com.YFFramework.game.core.global.event.GlobalEvent;
	import com.YFFramework.game.core.global.util.TypeProps;
	import com.YFFramework.game.core.module.character.model.TitleBasicManager;
	import com.YFFramework.game.core.module.character.model.TitleBasicVo;
	import com.YFFramework.game.core.module.character.model.TitleDyManager;
	import com.YFFramework.game.core.module.character.view.simpleView.TitlePageControl;
	import com.YFFramework.game.core.module.character.view.simpleView.TitleSelection;
	import com.dolo.ui.controls.CheckBox;
	import com.dolo.ui.controls.ToggleButton;
	import com.dolo.ui.tools.Xdis;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;

	/**
	 * @author jina;
	 * @version 1.0.0
	 * creation time：2013-11-20 下午1:32:06
	 */
	public class TitlePanel
	{
		//======================================================================
		//       public property
		//======================================================================
		
		//======================================================================
		//       private property
		//======================================================================
		private var _mc:MovieClip;
		
		private var _titleName:TextField;
		private var _hideTitle:CheckBox;
		private var _attrs:Vector.<TextField>;		
		private var _pageControl:TitlePageControl;
		private var _title1:ToggleButton;
		private var _title2:ToggleButton;
		private var _title3:ToggleButton;
		private var _title4:ToggleButton;
		private var _title5:ToggleButton;
		private var _titleBtns:Array;
		//======================================================================
		//        constructor
		//======================================================================
		
		public function TitlePanel(mc:MovieClip)
		{
			_mc=mc;
			
			_titleName=Xdis.getChild(_mc,"titleName");
			_hideTitle=Xdis.getChild(_mc,"hide_checkBox");
			_hideTitle.selected=false;
			_hideTitle.addEventListener(MouseEvent.CLICK,hideClick);
			
			_attrs=new Vector.<TextField>();
			for(var i:int=0;i<8;i++)
			{
				_attrs.push(Xdis.getChild(_mc,"attrValue"+i));
			}
			
			_pageControl=new TitlePageControl(Xdis.getChild(_mc,"pageControl"));
			
			var select:TitleSelection;
			var str:String;
			var titleMc:MovieClip;
			for(i=1;i<=5;i++)
			{
				titleMc=Xdis.getChild(_mc,"title"+i);
				titleMc.mouseEnabled=false;
				titleMc.mouseChildren=false;
			}
			
			_title1= Xdis.getChild(_mc,"title1_toggleButton");
			_title1.alwaysSelectedEffect=true;
			_title1.addEventListener(Event.CHANGE,titleTypeChange1);
			
			_title2= Xdis.getChild(_mc,"title2_toggleButton");
			_title2.alwaysSelectedEffect=true;
			_title2.addEventListener(Event.CHANGE,titleTypeChange2);
			
			_title3= Xdis.getChild(_mc,"title3_toggleButton");
			_title3.alwaysSelectedEffect=true;
			_title3.addEventListener(Event.CHANGE,titleTypeChange3);
			
			_title4= Xdis.getChild(_mc,"title4_toggleButton");
			_title4.alwaysSelectedEffect=true;
			_title4.addEventListener(Event.CHANGE,titleTypeChange4);
			
			_title5= Xdis.getChild(_mc,"title5_toggleButton");
			_title5.alwaysSelectedEffect=true;
			_title5.addEventListener(Event.CHANGE,titleTypeChange5);
			
			_titleBtns=[,_title1,_title2,_title3,_title4,_title5];
		}
		
		//======================================================================
		//        public function
		//======================================================================
		public function initTitleList():void
		{
			_title1.selected=true;
			btnsDisable(1);
			updateAttr();
		}
		/** 更行某个分类的全部称号 */
		public function updateTitleType(type:int=1):void
		{
			_pageControl.updateList(type);
			updateAttr();
		}
		
		/** 改变自己的称号 */
		public function updateMyTitle():void
		{
			var titleId:int=TitleDyManager.instance.curTitleId;
			_hideTitle.selected=false;
			if(titleId > 0)
			{
				_titleName.text=TitleBasicManager.Instance.getTitleBasicVo(titleId).name;
				_hideTitle.enabled=true;
			}
			else
			{
				_titleName.text='';
				_hideTitle.enabled=false;
			}
		}
		//======================================================================
		//        private function
		//======================================================================
		private function hideClick(e:MouseEvent):void
		{
			var hide:Boolean=_hideTitle.selected;//选中就是隐藏（true）
			YFEventCenter.Instance.dispatchEventWith(GlobalEvent.TITLE_HIDE,hide);
		}
		
		private function titleTypeChange1(e:Event):void
		{
			if(_title1.selected)
			{
				_pageControl.updateList(1);
				btnsDisable(1);
			}
		}
		
		private function titleTypeChange2(e:Event):void
		{
			if(_title2.selected)
			{
				_pageControl.updateList(2);
				btnsDisable(2);
			}
		}
		
		private function titleTypeChange3(e:Event):void
		{
			if(_title3.selected)
			{
				_pageControl.updateList(3);
				btnsDisable(3);
			}
		}
		
		private function titleTypeChange4(e:Event):void
		{
			if(_title4.selected)
			{
				_pageControl.updateList(4);
				btnsDisable(4);
			}
		}
		
		private function titleTypeChange5(e:Event):void
		{
			if(_title5.selected)
			{
				_pageControl.updateList(5);
				btnsDisable(5);
			}
		}
		
		private function btnsDisable(index:int):void
		{
			for(var i:int=1;i<=5;i++)
			{
				if(i != index)
					_titleBtns[i].selected=false;
			}
		}
		
		private function updateAttr():void
		{
			var ary:Array=TitleDyManager.instance.getAllTitleData();
			var hp:int=0;//生命
			var phyAtr:int=0;//物理攻击
			var mp:int=0;//魔法
			var mAtr:int=0;//魔法攻击
			var pstr:int=0;//物理穿透
			var phyde:int=0;//物理防御
			var mst:int=0;//魔法穿透
			var madef:int=0;//魔法防御			
			for each(var vo:TitleBasicVo in ary)
			{
				if(vo.attr_id == TypeProps.EA_HEALTH_LIMIT)
					hp += vo.attr_value;
				else if(vo.attr_id == TypeProps.EA_PHYSIC_ATK)
					phyAtr += vo.attr_value;
				else if(vo.attr_id == TypeProps.EA_MANA_LIMIT)
					mp += vo.attr_value;
				else if(vo.attr_id == TypeProps.EA_MAGIC_ATK)
					mAtr += vo.attr_value;
				if(vo.attr_id == TypeProps.EA_PSTRIKE)
					pstr += vo.attr_value;
				else if(vo.attr_id == TypeProps.EA_PHYSIC_DEFENSE)
					phyde += vo.attr_value;
				if(vo.attr_id == TypeProps.EA_MSTRIKE)
					mst += vo.attr_value;
				else if(vo.attr_id == TypeProps.EA_MAGIC_DEFENSE)
					madef += vo.attr_value;
			}
			var attrAry:Array=[hp,phyAtr,mp,mAtr,pstr,phyde,mst,madef];
			for(var i:int=0;i<8;i++)
			{
				_attrs[i].text='+'+attrAry[i].toString();
			}
		}
		//======================================================================
		//        event handler
		//======================================================================
		
		//======================================================================
		//        getter&setter
		//======================================================================
		
		
	}
} 