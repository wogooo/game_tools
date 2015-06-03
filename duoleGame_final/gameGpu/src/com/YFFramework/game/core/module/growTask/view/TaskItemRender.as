package com.YFFramework.game.core.module.growTask.view
{
	import com.YFFramework.core.text.HTMLUtil;
	import com.YFFramework.game.core.global.util.FilterConfig;
	import com.YFFramework.game.core.global.util.TypeProps;
	import com.YFFramework.game.core.module.growTask.source.GrowTaskSource;
	import com.dolo.ui.renders.ListRenderBase;
	import com.dolo.ui.tools.AutoBuild;
	import com.dolo.ui.tools.Xdis;
	
	import flash.text.TextField;

	/**
	 * @version 1.0.0
	 * creation time：2013-7-16 下午5:31:37
	 */
	public class TaskItemRender extends ListRenderBase{
		
		private var _descTxt:TextField;
		
		public function TaskItemRender(){
			renderHeight = 30;
			renderWidth = 185;
		}
		
		override protected function resetLinkage():void{
			_linkage = "uiSkin.GrowTaskItem";
		}
		
		override protected function onLinkageComplete():void{
			AutoBuild.replaceAll(_ui);
			_descTxt = Xdis.getChild(_ui,"descTxt");
		}
		
		override protected function updateView(item:Object):void{
			_descTxt.htmlText = HTMLUtil.createHtmlText(item.desc,12,"FFF0B6","_sans");
			_descTxt.mouseEnabled=false;
			if(item.status==GrowTaskSource.GROW_TASK_FINISHED){
				_descTxt.htmlText += HTMLUtil.createHtmlText("(已完成)",12,"00CC00","_sans");
			}
		}
		
		override public function setSize(newWidth:Number, newHeight:Number):void{
		}
		
		/**清除对象 
		 */		
		override public function dispose():void{
			super.dispose();
			_descTxt=null;
		}
	}
} 