package com.YFFramework.core.ui.movie
{
	import com.YFFramework.core.ui.movie.data.TypeDirection;

	/**宠物面板，角色面板显示使用
	 * @author yefeng
	 * 
	 * 2013 2013-3-18 上午11:44:47 
	 */
	public class AvatarShow extends RolePartView
	{
		public function AvatarShow()
		{
			super();
		}
		
		/**  向坐旋转
		 */		
		public function turnLeft():void
		{
			var direction:int = _activeDirection%TypeDirection.DirectionLen +1;
			play(_activeAction,direction);
		}
		
		/**向右旋转
		 */
		public function turnRight():void
		{
			var direction:int=_activeDirection-1+TypeDirection.DirectionLen;
			direction=(direction-1)%TypeDirection.DirectionLen +1;
			play(_activeAction,direction);
		}

				
	}
}