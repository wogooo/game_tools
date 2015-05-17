package com.dolo.ui.controls
{
	import flash.display.DisplayObject;
	import com.dolo.ui.renders.IListRender;
	import flash.events.Event;
	import com.dolo.ui.managers.UI;
	import com.dolo.ui.tools.Align;

	/**
	 * 类似Windows文件夹列表或者图片缩略图列表的网格列表 
	 * @author flashk
	 * 
	 */
	public class TileList extends List
	{
		public function TileList()
		{
			_isNeedResetRenderSize = false;
		}
		
		override protected function onStageRender(event:Event=null):void
		{
			UI.stage.removeEventListener(Event.RENDER,onStageRender);
			if(_renderContainer.numChildren ==0 ) return;
			var itemWidth:Number = _renderContainer.getChildAt(0).width;
			var itemHeight:Number = _renderContainer.getChildAt(0).height;
			var max:int = int(_compoWidth/itemWidth);
			if(Math.ceil(_renderContainer.numChildren/max)>_compoHeight){
				max = int(itemRenderViewWidth/itemWidth);
			}
			var maxHeight:Number = Align.gridAllChild(_renderContainer,itemWidth,itemHeight,max);
			_scrollBar.updateSize(maxHeight);
			var num:int = _renderContainer.numChildren;
			for(var i:int=0;i<num;i++){
				IListRender(_renderContainer.getChildAt(i)).index = i;
			}
		}
		
		override protected function resetItemSize():void
		{
			var renderViewWidth:int = _compoWidth-_scrollBar.compoWidth+defaultScrollBarXAdd;
			var num:int = _renderContainer.numChildren;
			var render:IListRender;
			var itemShowWidht:int = renderViewWidth;
			if(_scrollBar.visible == false){
				itemShowWidht = _compoWidth;
			}
			for(var i:int=0;i<num;i++){
				render = IListRender(_renderContainer.getChildAt(i));
			}
		}
		
	}
}