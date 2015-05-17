package view
{
	import com.YFFramework.air.flex.FlexUI;
	import com.YFFramework.air.flex.movie.FlexMovieClip;
	import com.YFFramework.core.ui.movie.data.ActionData;
	
	import mx.events.FlexEvent;
	
	/**2012-11-7 下午3:36:16
	 *@author yefeng
	 */
	public class TransferPtClip extends FlexUI
	{
		
		public var data:Object;
		private var _movie:FlexMovieClip;
		private var _offsetX:int;
		private var _offsetY:int;
		public function TransferPtClip(offsetX:int=0,offsetY:int=0)
		{
			_offsetX=offsetX
			_offsetY=offsetY
			data=new Object();
			super(false);
			mouseChildren=false;
		}
		
		override protected function initUI():void
		{
			super.initUI();
			_movie=new FlexMovieClip();
			addElement(_movie);
			_movie.start();
			_movie.x=_offsetX;
			_movie.y=_offsetY;
		}
		
		public function initData(actionData:ActionData):void
		{
			_movie.initData(actionData);
			_movie.playDefault();
		}
		override protected function addEvent():void
		{
			super.addEvent();
		}
		
		override protected function removeEvent():void
		{
			super.removeEvent();
		}
		
		override public function dispose(e:FlexEvent=null):void
		{
			_movie.dispose();
			super.dispose(e);
			_movie=null;
		}
		
		

	}
}