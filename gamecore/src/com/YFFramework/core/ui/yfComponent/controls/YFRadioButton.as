package com.YFFramework.core.ui.yfComponent.controls
{
	/**  2012-6-29
	 *	@author yefeng
	 */
	import com.YFFramework.core.event.ParamEvent;
	import com.YFFramework.core.event.YFEvent;
	import com.YFFramework.core.ui.yfComponent.YFComponent;
	import com.YFFramework.core.ui.yfComponent.YFSkin;
	import com.YFFramework.core.ui.yfComponent.events.YFControlEvent;
	
	import flash.events.MouseEvent;
	
	/**该对象的父容器触发事件  new ParamEvent(YFControlEvent.SelectChange,this)   返回的  e.param 是一个选中的YFRadioButton对象
	 */	
	public class YFRadioButton extends YFCheckBox
	{
		public function YFRadioButton(txt:String="文本框",autoRemove:Boolean=false)
		{
			super(txt,2,autoRemove);
		}
		
		
		override protected function onMouseUp(e:MouseEvent):void
		{
			select=true;
		}
//		override protected function initSkin():void
//		{
//			_style=YFSkin.Instance.getStyle(YFSkin.RadioButton);
//			_selectMC=_style.link.select;
//			_unSelectMC=_style.link.unSelect;
//			_iconW=_style.link.iconW;
//			_iconH=_style.link.iconH;
//		}
//		
		override public function set select(value:Boolean):void
		{
			super.select=value;
			if(_select)
			{ ///其他的设为非选中状态
				var len:int=parent.numChildren;
				var child:YFRadioButton;
				for(var i:int=0;i!=len;++i)
				{
					child=parent.getChildAt(i) as YFRadioButton;
					if(child&&child!=this)
					{
						child.select=false;
					}
				}	
				parent.dispatchEvent(new ParamEvent(YFControlEvent.SelectChange,this));
			}
		}
		
		
	}
}