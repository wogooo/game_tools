package view
{
	/**@author yefeng
	 *2012-6-5下午2:19:37
	 */
	import com.YFFramework.air.flex.FlexUI;
	
	public class MapObjectView extends FlexUI
	{
		public var tileX:int;
		/** tileY坐标 
		 */
		public var tileY:int;
		public function MapObjectView(autoRemove:Boolean=false)
		{
			super(autoRemove);
		}
		
		/**  根据 tile xy 更新对应的 x  y 坐标 
		 */
		public function updatePostion():void
		{
			
		}
	}
}