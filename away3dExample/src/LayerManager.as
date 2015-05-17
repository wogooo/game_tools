package
{
	import away3d.containers.Scene3D;
	
	import yf2d.display.Scence2D;

	/**@author yefeng
	 *2013-3-17下午9:56:44
	 */
	public class LayerManager
	{
		/**底层
		 */		
		public static var BottomLayerRoot:Scence2D;
		/**角色层
		 */		
		public static var RoleLayerRoot:Scene3D;
		/**顶层
		 */		
		public static var TopLayerRoot:Scence2D;

		public function LayerManager()
		{
		}
	}
}