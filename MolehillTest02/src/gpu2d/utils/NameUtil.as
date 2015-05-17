package gpu2d.utils
{
	/**
	 * author :夜枫
	 * 时间 ：2011-11-13 下午10:09:05
	 */
	public final class NameUtil
	{
		private static var nameIndex:int=0;
		public function NameUtil()
		{
		}
		public static function getNameIndex():String
		{
			nameIndex++;
			return nameIndex.toString();
		}
	}
}