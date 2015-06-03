package com.dolo.ui.skin
{
	import com.dolo.ui.tools.Scale9GridBitmap;

	public class ButtonSkin extends Skin{
		
		public var up:String;
		public var over:String;
		public var down:String;
		public var select:String;
		
		/**皮肤设置
		 * @param upLink	默认状态
		 * @param overLink	滑过状态
		 * @param downLink	鼠标按下状态
		 * @param selectLink 选中状态
		 * param不可为null
		 */		
		public function ButtonSkin(upLink:String,overLink:String,downLink:String,selectLink:String){
			up = upLink;
			over = overLink;
			down = downLink;
			select = selectLink;
		}
	}
}