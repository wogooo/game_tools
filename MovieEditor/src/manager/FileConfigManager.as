package manager
{
	import flash.desktop.NativeApplication;
	
	import type.TypeFile;

	/** 配置文件的默认启动项
	 *  @author yefeng
	 *   @time:2012-4-7下午05:15:07
	 */
	public class FileConfigManager
	{
		private var app:NativeApplication;
		public function FileConfigManager()
		{
			initFile();
		}
		private function initFile():void
		{
			app=NativeApplication.nativeApplication;
			app.setAsDefaultApplication(TypeFile.FileExtention);
		}
	}
}