package com.dolo.ui.tools
{
	import com.dolo.ui.controls.DoubleDeckTree;
	import com.dolo.ui.renders.ITreeRender;
	
	import flash.display.Sprite;
	import flash.geom.Rectangle;

	public class TreeSprite extends Sprite
	{
		private var _isOpen:Boolean = false;
		private var _max:int;
		private var _tree:DoubleDeckTree;
		
		public function TreeSprite(target:DoubleDeckTree)
		{
			_tree = target;
			_isOpen = _tree.trunkDefaultOpen;
			this.scrollRect = new Rectangle(0,0,2800,0);
		}
		
		public function get isOpen():Boolean
		{
			return _isOpen;
		}

		public function set isOpen(value:Boolean):void
		{
			_isOpen = value;
			if(_isOpen == true){
				this.scrollRect = new Rectangle(0,0,2800,_max);
			}else{
				var h:int =0;
				if(this.numChildren > 0){
					h = this.getChildAt(0).height;
				}
				this.scrollRect = new Rectangle(0,0,2800,h);
			}
			if(this.numChildren>0){
				ITreeRender(this.getChildAt(0)).open = value;
			}
		}

		override public function get height():Number
		{
			return this.scrollRect.height;
		}
		
		public function update():void
		{
			_max = Align.followVerticalOneByOne(this);
			isOpen = _isOpen;
		}
		
		public function dispose():void
		{
			while(this.numChildren>0){
				var render:ITreeRender = this.getChildAt(0) as ITreeRender;
				if(render){
					render.dispose();
				}
				this.removeChildAt(0);
			}
		}
		
		
	}
}