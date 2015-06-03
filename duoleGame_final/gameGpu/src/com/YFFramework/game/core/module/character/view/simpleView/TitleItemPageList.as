package com.YFFramework.game.core.module.character.view.simpleView
{
	/**
	 * @author jina;
	 * @version 1.0.0
	 * creation time：2013-11-21 上午10:20:08
	 */
	import com.YFFramework.game.core.global.util.TypeProps;
	import com.YFFramework.game.core.module.ModuleManager;
	import com.YFFramework.game.core.module.character.model.TitleBasicVo;
	import com.YFFramework.game.core.module.character.model.TitleDyManager;
	import com.dolo.common.PageItemListBase;
	import com.dolo.ui.controls.RadioButton;
	import com.dolo.ui.tools.Xdis;
	
	import flash.display.Sprite;
	import flash.text.TextField;
	
	public class TitleItemPageList extends PageItemListBase
	{
		//======================================================================
		//       public property
		//======================================================================
		
		//======================================================================
		//       private property
		//======================================================================
		
		//======================================================================
		//        constructor
		//======================================================================
		
		public function TitleItemPageList()
		{
			super();
		}
		
		//======================================================================
		//        public function
		//======================================================================
		override protected function initItem(data:Object,view:Sprite,index:int):void
		{
			var titleName:TextField=Xdis.getChild(view,"titleName");
			var putOn:RadioButton=Xdis.getChild(view,"putOn_radioButton");
			var attrName:TextField=Xdis.getChild(view,"attrName");
			var attrValue:TextField=Xdis.getChild(view,"attrValue");
			var condition:TextField=Xdis.getChild(view,"condition");
			var condi:TextField=Xdis.getChild(view,"conditionTxt");
			
			var titleVo:TitleBasicVo=data as TitleBasicVo;
			if(TitleDyManager.instance.getTitle(titleVo.title_id)==null)
			{
				putOn.selected=false;
				titleName.textColor=0x666666;
				putOn.enabled=false;
				attrName.textColor=0x666666;
				attrValue.textColor=0x666666;
//				condition.textColor=0x666666;
//				condi.textColor=0x666666;
			}
			else//在已得到称号列表
			{
				titleName.textColor=0xfff0b6;
				putOn.enabled=true;
				if(TitleDyManager.instance.curTitleId == titleVo.title_id)//且是当然选中的称号
					putOn.selected=true;
				else
					putOn.selected=false;
				attrName.textColor=0xfff0b6;
				attrValue.textColor=0xfff0b6;
//				condition.textColor=0x8cf213;
//				condi.textColor=0xfff0b6;
			}
			titleName.text=titleVo.name;
			attrName.text=TypeProps.getAttrName(titleVo.attr_id)+"：";
			attrValue.text='+'+titleVo.attr_value.toString();
			condition.text=titleVo.title_condition;
		}
		
		override protected function onItemClick(view:Sprite,vo:Object,index:int):void
		{
			var titleVo:TitleBasicVo=vo as TitleBasicVo;
			if(TitleDyManager.instance.getTitle(titleVo.title_id))
			{
				if(titleVo.title_id != TitleDyManager.instance.curTitleId)//如果id一样（点击是同一个称号）就不向服务器请求
				{
					ModuleManager.moduleCharacter.useTitleReq(titleVo.title_id);
				}
			}
		}
		//======================================================================
		//        private function
		//======================================================================
		
		//======================================================================
		//        event handler
		//======================================================================
		
		//======================================================================
		//        getter&setter
		//======================================================================
		
		
	}
} 