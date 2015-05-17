package com.YFFramework.game.core.module.smallMap.view.list
{
	import com.YFFramework.core.ui.abs.AbsUIView;
	import com.YFFramework.core.ui.container.VContainer;
	import com.YFFramework.core.ui.yfComponent.controls.YFTreeCell;
	
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	/**2012-11-14 下午5:33:17
	 *@author yefeng
	 */
	public class SmallMapListView extends VContainer
	{
		
		protected var _treeCell:YFTreeCell;
		
		protected var _vContainer:VContainer;
		public function SmallMapListView()
		{
			super(0,false);
		}
		public function set title(value:String):void
		{
			_treeCell.text=value;
		}
		
		public function get tittle():String
		{
			return _treeCell.text;
		}
		override protected function initUI():void
		{
			super.initUI();
			_treeCell=new YFTreeCell("test",2);
			_treeCell.height=20;
			_vContainer=new VContainer(1);
			addChild(_treeCell);
			addChild(_vContainer);
			updateView();
		}
		override protected function addEvents():void
		{
			super.addEvents();
			_treeCell.addEventListener(MouseEvent.CLICK,onClick);
			
			_treeCell.select=true;
			_treeCell.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
		}
		
		override protected function removeEvents():void
		{
			super.removeEvents();
			_treeCell.removeEventListener(MouseEvent.CLICK,onClick);
		}
		private function onClick(e:MouseEvent):void
		{
			if(_treeCell.select)
			{
				
				if(!contains(_vContainer)) addChild(_vContainer);
			}
			else 
			{
				if(contains(_vContainer)) removeChild(_vContainer);
			}
			updateView();	
		}
				
		/**都不被选中
		 */		
		public function setContentUnSelect():void
		{
			var len:int=_vContainer.numChildren;
			var cell:SmallMapListCell;
			for(var i:int=0;i!=len;++i)
			{
				cell=_vContainer.getChildAt(i) as SmallMapListCell;
				cell.select=false;
			}
		}
		
		public function setSelect(display:DisplayObject):void
		{
			var cell:SmallMapListCell=display as SmallMapListCell;
			if(cell)cell.select=true
		}
		
		
		
		override public function updateView():void
		{
			_vContainer.updateView();
			super.updateView();
		}
		
		override public function dispose(e:Event=null):void
		{
			super.dispose(e);
			_treeCell=null;
			_vContainer=null;
		}

		
	}
}