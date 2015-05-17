package com.YFFramework.core.center.abs.configFile
{
	import com.YFFramework.core.center.face.IConfigFile;
	import com.YFFramework.core.center.manager.ConfigFileManager;
	
	/**
	 * author :夜枫 * 时间 ：2011-9-25 下午03:11:25
	 */
	public  class AbsConfigFile implements IConfigFile
	{
		protected var _url:String;
		protected var _data:*;
		public function AbsConfigFile(url:String)
		{
			_url=url;
			regFile();
		}
		
		public function regFile():void
		{
			ConfigFileManager.Instance.regConfigFile(this);
		}
		public function get fileUrl():String
		{
			return _url;
		}
		public function set data(value:*):void
		{
			_data=value;
		}
		public function get data():*
		{
			return _data;
		}
		public function  remove():void
		{
			_url="";
			_url=null;
			_data=null;
		}
	}
}