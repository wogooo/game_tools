package com.YFFramework.game.core.module.character.view
{
	import com.YFFramework.core.ui.abs.AbsUIView;
	import com.YFFramework.core.ui.yfComponent.controls.YFGridOpen;
	import com.YFFramework.core.ui.yfComponent.controls.YFLabel;
	import com.YFFramework.core.world.model.type.EquipCategory;
	
	import flash.events.Event;
	
	/**
	 * 人物界面的格子
	 * 2012-8-22 上午10:39:36
	 *@author yefeng
	 */
	public class BodyGrid extends AbsUIView
	{
		
		/**装备部位id   值为EquipCategory的静态变量
		 */
		public var modelId:int;
		protected var _label:YFLabel;
		protected var _grids:YFGridOpen;
		public function BodyGrid(modelId:int)
		{
			this.modelId=modelId;
			super(false);
			mouseChildren=false;;
		}
		
		override protected function initUI():void
		{
			super.initUI();
			_grids=new YFGridOpen();
			addChild(_grids);
			var txt:String=EquipCategory.getModelName(modelId);
			_label=new YFLabel(txt,1,12,0xdddddd);
			addChild(_label);
			_label.exactWidth();
			_label.x=(_grids.width-_label.textWidth)*0.5-1;
			_label.y=(_grids.height-_label.textHeight)*0.5;
		}
		
		override public function dispose(e:Event=null):void
		{
			super.dispose(e);
			_label=null;
			_grids=null;
		}
		
		
	}
}