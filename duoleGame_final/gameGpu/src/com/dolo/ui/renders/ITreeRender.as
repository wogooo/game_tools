package com.dolo.ui.renders
{
	import com.dolo.ui.controls.DoubleDeckTree;

	public interface ITreeRender extends IListRender
	{
		function set tree(value:DoubleDeckTree):void;
		function set trunkIndex(value:int):void;
		function get trunkIndex():int;
		function set open(valeu:Boolean):void;
		function get nodeIndex():uint;
		
	}
}