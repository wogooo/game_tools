package view
{
	/**@author yefeng
	 *2012-6-5下午2:08:49
	 */
	import com.YFFramework.core.map.rectMap.RectMapConfig;
	import com.YFFramework.core.map.rectMap.RectMapUtil;
	
	import flash.geom.Point;
	
	import model.TypeRoad;
	
	import mx.events.FlexEvent;
	
	public class MarkObject extends MapObjectView
	{
		
		/**障碍点
		 */
		public static const BlockColor:uint=0xFF0000;
		/**可走
		 */
		public static const RoadColor:uint=0x00FF00;
		/**消隐 
		 */
		public static const AlphaColor:uint=0xFFFF00;
		/**地图 跳转
		 */
		public static const SkipColor:uint=0xFF00FF;
		
		
		public static const FlyColor1:uint=0xD9652F;
		public static const FlyColor2:uint=0xD96A72;
		
		
		private var color:uint;
		
		public var myId:int;
		
		//  0标识号障碍点  1 表示可走点  2  表示消隐点  3  表示跳转点
		public function MarkObject(id:int,tileX:int,tileY:int)
		{
			this.myId=id;
			switch(id)
			{
				case TypeRoad.Block:
					color=BlockColor;
					break;
				case TypeRoad.Walk:
					color=RoadColor;
					break;
				case TypeRoad.AlphaWalk:
					color=AlphaColor;
					break;
				case TypeRoad.Skip:
					color=SkipColor;
					break;
				case TypeRoad.WaterPt:
					color=FlyColor1;
					break;
				case TypeRoad.Fly2:
					color=FlyColor2;
					break;
			}
			super(true);
			this.tileX=tileX;
			this.tileY=tileY;
			updatePostion();
			alpha=0.6;

		}
		
		override protected function initUI():void
		{
			super.initUI();
			var star_commands:Vector.<int> = new Vector.<int>()
			star_commands.push(1, 2, 2, 2,2);
			var tileW:Number=RectMapConfig.tileW;
			var tileH:Number=RectMapConfig.tileH;
			var cors:Vector.<Number>=new Vector.<Number>()
			cors.push(-tileW*0.5,0,0,-tileH*0.5,tileW*0.5,0,0,tileH*0.5,-tileW*0.5,0);
				
			graphics.clear()
			graphics.beginFill(color);
			graphics.drawPath(star_commands, cors);
			graphics.endFill();
		}
		
		override public function dispose(e:FlexEvent=null):void
		{
			super.dispose(e);
			graphics.clear();
//			_image=null;
			myId=0;
		}
		
		override public function updatePostion():void
		{
			var pt:Point=RectMapUtil.getFlashCenterPosition(tileX,tileY);
			x=pt.x;
			y=pt.y;
		}
		
		
	}
}