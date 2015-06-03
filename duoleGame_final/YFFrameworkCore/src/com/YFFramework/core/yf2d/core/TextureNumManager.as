package com.YFFramework.core.yf2d.core
{
	

	/**当前贴图个数
	 * @author yefeng
	 * 2013 2013-12-24 下午2:00:30 
	 */
	public class TextureNumManager
	{
		
		/**最大只能申请
		 */
		private static const MaxNum:int=920;
		
		private static var _currentSize:int=0;
		public function TextureNumManager()
		{
		}
		public static function increase():void
		{
			_currentSize++;
			if(_currentSize>=MaxNum)
			{
				YF2d.Instance.disposeContext3D();
			}
		}
		public static function decrease():void
		{
			_currentSize--;
			if(_currentSize<0)_currentSize=0;
		}
		public static function reset():void
		{
			_currentSize=0;
		}
	}
}