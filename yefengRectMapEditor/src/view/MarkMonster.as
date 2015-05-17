package view
{
	import com.YFFramework.air.flex.FlexUI;
	import com.YFFramework.core.ui.utils.Draw;
	import com.YFFramework.core.map.rectMap.RectMapConfig;
	
	import flash.utils.Dictionary;
	
	import mx.events.FlexEvent;

	/**  2012-7-11
	 *	@author yefeng
	 */
	public class MarkMonster extends FlexUI
	{
		
		public var myId:int;
		
		private static var _colorArr:Vector.<int>=new Vector.<int>();
		private var _color:uint;
		/**
		 * @param id   怪物 id 
		 * @param x    x flash坐标
		 * @param y    y flash 坐标
		 * 
		 */
		public function MarkMonster(id:int,x:int,y:int)
		{
			this.myId=id;
			var index:int=_colorArr.indexOf(id);
			if(index==-1)_colorArr.push(id);
			_color=getColor(id);
			mouseChildren=false;
			buttonMode=true;
			super(true);
			this.x=x;
			this.y=y;

		}
		
		override protected function initUI():void
		{
			super.initUI();
			var radius:int=8;
			Draw.DrawCircle(graphics,radius,0,0,_color)
		}
		
		
		private  function getColor(id:int):uint
		{
			var len:int=0;
			var color:uint;
			for each (var obj:Object in _colorArr)
			{
				len++;
				if(id==obj) break;
			}
			
			switch(len)
			{
				case 1:
					color=0x2F3694;		
					break;
				case 2:
					color=0xA9CF54
					break;
				case 3:
					color=0xF7E967
					break;
				case 4:
					color=0xCAFCD8
					break;

				case 5:
					color=0x04BFBF
					break;

				case 6:
					color=0xA49A87	
					break;
				case 7:
					color=0xFF974F
					break;

				case 8:
					color=0xF77A52
					break;

				case 9:
					color=0x644D52
					break;

				case 10:
					color=0x8479FF	
					break;

				case 11:
					color=0xD379FF
					break;

				case 12:
					color=0x693D80
					break;

				case 13:
					color=0xE7F29E
					break;
				case 14:
					color=0x376954
					break;
				case 15:
					color=0x4EA1D9
					break;
			}
			return color;

		}
		override public function dispose(e:FlexEvent=null):void
		{
			super.dispose();
			graphics.clear();
		}
		
	}
}